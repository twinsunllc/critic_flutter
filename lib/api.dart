import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:inventiv_critic_flutter/modal/bug_report.dart';
import 'package:inventiv_critic_flutter/modal/ping_request_modal.dart';
import 'package:inventiv_critic_flutter/modal/ping_response.dart';
import 'package:inventiv_critic_flutter/modal/report_request_modal.dart';

final String _apiUrl = 'https://critic.inventiv.io/api/v2';

class Api {
  static Future<AppInstall> ping(PingRequest pingRequest) async {
    return await http.post('$_apiUrl/ping', body: json.encode(pingRequest.toJson()), headers: { HttpHeaders.contentTypeHeader: 'application/json' })
      .then((response){
        if(response.statusCode == 200){
          return AppInstall.fromJson(json.decode(response.body));
        } else {
          throw Exception('Response code: ' + response.statusCode.toString() + ', ' + response.body);
        }
      });
  }

  static Future<BugReport> submitReport(BugReportRequest submitReportRequest) async {
    return await http.post('$_apiUrl/bug_reports', body: json.encode(submitReportRequest.toJson()), headers: { HttpHeaders.contentTypeHeader: 'application/json' })
      .then((response){
        return BugReport.fromJson(json.decode(response.body));
      });
  }
}