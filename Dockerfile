FROM dtzar/helm-kubectl:3.14.3
LABEL org.opencontainers.image.authors="jesus@levo.mx"
LABEL org.opencontainers.image.source="https://github.com/apantle/helm_kubectl_awscli"
LABEL version=1.0
LABEL description="Alpine with Helm, Kubectl and AWS cli integrated to script"

RUN apk add --no-cache python3 py3-pip \
    && apk add --no-cache groff \
    && pip3 install awscli

RUN mkdir -p $HOME/bin \
    && curl -o $HOME/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator \
    && chmod +x $HOME/bin/aws-iam-authenticator \
    && export PATH=$PATH:$HOME/bin

ENV AWS_CLIENT_ID=define \
    AWS_CLIENT_SECRET=define \
    AWS_REGION=define \
    BASH_ENV=/etc/profile

COPY ./test-env-configure.sh /etc/profile

CMD ["bash", "-l"]
