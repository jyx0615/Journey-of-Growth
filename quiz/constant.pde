String question = "";
int questionX = 300;
int questionY = 100;
int correct = 0;   // 0 => not answer, 1 => wrong, 2 => right

int answerChoice = 2;
String answer = "";
int answerX = 300;
int answerY = 700;

int submitX = 300;
int submitY = 600;
int submitWidth = 100;
int submitHeight = 40;

// multiple choice question text
int choicesX = 50;
int choicesY = 200;
int choicesOffsetY = 60;
String []choices;
int activateBtn = -1;    // -1 => no choice is selected

// multiple choice buttons
int buttonX = 50;
int buttonY = 500;
int buttonWidth = 100;
int buttonHeight = 40;
int buttonOffsetX = 130;

// input question
String inputText = "";
int inputX = 200;
int inputY = 400;
int inputWidth = 300;
int inputHeight = 40;
boolean isActive = false;
int inputMaxLength = 20;

int mode = 2; // 1 => multiple choice, 2 => input question
int questionIndex = 0;

JSONArray quizList;

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
