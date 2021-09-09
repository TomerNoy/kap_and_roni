import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kap_and_roni/models/player.dart';
import '../models/arrow.dart';
import '../models/box.dart';
import '../theme.dart';

final prov = ChangeNotifierProvider.autoDispose((ref) => Prov());

class Prov with ChangeNotifier {
  var gridGap = 0.0;

  late int gridCount;
  late Size gridSize;

  final boxes = <Box>[], grid = <Row>[];
  final randomBoxes = <Box>[], arrows = <Arrow>[];

  /// players
  late bool isSinglePlayer;

  final _players = <Player>[];
  List<Player> get players => _players;
  set addAPlayer(Player p) => _players.add(p);
  void playerOneStep(int i, bool back) {
    back ? _players[_nowPlaying].atBox-- : _players[_nowPlaying].atBox++;
    tryNotify();
  }

  set playerJump(int i) {
    _players[_nowPlaying].atBox = i;
    tryNotify();
  }

  var _isTimerOn = false;
  bool get isTimerOn => _isTimerOn;
  set setTimerOn(bool b) {
    _isTimerOn = b;
    tryNotify();
  }

  /// whether the UI button is pressable
  var _isButtonOn = true;
  bool get isButtonOn => _isButtonOn;
  set setButtonOn(bool b) {
    _isButtonOn = b;
    tryNotify();
  }

  /// pre game determines who starts the game
  var _isPreGameMode = true;
  bool get isPreGameMode => _isPreGameMode;
  set setPreGameMode(bool b) {
    _isPreGameMode = b;
    tryNotify();
  }

  /// the result after pressed
  var _score = 0;
  int get score => _score;
  set setScore(int i) {
    _score = i;
    tryNotify();
  }

  /// messages to UI end usr
  var _msg = '';
  String get msg => _msg;
  set setMsg(String s) {
    _msg = s;
    tryNotify();
  }

  /// who's playing now
  var _nowPlaying = 0;
  int get nowPlaying => _nowPlaying;
  set setNowPlaying(int i) {
    _nowPlaying = i;
    tryNotify();
  }

  /// pre game results
  final preGameScores = [0, 0];

