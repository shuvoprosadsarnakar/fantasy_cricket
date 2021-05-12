import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: ListView(
        padding: Paddings.pagePadding,
        children: [
          getUsername(context),
          SizedBox(height: 30),

          getProfileInfo(
            context: context,
            title: 'Total Earned Chips',
            value: '1000',
            buttonText: 'Earning History',
            page: null,
          ),
          Divider(height: 50),

          getProfileInfo(
            context: context,
            title: 'Total Exchanged Chips',
            value: '1000',
            buttonText: 'Exchanging History',
            page: null,
          ),
          Divider(height: 50),

          getProfileInfo(
            context: context,
            title: 'Remaining Chips',
            value: '1000',
            buttonText: 'Exchange Chips',
            page: null,
          ),
        ],
      ),
    );
  }

  Text getUsername(BuildContext context) {
    return Text(
      'username',
      style: Theme.of(context).textTheme.headline3,
    );
  }

  Column getProfileInfo({
    BuildContext context,
    String title,
    String value,
    String buttonText,
    Widget page,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return page;
              },
            ));
          },
          child: Text(
            buttonText,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
