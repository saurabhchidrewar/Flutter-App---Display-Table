import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Customer {
  String baseUrl = "http://10.0.2.2:3000/";
  Future<List> getAllCustomers() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
