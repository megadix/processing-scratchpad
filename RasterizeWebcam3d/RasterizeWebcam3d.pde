/*
 * Inspired by:
 * https://timrodenbroeker.de/rasterize3d/
 */

import com.hamoid.*;
import processing.video.*;

boolean ENABLE_VIDEO = false;
int CAPTURE_WIDTH = 160;
int CAPTURE_HEIGTH = 120;
float ROT_Y = PI / 317;
float ROT_THETA = PI / 93;

Capture video;
boolean recording = false;

float rotY = 0;
float theta = 0;
float zAmplitude = 200;
float zSpread = 0;

VideoExport videoExport;

void setup() {
  size(640, 480, P3D);
  
  frameRate(30);

  if (ENABLE_VIDEO) {
    videoExport = new VideoExport(this, "RasterizeWebcam3d.mp4");
    videoExport.setDebugging(false);
    videoExport.setFrameRate(30);
    videoExport.startMovie();
  }
  
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }

  video = new Capture(this, CAPTURE_WIDTH, CAPTURE_HEIGTH);
  video.start();
}

void captureEvent(Capture video) {  
  video.read();
}

void _update() {
  rotY += ROT_Y;
  theta += ROT_THETA;
  zSpread = sin(theta) * zAmplitude;
}

void draw() {
  _update();

  background(#111111);

  fill(0);
  noStroke();
  sphereDetail(3);

  float numTiles = map(mouseY, 0, height, 80, 10);
  float tileSize = video.width / numTiles;
  int scrWidth_2 = width / 2;

  push();

  translate(scrWidth_2, 0);
  rotateY(rotY);

  video.loadPixels();
  float videoRatio = width / video.width;

  for (int x = 0; x < CAPTURE_WIDTH; x += tileSize) {
    for (int y = 0; y < CAPTURE_HEIGTH; y += tileSize) {
      int pixelIndex = int(x + y * video.width);

      int c = video.pixels[pixelIndex];

      float b = map(5.55 - (float) Math.log(brightness(c) + 1), 0, 5.55, 1, 0);
      float z = map(b, 0, 1, -zSpread, zSpread);

      push();
      translate(
        int(x * videoRatio - scrWidth_2), 
        int(y * videoRatio), 
        -z
        );
      fill(c);
      sphere(tileSize * b * 2.0F);
      pop();
    }
  }
  pop();

  stroke(128);
  fill(255);

  if (ENABLE_VIDEO && recording) {
    videoExport.saveFrame();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
  if (key == 'q' || keyCode == ESC) {
    if (ENABLE_VIDEO) {
      videoExport.endMovie();
    }
    exit();
  }
}
