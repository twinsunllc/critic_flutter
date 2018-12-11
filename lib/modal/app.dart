import 'package:flutter/foundation.dart';

class App{
  String name, package, platform;
  _Version version;

  App({this.name, this.package, this.platform, this.version});

  factory App.create({@required String name, @required String package, @required String platform, String versionCode, String versionName}){
    _Version version = new _Version(code: versionCode, name: versionName);
    return App(name: name, package: package, platform: platform, version: version);
  }

  factory App.fromJson(Map<String,dynamic> json){
    return App(
      name: json['name'],
      package: json['package'],
      platform: json['platform'],
      version: _Version.fromJson(json['version']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'package': package,
    'platform': platform,
    'version': version.toJson(),
  };
}

class _Version{
  String code, name;

  _Version({this.code, this.name});

  factory _Version.fromJson(Map<String,dynamic> json){
    return _Version(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'name': name,
  };
}