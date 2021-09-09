import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/prov.dart';
import '../theme.dart';

class WonDialog extends StatelessWidget {
  const WonDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provRef = context.read(prov);
    final name = provRef.players[provRef.nowPlaying].name;
    final isSad = name == 'Robot';

    /// icon
    final icon = FaIcon(
      isSad ? FontAwesomeIcons.frown : FontAwesomeIcons.glassCheers,
      color: isSad ? darkGreen : orange,
    );

    ///msg
    final msg = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 20),
        Text(
          isSad ? 'you lost... \ntry again ?' : '${name.toUpperCase()} WON !!!',
          style: titleStyle.copyWith(
            fontSize: 20,
            color: isSad ? darkGreen : blue,
          ),
        ),
      ],
    );

    /// go back
    final backButton = ElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: Text('back', style: subStyle.copyWith(color: offWhite)),
    );

    /// restart
    final againButton = ElevatedButton(
      onPressed: () => restart(context),
      child: Text('again', style: subStyle.copyWith(color: offWhite)),
    );

    return Container(
      color: Colors.black.withOpacity(0.5),
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Card(
          color: Colors.white.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                msg,
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    backButton,
                    const SizedBox(width: 30),
                    againButton,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void restart(BuildContext context) async => Navigator.pop(context, 'restart');
}
