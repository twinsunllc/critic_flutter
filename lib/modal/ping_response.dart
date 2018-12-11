class PingResponse{
  int id;

  PingResponse({this.id});

  factory PingResponse.fromJson(Map<String,dynamic> jsonBody){
    Map<String,dynamic> json = jsonBody['app_install'];
    return PingResponse(
      id: json['id'],
    );
  }
}