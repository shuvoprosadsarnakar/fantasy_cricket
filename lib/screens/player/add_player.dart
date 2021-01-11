import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/services/database.dart';
import 'package:flutter/material.dart';

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final _database = DataBase();
  final _formKey = GlobalKey<FormState>();

  Player _selectedPlayer = Player();

  //FOrm values
  List<String> _roles = ['Batsmen', 'Bowlers', 'Captain', 'Wicketkeeper'];

  List<String> _handed = ['Right', 'Left'];

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
        key: _formKey,
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
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: "Player name",
          hintText: "e.g Sachin tendulkar",
        ),
        validator: (name) {
          Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
          RegExp regex = new RegExp(pattern);
          if (name.isEmpty)
            return 'Empty username';
          else if (!regex.hasMatch(name))
            return 'Invalid name';
          else
            return null;
        },
        onChanged: (name) {
          _selectedPlayer.name = name;
        },
      ),
    );
  }

  Widget roleInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: "Role",
          hintText: "e.g Bowler",
        ), // Not necessary for Option 1
        value: _selectedPlayer.role,
        validator: (role) {
          if (role == null)
            return 'Empty role';
          else
            return null;
        },
        onChanged: (role) {
          _selectedPlayer.role = role;
        },
        items: _roles.map((role) {
          return DropdownMenuItem(
            child: Text(role),
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
        decoration: InputDecoration(
          labelText: "Handed",
          hintText: "e.g Right",
        ),
        value: _selectedPlayer.handed,
        onChanged: (hand) {
          _selectedPlayer.handed = hand;
        },
        items: _handed.map((hand) {
          return DropdownMenuItem(
            child: Text(hand),
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
        decoration: InputDecoration(
          labelText: "Nationality",
          hintText: "e.g America",
        ), // Not necessary for Option 1
        value: _selectedPlayer.nationality,
        onChanged: (newValue) {
          _selectedPlayer.nationality = newValue;
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
      onPressed: () => createRecord(_selectedPlayer),
      child: Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void createRecord(Player player) async {
    if (_formKey.currentState.validate()) {
      print(player.name);
      print(player.role);
      print(player.nationality);
      print(player.handed);
      _database.addPlayers(player);
    }
  }
}
