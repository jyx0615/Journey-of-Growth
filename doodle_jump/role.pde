void loadRoleImages() {
  roleFireImgs[0] = loadImage("roles/fire1.png");
  roleFireImgs[1] = loadImage("roles/fire2.png");
  roleFireImgs[2] = loadImage("roles/fire3.png");
  roleFireImgs[3] = loadImage("roles/fire4.png");

  roleFireImgsLeft[0] = loadImage("roles/fire1L.png");
  roleFireImgsLeft[1] = loadImage("roles/fire2L.png");
  roleFireImgsLeft[2] = loadImage("roles/fire3L.png");
  roleFireImgsLeft[3] = loadImage("roles/fire4L.png");

  roleImgs[0] = loadImage("roles/normal1.png");
  roleImgs[1] = loadImage("roles/normal2.png");
  roleImgs[2] = loadImage("roles/normal3.png");
  roleImgs[3] = loadImage("roles/normal4.png");

  roleImgsLeft[0] = loadImage("roles/normal1L.png");
  roleImgsLeft[1] = loadImage("roles/normal2L.png");
  roleImgsLeft[2] = loadImage("roles/normal3L.png");
  roleImgsLeft[3] = loadImage("roles/normal4L.png");
}

void drawRole() {
  if(faceRight){
    if (onFire)
      image(roleFireImgs[actionIndex], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
    else
      image(roleImgs[actionIndex], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
  } else {
    if (onFire)
      image(roleFireImgsLeft[actionIndex], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
    else
      image(roleImgsLeft[actionIndex], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
  }
}