#ifndef __SONAR_h__
#define __SONAR_h__
#define mySerial Serial6

#include <Arduino.h>
#include "DataSource.h"
#include "Pinouts.h"


class Sonar : public DataSource
{
public:
  Sonar(void);

  void init(void);

  static const int window = 5;

  // Managing state
  float rawdist;
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