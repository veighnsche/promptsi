import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reactions extends StatelessWidget {
  Reactions({
    Key? key,
    required this.reaction,
    required this.onReact,
    this.disabled = false,
  }) : super(key: key);

  Reactions.iconOnly({
    Key? key,
    required this.reaction,
    this.onReact,
    this.disabled = true,
  }) : super(key: key);

  final int? reaction;
  final Function(int)? onReact;
  final bool disabled;

  bool get _hasReaction {
    return reaction != null;
  }

  Reaction? get _selectedReaction {
    if (!_hasReaction) {
      return null;
    }
    return _reactions.elementAt(reaction!);
  }

  final Reaction _emptyReaction = Reaction(
    icon: const FaIcon(
      FontAwesomeIcons.heart,
      color: Colors.black26,
    ),
  );

  final List<FaIcon> _icons = [
    const FaIcon(
      FontAwesomeIcons.solidHeart,
      color: Colors.red,
    ),
    const FaIcon(
      FontAwesomeIcons.crown,
      color: Colors.orange,
    ),
    const FaIcon(
      FontAwesomeIcons.solidLaughSquint,
      color: Colors.orange,
    ),
    const FaIcon(
      FontAwesomeIcons.solidSadTear,
      color: Colors.blue,
    ),
    const FaIcon(
      FontAwesomeIcons.solidFlag,
      color: Colors.red,
    ),
  ];

  List<Reaction> get _reactions {
    return _icons.map((FaIcon icon) {
      return Reaction(icon: icon);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      if (!_hasReaction) {
        return const SizedBox.shrink();
      }
      return _icons.elementAt(reaction!);
    }

    return FlutterReactionButtonCheck(
      onReactionChanged: (reaction, index, isChecked) {
        onReact!(index);
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
