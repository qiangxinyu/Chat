var mysql = require('mysql');
var proto = require('./message_pb')

var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : 'qiangxinyu',
    database : 'Chat'
});

connection.connect(err => {
    if (err) {
        console.error('error connecting: ' + err.stack);
        return;
    }

    console.log('connected as id ' + connection.threadId);
});

//INSERT INTO chat_2 SEL `time` = 1515728536501, `data` = 'D', `id` = '', `type` = 1, `status` = 1, `imgHeight` = 0, `imgWidth` = 0, `voiceTime` = 0, `userID` = '2', `userName` = 'qxy', `userAvatar` = 'https://avatars3.githubusercontent.com/u/13347582?s=460&v=4'
//INSERT INTO posts SET `id` = 1, `title` = 'Hello MySQL'


var insertMessage = (message, token) => {
    if (message.getType() == proto.Message.MessageType.MESSAGE) {
        let messageData = message.getMessageData()
        let userInfo = messageData.getUserInfo()
        let targetID = messageData.getTargetId()

        let tableName = getTableName(targetID)

        var post = {
            time:messageData.getTime(),
            data:messageData.getData(),
            msgID:messageData.getId(),
            type:messageData.getType(),
            status:messageData.getStatus(),
            imgHeight:messageData.getImgHeight(),
            imgWidth:messageData.getImgWidth(),
            voiceTime:messageData.getVoiceTime(),
            userID:userInfo.getId(),
        }


        connection.query('CREATE TABLE ' + tableName + ' (' +
            '  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,' +
            '  `time` char(20) DEFAULT NULL,' +
            '  `data` char(255) DEFAULT NULL,' +
            '  `msgID` char(50) DEFAULT NULL,' +
            '  `type` int(11) DEFAULT NULL,' +
            '  `status` int(11) DEFAULT NULL,' +
            '  `imgHeight` int(11) DEFAULT NULL,' +
            '  `imgWidth` int(11) DEFAULT NULL,' +
            '  `voiceTime` int(11) DEFAULT NULL,' +
            '  `userID` char(20) DEFAULT NULL,' +
            '  PRIMARY KEY (`id`)' +
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8', (error, results, field) => {
            log(error,results,field)
        })

        connection.query('INSERT INTO ' + tableName + ' SET ?',post, (error, results, field) => {
            log('INSERT message',error,results,field)
        })

        updateUser(userInfo, token)
    }
}


var updateMessage = (message, userID) => {
    if (message.getType() == proto.Message.MessageType.READ) {
        let readData = message.getReadData()

        let messageID = readData.getMessageId()

        connection.query(
            'UPDATE  ' + getTableName(userID) + ' SET ? WHERE msgID = \'' + messageID + '\'',
            {status: proto.MessageData.MessageStatus.READ},
            (error, results, field) => {
            log(error,results,field)
        })
    }
}


var getUnreadMessages = (userID, result) => {
    connection.query('SELECT * FROM ' + getTableName(userID) + ' WHERE  status = ' + proto.MessageData.MessageStatus.UNREAD,
        (error, results, field) => {
            log('getUnreadMessages',error,results,field)
            if (results == undefined) {
                result()
            } else {
                result(results)
            }
        })
}

let userTableName = '`users`'


var insertUser = (userInfo, token) => {


    connection.query('CREATE TABLE ' + userTableName + ' (' +
        '  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,' +
        '  `userID` char(255) DEFAULT NULL,' +
        '  `token` char(255) DEFAULT NULL,' +
        '  `name` char(255) DEFAULT NULL,' +
        '  `avatar` char(255) DEFAULT NULL,' +
        '  PRIMARY KEY (`id`)' +
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8', (error, results, field) => {
        log(error,results,field)
    })


    var post = {
        userID:userInfo.getId(),
        name:userInfo.getName(),
        avatar:userInfo.getAvatar(),
        token
    }

    connection.query('INSERT INTO ' + userTableName + ' SET ?',post, (error, results, field) => {
        log(error,results,field)
    })
}

var updateUser = (userInfo, token) => {
    let userID = userInfo.getId()

    getUser(userID, dbuser => {
        log('updateUser - dbuser',dbuser,userID)
        if (dbuser !== undefined && dbuser !== null && dbuser.userID == userID) {
            var post = {
                name:userInfo.getName(),
                avatar:userInfo.getAvatar(),
                token
            }

            connection.query('UPDATE ' + userTableName + ' SET ? WHERE userID = ' + userID,post, (error, results, field) => {
                log('updateUser',error,results,field)
            })
        } else  {
            insertUser(userInfo, token)
        }
    })

}

var getUser = (userID, result) => {
    log('getUser begain')
    connection.query('SELECT * FROM ' + userTableName + ' WHERE userID = ' + userID, (error, results, field) => {
        log('getUser',error,results,field)
        if (results == undefined) {
            result()
        } else {
            let user = results[0]
            result(user)
        }
    })
}



var getTableName = id => {
    return '`chat_' + id + '`'
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

module.exports = {insertMessage, updateMessage, getUser, updateUser, getUnreadMessages}