  /// init all game params
  void init(Size size, bool singlePlayer, int difficulty) {
    isSinglePlayer = singlePlayer;
    gridCount = (difficulty * 2) + 6;
    setMeasurements = size;
    initBoxes();
    initBoxWidgets();
    initRandomBoxes();
    initArrows();
    initPlayers();
    Future.delayed(const Duration(milliseconds: 300)).whenComplete(
      // small delay is to avoid build errors
      () => {
        setMsg = '${singlePlayer ? '' : ''
            '${players[nowPlaying].name}: '}push for highest value'
      },
    );
  }

  /// board measurements according to screen size
  set setMeasurements(Size size) {
    final maxBoxWidth = (size.width - 16) / 10;
    final maxBoxHeight = (size.height - 100) / 10;
    gridGap = maxBoxWidth < maxBoxHeight ? maxBoxWidth : maxBoxHeight;
    gridSize = Size.square(gridGap * gridCount);
  }

  void initBoxes() {
    final totalBoxes = gridCount * gridCount;

    for (int x = 0; x < gridCount; x++) {
      for (int y = 0; y < gridCount; y++) {
        final count = x * gridCount + y;

        /// index count
        final revCountByRow = (count + gridCount - y * 2) - 1;

        /// for every odd row reverse it's count
        final countFinal = totalBoxes - 1 - (x.isEven ? count : revCountByRow);
        final box = Box(index: count, count: countFinal, x: x, y: y);

        /// add box to list
        boxes.add(box);
      }
    }
  }

  void initBoxWidgets() {
    final boxWidgets = boxes.map((e) {
      String? label;

      /// set position of player 1
      if (e.count == 0) label = 'START';
      if (e.count == boxes.length - 1) label = 'END';
      final box = e.initBox(gridGap, label: label);
      return box;
    }).toList();

    for (var i = 0; i < boxWidgets.length; i += gridCount) {
      grid.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: boxWidgets.sublist(i, i + gridCount),
        ),
      );
    }
  }

  void initRandomBoxes() {
    /// how many box need to draw arrows (two make 1 arrow)
    final randomCount = (gridCount * gridCount) / 2;

    /// add random boxes
    var random = math.Random();
    while (randomBoxes.length < randomCount) {
      final boxNumber = random.nextInt(boxes.length);
      final randomBox = boxes[boxNumber];

      /// exclude 'start' box
      if (!(randomBox.count == 0) && !(randomBox.count == boxes.length - 1)) {
        var countList = randomBoxes.map((e) => e.count).toList();

        /// exclude duplicates
        if (!countList.contains(randomBox.count)) {
          randomBoxes.add(randomBox);
        }
      }
    }
  }

  void initArrows() {
    for (var i = 0; i < randomBoxes.length; i += 2) {
      final start = randomBoxes[i].getOffset(gridGap);
      final end = randomBoxes[i + 1].getOffset(gridGap);

      Arrow arrow = Arrow(
          start: start,
          end: end,
          startCount: randomBoxes[i].count,
          endCount: randomBoxes[i + 1].count);
      final needSwitch =
          arrows.isNotEmpty && arrows.last.isUp() == arrow.isUp();
      if (needSwitch) arrow = arrow.flip();
      arrows.add(arrow);
    }
  }

  void initPlayers() {
    players
      ..add(Player(isSinglePlayer ? ' You' : 'Kap', green))
      ..add(Player(isSinglePlayer ? 'Robot' : 'Roni', purple));
  }

  /// position on grid by offset
  Offset getPlayerPosition(int i) {
    final player = players[i];
    final box = boxes.singleWhere((e) => e.count == player.atBox);
    final offset = box.getOffset(gridGap);
    final adjustedOffset = Offset(offset.dx, offset.dy - 12);
    return adjustedOffset;
  }

  /// usr pressed the counter button
  Future<void> onPointerDown() async {
    setButtonOn = false;
    setTimerOn = true;
    setMsg = '';
    var repCount = 6;

    while (_isTimerOn && repCount > 0) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (_score == 5) {
        repCount--;
        setScore = 0;
      } else {
        setScore = _score + 1;
      }
    }
  }

  /// when user releases the counter button
  Future<void> onPointerUp() async {
    setTimerOn = false; // release loop in case it's still running
    await Future.delayed(const Duration(milliseconds: 300));
    return _isPreGameMode ? preGame() : game(); // who starts or move players
  }

  /// handle pre game counts
  Future<void> preGame() async {
    preGameScores[_nowPlaying] = _score;
    setMsg = '${players[_nowPlaying].name} scored $_score';
    await Future.delayed(const Duration(seconds: 1));

    setScore = 0; // reset score
    if (_nowPlaying == 1) return preGameCalc(); // we got a 2 scores to compare
    setNowPlaying = 1;

    /// case robot
    if (isSinglePlayer) {
      setMsg = "robot's turn";
      await robotPress();
    } else {
      setMsg = '${players[1].name}: long press for highest value';
      await Future.delayed(const Duration(seconds: 1));
      setButtonOn = true;
    }
  }

  /// calculate pre game results after second player already pressed
  Future<void> preGameCalc() async {
    setScore = 0;
    final res = preGameScores[0].compareTo(preGameScores[1]);
    switch (res) {

      /// even
      case 0:
        setMsg = 'even, try again!';
        setNowPlaying = 0;
        break;

      /// player 1 won
      case 1:
        setMsg = '${players[0].name} start';
        setNowPlaying = 0;
        setPreGameMode = false;
        break;

      /// player 2 won
      case -1:
        setMsg = '${players[1].name} starts';
        setNowPlaying = 1;
        setPreGameMode = false;
        if (isSinglePlayer) {
          preGameScores[0] = preGameScores[1] = 0;
          return robotPress();
        }
        break;
    }
    preGameScores[0] = preGameScores[1] = 0;
    setButtonOn = true;
  }

  /// moving players on board
  Future<void> game() async {
    var back = false;
    for (int i = 0; i < _score; i++) {
      // if reached the end go back
      if (players[_nowPlaying].atBox + 1 == boxes.length) back = true;
      playerOneStep(i, back);

      // in case we fall on an arrow
      await Future.delayed(const Duration(milliseconds: 300));
      if (i == _score - 1) {
        final index = arrows
            .indexWhere((e) => e.startCount == players[_nowPlaying].atBox);
        if (index != -1) {
          await Future.delayed(const Duration(milliseconds: 300));
          playerJump = arrows[index].endCount;
        }
      }
    }
    setScore = 0;

    /// if won
    if (players[nowPlaying].atBox + 1 == boxes.length) {
      return setWinner();
    }
    _nowPlaying == 0 ? setNowPlaying = 1 : setNowPlaying = 0;
    if (isSinglePlayer && _nowPlaying == 1) return robotPress();
    setButtonOn = true;
  }

  /// when robot plays
  Future<void> robotPress() async {
    await Future.delayed(const Duration(seconds: 1));
    onPointerDown();
    final random = math.Random(); // random duration of robot pressed
    final mSec = random.nextInt(225) + 25;

    await Future.delayed(Duration(milliseconds: mSec));
    return onPointerUp();
  }

  bool _thereIsAWinner = false;
  bool get thereIsAWinner => _thereIsAWinner;
  void setWinner() {
    _thereIsAWinner = true;
    tryNotify();
  }

  /// to avoid build errors of notifier after disposed
  void tryNotify() {
    try {
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
