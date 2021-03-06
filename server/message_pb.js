/**
 * @fileoverview
 * @enhanceable
 * @suppress {messageConventions} JS Compiler reports an error if a variable or
 *     field starts with 'MSG_' and isn't a translatable message.
 * @public
 */
// GENERATED CODE -- DO NOT EDIT!

var jspb = require('google-protobuf');
var goog = jspb;
var global = Function('return this')();

goog.exportSymbol('proto.Message', null, global);
goog.exportSymbol('proto.Message.MessageType', null, global);
goog.exportSymbol('proto.MessageData', null, global);
goog.exportSymbol('proto.MessageData.MessageDataType', null, global);
goog.exportSymbol('proto.MessageData.MessageStatus', null, global);
goog.exportSymbol('proto.ReadData', null, global);
goog.exportSymbol('proto.ReceiveData', null, global);
goog.exportSymbol('proto.UserInfo', null, global);

/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */
proto.Message = function(opt_data) {
  jspb.Message.initialize(this, opt_data, 0, -1, null, null);
};
goog.inherits(proto.Message, jspb.Message);
if (goog.DEBUG && !COMPILED) {
  proto.Message.displayName = 'proto.Message';
}


if (jspb.Message.GENERATE_TO_OBJECT) {
/**
 * Creates an object representation of this proto suitable for use in Soy templates.
 * Field names that are reserved in JavaScript and will be renamed to pb_name.
 * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
 * For the list of reserved names please see:
 *     com.google.apps.jspb.JsClassTemplate.JS_RESERVED_WORDS.
 * @param {boolean=} opt_includeInstance Whether to include the JSPB instance
 *     for transitional soy proto support: http://goto/soy-param-migration
 * @return {!Object}
 */
proto.Message.prototype.toObject = function(opt_includeInstance) {
  return proto.Message.toObject(opt_includeInstance, this);
};


/**
 * Static version of the {@see toObject} method.
 * @param {boolean|undefined} includeInstance Whether to include the JSPB
 *     instance for transitional soy proto support:
 *     http://goto/soy-param-migration
 * @param {!proto.Message} msg The msg instance to transform.
 * @return {!Object}
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.Message.toObject = function(includeInstance, msg) {
  var f, obj = {
    type: jspb.Message.getFieldWithDefault(msg, 1, 0),
    messageData: (f = msg.getMessageData()) && proto.MessageData.toObject(includeInstance, f),
    readData: (f = msg.getReadData()) && proto.ReadData.toObject(includeInstance, f),
    receiveData: (f = msg.getReceiveData()) && proto.ReceiveData.toObject(includeInstance, f),
    appId: jspb.Message.getFieldWithDefault(msg, 5, "")
  };

  if (includeInstance) {
    obj.$jspbMessageInstance = msg;
  }
  return obj;
};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.Message}
 */
proto.Message.deserializeBinary = function(bytes) {
  var reader = new jspb.BinaryReader(bytes);
  var msg = new proto.Message;
  return proto.Message.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.Message} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.Message}
 */
proto.Message.deserializeBinaryFromReader = function(msg, reader) {
  while (reader.nextField()) {
    if (reader.isEndGroup()) {
      break;
    }
    var field = reader.getFieldNumber();
    switch (field) {
    case 1:
      var value = /** @type {!proto.Message.MessageType} */ (reader.readEnum());
      msg.setType(value);
      break;
    case 2:
      var value = new proto.MessageData;
      reader.readMessage(value,proto.MessageData.deserializeBinaryFromReader);
      msg.setMessageData(value);
      break;
    case 3:
      var value = new proto.ReadData;
      reader.readMessage(value,proto.ReadData.deserializeBinaryFromReader);
      msg.setReadData(value);
      break;
    case 4:
      var value = new proto.ReceiveData;
      reader.readMessage(value,proto.ReceiveData.deserializeBinaryFromReader);
      msg.setReceiveData(value);
      break;
    case 5:
      var value = /** @type {string} */ (reader.readString());
      msg.setAppId(value);
      break;
    default:
      reader.skipField();
      break;
    }
  }
  return msg;
};


/**
 * Serializes the message to binary data (in protobuf wire format).
 * @return {!Uint8Array}
 */
