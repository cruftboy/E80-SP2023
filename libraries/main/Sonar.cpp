#include "Sonar.h"
#include "Printer.h"

extern Printer printer;

Sonar::Sonar(void) 
  : DataSource("Sonar","float") // from DataSource
{}


void Sonar::init(void)
{
    mySerial.begin(9600);
}


void Sonar::read(void)
// This function is called in the main loop of Default_Robot.ino
{
  do{
    for(int i=0;i<4;i++)
    {
      data[i]=mySerial.read();
    }
  }while(mySerial.read()==0xff);

  mySerial.clear();

  if(data[0]==0xff)
    {

      int sum;
      sum=(data[0]+data[1]+data[2])&0x00FF;
      if(sum==data[3])
      {
        distance=(data[1]<<8)+data[2];
        rawdist = distance/10;
      }
    }
}


String Sonar::printState(void)
// This function returns a string that the Printer class 
// can print to the serial monitor if desired
{
  return "Distance: " + String(rawdist) + " cm";
}

size_t Sonar::writeDataBytes(unsigned char * buffer, size_t idx)
// This function writes data to the micro SD card
{
  float * data_slot = (float *) &buffer[idx];
  data_slot[0] = rawdist;
  return idx + sizeof(float);
}
