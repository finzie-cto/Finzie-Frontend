import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finzie/providers/user_provider.dart';
import 'package:finzie/screens/home_screen.dart';
import 'package:finzie/screens/screens.dart';
import 'package:finzie/utils/utils.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        phone: phone,
        token: '',
        password: password,
      );

      http.Response response = await http.post(
        Uri.parse('${Constants.uri}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'OTP sent',
          );
          Navigator.pushNamed(context, "otp",
              arguments: {"phone": phone, "password": password});
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "signUp");
    }
  }

  void createUser({
    required BuildContext context,
    required String phone,
    required String otp,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('${Constants.uri}/api/otp');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {"phone": phone, "otp": otp};
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('phone', phone);

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, "salary", arguments: {
            "phone": phone,
            "password": password,
          });
          // ignore: use_build_context_synchronously
          showSnackBar(
            context,
            'User created, login with the same credentials',
          );
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "createUser");
    }
  }

  void editUser(
      {required BuildContext context,
      required String name,
      required String email,
      required String password,
      required String phone}) async {
    try {
      final uri = Uri.parse('${Constants.uri}/api/editUser');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "name": name,
        'email': email,
        "password": password,
        "phone": phone
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          // ignore: use_build_context_synchronously
          showSnackBar(context, "Profile updated");
          print('profile updated');
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "editUser");
    }
  }

  void editTransaction(String _id,
      {required BuildContext context,
      required String debit,
      required String credit,
      required String timestamp,
      required String category,
      required String phone}) async {
    try {
      final uri = Uri.parse('${Constants.uri}/api/editTransaction');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "debit": debit,
        "credit": credit,
        "timestamp": timestamp,
        "category": category,
        "_id": _id,
        "phone": phone,
      };

      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          // ignore: use_build_context_synchronously
          showSnackBar(context, "Transaction updated");
          print('transaction updated');
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, "editTransaction");
    }
  }

  void resendOTP({
    required BuildContext context,
    required String phone,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response response = await http.post(
        Uri.parse('${Constants.uri}/api/resendOTP'),
        body: jsonEncode(
          {
            "phone": phone,
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          // ignore: use_build_context_synchronously
          showSnackBar(
            context,
            'OTP sent',
          );
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "resendOTP");
    }
  }

  void signInUser(
      {required BuildContext context,
      required String phone,
      required String password}) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response response = await http.post(
        Uri.parse('${Constants.uri}/api/signin'),
        body: jsonEncode(
          {
            "phone": phone,
            "password": password,
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userProvider.setUser(response.body);
          await prefs.setString(
              'x-auth-token', jsonDecode(response.body)['token']);
          await prefs.setString('phone', phone);

          navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
          // ignore: use_build_context_synchronously
          showSnackBar(
            context,
            'User logged in',
          );
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "signIn");
    }
  }

  void resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final uri = Uri.parse('${Constants.uri}/api/reset');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {"email": email};
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Email sent',
          );
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "resetPassword");
    }
  }

  void saveSalary(
      {required BuildContext context,
      required String phone,
      required String salary,
      required String save}) async {
    try {
      final uri = Uri.parse('${Constants.uri}/api/salary');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "phone": phone,
        "salary": salary,
        "sav": save
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Data stored',
          );
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "saveSalary");
    }
  }

  //get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Object> getSalary(
      {required String phone, required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/salary?phone=${phone}'),
      );
      return json.decode(res.body);
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "getSalary");
    }
    return {};
  }

  void editSalary(
      {required BuildContext context,
      required int salary,
      required int sav,
      required String phone}) async {
    try {
      final uri = Uri.parse('${Constants.uri}/api/editSalary');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "salary": salary,
        "sav": sav,
        "phone": phone
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          // ignore: use_build_context_synchronously
          showSnackBar(context, "Salary updated");
        },
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "editSalary");
    }
  }

  // week
  Future<String> getWeekExpense(
      {required String phone, required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/week?phone=${phone}'),
      );
      return res.body;
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "getWeekExpenses");
    }
    return "0";
  }

// month
  Future<String> getMonthExpense(
      {required String phone, required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/month?phone=${phone}'),
      );
      return res.body;
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "getMonthExpenses");
    }
    return "0";
  }

