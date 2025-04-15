// 載入圖片
void loadInImage(){
  img1 = loadImage("literature.png");
  img2 = loadImage("chemistry.png");
  img3 = loadImage("music.png");
  img4 = loadImage("art.png");
  img5 = loadImage("sports.png");
}

void drawIcon(int type, int x, int y, int size) {
  switch(type) {
    case 1:
      if (img1 != null) {
        image(img1, x, y, size, size);
      } else {
        // 如果圖片未加載，則繪製簡單的圖形
        fill(#FF0000);
        ellipse(x + size/2, y + size/2, size, size);
      }
      break;
    case 2:
      if (img2 != null) {
        image(img2, x, y, size, size);
      } else {
        fill(#00FF00);
        ellipse(x + size/2, y + size/2, size, size);
      }
      break;
    case 3:
      if (img3 != null) {
        image(img3, x, y, size, size);
      } else {
        fill(#0000FF);
        ellipse(x + size/2, y + size/2, size, size);
      }
      break;
    case 4:
      if (img4 != null) {
        image(img4, x, y, size, size);
      } else {
        fill(#FFFF00);
        ellipse(x + size/2, y + size/2, size, size);
      }
      break;
    case 5:
      if (img5 != null) {
        image(img5, x, y, size, size);
      } else {
        fill(#FF00FF);
        ellipse(x + size/2, y + size/2, size, size);
      }
      break;
    default:
      // 默認繪製
      fill(#FFFFFF);
      ellipse(x + size/2, y + size/2, size, size);
      break;
  }
}