proto.Message.prototype.serializeBinary = function() {
  var writer = new jspb.BinaryWriter();
  proto.Message.serializeBinaryToWriter(this, writer);
  return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.Message} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.Message.serializeBinaryToWriter = function(message, writer) {
  var f = undefined;
  f = message.getType();
  if (f !== 0.0) {
    writer.writeEnum(
      1,
      f
    );
  }
  f = message.getMessageData();
  if (f != null) {
    writer.writeMessage(
      2,
      f,
      proto.MessageData.serializeBinaryToWriter
    );
  }
  f = message.getReadData();
  if (f != null) {
    writer.writeMessage(
      3,
      f,
      proto.ReadData.serializeBinaryToWriter
    );
  }
  f = message.getReceiveData();
  if (f != null) {
    writer.writeMessage(
      4,
      f,
      proto.ReceiveData.serializeBinaryToWriter
    );
  }
  f = message.getAppId();
  if (f.length > 0) {
    writer.writeString(
      5,
      f
    );
  }
};


/**
 * @enum {number}
 */
proto.Message.MessageType = {
  NONE: 0,
  MESSAGE: 1,
  READ: 2,
  RECEIVE: 3,
  HEART: 4
};

/**
 * optional MessageType type = 1;
 * @return {!proto.Message.MessageType}
 */
proto.Message.prototype.getType = function() {
  return /** @type {!proto.Message.MessageType} */ (jspb.Message.getFieldWithDefault(this, 1, 0));
};


/** @param {!proto.Message.MessageType} value */
proto.Message.prototype.setType = function(value) {
  jspb.Message.setProto3EnumField(this, 1, value);
};


/**
 * optional MessageData message_data = 2;
 * @return {?proto.MessageData}
 */
proto.Message.prototype.getMessageData = function() {
  return /** @type{?proto.MessageData} */ (
    jspb.Message.getWrapperField(this, proto.MessageData, 2));
};


/** @param {?proto.MessageData|undefined} value */
proto.Message.prototype.setMessageData = function(value) {
  jspb.Message.setWrapperField(this, 2, value);
};


proto.Message.prototype.clearMessageData = function() {
  this.setMessageData(undefined);
};


/**
 * Returns whether this field is set.
 * @return {!boolean}
 */
proto.Message.prototype.hasMessageData = function() {
  return jspb.Message.getField(this, 2) != null;
};


/**
 * optional ReadData read_data = 3;
 * @return {?proto.ReadData}
 */
proto.Message.prototype.getReadData = function() {
  return /** @type{?proto.ReadData} */ (
    jspb.Message.getWrapperField(this, proto.ReadData, 3));
};


/** @param {?proto.ReadData|undefined} value */
proto.Message.prototype.setReadData = function(value) {
  jspb.Message.setWrapperField(this, 3, value);
};


proto.Message.prototype.clearReadData = function() {
  this.setReadData(undefined);
};


/**
 * Returns whether this field is set.
 * @return {!boolean}
 */
proto.Message.prototype.hasReadData = function() {
  return jspb.Message.getField(this, 3) != null;
};


/**
 * optional ReceiveData receive_data = 4;
 * @return {?proto.ReceiveData}
 */
proto.Message.prototype.getReceiveData = function() {
  return /** @type{?proto.ReceiveData} */ (
    jspb.Message.getWrapperField(this, proto.ReceiveData, 4));
};


/** @param {?proto.ReceiveData|undefined} value */
proto.Message.prototype.setReceiveData = function(value) {
  jspb.Message.setWrapperField(this, 4, value);
};


proto.Message.prototype.clearReceiveData = function() {
  this.setReceiveData(undefined);
};


/**
 * Returns whether this field is set.
 * @return {!boolean}
 */
proto.Message.prototype.hasReceiveData = function() {
  return jspb.Message.getField(this, 4) != null;
};


/**
 * optional string app_id = 5;
 * @return {string}
 */
proto.Message.prototype.getAppId = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 5, ""));
};


/** @param {string} value */
proto.Message.prototype.setAppId = function(value) {
  jspb.Message.setProto3StringField(this, 5, value);
};



/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */
proto.ReadData = function(opt_data) {
  jspb.Message.initialize(this, opt_data, 0, -1, null, null);
};
goog.inherits(proto.ReadData, jspb.Message);
if (goog.DEBUG && !COMPILED) {
  proto.ReadData.displayName = 'proto.ReadData';
}


