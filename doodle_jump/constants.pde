// role properties
int curX = 300;
int curY = 720;
float curV = 0;
int cur_jump_count = 0;
boolean jump = false;

// opperating settings
int MAX_JUMP_COUNT = 2;
float JUMP_V0 = -10;
float ACCELERATE = 0.3;
int LAYER_HEIGHT = 150;
int BLOCK_HEIGHT = 30;
int ROLE_HEIGHT = 80;
int ROLE_WIDTH = 20;
int MAX_LEVEL = 20;
int CANVA_SPEED = 10;

// game properties
int base = MAX_LEVEL - 5;  // since we render 5 levels at a time
boolean is_moving = false;
int canva_offset = 200;
int [][] blocks;
int []COLORS = {#EAD90E, #FF5733, #33FF57, #3357FF, #FFFF33, #FF3829};
