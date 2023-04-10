#include <Arduino.h>
#include <Wire.h>

#include <Sonar.h>


/////////////////////////* Global Variables *////////////////////////


Sonar sonar;

// loop start recorder
int loopStartTime;
int currentTime;

#define mySerial Serial6 // RX, TX
unsigned char data[4]={};
unsigned char b;
float distance;

void setup()
{
 Serial.begin(115200);
 sonar.init();
}

void loop()
{
  sonar.read();
  
  delay(100);
}