if (jspb.Message.GENERATE_TO_OBJECT) {
/**
 * Creates an object representation of this proto suitable for use in Soy templates.
 * Field names that are reserved in JavaScript and will be renamed to pb_name.
 * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
 * For the list of reserved names please see:
 *     com.google.apps.jspb.JsClassTemplate.JS_RESERVED_WORDS.
 * @param {boolean=} opt_includeInstance Whether to include the JSPB instance
 *     for transitional soy proto support: http://goto/soy-param-migration
 * @return {!Object}
 */
proto.ReadData.prototype.toObject = function(opt_includeInstance) {
  return proto.ReadData.toObject(opt_includeInstance, this);
};


/**
 * Static version of the {@see toObject} method.
 * @param {boolean|undefined} includeInstance Whether to include the JSPB
 *     instance for transitional soy proto support:
 *     http://goto/soy-param-migration
 * @param {!proto.ReadData} msg The msg instance to transform.
 * @return {!Object}
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.ReadData.toObject = function(includeInstance, msg) {
  var f, obj = {
    messageId: jspb.Message.getFieldWithDefault(msg, 1, "")
  };

  if (includeInstance) {
    obj.$jspbMessageInstance = msg;
  }
  return obj;
};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.ReadData}
 */
proto.ReadData.deserializeBinary = function(bytes) {
  var reader = new jspb.BinaryReader(bytes);
  var msg = new proto.ReadData;
  return proto.ReadData.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.ReadData} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.ReadData}
 */
proto.ReadData.deserializeBinaryFromReader = function(msg, reader) {
  while (reader.nextField()) {
    if (reader.isEndGroup()) {
      break;
    }
    var field = reader.getFieldNumber();
    switch (field) {
    case 1:
      var value = /** @type {string} */ (reader.readString());
      msg.setMessageId(value);
      break;
    default:
      reader.skipField();
      break;
    }
  }
  return msg;
};


/**
 * Serializes the message to binary data (in protobuf wire format).
 * @return {!Uint8Array}
 */
proto.ReadData.prototype.serializeBinary = function() {
  var writer = new jspb.BinaryWriter();
  proto.ReadData.serializeBinaryToWriter(this, writer);
  return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.ReadData} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.ReadData.serializeBinaryToWriter = function(message, writer) {
  var f = undefined;
  f = message.getMessageId();
  if (f.length > 0) {
    writer.writeString(
      1,
      f
    );
  }
};


/**
 * optional string message_id = 1;
 * @return {string}
 */
proto.ReadData.prototype.getMessageId = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 1, ""));
};


/** @param {string} value */
proto.ReadData.prototype.setMessageId = function(value) {
  jspb.Message.setProto3StringField(this, 1, value);
};



/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */
proto.ReceiveData = function(opt_data) {
  jspb.Message.initialize(this, opt_data, 0, -1, null, null);
};
goog.inherits(proto.ReceiveData, jspb.Message);
if (goog.DEBUG && !COMPILED) {
  proto.ReceiveData.displayName = 'proto.ReceiveData';
}


if (jspb.Message.GENERATE_TO_OBJECT) {
/**
 * Creates an object representation of this proto suitable for use in Soy templates.
 * Field names that are reserved in JavaScript and will be renamed to pb_name.
 * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
 * For the list of reserved names please see:
 *     com.google.apps.jspb.JsClassTemplate.JS_RESERVED_WORDS.
 * @param {boolean=} opt_includeInstance Whether to include the JSPB instance
 *     for transitional soy proto support: http://goto/soy-param-migration
 * @return {!Object}
 */
proto.ReceiveData.prototype.toObject = function(opt_includeInstance) {
  return proto.ReceiveData.toObject(opt_includeInstance, this);
};


/**
 * Static version of the {@see toObject} method.
 * @param {boolean|undefined} includeInstance Whether to include the JSPB
 *     instance for transitional soy proto support:
 *     http://goto/soy-param-migration
 * @param {!proto.ReceiveData} msg The msg instance to transform.
 * @return {!Object}
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.ReceiveData.toObject = function(includeInstance, msg) {
  var f, obj = {
    messageId: jspb.Message.getFieldWithDefault(msg, 1, ""),
    sendTime: jspb.Message.getFieldWithDefault(msg, 2, 0),
    receiveTime: jspb.Message.getFieldWithDefault(msg, 3, 0),
    targetId: jspb.Message.getFieldWithDefault(msg, 4, "")
  };

  if (includeInstance) {
    obj.$jspbMessageInstance = msg;
  }
  return obj;
};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.ReceiveData}
 */
proto.ReceiveData.deserializeBinary = function(bytes) {
  var reader = new jspb.BinaryReader(bytes);
  var msg = new proto.ReceiveData;
  return proto.ReceiveData.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.ReceiveData} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.ReceiveData}
 */
