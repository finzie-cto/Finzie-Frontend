import 'package:finzie/services/auth_services.dart';
import 'package:finzie/utils/utils.dart';
import 'package:flutter/material.dart';

class Data {
  static var salary = 5000.0;
  static var save = 2000.0;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final Object? rcvdData = ModalRoute.of(context)?.settings.arguments;
    final Map<String, String> temp = rcvdData as Map<String, String>;

    final salaryCon = TextEditingController();
    final saveCon = TextEditingController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let's track your expenses",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    "What's your monthly salary/pocket money?",
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: salaryCon,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'Enter your salary',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    "How much do you want to save?",
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: saveCon,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'Amount you want to save',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Please allow us to track your expenses by reading the instructions in your text messages :)",
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Continue button logic
                  String? phone = temp['phone'];
                  String? password = temp['password'];

                  if (salaryCon.text == '' || saveCon.text == '') {
                    showSnackBar(context, 'Please enter all fields');
                  } else {
                    AuthService().saveSalary(
                        context: context,
                        phone: phone as String,
                        salary: salaryCon.text,
                        save: saveCon.text);
                    AuthService().signInUser(
                        context: context,
                        phone: phone,
                        password: password as String);
                  }
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
