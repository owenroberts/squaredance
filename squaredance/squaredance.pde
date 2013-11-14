/* 
 first squaredance sketch
 
 cut all of the "butt" stuff
 play three different samples
 stop if switch is off
 if switch is on for a "long time" // at this point nothing
 volume increases linear longer you're standing on
 */


import processing.serial.*;     // import the Processing serial library
Serial myPort;                  // The serial port
boolean firstContact = false;

import oscP5.*;
import netP5.*;

OscP5 oscP5;

NetAddress myRemoteLocation; 
NetAddress loadLocation;

int tracks = 3;
int[] volume = new int[3];
int[] squares = new int[3];
boolean[] squareOn = new boolean[3];


void setup() {

  size(250, 225);
  textSize(12);

  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12006);
  loadLocation = new NetAddress("127.0.0.1", 12002);

  // List all the available serial ports
  println(Serial.list());
  String portName = Serial.list()[8];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(255);
  fill(0);
  for (int i = 0; i < squares.length; i++) {
    text(squares[i], 0, i*10 + 10); 

    if (squares[i] == 1 && squareOn[i] == false) {
      squareOn[i] = true;
      sampleBang(i);
      changeVolume(volume[i], i);
    } 
    else if (squares[i] == 1 && squareOn[i] == true) {
      volume[i]++;
      changeVolume(volume[i], i);
    } 
    else if (squares[i] == 0 && squareOn[i] == true) {
      squareOn[i] = false;
      volume[i] = 0;
      pauseBang(i);
      changeVolume(volume[i], i);
    } 
    else {
      //blah blah
    }
  }
}



void sampleBang(int _t) {
  String path = "/"+_t;
  OscMessage myOscMessage = new OscMessage("/test");
  myOscMessage.add(path);
  myOscMessage.add("/sample");
  oscP5.send(myOscMessage, myRemoteLocation);
}
void pauseBang(int _t) {
  String path = "/"+_t;
  OscMessage myOscMessage = new OscMessage("/test");
  myOscMessage.add(path);
  myOscMessage.add("/pause");
  oscP5.send(myOscMessage, myRemoteLocation);
}
void changeVolume(int _v, int _t) {
  String path = "/"+_t;
  OscMessage myOscMessage = new OscMessage("/vol");
  myOscMessage.add(path);
  myOscMessage.add(_v);
  oscP5.send(myOscMessage, myRemoteLocation);
}



void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  if (myString != null) {

    myString = trim(myString);

    // if you haven't heard from the microncontroller yet, listen:
    if (firstContact == false) {
      if (myString.equals("hello")) { 
        myPort.clear();          // clear the serial port buffer
        firstContact = true;     // you've had first contact from the microcontroller
        myPort.write('A');       // ask for more
      }
    } 
    // if you have heard from the microcontroller, proceed:
    else {
      // split the string at the commas
      // and convert the sections into integers:
      int sensors[] = int(split(myString, ','));

      // print out the values you got:
      for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
        //print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
      }
      // add a linefeed after all the sensor values are printed:
      //println();
      if (sensors.length > 1) {
        squares[0] = sensors[0];
        squares[1] = sensors[1];
        squares[2] = sensors[2];
      }
    }
    // when you've parsed the data you have, ask for more:
    myPort.write("A");
  }
}


void oscEvent(OscMessage theOscMessage) {
  // get and print the address pattern and the typetag of the received OscMessage
  //println("### received an osc message with addrpattern "+theOscMessage.addrpattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
}