proto.ReceiveData.deserializeBinaryFromReader = function(msg, reader) {
  while (reader.nextField()) {
    if (reader.isEndGroup()) {
      break;
    }
    var field = reader.getFieldNumber();
    switch (field) {
    case 1:
      var value = /** @type {string} */ (reader.readString());
      msg.setMessageId(value);
      break;
    case 2:
      var value = /** @type {number} */ (reader.readUint64());
      msg.setSendTime(value);
      break;
    case 3:
      var value = /** @type {number} */ (reader.readUint64());
      msg.setReceiveTime(value);
      break;
    case 4:
      var value = /** @type {string} */ (reader.readString());
      msg.setTargetId(value);
      break;
    default:
      reader.skipField();
      break;
    }
  }
  return msg;
};


/**
 * Serializes the message to binary data (in protobuf wire format).
 * @return {!Uint8Array}
 */
proto.ReceiveData.prototype.serializeBinary = function() {
  var writer = new jspb.BinaryWriter();
  proto.ReceiveData.serializeBinaryToWriter(this, writer);
  return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.ReceiveData} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.ReceiveData.serializeBinaryToWriter = function(message, writer) {
  var f = undefined;
  f = message.getMessageId();
  if (f.length > 0) {
    writer.writeString(
      1,
      f
    );
  }
  f = message.getSendTime();
  if (f !== 0) {
    writer.writeUint64(
      2,
      f
    );
  }
  f = message.getReceiveTime();
  if (f !== 0) {
    writer.writeUint64(
      3,
      f
    );
  }
  f = message.getTargetId();
  if (f.length > 0) {
    writer.writeString(
      4,
      f
    );
  }
};


/**
 * optional string message_id = 1;
 * @return {string}
 */
proto.ReceiveData.prototype.getMessageId = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 1, ""));
};


/** @param {string} value */
proto.ReceiveData.prototype.setMessageId = function(value) {
  jspb.Message.setProto3StringField(this, 1, value);
};


/**
 * optional uint64 send_time = 2;
 * @return {number}
 */
proto.ReceiveData.prototype.getSendTime = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 2, 0));
};


/** @param {number} value */
proto.ReceiveData.prototype.setSendTime = function(value) {
  jspb.Message.setProto3IntField(this, 2, value);
};


/**
 * optional uint64 receive_time = 3;
 * @return {number}
 */
proto.ReceiveData.prototype.getReceiveTime = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 3, 0));
};


/** @param {number} value */
proto.ReceiveData.prototype.setReceiveTime = function(value) {
  jspb.Message.setProto3IntField(this, 3, value);
};


/**
 * optional string target_id = 4;
 * @return {string}
 */
proto.ReceiveData.prototype.getTargetId = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 4, ""));
};


/** @param {string} value */
proto.ReceiveData.prototype.setTargetId = function(value) {
  jspb.Message.setProto3StringField(this, 4, value);
};



/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */
proto.MessageData = function(opt_data) {
  jspb.Message.initialize(this, opt_data, 0, -1, null, null);
};
goog.inherits(proto.MessageData, jspb.Message);
if (goog.DEBUG && !COMPILED) {
  proto.MessageData.displayName = 'proto.MessageData';
}


