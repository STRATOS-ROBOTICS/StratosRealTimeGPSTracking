import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Employees.dart';

class Services {
  static const ROOT =
      'https://foodfast001.000webhostapp.com//employee_actions2.php';
  static const String _GET_ACTION = 'GET_ALL';
  static const String _CREATE_TABLE = 'CREATE_TABLE';
  static const String _ADD_EMP_ACTION = 'ADD_EMP';
  static const String _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const String _DELETE_EMP_ACTION = 'DELETE_EMP';

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _GET_ACTION;
      final response = await http.post(ROOT, body: map);
      print("getEmployees >> Response:: ${response.body}");
      if (response.statusCode == 200) {
        List<Employee> list = parsePhotos(response.body);
        return list;
      } else {
        throw <Employee>[];
      }
    } catch (e) {
      return <Employee>[];
    }
  }

  static List<Employee> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  static Future<String> createTable() async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _CREATE_TABLE;
      final response = await http.post(ROOT, body: map);
      print("createTable >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> addEmployee(String firstName, String lastName) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _ADD_EMP_ACTION;
      map["lat"] = firstName;
      map["lng"] = lastName;
      final response = await http.post(ROOT, body: map);
      print("addEmployee >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> addPostion(String firstName, String lastName) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _ADD_EMP_ACTION;
      map["lat"] = firstName;
      map["lng"] = lastName;
      final response = await http.post(ROOT, body: map);
      print("addEmployee >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> updateEmployee(
      String empId, String firstName, String lastName) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _UPDATE_EMP_ACTION;
      map["emp_id"] = empId;
      map["lat"] = firstName;
      map["lng"] = lastName;
      final response = await http.post(ROOT, body: map);
      print("deleteEmployee >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _DELETE_EMP_ACTION;
      map["emp_id"] = empId;
      final response = await http.post(ROOT, body: map);
      print("deleteEmployee >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }
}
