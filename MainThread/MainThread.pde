import de.voidplus.leapmotion.*;

public static ArrayList<Particle> confetti;
public static  Logo logo;
public final int THRESHOLD = 100;
public LeapMotion leap;
public Bone[] bones;

void setup() {
  size(800, 600);
  //fullScreen();
  //frameRate(30);
  confetti = new ArrayList<Particle>();
  logo = new Logo(random(width), random(height));
  leap = new LeapMotion(this);
}

void leapOnConnect() {
  println("Leap Motion Connected");
}

void draw() {
  background(0);
  stroke(255);
  //drawThreshold();
  updateParticles();
  updateLogo();
  updateHands();
}

private void updateHands() {
  for (Hand hand : leap.getHands ()) {
    PVector handPosition = hand.getPosition();
    show(handPosition.x, handPosition.y);  


    for (Finger finger : hand.getFingers()) {
      PVector fingerPosition = finger.getPosition();
      show(fingerPosition.x, fingerPosition.y);
      //Default draw method with 3px in radius for each joints, can't be used for our purpose but good to have during dev process
      finger.draw();

      bones = new Bone[]{finger.getBone(0), finger.getBone(1), finger.getBone(2), finger.getBone(3)};

      for (Bone bone : bones ) {
        PVector joint = bone.getPrevJoint();
        show(joint.x, joint.y);
      }
    }
  }
}

private void updateParticles() {
  for (int i=0; i < confetti.size(); i++) {
    Particle p = confetti.get(i);
    // Remove particle if they are too small and not visible
    if (p.opacity < 50) {
      confetti.remove(i);
    } else {
      p.update();
    }
  }
}

private void updateLogo() {
  logo.update();
  if (logo.x + logo.logo_img.width >= width) {
    logo.xVelocity = -logo.xVelocity;
    logo.x = width - logo.logo_img.width;
    logo.updateColor();
    addConfetti();
  } else if (logo.x <= 0) {
    logo.xVelocity = -logo.xVelocity;
    logo.x = 0;
    logo.updateColor();
    addConfetti();
  }
  if (logo.y + logo.logo_img.height > height) {
    logo.yVelocity = -logo.yVelocity;
    logo.y = height - logo.logo_img.height;
    logo.updateColor();
    addConfetti();
  } else if (logo.y <= 0) {
    logo.yVelocity = -logo.yVelocity;
    logo.y = 0;
    logo.updateColor();
    addConfetti();
  }
}

// Emulate collision events when the logo hits the screen
void mousePressed() {
  for (int i= 0; i < 10; i++) {
    confetti.add(new Particle(mouseX, mouseY));
  }
}

public void addConfetti() {
  for (int i= 0; i < 30; i++) {
    confetti.add(new Particle(logo.xCenter, logo.yCenter));
  }
}

private void show(float x, float y) {
  fill(255, 0, 0);
  ellipse(x, y, 10, 10);
}

private void drawThreshold() {
  // Divide sections on screen where animations will behave differently
  line(100, 0, THRESHOLD, height);
  line(0, THRESHOLD, width, THRESHOLD);
  line(width - THRESHOLD, 0, width - THRESHOLD, height);
  line(0, height - THRESHOLD, width, height - THRESHOLD);
}
