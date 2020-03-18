import java.util.Iterator;

int NUM_STARS = 200;
int MAX_TRAIL = 10;
float MAX_DIST = 100;
float STARS_WIDTH = 30000;
float STARS_WIDTH_2 = STARS_WIDTH / 2;
float MIN_SPEED = 0.2;
float MAX_SPEED = 2.0;
float SPEED_INCREASE = 0.01;

ArrayList<Star> stars = new ArrayList<Star>();
float speed = MIN_SPEED;

int screenWidth_2 = 0;
int screenHeight_2 = 0;

boolean running = false;

/*
 * Helper functions
 */

void _repositionStar(Star star) {
  star.randomize();
  star.z = MAX_DIST;
}

void _update() {
  if (keyPressed == true && key == CODED && keyCode == CONTROL) {
    speed += SPEED_INCREASE;
  }
  else {
    speed -= SPEED_INCREASE;
  }

  speed = constrain(speed, MIN_SPEED, MAX_SPEED);

  for (int i = 0; i < NUM_STARS; i++) {
    Star star = stars.get(i);
    star.z -= speed;
    if (star.z < 1) {
      _repositionStar(star);
    }
  }
}

/*
 * Processing callbacks
 */

void setup() {
  fullScreen();
  pixelDensity(1);
  noCursor();
  noLoop();

  for (int i = 0; i < NUM_STARS; i++) {
    Star star = new Star();
    star.randomize();
    star.z = random(0, MAX_DIST);
    stars.add(star);
  }

  screenWidth_2 = width / 2;
  screenHeight_2 = height / 2;

  running = false;
}

void draw() {
  background(0);
  _update();
  loadPixels();

  Iterator<Star> iter = stars.iterator();

  while (iter.hasNext()) {
    Star star = iter.next();

    int trail = (int) (map(speed, MIN_SPEED, MAX_SPEED, 1, MAX_TRAIL));

    float z = star.z;

    for(int i = 0; i < trail; i++) {
      z = z + i / 3;
      int x = (int) (star.x / z + screenWidth_2);
      int y = (int) (star.y / z + screenHeight_2);

      if (x < 0 || x >= width || y < 0 || y >= height) {
        _repositionStar(star);
        continue;
      }

      float damp = map(star.z, 0, MAX_DIST, 0, 2);
      pixels[y * width + x] = color(star.r / damp, star.g / damp, star.b / damp, 255);
    }
  }
  updatePixels();

  stroke(128);
  fill(255);
  textAlign(LEFT);
  text("Press CTRL for warp", 10, 10);
  text("FPS: " + frameRate, 10, 30);

  if (!running) {
    textAlign(CENTER);
    text("Click to start", screenWidth_2, screenHeight_2);
    noLoop();
  }
}

void mouseClicked() {
  running = !running;
  if (running) {
    loop();
  }
}

/*
 * Classes
 */

class Star {
  float x;
  float y;
  float z;
  int r;
  int g;
  int b;

  void randomize() {
    this.x = random(-STARS_WIDTH, STARS_WIDTH);
    this.y = random(-STARS_WIDTH, STARS_WIDTH);
    this.r = (int) random(0, 255);
    this.g = (int) random(0, 255);
    this.b = (int) random(0, 255);
  }
}
