import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';

class ChoosePreMadePrompts extends StatelessWidget {
  const ChoosePreMadePrompts({
    Key? key,
    required this.onPromptsSubmit,
    this.minimumAmount = 1,
  }) : super(key: key);

  final Function(List<AppPrompt>) onPromptsSubmit;
  final int minimumAmount;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PromptsApi.fetchPreMadePrompts(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<AppPrompt>?> snapshot,
      ) {
        if (snapshot.hasError) {
          throw snapshot.error!;
          // return ErrorScaffold(message: snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return _FutureBuilderDone(
            widget: this,
            data: snapshot.data!,
          );
        }

        return const LoadingScaffold();
      },
    );
  }
}

class _FutureBuilderDone extends StatefulWidget {
  const _FutureBuilderDone({Key? key, required this.widget, required this.data})
      : super(key: key);

  final ChoosePreMadePrompts widget;
  final List<AppPrompt> data;

  Function(List<AppPrompt>) get onPromptsSubmit {
    return widget.onPromptsSubmit;
  }

  int get minimumAmount {
    return widget.minimumAmount;
  }

  @override
  State<_FutureBuilderDone> createState() => _FutureBuilderDoneState();
}

class _FutureBuilderDoneState extends State<_FutureBuilderDone> {
  List<AppPrompt> selectedPrompts = [];

  int get currentAmount {
    return selectedPrompts.length;
  }

  bool _inSelectedPrompt(AppPrompt prompt) {
    if (prompt.reference == null) {
      throw 'no reference in prompt model "${prompt.prompt}"';
    }

    return selectedPrompts
        .map((s) => s.reference!.id)
        .contains(prompt.reference!.id);
  }

  Function() _onPreMadePromptTap(AppPrompt prompt) {
    return () {
      setState(() {
        if (_inSelectedPrompt(prompt)) {
          selectedPrompts.removeWhere(
              (element) => element.reference!.id == prompt.reference!.id);
        } else {
          selectedPrompts.add(prompt);
        }
      });
    };
  }

  Icon _leadingCheckBox(AppPrompt prompt) {
    if (_inSelectedPrompt(prompt)) {
      return const Icon(Icons.check_box);
    }
    return const Icon(Icons.check_box_outline_blank);
  }

  void _onSubmit() {
    if (currentAmount >= widget.minimumAmount) {
      widget.onPromptsSubmit(selectedPrompts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text('Select your first $currentAmount/${widget.minimumAmount} prompts that your candidates can respond to'),
        ),
        const SizedBox(height: 32),
        Column(
          children: widget.data.map((AppPrompt prompt) {
            return Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: _onPreMadePromptTap(prompt),
                child: SizedBox(
                  width: 300,
                  child: ListTile(
                    leading: _leadingCheckBox(prompt),
                    title: Text(prompt.prompt),
                    subtitle:
                        Text('made by ${prompt.madeByProfile!.firstName}'),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        TextButton(
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          onPressed: _onSubmit,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
