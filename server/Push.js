var apn = require('apn');
var options = {
    token: {
        key: "./AuthKey_SM8377RTEK.p8",
        keyId: "SM8377RTEK",
        teamId: "UAA3E7W55E"
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
