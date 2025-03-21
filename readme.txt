python3 -m venv venv      # Create a virtual environment (if not created already)
source venv/bin/activate  # Activate the virtual environment (Mac/Linux)
pip install -r requirements.txt

AWS_ACCOUNT="717279690473"
APP_NAME="stp"


# CREATE THE DOCKER IMAGE LOCALLY
docker build -t stp .

# CREATE REPOSITORY in ECR
aws ecr create-repository --repository-name stp

# LOGIN TO ECR from Docker
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com

# TAG THE IMAGE
docker tag stp:latest ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${APP_NAME}:latest

# PUSH THE IMAGE
docker push ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${APP_NAME}:latest



# CREATE THE INITIAL CLUSTER
aws ecs create-cluster --cluster-name my-stp-cluster



# Need to create a role that can be assumed by ECS
aws iam create-role \
  --role-name stpEcsTaskExecutionRole \
  --assume-role-policy-document file://ecs-trust-policy.json


# And give it permission to execute ECS tasks.
aws iam attach-role-policy \
  --role-name stpEcsTaskExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

# And have cloudwatch access
aws iam attach-role-policy \
  --role-name ecsTaskExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess





# REGISTER THE TASK DEFINITION BLUEPRINT
aws ecs register-task-definition --cli-input-json file://task-dev1.json




To list current subnets for default VPC
 aws ec2 describe-subnets \
  --query "Subnets[*].{ID:SubnetId,Public:MapPublicIpOnLaunch,AZ:AvailabilityZone}" \
  --output table


Create a SG that allows traffic on port 5000

aws ec2 create-security-group \
  --group-name ecs-stp-sg \
  --vpc-id vpc-03defd0e6c747fd29


aws ec2 authorize-security-group-ingress \
  --group-name ecs-stp-sg \
  --protocol tcp --port 5000 \
  --source-group ecs-stp-sg



aws ecs create-service --cluster   my-stp-cluster \
  --service-name my-stp-service \
  --task-definition my-stp-task \
  --desired-count 1 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-0e079f13511576be2],securityGroups=[sg-02c7fa0f5f2f786a7],assignPublicIp=ENABLED}"


curl -X POST http://ECS-PUBLIC-IP:5000/process -d '<request><id>123</id></request>'
