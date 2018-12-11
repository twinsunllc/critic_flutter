import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:inventiv_critic_flutter/modal/bug_report.dart';
import 'package:inventiv_critic_flutter/modal/ping_request_modal.dart';
import 'package:inventiv_critic_flutter/modal/ping_response.dart';
import 'package:inventiv_critic_flutter/modal/report_request_modal.dart';

final String _apiUrl = ' https://critic.inventiv.io/api/v2';

class Api {
  static Future<AppInstall> ping(PingRequest report) async {
    return await http.post('$_apiUrl/ping', body: json.encode(report), headers: { HttpHeaders.contentTypeHeader: 'application/json' })
      .then((response) => AppInstall.fromJson(json.decode(response.body)));
  }

  static Future<BugReport> submitReport(BugReportRequest report) async {
    return await http.post('$_apiUrl/bug_reports', body: json.encode(report), headers: { HttpHeaders.contentTypeHeader: 'application/json' })
      .then((response) => BugReport.fromJson(json.decode(response.body)));
  }
}