import 'package:inventiv_critic_flutter/modal/bug_report.dart';
import 'package:meta/meta.dart';

class BugReportRequest{
  String apiToken;
  BugReport report;

  BugReportRequest({@required this.apiToken, @required this.report});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'api_token': apiToken,
    'bug_report': report,
  };
}