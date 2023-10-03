import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

//when in doubt, consult the Processsing reference: https://processing.org/reference/

int margin = 200; //set the margin around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
Robot robot; //initialized in setup 

int numRepeats = 1; //sets the number of times each button repeats in the test

int isInside = 4;   //sets the color of the highlighted row if the mouse hovers over it
// 0, 1, 2, 3 refer to the 4 different rows. 4 is everything else

final int RADIX = 10;

color black = color(0); 
color highlightPink = color(255,192,203,127); 
color cyan = color(0, 255, 255);

Rectangle row0;
Rectangle row1;
Rectangle row2;
Rectangle row3;

IntDict translateKeys;

void setup()
{
  size(700, 700); // set the size of the window
  //noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }
  
  translateKeys = new IntDict();
  translateKeys.set("a", 0);
  translateKeys.set("s", 1);
  translateKeys.set("d", 2);
  translateKeys.set("c", 3);

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
      // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);
  
  surface.setLocation(0,0);// put window in top left corner of screen (doesn't always work)
}


void draw()
{
  background(0); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    float timeTaken = (finishTime-startTime) / 1000f;
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f),0,100);
    fill(255); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + timeTaken + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + nf((timeTaken)/(float)(hits+misses),0,3) + " sec", width / 2, height / 2 + 100);
    text("Average time for each button + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty),0,3) + " sec", width / 2, height / 2 + 140);
    return; //return, nothing else to do now test is over
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on
  
  for (int i = 0; i < 4; i++)
    drawRectangleHighlight(i);

  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button
  
  
  fill(cyan);
  text("a", margin + (buttonSize/2), margin-buttonSize);
  text("s", (padding + buttonSize) + margin + (buttonSize/2), margin-buttonSize);
  text("d", 2*(padding + buttonSize) + margin + (buttonSize/2), margin-buttonSize);
  text("c", 3*(padding + buttonSize) + margin + (buttonSize/2), margin-buttonSize);
  
  
  // check whether the mouse is hovering over a box
  // need to create the highlights for the boxes rawr
  // draw a grid around the squares, test if the hovering works
  // then test the fill code
  
  //fill(255, 0, 0, 200); // set fill color to translucent red
  //ellipse(mouseX, mouseY, 20, 20); //draw user cursor as a circle with a diameter of 20
}

void mousePressed() // test to see if hit was in target!
{
 // if (trialNum >= trials.size()) //if task is over, just return
 //   return;

 // if (trialNum == 0) //check if first click, if so, start timer
 //   startTime = millis();

 // if (trialNum == trials.size() - 1) //check if final click
 // {
 //   finishTime = millis();
 //   //write to terminal some output. Useful for debugging too.
 //   println("we're done!");
 // }

 // Rectangle bounds = getButtonLocation(trials.get(trialNum));

 ////check to see if mouse cursor is inside button 
 // if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
 // {
 //   System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
 //   hits++; 
 // } 
 // else
 // {
 //   System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
 //   misses++;
 // }

 // trialNum++; //Increment trial number

 // //in this example code, we move the mouse back to the middle
 // robot.mouseMove(width/2, (height)/2); //on click, move cursor to roughly center of window!
}  

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   return new Rectangle(x, y, buttonSize, buttonSize);
}

//you can edit this method to change how buttons appear
void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);

  if (trials.get(trialNum) == i) // see if current button is the target
    fill(0, 255, 255); // if so, fill cyan
  else
    fill(200); // if not, fill gray

  rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
}

Rectangle getRectangleLocation(int i) 
{
   int x = margin-(buttonSize/2);
   int y = i * (padding + buttonSize) + margin - padding/2;
   return new Rectangle(x, y, 4*(buttonSize + padding), buttonSize + padding);
}

void drawRectangleHighlight(int i) 
{
  Rectangle bounds = getRectangleLocation(i);
  
  if (i == 0) {
    row0 = bounds;
  } else if (i == 1) {
    row1 = bounds;
  } else if (i == 2) {
    row2 = bounds;
  } else if (i == 3) {
    row3 = bounds;
  }

  if (i == isInside) {
    fill(highlightPink);
  } else {
    fill(black); // if not, fill gray
  }
  rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
}

//bool contains(int mx, int my, float xLeft, float yTop, float x

void mouseMoved()
{
   // checks whether the mouse is in rectangle 0, 1, 2, 3, 4(none)
   if (row0.contains(mouseX, mouseY)) {
     //print("row0\n");
     isInside=0;
   } else if (row1.contains(mouseX, mouseY)) {
     //print("row1\n");
     isInside=1;
   } else if (row2.contains(mouseX, mouseY)) {
     //print("row2\n");
     isInside=2;
   } else if (row3.contains(mouseX, mouseY)) {
     //print("row3\n");
     isInside=3;
   } else {
     //print("not in a row\n");
     isInside=4;
   }
}

void keyPressed() 
{
  if (trialNum >= trials.size()) //if task is over, just return
    return;

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal some output. Useful for debugging too.
    println("we're done!");
  }
  
  int answerButton = trials.get(trialNum) % 4;
  int answerRow = trials.get(trialNum) / 4;
  
  
  int keyAsInt;
  if (translateKeys.hasKey(String.valueOf(key))) {
    keyAsInt = translateKeys.get(String.valueOf(key));
  } else {
    keyAsInt = 4;
  }
  
  print("answerButton:" + answerButton + "\n");
  print("key:" + key + " translate:" + keyAsInt + "\n");

  //check to see if key clicked is the right button in the row
  if (keyAsInt==answerButton && isInside==answerRow){
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++; 
  } else {
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
  }
  
  trialNum++; //Increment trial number
}
