/*
Shoutout to the OpenCV and Processing community thank everyone that is building upon these giants <3
*/
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
Movie myMovie;

int timer = 0;
Table table;
int sec;
int timer2 = 0;
//int[] total = {10, 83, 92};
int[] interval = {120, 180};
Capture video;
OpenCV opencv;
StopWatchTimer sw = new StopWatchTimer();

void setup() {
  size(320, 240);
  //video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_EYE);  
  //opencv.loadCascade(OpenCV.CASCADE_MOUTH); 
  myMovie = new Movie(this, "test.mov");
  myMovie.loop();
  table = new Table();
  table.addColumn("x");
  table.addColumn("y");
  table.addColumn("label");
  //  video.start();
  sw.start();
  //myMovie.frameRate(0.0);
}

void draw() {
  //////////////////////////////////////////////////////////////////////////////////////////////
  //Calculating SD
  //double powerSum1 = 0;
  //double powerSum2 = 0;
  //double stdev = 0;

  //for (int i = 0; i<total.length; i++) {
  //  powerSum1 += total[i];
  //  powerSum2 += Math.pow(total[i], 2);
  //  stdev = Math.sqrt(i*powerSum2 - Math.pow(powerSum1, 2))/i;
  //  println(total[i]); // You specified that you needed to print each value of the array
  //}
  //println(stdev); 
  //////////////////////////////////////////////////////////////////////////////////////////////
  sec = sw.second(); 
  scale(1);
  opencv.loadImage(myMovie); 
  image(myMovie, 0, 0 );
  noFill();
  stroke(0, 253, 255);
  strokeWeight(0.5);
  Rectangle[] faces = opencv.detect();
  textSize(5);
  text("D-Side:", 5, 30);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); 
    TableRow newRow = table.addRow();
    if (faces[i].x < 120) {
      newRow.setDouble("label", 1.0);
      textSize(10);
      text("MC", 25, 30);
      stroke(255, 0, 0);
      line(120, 0, 120, 480);
      //println("MC");
      TimerUpdate();
    } else if (faces[i].x > 180) {
      //println("LA");
      textSize(10);
      stroke(255, 0, 0);
      text("LA", 25, 30);  
      line(180, 0, 180, 480);
      newRow.setDouble ("label", 2.0);
      TimerUpdate();
    } else {
      textSize(10);
      text("Focus", 25, 30);
      sw.start();
      newRow.setDouble("label", 0.0);
    }
    text("X:", 15, 50);
    text("Y:", 15, 70);
    text(faces[i].x, 25, 50);
    text(faces[i].y, 25, 70);

    newRow.setDouble("x", (double)faces[i].x);
    newRow.setDouble("y", (double)faces[i].y);

    saveTable(table, "data/data.csv");

    //if (table.getRowCount() == 100) {
    //  exit();
    //}
  }

  if (mousePressed == true) {
    myMovie.stop();
  }
  if (keyPressed == true) {
    myMovie.play();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////

void TimerUpdate() {
  if (sec >= 2) {
    //println("Distracted");
    //println("D-Time" + ":" + timer2/10 + sec);
  } else if (sec >= 6) {
    sw.start();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////
//Normalise CSV file.
void AddRow() {
}

void movieEvent(Movie m) {
  m.read();
  println(m);
}

void captureEvent(Capture c) {
  c.read();
}