import '../models/question_model.dart';

List<QuestionModel> quiz1 = [
  QuestionModel(
    id: 1,
    title: "assets/animal sounds/cow.mp3",
    type: "sound",
    answers: [
      "assets/animal images/african-grey-parrot.png",
      "assets/animal images/butterfly.png",
      "assets/animal images/cow.png",
      "assets/animal images/duck.png"
    ],
    correctAnswerIndex: 2,
  ),
  QuestionModel(
    id: 2,
    title: "How many legs does a spider have?",
    type: "mcq",
    answers: [
      "6",
      "7",
      "8",
      "9"
    ],
    correctAnswerIndex: 2,
  ),
  QuestionModel(
    id: 3,
    title: " If you freeze water, what do you get?",
    type: "mcq",
    answers: [
      "ice",
      "water",
      "cold",
      "dish"
    ],
    correctAnswerIndex: 0,
  ),
  QuestionModel(
    id: 4,
    title: "Put the following animals in their right place",
    type: "drag",
    answers: [
      "assets/animal images/duck.png",
      "assets/animal images/elephant.png",
      "assets/animal images/panda.png",
    ],
    dragChecker: {
      "duck":false,
      "elephant":false,
      "panda":false,
    },
  ),
  QuestionModel(
    id: 5,
    title: " Where is the Great Pyramid of Giza?",
    type: "mcq",
    answers: [
      "Egypt",
      "USA",
      "Russia",
      "Germany"
    ],
    correctAnswerIndex: 0,
  ),
];