Second step: Add product comments feature with edge computing

- `terraform/main.tf`: uncomment edgeworkers module, to allow upload of the EdgeWorker code
- `terraform/main.tf`: uncomment `edgeworker_id` in property module to allow usage of that code in property rules
- Run `./build-edgeworkers.sh` to package the EdgeWorker code
- Run `terraform apply` to create your edgeworker and update delivery property

While it's deploying review EdgeWorker code and property rules:
- In `terraform/property/rules.tf`, search for `webshop_rule_product_comments` to see how the edgeworker is referenced on specific request criteria
- EdgeWorker code is located in `edgeworkers-comments/src/main.js` the `responseProvider` function is called by the platform on incoming request.

After deployment, open a product page and play with the new edge-injected comment feature.
Comments are stored in a shared Edge Key-Value store, all participants will see comments from each others!