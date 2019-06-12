var {insertMessage,updateMessage, getUser,updateUser, getUnreadMessages} = require('./DBManager')
var getQNToken  = require('./QNToken')
var proto = require('./message_pb')

var APNPush = require('./Push')


// HTTP Server
const http = require('http');

const hostname = '60.205.231.127';
const port = 4000;

const server = http.createServer((req, res) => {
    log('req.url',req.url)
    var url = req.url
    var urls = url.split('?')
    var path = urls[0]
    log(path)

    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    if (path == '/gettoken') {
        res.end(JSON.stringify({'token':getQNToken()}));
    } else if (path == '/sign') {
        // getUser()
        let para = urls[1]
        log(para,para.length)
        if (para.length > 0) {
            let paras = para.split('=')
            let id = paras[0]
            if (id == 'id') {
                let userID = paras[1]
                log(userID)
                let ws = manager[userID]
                log(ws)
                if (ws !== undefined) {
                    res.end(JSON.stringify({'code':-1}))
                } else  {
                    res.end(JSON.stringify({'code':0}))
                }
            }
        }
    } else {
        res.end('')
    }
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});



// WS Server
var module_ws =  require('ws')
var WebSocketServer = module_ws.Server
var wss = new WebSocketServer({ port: 3456 });

var manager = []

wss.on('connection', (ws, req) => {
    console.log('client connected');
    let userWSInfo = req.url.slice(1)
    log(userWSInfo)

    let userInfos = userWSInfo.split("_")
    let userID = userInfos[0]
    let token = userInfos[1]

    var userInfo = new proto.UserInfo()
    userInfo.setId(userID)

    updateUser(userInfo,token)

    log(userID, token)

    let oldWS = manager[userID]
    if (_typeof(oldWS) == _typeof(ws) && oldWS.readyState == 1) {
        oldWS.send('error')
        oldWS.close()
    }

    manager[[userID]] = ws


    let unreads = getUnreadMessages(userID, list => {
        if (list == null || list == undefined) {
            return
        }
        for (var index in list) {
            let msg = list[index]
            getUser(msg.userID, user => {
                log('get user result',user,msg)
                if (user !== undefined) {
                    log('has user')
                    var userInfo = new proto.UserInfo()
                    userInfo.setId(user.userID)
                    userInfo.setName(user.name)
                    userInfo.setAvatar(user.avatar)


                    var messageData = new proto.MessageData()
                    messageData.setId(msg.msgID)
                    messageData.setStatus(msg.status)
                    messageData.setType(msg.type)
                    messageData.setData(msg.data)
                    messageData.setImgHeight(msg.imgHeight)
                    messageData.setImgWidth(msg.imgWidth)
                    messageData.setVoiceTime(msg.voiceTime)
                    messageData.setTime(msg.time)
                    messageData.setTargetId(userID)
                    messageData.setUserInfo(userInfo)


                    var message = new proto.Message()
                    message.setType(proto.Message.MessageType.MESSAGE)
                    message.setMessageData(messageData)

                    log('send message',message)

                    if (ws.readyState == 1) {
                        ws.send(message.serializeBinary())
                    }

                    messageData.setStatus(proto.MessageData.MessageStatus.READ)
                    message.setMessageData(messageData)
                    updateMessage(message,userID)
                }

            })

        }
    })



    ws.on('message', data => {
        log(data)

        let newData = new Uint8Array(data)
        var message = proto.Message.deserializeBinary(newData)
        if (message.getType() === proto.Message.MessageType.MESSAGE) {
            let messageData = message.getMessageData()

            let now = Date.now()
            let targetID = messageData.getTargetId()

            messageData.setId('id'+ now + targetID)
            messageData.setStatus(proto.MessageData.MessageStatus.UNREAD)

            var receive = new proto.ReceiveData()
            receive.setMessageId(messageData.getId())
            receive.setSendTime(messageData.getTime())


            receive.setReceiveTime(now)
            receive.setTargetId(targetID)


            var receiveMsg = new proto.Message()
            receiveMsg.setType(proto.Message.MessageType.RECEIVE)
            receiveMsg.setReceiveData(receive)

            if (ws.readyState === 1) {
                ws.send(receiveMsg.serializeBinary())
            }

            messageData.setTime(now)
            message.setMessageData(messageData)

            insertMessage(message, token)

            let targetWS = manager[targetID]
            if (_typeof(targetWS) == _typeof(ws) && targetWS.readyState === 1) {
                targetWS.send(message.serializeBinary())
                log('targetWS.....')
            } else  {
                // push
                getUser(targetID, dbuser => {
                    log('push ----',targetID, dbuser)
                    if (dbuser !== null && dbuser !== undefined && dbuser.userID == targetID) {
                        let token = dbuser.token
                        let body = getPushAlert(messageData)
                        let alert = {
                            title: messageData.getUserInfo().getName(),
                            body
                        }
                        log(token, alert)
                        APNPush(token,alert)
                    }
                })
            }
        } else if (message.getType() == proto.Message.MessageType.READ) {
            log('receive read')
            updateMessage(message,userID)
        }

    })

    ws.on('close', () => {
        console.log('disconnected');
        delete manager[[userID]]
    });

    ws.on('error', (e) => {
        delete manager[[userID]]
        log('ws error',e)
    })
})


getPushAlert = messageData => {
    let type = messageData.getType()

    if (type == proto.MessageData.MessageDataType.TEXT) {
        return messageData.getData()
    } else if (type == proto.MessageData.MessageDataType.VOICE) {
        return "[语音]"
    } else if (type == proto.MessageData.MessageDataType.IMAGE) {
        return "[图片]"
    }
}



var class2type = {} ;
"Boolean Number String Function Array Date RegExp Object Error".split(" ").forEach(function(e,i){
    class2type[ "[object " + e + "]" ] = e.toLowerCase();
}) ;
//当然为了兼容IE低版本，forEach需要一个polyfill，不作细谈了。
function _typeof(obj){
    if ( obj == null ){
        return String( obj );
    }
    return typeof obj === "object" || typeof obj === "function" ?
        class2type[ Object.prototype.toString.call(obj) ] || "object" :
        typeof obj;
}


log = (...msg) => {
    console.log(msg)
}
