import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kap_and_roni/paint/blinking_text.dart';
import 'package:kap_and_roni/paint/progress_bar.dart';
import 'package:kap_and_roni/paint/robot_icon.dart';
import '../paint/arrow.dart';
import '../providers/prov.dart';
import '../theme.dart';
import 'won_dialog.dart';

class Start extends ConsumerWidget {
  final bool isSinglePlayer;
  final int difficulty;
  static const circularIndicatorSize = 50.0, lineSize = 3.0, buttonSize = 36.0;

  const Start({
    required this.isSinglePlayer,
    required this.difficulty,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provRef = watch(prov);
    final size = MediaQuery.of(context).size;
    final nowPlaying = provRef.nowPlaying;

    /// calculate step size on grip
    if (provRef.gridGap == 0.0) provRef.init(size, isSinglePlayer, difficulty);

    /// players as obj
    final player1 = provRef.players.first, player2 = provRef.players.last;

    /// grid
    final grid = Column(mainAxisSize: MainAxisSize.min, children: provRef.grid);

    /// arrows on grid
    final arrowsWithGrid = CustomPaint(
      child: grid,
      foregroundPainter: ArrowsPaint(provRef.arrows),
    );

    /// player1 widget
    final movingPlayer1 = AnimatedPositioned(
      child: FaIcon(FontAwesomeIcons.male, size: 30, color: player1.color),
      left: provRef.getPlayerPosition(0).dx - 7,
      top: provRef.getPlayerPosition(0).dy - 5,
      duration: const Duration(milliseconds: 200),
    );

    /// player2 widget
    final movingPlayer2 = AnimatedPositioned(
      child: isSinglePlayer
          ? RobotIcon(col: player2.color)
          : FaIcon(FontAwesomeIcons.male, size: 30, color: player2.color),
      left: provRef.getPlayerPosition(1).dx - 3,
      top: provRef.getPlayerPosition(1).dy - 5,
      duration: const Duration(milliseconds: 200),
    );

    /// player 1 box
    final player1Box = Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: yellow),
        color: nowPlaying == 0 ? banana : offWhite,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
          topLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: boxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FaIcon(FontAwesomeIcons.male, size: 72, color: player1.color),
          Column(
            children: [
              nowPlaying == 0
                  ? BlinkingText(
                      text: player1.name,
                      style: subStyle.copyWith(fontWeight: FontWeight.bold),
                    )
                  : Text(player1.name, style: subStyle),
              const SizedBox(height: 5),
              if (provRef.isPreGameMode)
                Text('${provRef.preGameScores[0]}', style: subStyle),
            ],
          ),
        ],
      ),
    );

    /// player 2 box
    final player2Box = Container(
      padding: const EdgeInsets.all(8),
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: yellow),
        color: nowPlaying == 1 ? banana : offWhite,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          topLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
        boxShadow: boxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              nowPlaying == 1
                  ? BlinkingText(
                      text: player2.name,
                      style: subStyle.copyWith(fontWeight: FontWeight.bold),
                    )
                  : Text(player2.name, style: subStyle),
              const SizedBox(height: 5),
              if (provRef.isPreGameMode)
                Text('${provRef.preGameScores[1]}', style: subStyle),
            ],
          ),
          isSinglePlayer
              ? RobotIcon(col: player2.color, scale: 3)
              : FaIcon(FontAwesomeIcons.male, size: 72, color: player2.color),
        ],
      ),
    );

    /// press button
    final pressButton = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        /// indicator
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
          child: RotatedBox(
            quarterTurns: 75,
            child: Container(
              height: 30,
              width: 60,
              margin: const EdgeInsets.only(left: 52),
              child: ProgressBar(max: 1, current: provRef.score.toDouble() / 5),
            ),
          ),
        ),

        /// touch
        AbsorbPointer(
          absorbing: !provRef.isButtonOn,
          child: Listener(
            onPointerDown: (_) => context.read(prov).onPointerDown(),
            onPointerUp: (_) => context.read(prov).onPointerUp(),
            child: FloatingActionButton(
              disabledElevation: 0,
              elevation: 10,
              backgroundColor: darkGreen,
              onPressed: provRef.isTimerOn ? null : () {},
              child: Text(
                'PUSH',
                style: TextStyle(
                  color: provRef.isTimerOn
                      ? yellow
                      : provRef.isButtonOn
                          ? offWhite
                          : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 3,
          child: Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${provRef.score}',
              style: const TextStyle(color: darkGreen, fontSize: 16),
            ),
          ),
        ),
        Positioned(
          top: 25,
          left: 0,
          child: Visibility(
            visible: nowPlaying == 0,
            child: const FaIcon(FontAwesomeIcons.caretLeft, color: darkGreen),
          ),
        ),
        Positioned(
          top: 25,
          right: 0,
          child: Visibility(
            visible: nowPlaying == 1,
            child: const FaIcon(FontAwesomeIcons.caretRight, color: darkGreen),
          ),
        )
      ],
    );

    /// back button
    final appBarLeading = IconButton(
      icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: darkGreen),
      onPressed: () => Navigator.pop(context),
    );

    /// app bar title
    final title = Text(
      isSinglePlayer ? 'Kap & Robot' : 'Kap & Roni',
      style: subStyle.copyWith(color: darkGreen),
    );

    /// restart button
    final restartButton = IconButton(
      icon: const FaIcon(FontAwesomeIcons.undoAlt, color: darkGreen),
      onPressed: () => Navigator.pop(context, 'restart'),
    );

    /// board
    final board = Container(
      decoration: BoxDecoration(
        color: offWhite,
        border: Border.all(width: 2, color: darkGreen),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: boxShadow,
      ),
      child: Stack(
        children: [arrowsWithGrid, movingPlayer1, movingPlayer2],
      ),
    );

    /// msgs
    final msgs = Text(
      provRef.msg,
      style: Theme.of(context).textTheme.caption!.copyWith(
            color: darkGreen,
            shadows: shadow,
          ),
    );

    return Container(
      color: offWhite,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: offWhite,
            leading: appBarLeading,
            title: title,
            centerTitle: true,
            actions: [restartButton],
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const Spacer(flex: 3),
                  board,
                  const Spacer(flex: 1),
                  msgs,
                  const Spacer(flex: 1),
                  Row(
                    children: [
                      const Spacer(),
                      player1Box,
                      const Spacer(),
                      pressButton,
                      const Spacer(),
                      player2Box,
                      const Spacer(),
                    ],
                  ),
                  const Spacer(flex: 5),
                ],
              ),
              if (provRef.thereIsAWinner) const WonDialog(),
            ],
          ),
        ),
      ),
    );
  }
}
