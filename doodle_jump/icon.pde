// 載入圖片
void loadSubjectImages(){
  icons[0] = loadImage("subjects/literacture.png");
  icons[1] = loadImage("subjects/math.png");
  icons[2] = loadImage("subjects/music.png");
  icons[3] = loadImage("subjects/art.png");
  icons[4] = loadImage("subjects/sports.png");
  icons[5] = loadImage("subjects/certificate.png");
  icons[6] = loadImage("subjects/clock.png");
  icons[7] = loadImage("subjects/quiz.png");
  TCFont = createFont("Iansui-Regular", 15);
  door = loadImage("icons/door.png");
}

// 如果圖片未加載，則繪製簡單的圖形
void drawDefaultIcon(int x, int y, int size) {
  fill(#FFFFFF);
  ellipse(x + size/2, y + size/2, size, size);
}

void drawIcon(int type, int x, int y, int size) {
  // 如果類型為0，則不繪製圖標
  if (type == 0) {
    return;
  } else if (type >= 6 || icons[type - 1] == null) {
    imageMode(CORNER);
    image(icons[type - 1], x, y, size, size);
    //drawDefaultIcon(x, y, size);
  } else {
    imageMode(CORNER);
    image(icons[type - 1], x, y, size, size);
  }
}
