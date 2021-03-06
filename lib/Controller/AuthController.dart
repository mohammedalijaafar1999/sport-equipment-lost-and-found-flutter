import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sports_equipment_lost_and_found_it_project/Model/User.dart';
import '../../Utils/Globals.dart' as globals;

class AuthController {
  Future<bool> checkTokenValidity(var token) async {
    //get saved token
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");

    //use token to check validity of it
    var response = await http.get(
      Uri.parse(globals.hostname + '/api/user/getEquipments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    //check validity of token
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return false;
    } else {
      return true;
    }
  }

  //get the saved token on the device
  Future<bool> getToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    //check if there is saved token before
    var tokenExists = token != null && token != "";

    if (tokenExists) {
      //check if the token is still valid in the api
      bool validToken = await checkTokenValidity(token);
      if (validToken) {
        // take user to the home page
        return true;
      } else {
        // take user to the Login page
        return false;
      }
    } else {
      // take user to the Login page
      return false;
    }
  }

  Future<bool> register(
      String name, String email, String phone, String password) async {
    var response = await http.post(
      Uri.parse(globals.hostname + '/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'mobile_number': phone,
        'password': password,
      }),
    );

    print(response.body);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse(globals.hostname + '/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'token', value: data["token"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> logout() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");

    await http.post(
      Uri.parse(globals.hostname + '/api/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    await storage.delete(key: 'token');
    return true;
  }

  Future<User> getUser() async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");

      var res = await http.get(
        Uri.parse(globals.hostname + '/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      User user = User.fromJson(jsonDecode(res.body));

      return user;
    } catch (e) {
      print(e.toString());
      return User();
    }
  }

  Future<http.Response> updateUserContacts(String name, String phone) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");

      var response = await http.post(
        Uri.parse(globals.hostname + '/api/user/edit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'mobile_number': phone,
        }),
      );

      print(response.body);

      return response;
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<http.Response?> changePassword(String name, String phone,
      String currentPassword, String newPassword) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "token");

      var response = await http.post(
        Uri.parse(globals.hostname + '/api/user/edit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'mobile_number': phone,
        }),
      );

      print(response.body);

      return response;
    } catch (e) {
      print(e.toString());
    }
  }
}
