# Alpine based image with Helm, Kubectl, AWS cli and IAM authenticator

This is an extension to `dtzar/helm-kubectl` including
awscli and iam-authenticator to ease interaction with ECR
reducing the amount of boilerplate scripts.

## Includes
- Helm 3.7.1
- Kubectl 1.22.2
- AWS CLI 1.22.21
- IAM authenticator 1.21.2

### Maybe this is not for you?

If you don't need AWS cli because you use another k8s provider,
this is actually a bloated image, you could use directly dtzar's
project raw, or build your own extension.

This is even the recommended approach by David Tesar, author of
the very helpful base image, because
[not everyone requires some tools](https://github.com/dtzar/helm-kubectl/issues/74#issuecomment-767904614).

Check the How to comparison next if you are not sure:

## How to comparison (use in a pipeline)

### Using this image
> tezcatl/helm_kubectl_awscli

```yaml
- step: build-and-push
  name: Build and Push to ECR
  image: tezcatl/helm_kubectl_awscli:v1
  script:
    - AWS_CLIENT_ID="${AWS_CLIENT_ID}" AWS_CLIENT_SECRET="${AWS_CLIENT_SECRET}" AWS_REGION=us-east-2 source $BASH_ENV
    # Don't use eval aws ecr get-login < is deprecated
    - ECR_PASSWORD=$(aws ecr get-login-password)
    - docker login -u AWS -p "${ECR_PASSWORD}" "https://${AWS_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    - docker build -t your-service:tag-release
    - docker push your-service:tag-release
```

### Using the base image
> dtzar/helm-kubectl
```yaml
- step: build-and-push
  name: Build and Push to ECR
  image: dtzar/helm-kubectl
  script:
    - apk add python py3-pi
    - pip3 install awscli
    - aws configure set aws_access_key_id "${AWS_CLIENT_ID}"
    - aws configure set aws_access_secret_key "${AWS_CLIENT_SECRET}"
    - mkdir $HOME/bin
    - curl -o $HOME/bin/aws-iam-authenticator https://amazon-eks...aws-iam-authenticator-script
    - chmod +x $HOME/bin/aws-iam-authenticator
    - export PATH=$PATH:$HOME/bin
    # all of this before is what we try to avoid repeat on every run
    # Don't use eval aws ecr get-login < is deprecated
    - ECR_PASSWORD=$(aws ecr get-login-password)
    - docker login -u AWS -p "${ECR_PASSWORD}" "https://${AWS_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    - docker build -t your-service:tag-release
    - docker push your-service:tag-release
```

Repeating all that instructions is time/energy/water consuming, instead
you get the same binaries installed and ready to go (see the Dockerfile).

### Local test of your commands

```bash
docker run --rm -it tezcatl/helm_kubectl_awscli \
--env AWS_CLIENT_ID=K7VQSZQBRA0CKMSQ1VM4 \
--env AWS_CLIENT_SECRET=KXJSPoIf6b9bdEmZsW6Qj4gJRRCaTYXmYcfgdDCH \
--env AWS_REGION=us-east-2 bash -c 'aws ecr get-login-password'
```

If you want to avoid copy-paste ID and secret or leaking them to your
history, you could cut'em from your stored credentials.

```bash
AWS_CLIENT_ID=$(grep id ~/.aws/credentials | cut -f3 -d' ')
AWS_CLIENT_SECRET=$(grep secret ~/.aws/credentials | cut -f3 -d' ')
```

> this works if you have only one profile in your credentials

### Stuck? Want some help?

Again, if you don't use AWS ECR, and can't find a precompiled image
to help you with your provider, maybe this can be a reference to build
and share your own solution.

If you are unsure if this can be helpful or find an issue, don't hesitate
on file an issue, and/or share your stackoverflow question.
I'll try to help and we can learn from each other.

## Mind the water

But please, please, in any case. Don't
overspend energy and water unnecessarily.
Always that you can reuse a prebuilt solution
(or optimize building and sharing your own)
and help the children keep the water.
