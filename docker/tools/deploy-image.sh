AWS_ACCOUNT=''
REGION='us-east-1'
IMAGE_NAME='colehendo-app'
IMAGE_TAG='latest'

aws ecr get-login-password --region "${REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE_NAME}"

cd ..
docker image build -t "${IMAGE_NAME}" .
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE_NAME}:${IMAGE_TAG}"
docker push "${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE_NAME}:${IMAGE_TAG}"