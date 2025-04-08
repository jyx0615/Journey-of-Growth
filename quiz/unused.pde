void generateMultipleChoice() {
  int num1 = int(random(100));
  int num2 = int(random(100));
  question = "What is " + num1 + " + " + num2 + "?";
  choices =new String[]{
    "This is the first item", 
    "This is the second item", 
    "This is the third item", 
    "This is the last item"
  };
  activateBtn = -1;
  answerChoice = 2;
}

void generateInputQuiz() {
  int num1 = int(random(100));
  int num2 = int(random(100));
  question = "What is " + num1 + " + " + num2 + "?";
  answer = str(num1 + num2);
}
