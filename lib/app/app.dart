import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kap_and_roni/app/start.dart';
import 'package:kap_and_roni/storage/pref.dart';
import 'dart:ui';
import 'dart:io';
import '../theme.dart';

class App extends StatefulWidget {
  final int difficulty;
  const App({Key? key, required this.difficulty}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var difficultySelected = <bool>[];

  @override
  void initState() {
    onSelectDifficulty(widget.difficulty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// title
    final title = Column(
      children: [
        FittedBox(
          child: Text(
            'Kap & Roni',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: titleStyle.copyWith(
              color: orange,
              fontSize: 50,
              shadows: shadow,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('Welcome !!', style: subStyle.copyWith(fontSize: 24)),
      ],
    );

    /// grid size
    final gridSize = Column(
      children: [
        Text('grid size', style: subStyle),
        const SizedBox(height: 10),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: offWhite,
          ),
          child: ToggleButtons(
            children: [
              Text(' 6 X 6 ', style: subStyle),
              Text(' 8 X 8 ', style: subStyle),
              Text(' 10 X 10 ', style: subStyle),
            ],
            isSelected: difficultySelected,
            onPressed: (v) {
              onSelectDifficulty(v);
              Pref().setDifficulty(v);
            },
            borderWidth: 2,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        )
      ],
    );

    /// 1 player button
    final onePlayer = ElevatedButton.icon(
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed) ? 0 : 5,
        ),
      ),
      label: Text('Single Player', style: subStyle.copyWith(color: offWhite)),
      icon: const FaIcon(FontAwesomeIcons.robot, size: 17, color: offWhite),
      onPressed: () => onStart(true),
    );

    /// 2 player button
    final twoPlayers = ElevatedButton.icon(
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed) ? 0 : 5,
        ),
      ),
      label: Text('Kap & Roni', style: subStyle.copyWith(color: offWhite)),
      icon: const FaIcon(
        FontAwesomeIcons.userFriends,
        size: 17,
        color: offWhite,
      ),
      onPressed: () => onStart(false),
    );

    /// exit app
    final exitButton = IconButton(
      onPressed: () => exit(0),
      icon: Column(
        children: [
          const FaIcon(FontAwesomeIcons.skull, color: darkGreen, size: 22),
          Text(
            'EXIT',
            style: subStyle.copyWith(
              fontSize: 6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    /// start button
    return Scaffold(
      appBar: AppBar(
        backgroundColor: offWhite,
        elevation: 0,
        leading: exitButton,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              title,
              const Spacer(),
              gridSize,
              const SizedBox(height: 32),
              onePlayer,
              const SizedBox(height: 8),
              twoPlayers,
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }

  /// difficulty selected
  void onSelectDifficulty(int index) {
    setState(() => difficultySelected = List.generate(3, (i) => i == index));
  }

  /// on start game
  Future<void> onStart(bool isSinglePlayer) async {
    /// navigate to game page
    final res = await Navigator.push(context, _route(isSinglePlayer));

    if (res == 'restart') {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Material(
                color: offWhite,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                      child: LinearProgressIndicator(
                        color: banana,
                        backgroundColor: offWhite,
                      ),
                    ),
                    Text(
                      'Restarting...',
                      style: titleStyle.copyWith(color: darkGreen),
                    ),
                  ],
                )),
          );
        },
      );
      await Future.delayed(const Duration(milliseconds: 600));
      Navigator.pop(context);
      onStart(isSinglePlayer);
    }
  }

  /// route transition
  Route _route(bool isSinglePlayer) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Start(
        isSinglePlayer: isSinglePlayer,
        difficulty: difficultySelected.indexWhere((e) => e),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
