# aws-es-proxy-by-ec2

本项目提供一个简单的HTTP代理，让用户可以在本地直接访问线上的Amazon Elasticsearch service。
使用本项目，用户需要提供EC2的ssh权限相关信息。本项目通过ssh执行远程命令，获取EC2的meta data。
并根据获取的meta data 加密用户的代理请求。


Fork from [aws-es-proxy](https://github.com/abutaha/aws-es-proxy)

改动原因：

**aws es proxy**必须提供AWS_ACCESS_KEY_ID、AWS_SECRET_ACCESS_KEY相关标识信息，但生产机器常常是不允许本地的链接，即没有key和token相关信息，也不允许IAM roles策略访问。

改动：

用户提供登录机器EC2的ssh权限。
本项目会通过ssh 执行远程命令获取EC2的meta data，然后设置ENV。从而允许用户通过本地直接访问线上封闭的ES

## Installation

### Download binary executable

**aws-es-proxy** has single executable binaries for Linux, Mac and Windows.

Download the latest [aws-es-proxy release](https://github.com/abutaha/aws-es-proxy/releases/).

### Docker

There is an official docker image avaiable for aws-es-proxy. To run the image:

```sh
# v0.9 and newer (latest always point to the latest release):

docker run --rm -it abutaha/aws-es-proxy:0.9 -endpoint https://dummy-host.ap-southeast-2.es.amazonaws.com

v.08:

docker run --rm -it abutaha/aws-es-proxy ./aws-es-proxy -endpoint https://dummy-host.ap-southeast-2.es.amazonaws.com

```
### Via homebrew

```sh
brew install aws-es-proxy
```
## Configuring Credentials

在使用 **aws-es-proxy-by-ec2** 之前, 请设置允许ES访问的EC2的ssh权限配置信息, 类似:

```
server: 'EC2 IP'
port: '22'
user: 'EC2 USERNAME'
key: "
EC2 PRIVATE KEY (或通过password)
"
timeout: 120
proxy:
   server: '代理IP'
   port: '22'
   user: '代理用户'
   password: '代理用户密码'
   timeout: 120
```

改配置是直接提供给[easyssh-proxy库](https://github.com/appleboy/easyssh-proxy)使用，请参考改go module

## Usage example:

```sh
./aws-es-proxy -endpoint https://test-es-somerandomvalue.eu-west-1.es.amazonaws.com
Listening on 127.0.0.1:9200
```

*aws-es-proxy-by-ec2* listens on 127.0.0.1:9200 ， 你可以通过传参数 `-listen`更改。

```sh
./aws-es-proxy -listen :8080 -endpoint ...
./aws-es-proxy -listen 10.0.0.1:9200 -endpoint ...
```

使用 `-h` 可以获取到命令行help:

```sh
./aws-es-proxy -h
Usage of ./aws-es-proxy:
  -endpoint string
        Amazon ElasticSearch Endpoint (e.g: https://dummy-host.eu-west-1.es.amazonaws.com)
  -listen string
        Local TCP port to listen on (default "127.0.0.1:9200")
  -log-to-file
        Log user requests and ElasticSearch responses to files
  -no-sign-reqs
        Disable AWS Signature v4
  -pretty
        Prettify verbose and file output
  -ssh-config string
        Access to ec2 machine information
  -verbose
        Print user requests
```

