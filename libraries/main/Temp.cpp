#include "Temp.h"
#include "Printer.h"

extern Printer printer;

Temp::Temp(void) 
  : DataSource("Temp","float") // from DataSource
{}


void Temp::init(void)
{
}


void Temp::updateState(void)
// This function is called in the main loop of Default_Robot.ino
{
  voltage = (3.3f*analogRead(PIN))/1024.0f;
}


String Temp::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Temp Voltage: " + String(voltage);
}

size_t Temp::writeDataBytes(unsigned char * buffer, size_t idx)
// This function writes data to the micro SD card
{
  float * data_slot = (float *) &buffer[idx];
  data_slot[0] = voltage;
  return idx + sizeof(float);
}
