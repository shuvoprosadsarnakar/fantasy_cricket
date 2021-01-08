import 'package:flutter/material.dart';

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole;
  List<String> _roles = ['Batsmen', 'Bowlers', 'Captain', 'Wicketkeeper'];
  
  String _selectedHanded;
  List<String> _handed = ['Right', 'Left'];

  String _selectedNationality;
  List<String> _nationalities = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Argentina',
    'Australia',
    'Austria',
    'Bangladesh',
    'Belgium',
    'Bolivia',
    'Botswana'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add player"),
      ),
      body: Form(
        child: ListView(
          children: [
            nameInput(),
            roleInput(),
            handedInput(),
            nationalityInput(),
            submitButton()
          ],
        ),
      ),
    );
  }

  Widget nameInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Player name",
          hintText: "e.g Sachin tendulkar",
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget roleInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        hint: Text('Role'), // Not necessary for Option 1
        value: _selectedRole,
        onChanged: (newValue) {
          setState(() {
            _selectedRole = newValue;
          });
        },
        items: _roles.map((role) {
          return DropdownMenuItem(
            child: new Text(role),
            value: role,
          );
        }).toList(),
      ),
    );
  }

  Widget handedInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        hint: Text('Handed'), // Not necessary for Option 1
        value: _selectedHanded,
        onChanged: (newValue) {
          setState(() {
            _selectedHanded = newValue;
          });
        },
        items: _handed.map((hand) {
          return DropdownMenuItem(
            child: new Text(hand),
            value: hand,
          );
        }).toList(),
      ),
    );
  }

  Widget nationalityInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        hint: Text('Nationality'), // Not necessary for Option 1
        value: _selectedNationality,
        onChanged: (newValue) {
          setState(() {
            _selectedNationality = newValue;
          });
        },
        items: _nationalities.map((nationality) {
          return DropdownMenuItem(
            child: new Text(nationality),
            value: nationality,
          );
        }).toList(),
      ),
    );
  }

  RaisedButton submitButton() {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      onPressed: () {},
      child: Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
