import { HtmlRewritingStream } from 'html-rewriter';
import { httpRequest } from 'http-request';
import { createResponse } from 'create-response';
import { logger } from 'log';
import { removeUnsafeRequestHeaders, removeUnsafeResponseHeaders, getUniqueHeaderValue } from './http-helpers.js';
import URLSearchParams from 'url-search-params';

/**
 * 
 * @param {EW.ResponseProviderRequest} request
 * @returns {Promise<object>} response
 */
export async function postComment(request) {
    // Get data from request
    const productId = request.path.split("/").slice(-1);
    const requestBody = await request.text();
    const params = new URLSearchParams(requestBody);
    const text = params.get("text");
    const name = params.get("name");

    // Leverage AI to detect sentiment
    const aiResponse = await httpRequest("/comments-sentiment", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ text }),
    });
    const sentiment = aiResponse.text();

    // Upload AI-enhanced comment
    await httpRequest(`/comments/${productId}`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ text, name, sentiment }),
    });
}

const commentFormHtml = url => `
<form action="${url}" method="POST">
  <label for="name">name:</label>
  <input type="text" id="name" name="name"><br><br>
  <label for="text">comment:</label>
  <textarea id="text" name="text"></textarea><br><br>
  <input type="submit" value="Submit">
</form>
`;

/**
 * 
 * @param {EW.ResponseProviderRequest} request
 * @returns {Promise<object>} response
 */
export async function getComments(request) {
    //Step 0: prefetch comments
    const productId = request.path.split("/").slice(-1);
    const commentsPromise = httpRequest(`/comments/${productId}`);

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
        //Step 3.1: Fetch comments
        const commentsResponse = await commentsPromise;
        const comments = await commentsResponse.json();

        //Step 3.2: Rewrite the HTML with comments
        const rewriter = new HtmlRewritingStream();
        rewriter.onElement(`body`, el => {
            //TODO: protect against injections, XSS, XSRF
            const commentsHtml = comments.map(c => `<li><span class="sentiment">${comments.sentiment}</span>${comments.name}:${comments.text}</li>`);
            el.append('<ul>');
            el.append(commentsHtml);
            el.append('</ul>');
            el.append(commentFormHtml(request.url));
        });
        responseBody = responseBody.pipeThrough(rewriter);
    }

    //Step 4: Forward pristine response to end-user
    return createResponse(pristineResponse.status, responseHeaders, responseBody);
}

/**
 * 
 * @param {EW.ResponseProviderRequest} request
 * @returns {Promise<object>} response
 */
export async function responseProvider(request) {
    if (request.method === "POST") {
        return postComment(request);
    } else {
        return getComments(request);
    }
}
