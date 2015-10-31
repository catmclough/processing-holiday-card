import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import fisica.*;

float frequency = 5;
float damping = 100;
float puenteY;

FBody[] steps = new FBody[20];

FWorld world;

int boxWidth = 25;

PImage wall;
PImage charlie;
PImage linus;
PImage bg;

int r, g, b;

//initialize audio variable
Minim minim;

//initialize audio file
AudioPlayer song3;

void setup()
{
  size(600, 680);
  smooth();

  minim = new Minim(this);

  song3 = minim.loadFile("charliesong.mp3");;

  song3.play();

  // init the world with a reference to our canvas
  Fisica.init(this);

  // set up the world
  world = new FWorld();

  world.setEdges();

  wall = loadImage("wall.png");
  charlie = loadImage("charlie.png");
  linus = loadImage("linus.png");
  bg = loadImage("background.jpg");

  FBox wallBody = new FBox(600, 160);
  wallBody.setStatic(true);
  wallBody.setPosition(width/2, 590);
  wallBody.attachImage(wall);
  world.add(wallBody);

  FCircle charlieBody = new FCircle(137);
  charlieBody.setStatic(true);
  charlieBody.setPosition(220, 455);
  charlieBody.attachImage(charlie);
  world.add(charlieBody);

  FCircle linusBody = new FCircle(127);
  linusBody.setStatic(true);
  linusBody.setPosition(387, 475);
  linusBody.attachImage(linus);
  world.add(linusBody);

  for (int i=0; i<steps.length; i++) {
    steps[i] = new FCircle(boxWidth);
    steps[i].setPosition(map(i, 0, steps.length-1, boxWidth, width-boxWidth), puenteY);
    steps[i].setNoStroke();
    world.add(steps[i]);
  }

    for (int i=1; i<steps.length; i++) {
    FDistanceJoint junta = new FDistanceJoint(steps[i-1], steps[i]);
    junta.setAnchor1(boxWidth/2, 0);
    junta.setAnchor2(-boxWidth/2, 0);
    junta.setFrequency(frequency);
    junta.setDamping(damping);
    junta.setFill(0);
    junta.calculateLength();
    world.add(junta);
  }

    FCircle left = new FCircle(10);
  left.setStatic(true);
  left.setPosition(0, puenteY);
  left.setDrawable(false);
  world.add(left);

  FCircle right = new FCircle(10);
  right.setStatic(true);
  right.setPosition(width, puenteY);
  right.setDrawable(false);
  world.add(right);


    FDistanceJoint juntaPrincipio = new FDistanceJoint(steps[0], left);
  juntaPrincipio.setAnchor1(-boxWidth/2, 0);
  juntaPrincipio.setAnchor2(0, 0);
  juntaPrincipio.setFrequency(frequency);
  juntaPrincipio.setDamping(damping);
  juntaPrincipio.calculateLength();
  juntaPrincipio.setFill(0);
  world.add(juntaPrincipio);

  FDistanceJoint juntaFinal = new FDistanceJoint(steps[steps.length-1], right);
  juntaFinal.setAnchor1(boxWidth/2, 0);
  juntaFinal.setAnchor2(0, 0);
  juntaFinal.setFrequency(frequency);
  juntaFinal.setDamping(damping);
  juntaFinal.calculateLength();
  juntaFinal.setFill(0);
  world.add(juntaFinal);
}

void draw()
{
  image(bg, 0, 0);
  image(bg, 0, 210);
  image(bg, 0, 420);
  textSize(50);
  fill(255);
  textAlign(CENTER);
  text("Happy Holidays!", width/2, 250);
  textSize(10);
  text("(click to make it snow)", width/2, 280);

  world.step();

  // now have it draw itself to the screen
  world.draw();
}

void keyPressed()
{
  // is there a body here?
  FBody clickedBody = world.getBody(mouseX, mouseY);

  // nothing here! create a new body!
  if (clickedBody == null)
  {
    for (int i = 0; i < 25; i++) {
      // create a box using the current mouse position
      FCircle snowBall = new FCircle(random(5, 15));
      snowBall.setPosition(mouseX+random(-250, 250), mouseY+random(-100, 100));
      snowBall.setRotation(random(TWO_PI));
      snowBall.setVelocity(random(-80, 80), random(100));
      snowBall.setFillColor(color(255));
      snowBall.setStrokeColor(color(255));
      world.add(snowBall);
    }

    for (int i=0; i<steps.length; i++) {
      int randomColor = (int)random(4);
      if (randomColor == 0) {
        steps[i].setFill(255,0,0);
      } else if (randomColor == 1) {
        steps[i].setFill(0,153,0);
      } else if (randomColor == 2) {
         steps[i].setFill(0,255,0);
      } else if (randomColor == 3) {
        steps[i].setFill(0,204,204);
      }
  }
  }
}
