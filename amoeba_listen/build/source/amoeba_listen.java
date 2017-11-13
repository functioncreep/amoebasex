import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class amoeba_listen extends PApplet {





ControlP5 cp5;
OscP5 oscP5;
NetAddress amoebaOne;

String input = "";
// String[] history = new String[50];
ArrayList<History> history =  new ArrayList<History>();

public void setup() {
  

  PFont font = createFont("courier", 20);

  // fill history with empty strings
  // for (int i = 0; i < history.length; i++) {
  //   history[i] = "";
  // }

  cp5 = new ControlP5(this);
  int inputWidth = width;
  int inputHeight = 40;

  cp5.addTextfield("input")
     .setPosition(0, height - inputHeight)
     .setSize(inputWidth, inputHeight)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,255))
     ;

  textFont(font);

  // OSC stuff:

  // start OscP5 listening on port 7771
  oscP5 = new OscP5(this, 7771);

  // "plug" pillae message into function
  oscP5.plug(this, "pillae", "/pillae");
}

public void draw() {
  background(160);

  // starting x and y pos for text
  int posX = 5;
  int posY = 25;

  // loop thru items and draw
  for (History entry : history) {
    if (entry.self == true) {
      textAlign(LEFT);
      fill(255, 255, 255);
      text(entry.text, posX, posY);
      // println(entry.text + " " + entry.self);
    } else if (entry.self == false) {
      textAlign(RIGHT);
      fill(0, 0, 0);
      text(entry.text, width - posX, posY);
      // println(entry.text + " " + entry.self);
    }

    // text(history[i], posX, posY);
    //println(history[i]);
    posY += 30;
  }
}

public void shiftText(String _input, boolean _self) {
  // String[] inBuf = new String[history.length];  // buffer to copy array into
  //
  // // copy history into buffer
  // arrayCopy(history, inBuf);
  //
  // // right shift history by one
  // for (int i = 0; i < history.length - 1; i++) {
  //   history[i + 1] = inBuf[i];
  // }
  //
  // // add input to first object in history
  // history[0] = _input;

  history.add(0, new History(_input, _self));

  if (history.size() >= 50) {
    history.remove(49);
  }
}

// event handler... make specific to "input"?
public void controlEvent(ControlEvent _event) {
  if (_event.isFrom(cp5.getController("input"))) {
    shiftText(input, true);
  }
}

// pillae function
public void pillae(String _plasmid) {
  println("Amoeba One would like to conjugate. Do you consent? (plasmid: " + _plasmid + ")");
  shiftText(_plasmid, false);
}

// OSC event handler
public void oscEvent(OscMessage _message) {
  // print the address pattern and the typetag of the received OscMessage
  //print("### received an osc message.");
  //print(" addrpattern: " + _message.addrPattern());
  //println(" contents: " + _message.typetag());
}

class History
{
  public String text;
  public boolean self;

  public History(String _text, boolean _self) {
    text = _text;
    self = _self;
  }

  // testing
  public void dump() {
    println("text: " + text);
    println("self?: " + self);
  }
}
  public void settings() {  size(500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "amoeba_listen" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}