import 'package:flutter/material.dart';

class PlayerProfile extends StatelessWidget
{
  final player;

  PlayerProfile(this.player);

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          getImageAndName('https://upload.wikimedia.org/wikipedia/commons/1/11/Steve_Smith_%28cricketer%29%2C_2014_%28cropped%29.jpg', player.name),
          
          Divider(height: 40),

          getBio(
            name: player.name,
            born: '*',
            nation: player.nationality,
            role: player.role,
            battingStyle: '*',
            bowlingStyle: '*',
          ),
          
          SizedBox(height: 10),

          getBatStat(context),
          
          SizedBox(height: 10),

          getBowlStat(context),

          SizedBox(height: 10),

          getRankingStat(context),

          SizedBox(height: 10),

          getDescription(context),
        ],
      ),
    );
  }

  Widget getImageAndName(String image, String name)
  {
    return Column(
      children: [
        ClipRRect(
          child: Image(
            image: NetworkImage(image),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(5),
        ),

        SizedBox(height: 20),
        
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget getBio({String name, String born, String nation, String role,
  String battingStyle, String bowlingStyle})
  {
    Map<String, int> born = {'day': 4, 'month': 10, 'year': 1994};
    List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
    'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String teams = 'Australia, Sydney Sixers, Rajasthan Royals';
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - born['year'];

    if((currentDate.month < born['month']) || (currentDate.month == born['month']
    && born['day'] < currentDate.day)) age--;

    return Column(
      children: [
        getBioRow('Name', name),
        getBioRow('Born', '*' /*'${monthNames[born['month'] - 1]} ${born['day']}, ${born['year']}'*/),
        getBioRow('Age', '*' /*'${age.toString()} Years'*/),
        getBioRow('Nationality', nation),
        getBioRow('Role', role),
        getBioRow('Batting Style', battingStyle),
        getBioRow('Bowling Style', bowlingStyle),
        getBioRow('Teams', '*'),
      ],
    );
  }

  Widget getBioRow(String fieldName, String fieldValue)
  {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                fieldName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(width: 10),
            
            Expanded(
              flex: 3,
              child: Text(fieldValue),
            ),
          ],
        ),

        SizedBox(height: 10),
      ],
    );
  }

  Widget getBatStat(BuildContext context)
  {
    List<int> matches = [3, 124, 77];
    List<int> innings = [6, 113, 71];
    List<int> runs = [33, 2796, 1317];
    List<double> averages = [5.5, 27.41, 21.95];
    List<double> strikeRates = [48.53, 85.5, 145.85];
    List<int> highScores = [24, 116, 89];
    List<int> notOuts = [0, 11, 11];
    List<int> hundreds = [0, 1, 0];
    List<int> fifties = [0, 15, 4];
    List<int> fours = [4, 171, 82];
    List<int> sixes = [1, 90, 77];

    return Column(
      children: [
        getStatHead(context, 'Batting Statistics'),
        getStatRow('Matches', matches, Colors.grey[200]),
        getStatRow('Innings', innings, Colors.grey[50]),
        getStatRow('Runs', runs, Colors.grey[200]),
        getStatRow('Averages', averages, Colors.grey[50]),
        getStatRow('Strike Rates', strikeRates, Colors.grey[200]),
        getStatRow('High Scores', highScores, Colors.grey[50]),
        getStatRow('Not Outs', notOuts, Colors.grey[200]),
        getStatRow('Hundreds', hundreds, Colors.grey[50]),
        getStatRow('Fifties', fifties, Colors.grey[200]),
        getStatRow('Fours', fours, Colors.grey[50]),
        getStatRow('Sixes', sixes, Colors.grey[200]),
      ],
    );
  }

  Widget getBowlStat(BuildContext context)
  {
    List<int> matches = [3, 124, 77];
    List<int> innings = [6, 113, 71];
    List<int> runs = [33, 2796, 1317];
    List<double> averages = [5.5, 27.41, 21.95];
    List<double> strikeRates = [48.53, 85.5, 145.85];
    List<int> highScores = [24, 116, 89];
    List<int> notOuts = [0, 11, 11];
    List<int> hundreds = [0, 1, 0];
    List<int> fifties = [0, 15, 4];
    List<int> fours = [4, 171, 82];
    List<int> sixes = [1, 90, 77];

    return Column(
      children: [
        getStatHead(context, 'Bowling Statistics'),
        getStatRow('Matches', matches, Colors.grey[200]),
        getStatRow('Innings', innings, Colors.grey[50]),
        getStatRow('Runs', runs, Colors.grey[200]),
        getStatRow('Averages', averages, Colors.grey[50]),
        getStatRow('Strike Rates', strikeRates, Colors.grey[200]),
        getStatRow('High Scores', highScores, Colors.grey[50]),
        getStatRow('Not Outs', notOuts, Colors.grey[200]),
        getStatRow('Hundreds', hundreds, Colors.grey[50]),
        getStatRow('Fifties', fifties, Colors.grey[200]),
        getStatRow('Fours', fours, Colors.grey[50]),
        getStatRow('Sixes', sixes, Colors.grey[200]),
      ],
    );
  }

  Widget getRankingStat(BuildContext context)
  {
    List<int> matches = [3, 124, 77];
    List<int> innings = [6, 113, 71];
    List<int> runs = [33, 2796, 1317];
    List<double> averages = [5.5, 27.41, 21.95];
    List<double> strikeRates = [48.53, 85.5, 145.85];
    List<int> highScores = [24, 116, 89];
    List<int> notOuts = [0, 11, 11];
    List<int> hundreds = [0, 1, 0];
    List<int> fifties = [0, 15, 4];
    List<int> fours = [4, 171, 82];
    List<int> sixes = [1, 90, 77];

    return Column(
      children: [
        getStatHead(context, 'ICC Rankings'),
        getStatRow('Matches', matches, Colors.grey[200]),
        getStatRow('Innings', innings, Colors.grey[50]),
        getStatRow('Runs', runs, Colors.grey[200]),
        getStatRow('Averages', averages, Colors.grey[50]),
        getStatRow('Strike Rates', strikeRates, Colors.grey[200]),
        getStatRow('High Scores', highScores, Colors.grey[50]),
        getStatRow('Not Outs', notOuts, Colors.grey[200]),
        getStatRow('Hundreds', hundreds, Colors.grey[50]),
        getStatRow('Fifties', fifties, Colors.grey[200]),
        getStatRow('Fours', fours, Colors.grey[50]),
        getStatRow('Sixes', sixes, Colors.grey[200]),
      ],
    );
  }

  Widget getStatHead(BuildContext context, String title)
  {
    return Column(
      children: [
        getSectionHeader(context, title),

        SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Text(''),
            ),
            Expanded(
              child: Text('Test'),
            ),
            Expanded(
              child: Text('ODI'),
            ),
            Expanded(
              child: Text('T20'),
            ),
          ],
        ),

        SizedBox(height: 10),
      ],
    );
  }

  Widget getSectionHeader(BuildContext context, String title)
  {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 5),
    );
  }

  Widget getStatRow(String title, List<dynamic> datas, Color color)
  {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          color: color,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(title),
                  padding: EdgeInsets.symmetric(horizontal: 3),
                ),
              ),
              Expanded(
                child: Text(datas[0].toString()),
              ),
              Expanded(
                child: Text(datas[1].toString()),
              ),
              Expanded(
                child: Text(datas[2].toString()),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }

  Widget getDescription(BuildContext context)
  {
    String description = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.\n\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

    return Column(
      children: [
        getSectionHeader(context, 'Description'),
        SizedBox(height: 15),
        Text(description),
      ],
    );
  }
}