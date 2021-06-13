import '../../../services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgePage extends StatefulWidget {
  const AgePage({Key key}) : super(key: key);
  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  TextEditingController ageController;
  bool active = false;
  String error;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController(
        text: Provider.of<UserService>(context, listen: false).age ?? '');

    Provider.of<UserService>(context, listen: false).updateStatus(false);

    ageController.addListener(() {
      if (ageController.text.length > 0) {
        Provider.of<UserService>(context, listen: false).updateStatus(true);
      } else {
        Provider.of<UserService>(context, listen: false).updateStatus(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What's your age, ${Provider.of<UserService>(context, listen: false).name ?? ''} ?",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300])),
              child: TextField(
                controller: ageController,
                style: const TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    error = '';
                    Provider.of<UserService>(context, listen: false)
                        .putAge(value);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    isDense: true),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              error ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.grey[800],
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Wrap(
                    children: [
                      const Text(
                          'This data will only be used for symptom based disease diagnose purposes and we would never share this with anyone. Promise.')
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      ),

      //       onTap: active
      //           ? () {
      //               if (age.isNotEmpty) {
      //                 if (widget.pageController.hasClients) {
      //                   widget.pageController.nextPage(
      //                       duration: Duration(milliseconds: 250),
      //                       curve: Curves.ease);
      //                 }
      //               } else {
      //                 error = "Enter Valid Email";
      //                 setState(() {});
      //               }
      //             }
      //           : () {},
    );
  }
}
