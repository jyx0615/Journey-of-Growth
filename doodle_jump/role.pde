void loadRoleImages() {
  roleFireImgs[0] = loadImage("roles/fire1.png");
  roleFireImgs[1] = loadImage("roles/fire2.png");
  roleFireImgs[2] = loadImage("roles/fire3.png");

  roleFireImgsLeft[0] = loadImage("roles/fire1L.png");
  roleFireImgsLeft[1] = loadImage("roles/fire2L.png");
  roleFireImgsLeft[2] = loadImage("roles/fire3L.png");

  roleImgs[0] = loadImage("roles/normal1.png");
  roleImgs[1] = loadImage("roles/normal2.png");
  roleImgs[2] = loadImage("roles/normal3.png");

  roleImgsLeft[0] = loadImage("roles/normal1L.png");
  roleImgsLeft[1] = loadImage("roles/normal2L.png");
  roleImgsLeft[2] = loadImage("roles/normal3L.png");
  
  rockImg = loadImage("roles/rock.png");
}

void drawRole() {
  // if frozen use rock.png
  if(frozen) {
    image(rockImg, curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
    return;
  }
  
  int indexToShow = actionIndex;
  if (jump){
    indexToShow = 2;
  }
  if(faceRight){
    if (onFire)
      image(roleFireImgs[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
    else
      image(roleImgs[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
  } else {
    if (onFire)
      image(roleFireImgsLeft[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
    else
      image(roleImgsLeft[indexToShow], curX, curY, ROLE_WIDTH, ROLE_HEIGHT);
  }
}
