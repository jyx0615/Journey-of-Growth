class Enemy {
  int x, y;
  float theta, speed;
  
  Enemy(int xPos, int yPos, float thetaIn, float speedIn) {
    x = xPos;
    y = yPos;
    theta = thetaIn;
    speed = speedIn;
  }
  
  void draw() {
    fill(#0F6FF2);
    circle(x, y, 60);
  }
  
  void move() {
    x += int(speed * cos(theta));
    y += int(speed * sin(theta));
  }
  
  boolean hitRole() {
    int d = (curX - x) * (curX - x) + (curY- y) * (curY - y);
    if(d < 90 * 90)
      return true;
    return false;
  }
  
  boolean getHit() {
    for (int i = 0; i < weapons.size(); i++) {
      Weapon w = weapons.get(i);
      int d = (w.x - x) * (w.x - x) + (w.y - y) * (w.y - y);
      if(d < weaponR * weaponR)
        return true;
    }
    return false;
  }
}
