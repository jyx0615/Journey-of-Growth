// 載入圖片
void loadInImage(){
  icons[0] = loadImage("literature.png");
  icons[1] = loadImage("chemistry.png");
  icons[2] = loadImage("music.png");
  icons[3] = loadImage("art.png");
  icons[4] = loadImage("sports.png");
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
    drawDefaultIcon(x, y, size);
  } else {
    image(icons[type - 1], x, y, size, size);
  }
}
