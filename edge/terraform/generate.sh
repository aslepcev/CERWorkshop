akamai terraform --accountkey 'B-C-1ED34DK:1-8BYUX' export-property --rules-as-hcl --tfworkpath "./property" webshop

akamai terraform --accountkey 'B-C-1ED34DK:1-8BYUX' export-edgeworker --tfworkpath "./edgeworkers" "91405"

akamai terraform --accountkey 'B-C-1ED34DK:1-8BYUX' export-domain --tfworkpath "./gtm" "webshop-gmoissai.akadns.net"
