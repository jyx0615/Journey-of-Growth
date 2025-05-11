class Weapon {
  int x, y;
  float theta, speed;
  Weapon(float thetaIn, float speedIn) {
    x = 300;
    y = 400;
    theta = thetaIn;
    speed = speedIn;
  } 
  
  void move() {
      x += int(speed * cos(theta));
      y += int(speed * sin(theta));
  }
  
  void draw() {
    image(weaponImgs[0], x, y, weaponR, weaponR);
  }
  
  boolean out() {
    if(x >= width || x <= 0){
      if(y >= height || y <= 0)
        return true;
    }
    return false;
  }
}
