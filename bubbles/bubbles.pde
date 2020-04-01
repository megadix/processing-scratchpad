static final int NUM_PARTICLES = 30;
static final float PARTICLE_SPEED = -1;
static final float X_SPREAD = 0.1;

class Particle {
  PVector position = new PVector();
  PVector velocity = new PVector();
  color col;

  void update() {
    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;
  }
}

Particle[] particles;

color[] palette;
color background;

float partMaxZ;

void resetParticle(Particle particle) {
  particle.position.x = random(0.0, width);
  particle.position.y = height + particle.position.z;
  particle.velocity.x = 0.0;
  particle.velocity.y = PARTICLE_SPEED - particle.position.z / 10;
  particle.col = palette[int(random(0, palette.length))];
}

Particle newParticle(int i, float maxZ) {
  Particle particle = new Particle();
  particle.position.z = map(i, 0, NUM_PARTICLES, 1, maxZ);
  resetParticle(particle);
  particle.position.y += random(0, height / 2);
  
  return particle;
}

void setupPalette() {
  background = #354B65;
  palette = new color[10];
  palette[0] = #0336EF;
  palette[1] = #3AB5FF;
  palette[2] = #89FFFF;
  palette[3] = #88C3FF;
  palette[4] = #E42F64;
  palette[5] = #040818;
  palette[6] = #3F495D;
  palette[7] = #E0EAE3;
  palette[8] = #BBB3A5;
  palette[9] = #8A6D89;
}

void setup() {
  //fullScreen();
  size(640, 480);

  setupPalette();

  partMaxZ = width / 10;

  particles = new Particle[NUM_PARTICLES];

  int numFarAway = NUM_PARTICLES - NUM_PARTICLES / 10;

  for (int i = 0; i < numFarAway; i++) {
    particles[i] = newParticle(i, partMaxZ / 3);
  }
  for (int i = numFarAway; i < NUM_PARTICLES; i++) {
    particles[i] = newParticle(i, partMaxZ);
  }
  
}

void draw() {
  background(background);

  for (int i = 0; i < NUM_PARTICLES; i++) {
    Particle particle = particles[i];

    particle.velocity.x += random(-X_SPREAD, X_SPREAD);
    particle.update();

    if ((particle.position.y + particle.position.z < 0) ||
        (particle.position.x - particle.position.z > width) ||
        (particle.position.x + particle.position.z < 0)) {
      resetParticle(particle);
    }

    stroke(particle.col, 128);
    strokeWeight(map(particle.position.z, 1, partMaxZ, 1, 5));
    fill(particle.col, 64);
    circle(particle.position.x, particle.position.y, particle.position.z);
  }
}
