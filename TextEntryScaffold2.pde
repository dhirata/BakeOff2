import java.util.Arrays;
import java.util.Collections;
import android.view.MotionEvent;


String[] phrases; //contains all of the phrases
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 256; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';

boolean leftSide = true;
int margin = 200;
Gestures g;      // create a gesture object
color backgroundColor;   
String displayString;
int oSize;
int nSize;

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
    
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(960, 540); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  //String[] fontList = PFont.list();
  //printArray(fontList);
  textFont(loadFont("Monospaced-48.vlw"), 24); //set the font to arial 24
  backgroundColor=color(0);
  g=new Gestures(100,50,this);    // iniate the gesture object first value is minimum swipe length in pixel and second is the diagonal offset allowed
  g.setSwipeUp("swipeUp");    // attach the function called swipeUp to the gesture of swiping upwards
  g.setSwipeDown("swipeDown");    // attach the function called swipeDown to the gesture of swiping/ downwards
  g.setSwipeLeft("swipeLeft");  // attach the function called swipeLeft to the gesture of swiping left
  g.setSwipeRight("swipeRight");  // attach the function called swipeRight to the gesture of swiping right
  noStroke(); //my code doesn't use any strokes.
  
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

 // image(watch,-200,200);
  fill(100);
  rect(200, 200, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase.substring(0, 22), 70, 100); //draw the target string
    text("          " + currentPhrase.substring(22), 70, 140); //overflow I hope it doesnt go over 44
    //text("Entered:  " + currentTyped, 70, 140); //draw what the user has entered thus far 
    fill(255, 0, 0);
    rect(350, 00, 150, 60); //drag next button
    fill(255);
    text("NEXT > ", 375, 40); //draw next label
    
    int lowerbound = Math.max(0, currentTyped.length() - 16); //creates buffer
    displayString = currentTyped.substring(lowerbound, currentTyped.length()) + "|"; //creates cursor 
    text(displayString, margin + 5, margin + sizeOfInputArea/5 * 3/4);
    //my draw code
    textAlign(CENTER);
    //text("" + currentLetter, 200+sizeOfInputArea/2, 200+sizeOfInputArea/3); //draw current letter
    //fill(255, 0, 0);
    //rect(200, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw left red button
    //fill(0, 255, 0);
    //rect(200+sizeOfInputArea/2, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw right green button
    
    //Keys
    if(leftSide) {
      //top left keys
      rect(margin, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      text("z", margin + sizeOfInputArea/5/2, margin + 2* sizeOfInputArea/4);
      
      rect(margin + sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 2 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 3 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 4 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      
      //middle left keys
      //rect(margin, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 2 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 3 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 4 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      
      //bottom left keys
      rect(margin + sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 2 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 3 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 4 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
    }
    else {
      //top right keys
      rect(margin, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 2 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 3 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 4 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
     
      //middle right keys
      rect(margin, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 2 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 3 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 4 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      
      //bottom right keys
      rect(margin, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
      rect(margin + 2 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4);
    }
    
  }
  
}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

void mousePressed()
{
  oSize = currentTyped.length();
  if(leftSide) {
    if(didMouseClick(margin, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
     currentTyped += 'q'; 
    }
    if(didMouseClick(margin + sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
     currentTyped += 'w'; 
    }
    if(didMouseClick(margin + 2 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'e';
    }
    if(didMouseClick(margin + 3 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'r'; 
    }
    if(didMouseClick(margin + 4 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 't'; 
    }
    if(didMouseClick(margin + sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'a'; 
    }
    if(didMouseClick(margin + 2 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 's'; 
    }
    if(didMouseClick(margin + 3 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'd'; 
    }
    if(didMouseClick(margin + 4 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'f'; 
    }
    if(didMouseClick(margin + sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'z'; 
    }
    if(didMouseClick(margin + 2 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'x'; 
    }
    if(didMouseClick(margin + 3 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
       currentTyped += 'c'; 
    }
    if(didMouseClick(margin + 4 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
       currentTyped += 'v'; 
    }
  
  }
  else {
   if(didMouseClick(margin, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
     currentTyped += 'y'; 
    }
    if(didMouseClick(margin + sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
     currentTyped += 'u'; 
    }
    if(didMouseClick(margin + 2 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'i';
    }
    if(didMouseClick(margin + 3 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'o'; 
    }
    if(didMouseClick(margin + 4 * sizeOfInputArea/5, margin + sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'p'; 
    } 
    
    if(didMouseClick(margin, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'g'; 
    }
    if(didMouseClick(margin + sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'h'; 
    }
    if(didMouseClick(margin + 2 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'j'; 
    }
    if(didMouseClick(margin + 3 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'k'; 
    }
    if(didMouseClick(margin + 4 * sizeOfInputArea/5, margin + 2 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'l'; 
    }
    if(didMouseClick(margin, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'b'; 
    }
    if(didMouseClick(margin + sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'n'; 
    }
    if(didMouseClick(margin + 2 * sizeOfInputArea/5, margin + 3 * sizeOfInputArea/4, sizeOfInputArea/5, sizeOfInputArea/4)) {
      currentTyped += 'm'; 
    }
  }
  //You are allowed to have a next button outside the 2" area
  if (didMouseClick(350, 00, 150, 60)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }  
}

void changeSides() {
   leftSide = !leftSide; 
}

void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

    if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output
    System.out.println("WPM: " + (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f)); //output
    System.out.println("==================");
    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  }
  else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}

//// android touch event. 
/*
Swiping code
made by
david sjunnesson
david@tellart.com
Tellart.com
2012
Found at https://forum.processing.org/one/topic/gesture-example.html
*/
public boolean surfaceTouchEvent(MotionEvent event) {
// check what that was  triggered  
 switch(event.getAction()) {
 case MotionEvent.ACTION_DOWN:    // ACTION_DOWN means we put our finger down on the screen 
   g.setStartPos(new PVector(event.getX(), event.getY()));    // set our start position
   break;
 case MotionEvent.ACTION_UP:    // ACTION_UP means we pulled our finger away from the screen  
   g.setEndPos(new PVector(event.getX(), event.getY()));    // set our end position of the gesture and calculate if it was a valid one
   break;
 }
 return super.surfaceTouchEvent(event);
}

// function that is called when we are swiping upwards
void swipeUp() {
 //println("a swipe up");    
 //backgroundColor=color(100);
}
void swipeDown() {
 //println("a swipe down");
 //backgroundColor=color(150);
}
void swipeLeft() {
 if(leftSide) {
     changeSides();
 }
  nSize = currentTyped.length();
  if(oSize != nSize)  {
    currentTyped = currentTyped.substring(0, currentTyped.length() - 1); 
  }
}
void swipeRight() {
  if(!leftSide) {
      changeSides();
  }
   nSize = currentTyped.length();
   if(oSize != nSize)  {
    currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
   }
}


import java.lang.reflect.Method;
class Gestures {
 int  maxOffset, minLength;
 String functionName;
 PVector startPos, endPos;
 PApplet pApp;
 Method[] m;
 Gestures(int minimum,int offSet,PApplet theApplet) {
   m=new Method[4];
   pApp = theApplet;
   maxOffset=offSet;    //number pixels you are allowed to travel off the axis and still being counted as a swipe
   minLength=minimum;    // number of pixels you need to move your finger to count as a swipe
 }
 // where did our motion start
 void setStartPos(PVector pos) {
   startPos=pos;
 }
 // where did it end and also call to check if it was a valid swipe
 void setEndPos(PVector pos) {
   endPos=pos;
   checkSwipe();
   endPos=new PVector();
   startPos=new PVector();
 }
 // check if it is a valid swipe that has been performed and if so perform the attached function
 void checkSwipe() {
   if (abs(startPos.x-endPos.x)>minLength&&abs(startPos.y-endPos.y)<maxOffset) {
     if (startPos.x<endPos.x) {
       performAction(2);    // a swipe right
     }
     else {
       performAction(0);    // a swipe left
     }
   }
   else {
     if (abs(startPos.y-endPos.y)>minLength&&abs(startPos.x-endPos.x)<maxOffset) {
       if (startPos.y<endPos.y) {
         performAction(3);  // a swipe downwards
       }
       else {
         performAction(1);  // a swipe upwards
       }
     }
   }
 }
 // call the function that we have defined with setAction
 void performAction(int direction) {
   if (m[direction] == null)
     return;
   try {
     m[direction].invoke(pApp);
   } 
   catch (Exception e) {
     e.printStackTrace();
   }
 }
 // define a function that should get called when the different swipes is done
 void setAction(int direction, String method) {
   if (method != null && !method.equals("")) {
     try {
       m[direction] = pApp.getClass().getMethod(method);
     } 
     catch (SecurityException e) {
       e.printStackTrace();
     } 
     catch (NoSuchMethodException e) {
       e.printStackTrace();
     }
   }
 }
 // attach a function to a left swipe
 void setSwipeLeft(String _funcName) {
   setAction(0, _funcName);
 }
 void setSwipeUp(String _funcName) {
   setAction(1, _funcName);
 }
 void setSwipeRight(String _funcName) {
   setAction(2, _funcName);
 }
 void setSwipeDown(String _funcName) {
   setAction(3, _funcName);
 }
}


//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}