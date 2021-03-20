import 'package:codered/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class FirstAidSteps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Stack(
          children: [
            Container(
              decoration:
                  BoxDecoration(color: CodeRedColors.primary, boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 8)
              ]),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Text('ETA',
                          style: TextStyle(color: Colors.white, fontSize: 22))),
                  Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: Text('4 mins',
                          style: TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            Positioned(
              top: 36,
              left: 6,
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context)),
            )
          ],
        ),
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.25),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              margin: EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Medical help is on the way!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Nearest ambulance has been notified and should reach your place shortly. We'll also try to notify all nearby first-responders.",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    color: CodeRedColors.inputFields,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.medical_services),
                            SizedBox(width: 8),
                            Text('PB08 BX 95XX',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              // color: CodeRedColors.primary,
                              // padding: EdgeInsets.symmetric(
                              //     vertical: 12, horizontal: 24),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text('Cancel Ambulance',
                                      style: TextStyle(
                                          color: CodeRedColors.primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            MaterialButton(
                              color: CodeRedColors.primary,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Icon(Icons.call,
                                      color: Colors.white, size: 15),
                                  SizedBox(width: 4),
                                  Text('Call driver',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FirstResponderInstructions(),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class FirstResponderInstructions extends StatelessWidget {
  const FirstResponderInstructions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("First Responder Instructions",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 6),
          child: Text(
            "Perform these activities until the medical services arrive.",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
          ),
        ),
        SizedBox(height: 12),
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: CodeRedColors.primary,
                      child: Text('1', style: TextStyle(color: Colors.white))),
                  Container(
                      padding: EdgeInsets.only(left: 6),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                          "Make sure the person stays conscious. Try to sprinkle few water droplets, if you can"))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: CodeRedColors.primary,
                      child: Text('2', style: TextStyle(color: Colors.white))),
                  Container(
                      padding: EdgeInsets.only(left: 6),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                          "If the person is unable to breathe, make them lie down belly-first on the ground."))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: CodeRedColors.primary,
                      child: Text('3', style: TextStyle(color: Colors.white))),
                  Container(
                      padding: EdgeInsets.only(left: 6),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                          "If you think the person is suffering from a cardiac arrest, give them some 'aspirin' diluted with water."))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: CodeRedColors.primary,
                      child: Text('4', style: TextStyle(color: Colors.white))),
                  Container(
                      padding: EdgeInsets.only(left: 6),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text("If the person is unconscious, perform CPR."))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: CodeRedColors.primary,
                      child: Text('5', style: TextStyle(color: Colors.white))),
                  Container(
                      padding: EdgeInsets.only(left: 6),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                          "DO NOT PANIC. Wait for medical services to arrive."))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
