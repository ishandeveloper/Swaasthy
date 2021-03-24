import 'package:codered/services/index.dart';
import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            MaterialButton(
              child: Text("PRESS ME TO TEST"),
              onPressed: () async {
                await ConsultHelper.getHeroDoctors()
                    .then((value) => setState(() {
                          data = value;
                        }));
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(data.toString()),
            )
          ],
        ),
      ),
    );
  }
}
