import { HtmlRewritingStream } from 'html-rewriter';
import { httpRequest } from 'http-request';
import { createResponse } from 'create-response';
import { logger } from 'log';
import { removeUnsafeRequestHeaders, removeUnsafeResponseHeaders, getUniqueHeaderValue } from './http-helpers.js';
import URLSearchParams from 'url-search-params';
import { EdgeKV } from './edgekv.js';

// Comments database
const edgeKV = new EdgeKV("default", "webshop2024-comments");

/**
 * Event handler triggered by EdgeWorkers
 * @param {EW.ResponseProviderRequest} request
 * @returns {Promise<object>} response
 */
export async function responseProvider(request) {
    if (request.method === "POST") {
        // Add new comment
        return postComment(request);
    } else {
        // Inject comment list into HTML page
        return getComments(request);
    }
}

/**
 * Insert a comment into the database and redirects to product page
 * @param {EW.ResponseProviderRequest} request
 * @returns {Promise<object>} response
 */
export async function postComment(request) {
    // Get data from request
    const productId = request.path.split("/").at(-1);
    const requestBody = await request.text();
    const params = new URLSearchParams(requestBody);
    const text = params.get("text");
    const name = params.get("name");

    let sentiment = ""
    /*
    // Leverage AI to detect sentiment
    const aiResponse = await httpRequest("/v2/models/sentiment_analysis/infer", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ sequences: text }),
    });
    const sentimentObj = await aiResponse.json();
    sentiment = sentimentObj.labels?.toString();
    */

    // Upload AI-enhanced comment to EdgeKV
    const allComments = await edgeKV.getJson({ item: productId, default_value: [] });
    allComments.push({
        name,
        text,
        sentiment,
    });
    await edgeKV.putJson({
        item: productId,
        value: allComments
    });

    // Redirect back to product page
    return createResponse(303, { "location": request.url }, "");
}

const escapeHtml = (/** @type {string} */ unsafe) => {
    if (!unsafe)
        return "";
    return unsafe.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#039;');
}

const css = `
    <style>
    .comments-container{
    position: fixed;
    bottom: 0;
    right: 15px;
    border: 3px solid #f1f1f1;
    background-color: white;
    z-index: 9;
    }
    .comments-form input[type=text], .comments-form textarea {
    width: 100%;
    padding: 15px;
    margin: 5px 0 22px 0;
    border: none;
    background: #f1f1f1;
    }
    .comments-form input[type=submit] {
    background-color: #04AA6D;
    color: white;
    padding: 16px 20px;
    border: none;
    cursor: pointer;
    width: 100%;
    margin-bottom:10px;
    }
    ul.comments {max-height: 200px; max-width: 300px; overflow: auto}
    ul.comments li {margin-bottom: 8px;}
    </style>
    `;

const commentFormHtml = (/** @type {string} */ url) => `
    <div>New comment</div>
    <form class="comments-form" action="${url}" method="POST">
        <label for="name">name:</label>
        <input type="text" id="name" name="name"><br><br>
        <label for="text">comment:</label>
        <textarea id="text" name="text"></textarea><br><br>
        <input type="submit" value="Submit">
    </form>
    `;

/**
 * Fetch product comments and HTML page,
 * then respond with HTML injected with product comments
 * @param {EW.ResponseProviderRequest} request
 * @returns {Promise<object>} response
 */
export async function getComments(request) {
    //Step 0: Pre-fetch product comments from EdgeKV (no await)
    const productId = request.path.split("/").at(-1);
    const commentsPromise = edgeKV.getJson({ item: productId, default_value: [] });

    //Step 1: Request pristine content
    const requestHeaders = removeUnsafeRequestHeaders(request.getHeaders());
    requestHeaders["pristine"] = ["1"];
    const pristineResponse = await httpRequest(request.url, {
        method: request.method,
        headers: requestHeaders,
        body: request.body
    });

    //Step 2: prepare response from pristine content
    const responseHeaders = removeUnsafeResponseHeaders(pristineResponse.getHeaders());
    let responseBody = pristineResponse.body;

    //Step 3: inject comments
    const pristineContentType = getUniqueHeaderValue(pristineResponse, "content-type")?.trim()?.toLowerCase();
    // Only for HTML content type
    if (!pristineContentType?.startsWith("text/html")) {
        logger.warn(`response Content-Type is not HTML:${pristineContentType}`);
    }
    else {
        //Step 3.1: Fetch comments (await previous promise)
        const comments = await commentsPromise;

        //Step 3.2: Rewrite the HTML with comments
        const rewriter = new HtmlRewritingStream();
        rewriter.onElement(`body`, el => {
            el.append(css);
            el.append('<div class="comments-container">')
            // Show list of previous comments
            const commentsHtml = comments.map(c => `<li><div class="sentiment">${escapeHtml(c.sentiment)}</div><div class="name">${escapeHtml(c.name)}</div><div class="comment">${escapeHtml(c.text)}</div></li>`);
            el.append('<ul class="comments">');
            el.append(commentsHtml.join(""));
            el.append('</ul>');
            // Inject form
            el.append(commentFormHtml(request.url));
            el.append('</div>')
        });
        responseBody = responseBody.pipeThrough(rewriter);
    }

    //Step 4: Forward pristine response to end-user
    return createResponse(pristineResponse.status, responseHeaders, responseBody);
}


