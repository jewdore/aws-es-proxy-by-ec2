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

### 下载二进制文件

**aws-es-proxy** has single executable binaries for Linux, Mac and Windows.

Download the latest [aws-es-proxy-by-ec2 release](https://github.com/jewdore/aws-es-proxy-by-ec2/releases).

### Docker

可以自己构建，然后直接docker run。注意：docker方式必须提供listen参数，默认127.0.0.1，只接受docker 容器内的回环会话。

```sh
docker build -t <image_tag> .
&& docker run
--entrypoint /app -listen 0.0.0.0:9200 -endpoint https://demo.us-west-2.es.amazonaws.com -verbose -pretty -ssh-config /tmp/config.yaml
-v /Users/jewdore/.rtb-tools/bidder-config:/tmp/config.yaml
-p 9200:9200
<image_tag> 
著作权归作者所有。
商业转载请联系作者获得授权，非商业转载请注明出处。
作者：IT玩客
链接：https://www.91the.top/joy/aws-es-proxy-by-ec2.html
```
### Via homebrew

```sh
brew tap jewdore/tap && brew install aws-es-proxy-by-ec2
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

