import '../../../services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNamePage extends StatefulWidget {
  const UserNamePage({Key key}) : super(key: key);
  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
        text: Provider.of<UserService>(context, listen: false).name ?? '');

    Provider.of<UserService>(context, listen: false).updateStatus(false);

    nameController.addListener(() {
      if (nameController.text.length > 0) {
        Provider.of<UserService>(context, listen: false).updateStatus(true);
      } else {
        Provider.of<UserService>(context, listen: false).updateStatus(false);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your User Name',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300])),
            child: TextField(
              controller: nameController,
              style: const TextStyle(
                fontSize: 18,
              ),
              onChanged: (value) {
                setState(() {
                  Provider.of<UserService>(context, listen: false)
                      .putName(value);
                });
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  isDense: true),
            ),
          )
        ],
      ),
    ));
  }
}
