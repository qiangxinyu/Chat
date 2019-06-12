var apn = require('apn');
var options = {
    token: {
        key: "./AuthKey_743PGG5TNZ.p8",
        keyId: "743PGG5TNZ",
        teamId: "VVK7LQ64A3"
    },
    production: false
};
var apnProvider = new apn.Provider(options);



APNPush = (token, alert) => {
    var note = new apn.Notification();

    note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
    note.badge = 1;
    note.sound = "ping.aiff";
    note.alert = alert
    note.content =
    note.payload = {'messageFrom': 'Chat Server'};
    note.topic = "com.qxy.testchat";

    apnProvider.send(note, token).then( (result) => {
        // see documentation for an explanation of result
        log('push result',result)
    });
}


module.exports = APNPush
