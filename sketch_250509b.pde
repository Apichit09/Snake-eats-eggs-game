int cellSize = 20;
int cols, rows;
Snake snake;
Egg egg;
ArrayList<Particle> particles;
ArrayList<PVector> obstacles;

boolean gameOver;
int score;
int baseSpeed = 10;
int speedTimer;

void setup() {
  size(600, 600);
  cols = width / cellSize;
  rows = height / cellSize;
  textFont(createFont("Arial Bold", 18));
  initializeGame();
}

void draw() {
  background(255);
  drawGrid();
  drawObstacles();

  if (!gameOver) {
    handleSpeed();
    PVector head = snake.getHead();
    PVector next = head.copy().add(snake.dir);

    if (next.x < 0 || next.x >= cols || next.y < 0 || next.y >= rows) {
      gameOver = true;
    }

    for (PVector o : obstacles) {
      if (next.equals(o)) {
        gameOver = true;
        break;
      }
    }

    boolean ate = next.equals(egg.pos);
    if (ate) {
      score++;
      emitParticles(next, 20);
      int t = egg.type;
      egg.spawn(snake.body, obstacles);
      if (t == 1) {
        snake.grow(); snake.grow();
      } else if (t == 2) {
        frameRate(baseSpeed * 2);
        speedTimer = 100;
      } else {
        snake.grow();
      }
    }

    snake.body.add(0, next);
    if (!ate) snake.body.remove(snake.body.size() - 1);

    if (!egg.isImmortal() && snake.selfCollision()) {
      gameOver = true;
    }

    snake.display();
    egg.display();
    updateParticles();
    drawScore();
  } else {
    drawGameOver();
  }
}

void keyPressed() {
  if (!gameOver) {
    if (keyCode == UP && snake.dir.y == 0)    snake.dir.set(0, -1);
    if (keyCode == DOWN && snake.dir.y == 0)  snake.dir.set(0, 1);
    if (keyCode == LEFT && snake.dir.x == 0)  snake.dir.set(-1, 0);
    if (keyCode == RIGHT && snake.dir.x == 0) snake.dir.set(1, 0);
  } else if (keyCode == ENTER) {
    initializeGame();
  }
}

void initializeGame() {
  snake = new Snake();
  obstacles = new ArrayList<PVector>();
  spawnObstacles(15);
  egg = new Egg();
  egg.spawn(snake.body, obstacles);
  particles = new ArrayList<Particle>();
  score = 0;
  speedTimer = 0;
  gameOver = false;
  frameRate(baseSpeed);
}

void handleSpeed() {
  if (speedTimer > 0) speedTimer--;
  else frameRate(baseSpeed + score / 5);
}

void drawGrid() {
  stroke(220);
  for (int i = 0; i <= cols; i++) line(i * cellSize, 0, i * cellSize, height);
  for (int j = 0; j <= rows; j++) line(0, j * cellSize, width, j * cellSize);
  noStroke();
}

void spawnObstacles(int count) {
  obstacles.clear();
  while (obstacles.size() < count) {
    PVector p = new PVector(floor(random(cols)), floor(random(rows)));
    if (!snake.body.contains(p) && !obstacles.contains(p)) {
      obstacles.add(p);
    }
  }
}

void drawObstacles() {
  fill(180);
  noStroke();
  for (PVector o : obstacles) {
    rect(o.x * cellSize, o.y * cellSize, cellSize, cellSize);
  }
}

void emitParticles(PVector origin, int amt) {
  for (int i = 0; i < amt; i++) particles.add(new Particle(origin));
}

void updateParticles() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update(); p.display();
    if (p.done()) particles.remove(i);
  }
}

void drawScore() {
  fill(0);
  textAlign(LEFT, TOP);
  text("Score: " + score, 10, 10);
}

void drawGameOver() {
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  textSize(36);
  text("Game Over", width / 2, height / 2 - 20);
  textSize(18);
  text("Press ENTER to restart", width / 2, height / 2 + 20);
}

class Snake {
  ArrayList<PVector> body;
  PVector dir;
  Snake() {
    body = new ArrayList<PVector>();
    body.add(new PVector(cols/2, rows/2));
    dir = new PVector(1, 0);
  }
  PVector getHead() { return body.get(0); }
  void grow() { body.add(body.get(body.size() - 1).copy()); }
  void display() {
    for (int i = 0; i < body.size(); i++) {
      float c = map(i, 0, body.size(), 50, 200);
      fill(0, c, 0);
      PVector v = body.get(i);
      rect(v.x * cellSize, v.y * cellSize, cellSize, cellSize, 4);
    }
  }
  boolean selfCollision() {
    PVector head = getHead();
    for (int i = 1; i < body.size(); i++) {
      if (head.equals(body.get(i))) return true;
    }
    return false;
  }
}

class Egg {
  PVector pos;
  int type;
  float pulse;
  Egg() {
    pos = new PVector(0, 0);
    type = 0;
    pulse = 0;
  }
  void spawn(ArrayList<PVector> snakeBody, ArrayList<PVector> obs) {
    do {
      pos.set(floor(random(cols)), floor(random(rows)));
    } while (snakeBody.contains(pos) || obs.contains(pos));
    pulse = 0;
    float r = random(1);
    if (r < 0.6) type = 0;
    else if (r < 0.8) type = 1;
    else if (r < 0.9) type = 2;
    else type = 3;
  }
  boolean isImmortal() { return type == 3; }
  void display() {
    pulse += 0.1;
    float s = cellSize * (0.6 + 0.1 * sin(pulse));
    switch(type) {
      case 0: fill(255, 165, 0); break;
      case 1: fill(0, 0, 255);   break;
      case 2: fill(255, 0, 255); break;
      case 3: fill(0, 255, 255); break;
    }
    noStroke(); ellipse((pos.x + 0.5) * cellSize, (pos.y + 0.5) * cellSize, s, s);
  }
}

class Particle {
  PVector pos, vel;
  float alpha;
  Particle(PVector origin) {
    pos = origin.copy().mult(cellSize).add(cellSize/2, cellSize/2);
    vel = PVector.random2D().mult(random(1, 3));
    alpha = 255;
  }
  void update() {
    pos.add(vel);
    alpha -= 5;
  }
  void display() {
    noStroke(); fill(255, 200, 0, alpha);
    ellipse(pos.x, pos.y, 6, 6);
  }
  boolean done() { return alpha <= 0; }
}
