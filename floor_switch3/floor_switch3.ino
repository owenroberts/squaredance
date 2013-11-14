//squaredance
// three switch on A0, A1, A2
// sends to processing

int sensorValue;
void setup()
{
  // start serial port at 9600 bps:
  Serial.begin(9600);
  establishContact();
}

void loop() {
  if (Serial.available() > 0) {
    // read the incoming byte:
    int inByte =Serial.read();l
    
    // read the sensor:
    sensorValue = digitalRead(2);
    // print the results:
    Serial.print(sensorValue, DEC);
    Serial.print(",");

    // read the sensor:
    sensorValue = digitalRead(4);
    // print the results:
    Serial.print(sensorValue, DEC);
    Serial.print(",");

    sensorValue = digitalRead(7);
    // print the last sensor value with a println() so that
    // each set of four readings prints on a line by itself:
    Serial.println(sensorValue, DEC);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("hello");   // send a starting message
    delay(300);
  }
}





