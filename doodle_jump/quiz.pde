class Quiz {
  int type;
  String question;
  String answerStr;
  int answerNum;
  String[] choices;

  Quiz(JSONObject obj) {
    type = obj.getInt("type");
    question = obj.getString("question");

    if (type == 1) {
      answerNum = obj.getInt("answer");
      JSONArray c = obj.getJSONArray("choices");
      choices = new String[c.size()];
      for (int i = 0; i < c.size(); i++) {
        choices[i] = c.getString(i);
      }
    } else if (type == 2) {
      answerStr = obj.getString("answer");
    }
  }
}

Quiz[] quizzes;

boolean quiz_mode = false; // Flag to track quiz mode
float transitionProgress = 0; // Progress of the transition (0 to 1)
boolean show_quiz_content = false; // Flag to show quiz content
float exit_counter = 0;

void drawQuizSection() {
  rectMode(CORNER);
  noStroke();
  fill(232, 220);
  rect(0, 0, width, height);

  // draw the quiz start background
  if (!show_quiz_content) {
    // Draw the quiz start background
    if (transitionProgress < 1) {
      transitionProgress += 0.02; // Adjust speed of transition
      float scale = min(map(transitionProgress, 0, 1, 0, 1), 1);
      float centerX = width / 2;
      float centerY = 360;
      float imgWidth = 400 * scale;
      float imgHeight = 600 * scale;

      imageMode(CENTER);
      image(quizStartBackground, centerX, centerY, imgWidth, imgHeight);
    } else {
      imageMode(CENTER);
      image(quizStartBackground, width/2, 360, 400, 600);
      show_quiz_content = true; // Show quiz content after transition
    } 
  } 
  // draw the quiz background with content
  else {
    imageMode(CENTER);
    image(quizBackground, width/2, 360, 400, 600);

    // Draw quiz content
    drawQuestion();
    if (type == 1) { // Multiple choice
      drawChoices();
      drawButtons();
    } else if (type == 2) { // Input question
      drawInputTitle();
      drawInput();
    }
    drawSubmitButton();
    drawAnswer();

    // Leave the quiz section
    if(exit_counter > 0) {
      exit_counter -= 0.015;
      if(exit_counter <= 0) {
        resetQuiz();
      }
    }
  }
}

void loadBackgroundImage() {
  quizStartBackground = loadImage("background/quiz_start.png");
  quizBackground = loadImage("background/quiz.png");
}

void resetQuiz() {
  transitionProgress = 0; // Reset transition progress
  show_quiz_content = false; // Reset quiz content visibility
  correct = 0; // Reset answer status
  inputText = "";
  activateBtn = -1;
  quiz_mode = false;
  exit_counter = 0;
}

void handleSubmit() {
  correct = 1;
  if (type == 1 && activateBtn == answerChoice - 1)
    correct = 2;
  else if (type == 2 && inputText.equals(answer))
    correct = 2;
  if(correct == 2) {
    correctSound.rewind();
    correctSound.play();
  } else {
    wrongSound.rewind();
    wrongSound.play();
  }
  exit_counter = 1;
}

void drawSubmitButton() {
  noStroke();
  rectMode(CENTER);
  fill(#3DB709);
  rect(submitX, submitY, submitWidth, submitHeight, 5);
  fill(#1D5D03);
  textAlign(CENTER, CENTER);
  text("submit", submitX, submitY);
}

void drawAnswer() {
  textAlign(CENTER, CENTER);
  if(correct == 1){
    fill(#E80911);
    text("wrong", answerX, answerY);
  } else if (correct == 2){
    fill(#3DB709);
    text("correct", answerX, answerY);
  }
}

void drawInputTitle() {
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Your answer", inputX - 30, inputY - 30);
}

void drawInput() {
  rectMode(CORNER);
  textAlign(LEFT, CENTER);

  stroke(#2609E8);
  fill(240);
  rect(inputX, inputY, inputWidth, inputHeight, 5);

  fill(0);
  textSize(20);
  text(inputText, inputX + 10, inputY + inputHeight/2);
}

void setQuiz(Quiz q) {
  question = q.question;
  type = q.type;
  if (q.type == 1){
    answerChoice = q.answerNum;
    choices = q.choices;
  } else if(q.type == 2) {
    answer = q.answerStr;
  }
}

void drawQuestion() {
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(20);
  text(question, questionX, questionY);
}

void drawChoices() {
  textAlign(LEFT, CENTER);
  for (int i = 0; i < choices.length; i++) {
    text("(" + str(i+1) + ") " + choices[i], choicesX, choicesY + choicesOffsetY * i);
  }
}

void drawButtons() {
  rectMode(CORNER);
  textAlign(CENTER, CENTER);
  textSize(24);
  for (int i = 0; i < choices.length; i ++) {
     int startX = buttonX + buttonOffsetX * i;
     stroke(23, 92, 192);
     noFill();
     rect(startX, buttonY, buttonWidth, buttonHeight, 5);

     stroke(0);
     circle(startX + 50, buttonY + buttonHeight/2, 15);
     fill(0);

     text("(" + str(i+1) + ")", startX + 20, buttonY + buttonHeight/2);
     if(activateBtn == i) {
       fill(23, 92, 192);
       circle(startX + 50, buttonY + buttonHeight/2, 10);
     }
  }
}

void readQuiz() {
  JSONArray quizData = loadJSONArray("quiz.json");
  quizzes = new Quiz[quizData.size()];

  for (int i = 0; i < quizData.size(); i++) {
    quizzes[i] = new Quiz(quizData.getJSONObject(i));
  }

  //// Example: show all loaded quizzes
  //for (int i = 0; i < quizzes.length; i++) {
  //  setQuiz(quizzes[i], i + 1);
  //}
}
