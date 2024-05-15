class AnswerModel {
  late String questionId;
  late bool passedByUser;

  int? userChoiceIndex; // mcq , sound

  AnswerModel({
    required this.questionId,
    required this.passedByUser,
    this.userChoiceIndex,
  });
}
