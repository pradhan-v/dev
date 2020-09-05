# AWS Development Tools

### Install AWS CLI

```bash
pip3 install --user awscli
```

### Install AWS SAM CLI

```bash
pip3 install --user aws-sam-cli
```

Re login if command not found 

### Install LocalStack

```bash
pip install --user localstack
````

Got an error when I ran the `localstack` command.

```bash
localstack -v
```

```bash
/usr/share/python-wheels/requests-2.18.4-py2.py3-none-any.whl/requests/__init__.py:80: RequestsDependencyWarning: urllib3 (1.25.7) or chardet (3.0.4) doesn't match a supported version!
0.10.7
```

Upgraded `pip`. This installed pip (not pip3)

```bash
python3 -m pip install --upgrade pip
```

### Install AWS Local command wrapper for `localstack`

```bash
pip install --user awscli-local
```

---

## AWS CLI examples

### Update layers

```bash
aws lambda update-function-configuration \
  --function-name smartplans-test-assembler-lambda-service \
  --layers \
  arn:aws:lambda:us-east-1:000000000000:layer:hello-world-base-libraries:46 \
  arn:aws:lambda:us-east-1:000000000000:layer:hello-universe-libraries:26
```

### Invoke a Lambda function

```bash
PAYLOAD='{"requestid":100, "projectid":100}'
aws lambda invoke \
  --function-name the-function-name \
  --payload "$PAYLOAD" \
  --invocation-type RequestResponse \
  output.json
```

### Show files in a S3 location

```bash
aws s3 ls "s3://hello-world-root/world/data/input/" | grep .pdf
```

### Copy pdf files from a S3 "folder" to current folder

```bash
aws s3 cp "s3://hello-world-root/world/data/input/" ~/temp --exclude "*" --include "*.pdf" --recursive
```

### Deploy function

#### Create a S3 bucket

```bash
awslocal s3 mb s3://hello-world-root/
```

```bash
awslocal s3api put-object --bucket hello-world-root --key lambda-functions
```

##### dont know what this is !!!

```bash
awslocal iam create-role --role-name localserverless --assume-role-policy-document {}
awslocal iam get-role --role-name localserverless
```

##### Variables

```bash
LOCAL_ZIP_PATH=build/distributions/integration-lambda-service.zip
S3_LAMBDA_KEY=s3://hello-world-root/lambda-functions/integration-lambda-service.zip

FUNCTION_NAME=integration-lambda-service
S3_BUCKET=hello-world-root
S3_LAMBDA_KEY=lambda-functions/integration-lambda-service.zip
REGION=us-east-1
```

##### Copy zip to S3

```bash
awslocal s3 cp $LOCAL_ZIP_PATH $S3_LAMBDA_KEY
```

##### Create function

```bash
awslocal lambda create-function \
	--function-name $FUNCTION_NAME \
	--runtime java8 \
	--zip-file fileb://$LOCAL_ZIP_PATH \
	--role arn:aws:iam::000000000000:role/localserverless \
	--handler com.helloworld.integration.handler.HelloIntegrationHandler

awslocal lambda update-function-code \
	--function-name $FUNCTION_NAME \
	--s3-bucket $S3_BUCKET \
	--s3-key $S3_LAMBDA_KEY \
	--region $REGION
```

##### Get info about a function

```bash
aws lambda get-function --function-name $FUNCTION_NAME
```

