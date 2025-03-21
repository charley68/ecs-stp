cd infra
tf apply

# Now we need to build/push the docker immage before the task and service are created in ecs TF 
# This currently assumes the ECR repository exists so should move that into the INFRA i think

python3 -m venv venv      # Create a virtual environment (if not created already)
source venv/bin/activate  # Activate the virtual environment (Mac/Linux)
pip install -r requirements.txt

AWS_ACCOUNT="717279690473"
APP_NAME="stp"


# CREATE THE DOCKER IMAGE LOCALLY
docker build -t stp .

# LOGIN TO ECR from Docker
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com

# TAG THE IMAGE
docker tag stp:latest ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${APP_NAME}:latest

# PUSH THE IMAGE
docker push ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${APP_NAME}:latest


cd ecs
tf apply



# Test
curl -X POST http://18.130.8.60:5000/process -d '<request><id>123</id></request>'