if (jspb.Message.GENERATE_TO_OBJECT) {
/**
 * Creates an object representation of this proto suitable for use in Soy templates.
 * Field names that are reserved in JavaScript and will be renamed to pb_name.
 * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
 * For the list of reserved names please see:
 *     com.google.apps.jspb.JsClassTemplate.JS_RESERVED_WORDS.
 * @param {boolean=} opt_includeInstance Whether to include the JSPB instance
 *     for transitional soy proto support: http://goto/soy-param-migration
 * @return {!Object}
 */
proto.MessageData.prototype.toObject = function(opt_includeInstance) {
  return proto.MessageData.toObject(opt_includeInstance, this);
};


/**
 * Static version of the {@see toObject} method.
 * @param {boolean|undefined} includeInstance Whether to include the JSPB
 *     instance for transitional soy proto support:
 *     http://goto/soy-param-migration
 * @param {!proto.MessageData} msg The msg instance to transform.
 * @return {!Object}
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.MessageData.toObject = function(includeInstance, msg) {
  var f, obj = {
    data: jspb.Message.getFieldWithDefault(msg, 1, ""),
    type: jspb.Message.getFieldWithDefault(msg, 2, 0),
    targetId: jspb.Message.getFieldWithDefault(msg, 3, ""),
    time: jspb.Message.getFieldWithDefault(msg, 4, 0),
    status: jspb.Message.getFieldWithDefault(msg, 5, 0),
    userInfo: (f = msg.getUserInfo()) && proto.UserInfo.toObject(includeInstance, f),
    id: jspb.Message.getFieldWithDefault(msg, 7, ""),
    imgHeight: jspb.Message.getFieldWithDefault(msg, 8, 0),
    imgWidth: jspb.Message.getFieldWithDefault(msg, 9, 0),
    voiceTime: jspb.Message.getFieldWithDefault(msg, 10, 0)
  };

  if (includeInstance) {
    obj.$jspbMessageInstance = msg;
  }
  return obj;
};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.MessageData}
 */
proto.MessageData.deserializeBinary = function(bytes) {
  var reader = new jspb.BinaryReader(bytes);
  var msg = new proto.MessageData;
  return proto.MessageData.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.MessageData} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.MessageData}
 */
proto.MessageData.deserializeBinaryFromReader = function(msg, reader) {
  while (reader.nextField()) {
    if (reader.isEndGroup()) {
      break;
    }
    var field = reader.getFieldNumber();
    switch (field) {
    case 1:
      var value = /** @type {string} */ (reader.readString());
      msg.setData(value);
      break;
    case 2:
      var value = /** @type {!proto.MessageData.MessageDataType} */ (reader.readEnum());
      msg.setType(value);
      break;
    case 3:
      var value = /** @type {string} */ (reader.readString());
      msg.setTargetId(value);
      break;
    case 4:
      var value = /** @type {number} */ (reader.readUint64());
      msg.setTime(value);
      break;
    case 5:
      var value = /** @type {!proto.MessageData.MessageStatus} */ (reader.readEnum());
      msg.setStatus(value);
      break;
    case 6:
      var value = new proto.UserInfo;
      reader.readMessage(value,proto.UserInfo.deserializeBinaryFromReader);
      msg.setUserInfo(value);
      break;
    case 7:
      var value = /** @type {string} */ (reader.readString());
      msg.setId(value);
      break;
    case 8:
      var value = /** @type {number} */ (reader.readUint32());
      msg.setImgHeight(value);
      break;
    case 9:
      var value = /** @type {number} */ (reader.readUint32());
      msg.setImgWidth(value);
      break;
    case 10:
      var value = /** @type {number} */ (reader.readUint32());
      msg.setVoiceTime(value);
      break;
    default:
      reader.skipField();
      break;
    }
  }
  return msg;
};


/**
 * Serializes the message to binary data (in protobuf wire format).
 * @return {!Uint8Array}
 */
proto.MessageData.prototype.serializeBinary = function() {
  var writer = new jspb.BinaryWriter();
  proto.MessageData.serializeBinaryToWriter(this, writer);
  return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.MessageData} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.MessageData.serializeBinaryToWriter = function(message, writer) {
  var f = undefined;
  f = message.getData();
  if (f.length > 0) {
    writer.writeString(
      1,
      f
    );
  }
  f = message.getType();
  if (f !== 0.0) {
    writer.writeEnum(
      2,
      f
    );
  }
  f = message.getTargetId();
  if (f.length > 0) {
    writer.writeString(
      3,
      f
    );
  }
  f = message.getTime();
  if (f !== 0) {
    writer.writeUint64(
      4,
      f
    );
  }
  f = message.getStatus();
  if (f !== 0.0) {
    writer.writeEnum(
      5,
      f
    );
  }
  f = message.getUserInfo();
  if (f != null) {
    writer.writeMessage(
      6,
      f,
      proto.UserInfo.serializeBinaryToWriter
    );
  }
  f = message.getId();
  if (f.length > 0) {
    writer.writeString(
      7,
      f
    );
  }
  f = message.getImgHeight();
  if (f !== 0) {
    writer.writeUint32(
      8,
      f
    );
  }
  f = message.getImgWidth();
  if (f !== 0) {
    writer.writeUint32(
      9,
      f
    );
  }
  f = message.getVoiceTime();
  if (f !== 0) {
    writer.writeUint32(
      10,
      f
    );
  }
};


