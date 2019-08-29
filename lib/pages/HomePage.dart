import 'package:first_flutter_app/widgets/Dice.dart';
import 'package:first_flutter_app/entities/DiceEntity.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<DiceEntity> _dices = [
    DiceEntity(0),
    DiceEntity(1),
  ];

  AnimationController _angleController;
  AnimationController _dyController;
  Animation<double> _angleAnimation;
  Animation<double> _dyAnimation;

  void _rotateDices() {
    _rotateDice(_dices[0]);
    _rotateDice(_dices[1]);
  }

  void _rotateDice(DiceEntity dice) {
    print(dice.isThrown);
    if (dice.isThrown) {
      _translateDice(dice);
      Future.delayed(Duration(milliseconds: 200), () {
        _rollDice(dice);
      });
    } else {
      _rollDice(dice);
    }
  }

  void _rollDice(DiceEntity dice) {
    _angleController.forward();
    int _counter = 0;
    Timer.periodic(
        Duration(milliseconds: 70),
        (timer) => {
              _counter++,
              if (_counter > 4) {timer.cancel()},
              setState(() {
                dice.number = math.Random().nextInt(7);
              })
            });
    Future.delayed(const Duration(milliseconds: 500), () {
      _angleController.reverse();
    });
    _translateDice(dice);
  }

  void _translateDice(DiceEntity dice) {
    dice.isThrown? _dyController.reverse() : _dyController.forward();
    _toggleIsThrown(dice);
  }

  void _toggleIsThrown(DiceEntity dice) {
    setState(() {
      dice.isThrown = !dice.isThrown;
    });
  }

  @override
  void initState() {
    super.initState();
    _angleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 0),
    );
    _dyController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 200),
    );

    _angleAnimation = Tween<double>(begin: 0.0, end: math.pi * 5).animate(
        CurvedAnimation(parent: _angleController, curve: Curves.linear));

    _dyAnimation = Tween<double>(begin: 0.0, end: -100.0)
        .animate(CurvedAnimation(parent: _dyController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(120, 0, 120, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Dice(_angleAnimation, _dyAnimation,
                      _dices[0].number),
                  Dice(_angleAnimation, _dyAnimation,
                      _dices[1].number),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            RaisedButton(
              onPressed: _rotateDices,
              child: Text('Roll Dice'),
              color: Colors.red,
              textColor: Colors.white,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: Colors.transparent, style: BorderStyle.solid),
              ),
            )
          ],
        ),
      ),
    );
  }
}
