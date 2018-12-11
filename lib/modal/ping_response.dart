class AppInstall{
  int id;

  AppInstall({this.id});

  factory AppInstall.fromJson(Map<String,dynamic> jsonBody){
    Map<String,dynamic> json = jsonBody['app_install'];
    return AppInstall(
      id: json['id'],
    );
  }
}