/**
 * @enum {number}
 */
proto.MessageData.MessageDataType = {
  NONE: 0,
  TEXT: 1,
  IMAGE: 2,
  VOICE: 3
};

/**
 * @enum {number}
 */
proto.MessageData.MessageStatus = {
  NONESTATUS: 0,
  UNREAD: 3,
  READ: 4
};

/**
 * optional string data = 1;
 * @return {string}
 */
proto.MessageData.prototype.getData = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 1, ""));
};


/** @param {string} value */
proto.MessageData.prototype.setData = function(value) {
  jspb.Message.setProto3StringField(this, 1, value);
};


/**
 * optional MessageDataType type = 2;
 * @return {!proto.MessageData.MessageDataType}
 */
proto.MessageData.prototype.getType = function() {
  return /** @type {!proto.MessageData.MessageDataType} */ (jspb.Message.getFieldWithDefault(this, 2, 0));
};


/** @param {!proto.MessageData.MessageDataType} value */
proto.MessageData.prototype.setType = function(value) {
  jspb.Message.setProto3EnumField(this, 2, value);
};


/**
 * optional string target_id = 3;
 * @return {string}
 */
proto.MessageData.prototype.getTargetId = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 3, ""));
};


/** @param {string} value */
proto.MessageData.prototype.setTargetId = function(value) {
  jspb.Message.setProto3StringField(this, 3, value);
};


/**
 * optional uint64 time = 4;
 * @return {number}
 */
proto.MessageData.prototype.getTime = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 4, 0));
};


/** @param {number} value */
proto.MessageData.prototype.setTime = function(value) {
  jspb.Message.setProto3IntField(this, 4, value);
};


/**
 * optional MessageStatus status = 5;
 * @return {!proto.MessageData.MessageStatus}
 */
proto.MessageData.prototype.getStatus = function() {
  return /** @type {!proto.MessageData.MessageStatus} */ (jspb.Message.getFieldWithDefault(this, 5, 0));
};


/** @param {!proto.MessageData.MessageStatus} value */
proto.MessageData.prototype.setStatus = function(value) {
  jspb.Message.setProto3EnumField(this, 5, value);
};


/**
 * optional UserInfo user_info = 6;
 * @return {?proto.UserInfo}
 */
proto.MessageData.prototype.getUserInfo = function() {
  return /** @type{?proto.UserInfo} */ (
    jspb.Message.getWrapperField(this, proto.UserInfo, 6));
};


/** @param {?proto.UserInfo|undefined} value */
proto.MessageData.prototype.setUserInfo = function(value) {
  jspb.Message.setWrapperField(this, 6, value);
};


proto.MessageData.prototype.clearUserInfo = function() {
  this.setUserInfo(undefined);
};


/**
 * Returns whether this field is set.
 * @return {!boolean}
 */
proto.MessageData.prototype.hasUserInfo = function() {
  return jspb.Message.getField(this, 6) != null;
};


/**
 * optional string id = 7;
 * @return {string}
 */
proto.MessageData.prototype.getId = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 7, ""));
};


/** @param {string} value */
proto.MessageData.prototype.setId = function(value) {
  jspb.Message.setProto3StringField(this, 7, value);
};


/**
 * optional uint32 img_height = 8;
 * @return {number}
 */
proto.MessageData.prototype.getImgHeight = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 8, 0));
};


/** @param {number} value */
proto.MessageData.prototype.setImgHeight = function(value) {
  jspb.Message.setProto3IntField(this, 8, value);
};


/**
 * optional uint32 img_width = 9;
 * @return {number}
 */
proto.MessageData.prototype.getImgWidth = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 9, 0));
};


/** @param {number} value */
proto.MessageData.prototype.setImgWidth = function(value) {
  jspb.Message.setProto3IntField(this, 9, value);
};


/**
 * optional uint32 voice_time = 10;
 * @return {number}
 */
proto.MessageData.prototype.getVoiceTime = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 10, 0));
};


