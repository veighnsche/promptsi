import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_prompt/with_my_reply.dart';
import 'package:prompts_game/models/documents/app_prompt/with_replies.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';

class AppPrompt extends WithDocumentReference with WithMyReply, WithReplies {
  AppPrompt(DocumentReference reference,
      {required this.madeById, required this.prompt})
      : super(reference);

  AppPrompt.create({
    required this.madeById,
    required this.prompt,
  }) : super(null);

  final String madeById;
  final String prompt;

  Future<AppPrompt> rePrompt() async {
    return PromptsApi.createRePrompt(prompt, madeById);
  }

  AppPrompt.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : madeById = json['madeById'],
        prompt = json['prompt'],
        super(reference);

  Map<String, dynamic> toJson() => {
        'madeById': madeById,
        'prompt': prompt,
        'createdOn': DateTime.now().millisecondsSinceEpoch,
      };
}
