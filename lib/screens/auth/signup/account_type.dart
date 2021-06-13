import '../../text_recognition.dart';
import '../../../services/user_services.dart';
import '../../../utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountType extends StatefulWidget {
  const AccountType({Key key}) : super(key: key);
  @override
  _AccountTypeState createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  int accountType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Are you a medical volunteer?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        chooseAccount('Yes', 1),
                        chooseAccount('No', 0)
                      ],
                    )),
              ],
            ),
          ),
          if (accountType == 1)
            Flexible(flex: 8, fit: FlexFit.tight, child: TextRecognition())
        ],
      ),
    ));
  }

  Widget chooseAccount(String text, int value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
        child: Row(
          children: [
            Radio(
                value: value,
                groupValue: accountType,
                activeColor: CodeRedColors.primary,
                onChanged: (val) {
                  setState(() {
                    accountType = val;
                    Provider.of<UserService>(context, listen: false)
                        .putType(val);
                  });
                }),
            Text(text),
            const SizedBox(width: 4)
          ],
        ),
      ),
    );
  }
}
