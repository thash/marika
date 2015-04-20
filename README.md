Marika
=================

AWS billing report -> Slack

![](https://cloud.githubusercontent.com/assets/24908/7224740/22c5905c-e771-11e4-95e5-39b1af91534c.png)


requirements
=================

* AWS: [請求明細レポートをオンにする](http://docs.aws.amazon.com/ja_jp/awsaccountbilling/latest/aboutv2/detailed-billing-reports.html)
* Slack: enable [Incoming Webhooks | Slack](https://api.slack.com/incoming-webhooks)


usage
=================

````````
AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX" \
AWS_SECRET_ACCESS_KEY="YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY" \
BUCKET="your-billing-bucket-name" \
WEBHOOK_URL="https://hooks.slack.com/services/xxxxxxxxx/yyyyyyyyy/zzzzzzzzzzzzzzzzzzzzzzzz" \
ruby marika.rb
````````