// salary
  Future<double> getSalaryData(
      {required String phone, required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/getSalary?phone=${phone}'),
      );
      return double.parse(res.body);
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "getSalaryData");
    }
    return 0;
  }

// salary
  Future<List> getPrevTransactions(
      {required String phone, required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/previous?phone=${phone}'),
      );
      return json.decode(res.body) as List<dynamic>;
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "getPrevTransactions");
    }
    return [];
  }

  // calendar
  Future<List> getCalendar(
      {required String phone,
      required String date,
      required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/calendar?phone=${phone}&date=${date}'),
      );
      return json.decode(res.body) as List<dynamic>;
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "getCalendar");
    }
    return [];
  }

  Future<Object> getUser(
      {required String phone, required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.uri}/api/user?phone=${phone}'),
      );
      return json.decode(res.body);
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "getUser");
    }
    return {};
  }

  //get user data
  void signOut(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('x-auth-token', '');
      final navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "signOut");
    }
  }

// post transaction
  Future<Transaction> postTransaction(
      {required BuildContext context,
      required String phone,
      required String debit,
      required String credit,
      required String timestamp,
      required String category}) async {
    Transaction transaction =
        Transaction('', amount: 0, category: '', date: '', time: '', title: '');
    try {
      final uri = Uri.parse('${Constants.uri}/api/transaction');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "phone": phone,
        "debit": debit,
        "credit": credit,
        "timestamp": int.parse(timestamp),
        "category": category
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      print('huehue ${int.parse(timestamp)}');
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      // ignore: use_build_context_synchronously
      print(jsonDecode(response.body)['_id']);
      print(jsonDecode(response.body)['debit']);
      print(jsonDecode(response.body)['credit']);
      print(jsonDecode(response.body)['date']);
      print(jsonDecode(response.body)['category']);
      print(jsonDecode(response.body)['time']);

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Transaction stored successfully");
          print('Nush<3Chiti');
          // initHome();
        },
      );

      if (int.parse(jsonDecode(response.body)['credit']) > 0) {
        var _transaction = Transaction(jsonDecode(response.body)['_id'],
            title: 'Credited',
            amount: int.parse(jsonDecode(response.body)['credit']),
            date: jsonDecode(response.body)['date'],
            category: jsonDecode(response.body)['category'],
            time: jsonDecode(response.body)['time']);
        print(_transaction);
        return _transaction;
      } else {
        var _transaction = Transaction(jsonDecode(response.body)['_id'],
            title: 'Debited',
            amount: -int.parse(jsonDecode(response.body)['debit']),
            date: jsonDecode(response.body)['date'],
            category: jsonDecode(response.body)['category'],
            time: jsonDecode(response.body)['time']);
        print(_transaction);
        return _transaction;
      }
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, "postTransaction");
    }
    return transaction;
  }

  Future<List<Transaction>> postManyTransactions({
    required BuildContext context,
    required List<TransactionBackend> backends,
  }) async {
    print(backends[0].phone);
    try {
      final uri = Uri.parse('${Constants.uri}/api/transactions');
      final headers = {'Content-Type': 'application/json'};
      Map<String, List<TransactionBackend>> body = {"data": backends};
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          print(response.body);
          showSnackBar(context, "Transactions stored successfully");
        },
      );

      List res = json.decode(response.body) as List<dynamic>;
      List<Transaction> _transactions = [];
      for (int i = 0; i < res.length; i++) {
        var map = res[i] as Map<String, dynamic>;
        if ((map['debit']) != "0" && map['debit'] != "0.0") {
          _transactions.add(
            Transaction(map['_id'].toString(),
                title: "Debited",
                amount: -int.parse(map['debit']),
                date: (map['date']).toString(),
                category: map['category'].toString(),
                time: map['time'].toString()),
          );
        } else {
          // print(map['date'].toString());
          _transactions.add(Transaction(map['_id'].toString(),
              title: "Credited",
              amount: int.parse(map['credit']),
              date: (map['date']).toString(),
              category: map['category'].toString(),
              time: map['time'].toString()));
        }
      }
      return _transactions;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return [];
  }
}
