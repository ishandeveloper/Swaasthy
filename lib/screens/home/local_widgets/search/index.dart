import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CodeRedColors.inputFields,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.search, color: CodeRedColors.icon),
          SizedBox(width: 6),
          Text(
            'Search for a disease, symptom etc.',
            style: TextStyle(color: CodeRedColors.secondaryText),
          )
        ],
      ),
    );
  }
}
