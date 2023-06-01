import 'package:finzie/services/auth_services.dart';
import 'package:finzie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class EditSalaryScreen extends StatefulWidget {
  @override
  _EditSalaryScreenState createState() => _EditSalaryScreenState();
}

class _EditSalaryScreenState extends State<EditSalaryScreen> {
  final _formKey = GlobalKey<FormState>();
  String phone = "";

  final salaryController = TextEditingController();
  final savController = TextEditingController();

  void getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('phone');
    setState(() {
      phone = token as String;
    });
    // ignore: use_build_context_synchronously
    var user =
        AuthService().getSalary(phone: token as String, context: context);
    var temp = await user;
    var map = temp as Map<String, dynamic>;

    setState(() {
      salaryController.text = map['data']['salary'].toString();
      savController.text = map['data']['sav'].toString();
    });
  }

  @override
  void initState() {
    getPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Salary'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: salaryController,
                decoration: InputDecoration(
                  labelText: 'Salary',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextFormField(
                controller: savController,
                decoration: InputDecoration(
                  labelText: 'Save',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Update Salary'),
                onPressed: () {
                  if (salaryController.text == '' || savController.text == '') {
                    showSnackBar(context, 'Please fill all the fields');
                  } else {
                    AuthService().editSalary(
                        context: context,
                        salary: int.parse(salaryController.text),
                        sav: int.parse(savController.text),
                        phone: phone);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
