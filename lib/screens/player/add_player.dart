import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/services/database.dart';
import 'package:flutter/material.dart';

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final _databse = DataBase();
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
        onChanged: (name) {
          setState(() {
            _selectedPlayer.name = name;
          });
        },
      ),
    );
  }

  Widget roleInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        hint: Text('Role'), // Not necessary for Option 1
        value: _selectedPlayer.role,
        onChanged: (role) {
          setState(() {
            _selectedPlayer.role = role;
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
        value: _selectedPlayer.handed,
        onChanged: (newValue) {
          setState(() {
            _selectedPlayer.handed = newValue;
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
        value: _selectedPlayer.nationality,
        onChanged: (newValue) {
          setState(() {
            _selectedPlayer.nationality = newValue;
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
      onPressed: () => createRecord(_selectedPlayer),
      child: Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void createRecord(Player player) async {
    print(player.name);
    print(player.role);
    print(player.nationality);
    print(player.handed);
    _databse.addPlayers(player);
  }
}
