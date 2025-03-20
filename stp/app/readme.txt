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
docker tag stp:latest ${AWS_ACCOUNT}.dkr.ecr. eu-west-2.amazonaws.com/${APP_NAME}:latest

# PUSH THE IMAGE
docker push ${AWS_ACCOUNT}.dkr.ecr. eu-west-2.amazonaws.com/${APP_NAME}:latest



# CREATE THE INITIAL CLUSTER
aws ecs create-cluster --cluster-name my-stp-cluster

# REGISTER THE TASK DEFINITION BLUEPRINT
aws ecs register-task-definition --cli-input-json file://task-dev1.json


aws ecs create-service --cluster   my-stp-cluster \
  --service-name my-stp-service \
  --task-definition my-stp-task \
  --desired-count 1 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxxxxxxx],securityGroups=[sg-xxxxxxxx],assignPublicIp=ENABLED}"

