/**
 * Inspired by: "Processing-Tutorial: Rasterize 3D" by Tim Rodenbröker
 * https://timrodenbroeker.de/rasterize3d/
 */

PImage img = null;

void setup() {
  fullScreen(P3D);
  img = loadImage("data/kiru_up.jpg");
  img.resize(width / 2, height / 2);
}

void draw() {
  background(#f1f1f1);

  fill(0);
  noStroke();
  sphereDetail(3);

  float tiles = map(mouseY, 0, height, 100, 20);
  float tileSize = width / tiles;
  int width_2 = width / 2;
  int height_2 = height / 2;

  push();

  translate(width_2, 0, -width);
  rotateY(map(mouseX, 0, width, -PI, PI));

  for (int x = 0; x < tiles; x++) {
    for (int y = 0; y < tiles; y++) {
      int c = img.get(
        (int) map(x, 0, tiles, 0, img.width), 
        (int) map(y, 0, tiles, 0, img.height)
        );

      float b = map(brightness(c), 0, 255, 1, 0);
      float z = map(b, 0, 1, -150, 150);

      push();
      translate(
        (int) (x * tileSize - width_2), 
        (int) (y * tileSize - height_2), 
        -z
        );
      fill(c);
      sphere(tileSize * b * 0.8F);
      pop();
    }
  }
  pop();
}
