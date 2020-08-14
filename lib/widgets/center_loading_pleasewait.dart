import 'package:flutter/material.dart';

class CenterLoadingPleasewait extends StatelessWidget {
  const CenterLoadingPleasewait({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Processing please wait...',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
