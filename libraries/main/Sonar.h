#ifndef __SONAR_h__
#define __SONAR_h__
#define TRIG_PIN 24
#define INTERRUPT_PIN 25

#include <Arduino.h>
#include "DataSource.h"
#include "Pinouts.h"


class Sonar : public DataSource
{
public:
  Sonar(void);

  void init(void);


  // Managing state
  float dist;
  unsigned char data[4]={};
  void read(void);
  String printState(void);


float distance;

  // Write out
  size_t writeDataBytes(unsigned char * buffer, size_t idx);

  int lastExecutionTime = -1;
};

#endif