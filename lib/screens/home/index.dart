import '../../utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../drawer.dart';
import 'local_widgets/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        key: drawerKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: CodeRedColors.primary,
          onPressed: () {
            Navigator.pushNamed(context, '/emergency');
          },
          child: Transform.translate(
            offset: const Offset(25, 0),
            child: Transform(
                transform: Matrix4.rotationY((-2) * 3.142857142857143 / 2),
                child: const Icon(FontAwesome.ambulance)),
          ),
        ),
        drawer: const HomeScreenDrawer(),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 72),
            child: HomeAppBar(
              drawerKey: drawerKey,
            )),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ListView(
              children: [
                const HomeGreetings(),
                const SizedBox(height: 20),
                const HomeSearch(),
                const SizedBox(height: 20),
                const HomeCardActions()
              ],
            )),
      ),
    );
  }
}
