#include "Sonar.h"
#include "Printer.h"

extern Printer printer;

Sonar::Sonar(void) 
  : DataSource("Sonar","float") // from DataSource
{}


void Sonar::init(void)
{
    pinMode(TRIG_PIN, OUTPUT);
    pinMode(INTERRUPT_PIN, INPUT);
}


void Sonar::read(void)
// This function is called in the main loop of Default_Robot.ino
{
  digitalWrite(TRIG_PIN, HIGH); // trigger
  delayMicroseconds(20);
  digitalWrite(TRIG_PIN, LOW);
  float start = micros();
  float now;
  bool flag = false;
  do {
    now = micros();

    //flag = max(flag,analogRead(INTERRUPT_PIN));
    flag = (analogRead(INTERRUPT_PIN)>5);
  }
  while(now-start < 5000 && !flag); // give up after 5 ms
  
  if(now-start >= 5000) {
    dist = 0;
  }
  else {
    dist = 1500.0f*((now-start)/2.0f)/1000000.0f;
  }
}


String Sonar::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Distance: " + String(dist) + " cm";
}

size_t Sonar::writeDataBytes(unsigned char * buffer, size_t idx)
// This function writes data to the micro SD card
{
  float * data_slot = (float *) &buffer[idx];
  data_slot[0] = dist;
  return idx + sizeof(float);
}
