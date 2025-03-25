This set of branches reates to ECS and various ways of setting it up.
In this main branch, we just have the infra section which can be cloned and additional requirements added to tf/ecs





public-no-loadbalancer
**********************

This is the easiest to setup.  It involves just setting up a public subnet and enusring we have a public IP
with no Multi AZ or private subnets to worry about.  This is the cheapest option and easiest for DEV but not
suitable for PROD due to lack of resilience to failure.


private-with-loadbalancer
*************************

This is the proper way to do things if you need full failover and private subnets.  It is expensive though as requires
at least 2 NAT gaateways  (About $30 a month + data) but gives the most flexibililty since it enables internet access
to private subnets (Via NAT).


private-with-vpc-endpoints
**************************

This is an altneritve to using NAT.  Instead of having a NAT gateway,  we allow VPC Endpoints which enables direct acccess to most AWS services
without going over the internet so way save on NAT costs.  Only s3 and dynamo are free though  (Gateway Endpoints).   All other endpounts (such as SNS,SQS, Lambda, Secrets Manager, ECR etc) are INTERFACE endpoints and charged per hour + data.  Charges are about $7.20 per month per AZ.  


So ... NAT or ENDPOINT depends how many services you require.    If you're app is only using ECR (which requires 2 endpoints - api and dkr) then you'll pay
$7.20 per service per month per AZ.  So total of $14.40 per AZ.   Compared to NAT which is about $34 but lets you use any AWS Service.

Note also,  endpoint data charges are MUCH cheaper (About 1/5).

But, if you start to use a lot of EndPoints,  NAT may become cheaper.  




