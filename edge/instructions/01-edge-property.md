First step: deploy edge delivery property and global load balancer

- Update `terraform/variables.tf` so `unique_name.default` is the exact same user id you used deploying your cloud

- Run `terraform apply` to create your load balancer and delivery property

- While it's deploying review `gtm` and `property` folder:
  - GTM is the load balancer with your 4 `datacenters` and `properties` for each service you deployed (frontend, api, neural magic, harper db...)
  - Property defines the public hostnames on CDN and rules applied to incoming traffic

Once deployment is completed
- Output will show `api_hostname` as deployed on the CDN, you can update your frontend code to reference it
- `web_hostname` is the public hostname of your website with global load balancing