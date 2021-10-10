import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reactions extends StatelessWidget {
  Reactions({
    Key? key,
    this.reaction,
    required this.onReact,
  }) : super(key: key);

  final int? reaction;
  final Function(int) onReact;

  bool get _hasReaction {
    return reaction != null;
  }

  Reaction? get _selectedReaction {
    if (!_hasReaction) {
      return null;
    }
    return _reactions[reaction!];
  }

  final Reaction _emptyReaction = Reaction(
    icon: const FaIcon(
      FontAwesomeIcons.heart,
      color: Colors.black26,
    ),
  );

  final List<Reaction> _reactions = [
    Reaction(
      icon: const FaIcon(
        FontAwesomeIcons.solidHeart,
        color: Colors.red,
      ),
    ),
    Reaction(
      icon: const FaIcon(
        FontAwesomeIcons.crown,
        color: Colors.orange,
      ),
    ),
    Reaction(
      icon: const FaIcon(
        FontAwesomeIcons.solidLaughSquint,
        color: Colors.orange,
      ),
    ),
    Reaction(
      icon: const FaIcon(
        FontAwesomeIcons.solidSadTear,
        color: Colors.blue,
      ),
    ),
    Reaction(
      icon: const FaIcon(
        FontAwesomeIcons.solidFlag,
        color: Colors.red,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterReactionButtonCheck(
      onReactionChanged: (reaction, index, isChecked) {
        onReact(index);
      },
      boxItemsSpacing: 16,
      boxPadding: const EdgeInsets.all(16),
      isChecked: _hasReaction,
      selectedReaction: _selectedReaction,
      initialReaction: _emptyReaction,
      reactions: _reactions,
    );
  }
}
