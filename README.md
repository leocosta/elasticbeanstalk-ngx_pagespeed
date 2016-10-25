# AWS Elastic Beanstalk with Nginx / Ngx Pagespeed 

## Example installation

- Create a new EC2 instance using any preconfigured Beanstalk image;
- SSH into the instance as root and run the script:

```bash
wget https://raw.githubusercontent.com/leocosta/elasticbeanstalk-ngx_pagespeed/master/elasticbeanstalk-lemp.sh
chmod +x elasticbeanstalk-lemp.sh
bash elasticbeanstalk-lemp.sh
```

- Exit SSH, and create AMI image from the customized instance;
- Set your EB application's custom AMI ID to the new image and save the configuration.
