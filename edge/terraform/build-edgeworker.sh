cd ../edgeworkers-comments/src
#increment bundle version
jq '."edgeworker-version"=(((."edgeworker-version"|tonumber)+1)|tostring)' bundle.json > bundle.json.tmp && mv bundle.json.tmp bundle.json
#build bundle
tar -czf ../../terraform/bundle.tgz *.js bundle.json
