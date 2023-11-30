import 'dart:convert';

Request? requestFromJson(String str) {
  try {
    return Request.fromJson(json.decode(str));
  } catch (e) {
    print(
        '--------------------------------------------------------------------------------------');
    print('Error $e');
    print(
        '--------------------------------------------------------------------------------------');
    return null;
  }
}

String requestToJson(Request data) => json.encode(data.toJson());

class Request {
  Message message;

  Request({
    required this.message,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    message: Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
  };
}

class Message {
  String latUser;
  String lngUser;
  String latScene;
  String lngScene;
  String latAmb;
  String lngAmb;

  Message({
    required this.latUser,
    required this.lngUser,
    required this.latScene,
    required this.lngScene,
    required this.latAmb,
    required this.lngAmb,

  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(

    latUser: json["latUser"],
    lngUser: json["lngUser"],
    latScene: json["latScene"],
    lngScene: json["lngScene"],
    latAmb: json["latAmb"],
    lngAmb:json["lngAmb"],
  );

  Map<String, dynamic> toJson() => {
    "latUser": latUser,
    "lngUser": lngUser,
    "latScene": latScene,
    "lngScene": lngScene,
    "latAmb":latAmb,
    "lngAmb":latAmb,
  };
}

