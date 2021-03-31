import 'package:flutter/material.dart';

class FullWidthHomeCard extends StatelessWidget {
  final String subText;
  final String header;
  final String imagePath;
  final Function onTap;
  final Color background;

  const FullWidthHomeCard({
    @required this.subText,
    @required this.header,
    @required this.imagePath,
    @required this.background,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.onTap(),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 150,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 6,
              offset: Offset(0, 2))
        ], borderRadius: BorderRadius.circular(8), color: this.background),
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                top: 0,
                right: 16,
                child: Container(
                    height: 175,
                    width: 175,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(this.imagePath))))),
            Positioned(
                top: 12,
                left: 32,
                bottom: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.subText, style: TextStyle(fontSize: 22)),
                    Text(this.header, style: TextStyle(fontSize: 31)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
