### iOS + nodejs 即时通讯项目

后端使用 nodejs 搭建。

客户端目前只有 iOS

传输协议使用了谷歌的[protobuf](https://github.com/google/protobuf)

```
cd example
pod install

//公网上的服务器可能会奔溃，最好完成配置使用本地服务器，这样也可以进行推送。
//编译过程中出现 <EZAudioOSX/EZAudio.h> 报错问题改为 "EZAudio.h" 就好了
```

### IM_Configure
`protobuf` 的配置文件根据文章进行编译。


### server端

使用 `node server.jsx` 启动服务

##### `server.jsx`:

```
11  const hostname = '192.168.1.4';
12  const port = 3000;
```
HTTP 服务配置，用来给客户端返回七牛上传token


```
58  var wss = new WebSocketServer({ port: 3456 });
```
WebSocket 服务的端口配置


##### 'QNToken.js`

```
174 var bucketName = 'testimage'
165 var accessKey = 'CejIDllxxkKRj_Xf547-dq-QGvYW_xw1PhwTjAEN'
176 var secretKey = 'BwOTDW_OFSN7P7yilFoRMtC-slnlfB6h6aNK-lmx'
```

七牛 Token 生成的配置。

##### `DBManager.js`

```
4  var connection = mysql.createConnection({
5     host     : 'localhost',
6     user     : 'root',
7     password : '',
8     database : 'mydb'
9  });
```

数据库使用了 mysql，这里是本地数据库的配置。

##### `Push.js`

```
4 	key: "./xxx.p8",
5	keyId: "",
6	teamId: ""
```

iOS 推送配置

### GPChat iOS SDK

进入目录后使用 `pod install` 安装第三方

编译过程中出现 `<EZAudioOSX/EZAudio.h>` 报错问题改为 `"EZAudio.h"` 就好了


获取 `七牛token` 的接口在文件 `NetTool.swift` 中

`WebSocket` 的接口在 `SocketManager.swift` 中