/** @param {number} value */
proto.MessageData.prototype.setVoiceTime = function(value) {
  jspb.Message.setProto3IntField(this, 10, value);
};



/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */
proto.UserInfo = function(opt_data) {
  jspb.Message.initialize(this, opt_data, 0, -1, null, null);
};
goog.inherits(proto.UserInfo, jspb.Message);
if (goog.DEBUG && !COMPILED) {
  proto.UserInfo.displayName = 'proto.UserInfo';
}


if (jspb.Message.GENERATE_TO_OBJECT) {
/**
 * Creates an object representation of this proto suitable for use in Soy templates.
 * Field names that are reserved in JavaScript and will be renamed to pb_name.
 * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
 * For the list of reserved names please see:
 *     com.google.apps.jspb.JsClassTemplate.JS_RESERVED_WORDS.
 * @param {boolean=} opt_includeInstance Whether to include the JSPB instance
 *     for transitional soy proto support: http://goto/soy-param-migration
 * @return {!Object}
 */
proto.UserInfo.prototype.toObject = function(opt_includeInstance) {
  return proto.UserInfo.toObject(opt_includeInstance, this);
};


/**
 * Static version of the {@see toObject} method.
 * @param {boolean|undefined} includeInstance Whether to include the JSPB
 *     instance for transitional soy proto support:
 *     http://goto/soy-param-migration
 * @param {!proto.UserInfo} msg The msg instance to transform.
 * @return {!Object}
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.UserInfo.toObject = function(includeInstance, msg) {
  var f, obj = {
    id: jspb.Message.getFieldWithDefault(msg, 1, ""),
    name: jspb.Message.getFieldWithDefault(msg, 2, ""),
    avatar: jspb.Message.getFieldWithDefault(msg, 3, "")
  };

  if (includeInstance) {
    obj.$jspbMessageInstance = msg;
  }
  return obj;
};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.UserInfo}
 */
proto.UserInfo.deserializeBinary = function(bytes) {
  var reader = new jspb.BinaryReader(bytes);
  var msg = new proto.UserInfo;
  return proto.UserInfo.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.UserInfo} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.UserInfo}
 */
proto.UserInfo.deserializeBinaryFromReader = function(msg, reader) {
  while (reader.nextField()) {
    if (reader.isEndGroup()) {
      break;
    }
    var field = reader.getFieldNumber();
    switch (field) {
    case 1:
      var value = /** @type {string} */ (reader.readString());
      msg.setId(value);
      break;
    case 2:
      var value = /** @type {string} */ (reader.readString());
      msg.setName(value);
      break;
    case 3:
      var value = /** @type {string} */ (reader.readString());
      msg.setAvatar(value);
      break;
    default:
      reader.skipField();
      break;
    }
  }
  return msg;
};


/**
 * Serializes the message to binary data (in protobuf wire format).
 * @return {!Uint8Array}
 */
proto.UserInfo.prototype.serializeBinary = function() {
  var writer = new jspb.BinaryWriter();
  proto.UserInfo.serializeBinaryToWriter(this, writer);
  return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.UserInfo} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.UserInfo.serializeBinaryToWriter = function(message, writer) {
  var f = undefined;
  f = message.getId();
  if (f.length > 0) {
    writer.writeString(
      1,
      f
    );
  }
  f = message.getName();
  if (f.length > 0) {
    writer.writeString(
      2,
      f
    );
  }
  f = message.getAvatar();
  if (f.length > 0) {
    writer.writeString(
      3,
      f
    );
  }
};


/**
 * optional string id = 1;
 * @return {string}
 */
proto.UserInfo.prototype.getId = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 1, ""));
};


/** @param {string} value */
proto.UserInfo.prototype.setId = function(value) {
  jspb.Message.setProto3StringField(this, 1, value);
};


/**
 * optional string name = 2;
 * @return {string}
 */
proto.UserInfo.prototype.getName = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 2, ""));
};


/** @param {string} value */
proto.UserInfo.prototype.setName = function(value) {
  jspb.Message.setProto3StringField(this, 2, value);
};


/**
 * optional string avatar = 3;
 * @return {string}
 */
proto.UserInfo.prototype.getAvatar = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 3, ""));
};


/** @param {string} value */
proto.UserInfo.prototype.setAvatar = function(value) {
  jspb.Message.setProto3StringField(this, 3, value);
};


goog.object.extend(exports, proto);
