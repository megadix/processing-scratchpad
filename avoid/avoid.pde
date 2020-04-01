static final int NUM_PARTICLES = 100;
static final int PARTICLE_SIZE = 10;
static final int PARTICLE_SIZE_2 = PARTICLE_SIZE / 2;
static final float SENSITIVITY_RADIUS = 50;
static final float SENSITIVITY = pow(SENSITIVITY_RADIUS, 2);
static final float INIT_SPEED = 1.0;
static final float ESCAPE_SPEED = 5.0;
static final float SLOW_DOWN = 0.96;
static final float MAX_ROT = PI / 128;

class Particle {
  static final int STATE_IDLE = 0;
  static final int STATE_AVOID = 1;
  int state = STATE_IDLE;

  color fill = #333333;
  float heading = 0;
  PVector pos = new PVector();
  PVector vel = new PVector();


  void update() {
    PVector d = new PVector(pos.x - mouseX, mouseY - pos.y);

    if (d.magSq() < SENSITIVITY) {
      state = STATE_AVOID;
    }
    else {
      state = STATE_IDLE;
    }

    switch(state) {
    case STATE_IDLE:
      fill = #333333;
      if (vel.mag() > INIT_SPEED) {
        vel.mult(SLOW_DOWN);
      }
      float rot = (noise(pos.x * 0.01, pos.y * 0.01) - 0.5) * MAX_ROT;
      vel.rotate(rot);
      break;
    case STATE_AVOID:
      fill = #ff0000;
      heading = d.heading();
      vel.set(ESCAPE_SPEED, 0);
      vel.rotate(heading);
      break;
    }

    pos.add(vel);

    // torus topology

    if (pos.x < -PARTICLE_SIZE) {
      pos.x = width + PARTICLE_SIZE;
    } else if (pos.x > width + PARTICLE_SIZE) {
      pos.x = -PARTICLE_SIZE;
    }

    if (pos.y < -PARTICLE_SIZE) {
      pos.y = height + PARTICLE_SIZE;
    } else if (pos.y > height + PARTICLE_SIZE) {
      pos.y = -PARTICLE_SIZE;
    }

    if (vel.magSq() > 0) {
      heading = vel.heading();
    }
  }

  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(heading);
    fill(this.fill);
    stroke(255);
    triangle(-PARTICLE_SIZE_2, PARTICLE_SIZE_2, PARTICLE_SIZE, 0, -PARTICLE_SIZE_2, -PARTICLE_SIZE_2);
    circle(0, 0, 2);
    popMatrix();
  }
}

Particle[] particles;

void _initParticles() {
  float minX = width / 8;
  float maxX = minX * 7;

  float minY = height / 8;
  float maxY = minY * 7;

  for (int i = 0; i < NUM_PARTICLES; i++) {
    particles[i] = new Particle();
    particles[i].pos.set(random(minX, maxX), random(minY, maxY));
    particles[i].heading = random(0, TWO_PI);
    particles[i].vel.set(INIT_SPEED, 0);
    particles[i].vel.rotate(particles[i].heading);
  }
}

void setup() {
  size(640, 480);
  particles = new Particle[NUM_PARTICLES];
  _initParticles();
}

void draw() {
  background(0);

  for (int i = 0; i < NUM_PARTICLES; i++) {
    Particle p = particles[i];
    p.update(); 
    p.draw();
  }
  
  stroke(#F6FF0A);
  fill(#F6FF0A, 50);
  circle(mouseX, mouseY, SENSITIVITY_RADIUS);
}

void mouseClicked() {
  _initParticles();
}
