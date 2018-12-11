
import 'package:flutter/foundation.dart';

class BugReport{
  String description, stepsToReproduce, userIdentifier, createdAt, updatedAt;
  List<Attachment> attachments;

  BugReport({this.description, this.stepsToReproduce, this.userIdentifier, this.createdAt, this.updatedAt, this.attachments});

  BugReport.create({@required this.description, @required this.stepsToReproduce, this.userIdentifier = 'No user id provided'})
    : assert (description != null), assert(stepsToReproduce != null), assert (userIdentifier != null);

  factory BugReport.fromJson(Map<String,dynamic> json){
    return BugReport(
      description: json['description'],
      stepsToReproduce: json['steps_to_reproduce'],
      userIdentifier: json['user_identifier'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      attachments: Attachment.fromList(json['atachments']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'description': description,
    'steps_to_reproduce': stepsToReproduce,
    'user_identifier': userIdentifier,
  };
}

class Attachment{
  String name, size, type, uploadedAt, url;

  Attachment({this.name, this.size, this.type, this.uploadedAt, this.url});

  factory Attachment.fromJson(Map<String,dynamic> json){
    return Attachment(
      name: json['file_file_name'],
      size: json['file_file_size'],
      type: json['file_content_type'],
      uploadedAt: json['file_updated_at'],
      url: json['file_url'],
    );
  }

  static List<Attachment> fromList(List<dynamic> items) {
    final List<Attachment> attachments = <Attachment>[];
    if(items == null){
      return attachments;
    }
    for (final dynamic item in items) {
      attachments.add(new Attachment.fromJson(item));
    }
    return attachments;
  }
}