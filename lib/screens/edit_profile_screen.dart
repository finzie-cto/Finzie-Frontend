import 'package:finzie/services/auth_services.dart';
import 'package:finzie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";
  String phone = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('phone');
    setState(() {
      phone = token as String;
    });
    // ignore: use_build_context_synchronously
    var user = AuthService().getUser(phone: token as String, context: context);
    var temp = await user;
    var map = temp as Map<String, dynamic>;

    print(map['data']['email']);

    setState(() {
      nameController.text = map['data']['name'];
      emailController.text = map['data']['email'];
      _password = "";
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
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) => {_email = value},
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Update Profile'),
                onPressed: () {
                  if (nameController.text == '' ||
                      emailController.text == '' ||
                      passwordController.text == '') {
                    showSnackBar(context, 'Please fill all the fields');
                  } else if (!EmailValidator.validate(emailController.text)) {
                    showSnackBar(context, 'Please enter a valid email');
                  } else {
                    AuthService().editUser(
                        context: context,
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
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
