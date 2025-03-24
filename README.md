# ecs-stp


This version creates the VPC and public  subnets and ECS but places the tasks in public subnet
which makes life much easier but less secure !!  As its public, it can access the internet fgor pulling
down from ECR 

It also has no Load Balancer and hence only deployed on ONE SUBNET. It is therefore NOT resilient to failover.

Testing requires getting the public IP of the Task.  It doesnt use a service so just runs one Task.
