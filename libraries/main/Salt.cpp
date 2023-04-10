#include "Salt.h"
#include "Printer.h"

extern Printer printer;

Salt::Salt(void) 
  : DataSource("Salt","float") // from DataSource
{}


void Salt::init(void)
{
}


void Salt::updateState(void)
// This function is called in the main loop of Default_Robot.ino
{
  voltage = 0;
  float max = 0;
  float time = millis();
  float end = time + 5;

  while(time < end) {
      voltage = (3.3f*analogRead(PIN))/1024.0f;
      if(voltage > max){
        max = voltage;
      }
      time = millis();
  }
  voltage = max;
}


String Salt::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Salt Voltage: " + String(voltage);
}

size_t Salt::writeDataBytes(unsigned char * buffer, size_t idx)
// This function writes data to the micro SD card
{
  float * data_slot = (float *) &buffer[idx];
  data_slot[0] = voltage;
  return idx + sizeof(float);
}

