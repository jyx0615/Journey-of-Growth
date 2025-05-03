void drawResultPage() {
  background(#AACCFF);
  textFont(TCFont);
  
  // 計算最高分的科目
  int maxScore = -1;
  int maxIndex = -1;
  for (int i = 0; i < scores.length; i++) {
    if (scores[i] > maxScore) {
      maxScore = scores[i];
      maxIndex = i;
    }
  }
  
  resultSubject = subjects[maxIndex];
  
  // 根據最高分的科目分配學院
  switch(maxIndex) {
    case 0:  // 文科
      resultAcademy = "文學院";
      break;
    case 1:  // 理科
      resultAcademy = "理學院";
      break;
    case 2:  // 音樂
      resultAcademy = "音樂學院";
      break;
    case 3:  // 藝術
      resultAcademy = "藝術學院";
      break;
    case 4:  // 體育
      resultAcademy = "體育學院";
      break;
    default:
      resultAcademy = "未分配學院";
      break;
  }
  
  // 繪製結果頁面
  fill(0);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("遊戲結束", width/2, height/4);
  
  textSize(30);
  text("你的最高分科目：" + resultSubject, width/2, height/2 - 50);
  text("得分：" + maxScore, width/2, height/2);
  text("恭喜你分配到", width/2, height/2 + 50);
  
  textSize(50);
  fill(#FF5733);
  text(resultAcademy, width/2, height/2 + 120);
}
