Third step: Update edgeworker code to enable AI sentiment detection

- In `edgeworkers-comments/src/main.js` uncomment the portion of code calling the AI service.
- Run `terraform/build-edgeworker.sh` to repackage your new version of the code
- `terraform apply`

After deployment, post new comment and notice how sentiment gets added.