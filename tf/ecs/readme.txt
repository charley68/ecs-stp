
In here we create service or ECS specific things.  THe LB is also in here since its specific to the ECS task.  

 
[Internet User]
      │
      ▼
[ALB Listener on Port 80]   ← listens for incoming requests
      │
      ▼
[Application Load Balancer (ALB)] — public subnet
      │
      ▼
[Target Group (port 5000)] — holds ECS task IPs
      │
      ▼
[ECS Fargate Task] — running in private subnet

 


# TEST WITH ....
curl -X POST steve-app-alb-1756778934.eu-west-2.elb.amazonaws.com/process   -d '<request><id>123</id></request>'
