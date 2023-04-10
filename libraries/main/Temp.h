#ifndef __TEMP_h__
#define __TEMP_h__

#include <Arduino.h>
#include "DataSource.h"
#include "Pinouts.h"

/*
 * Temp implements SD logging for the thermistor
 */


class Temp : public DataSource
{
public:
  Temp(void);

  void init(void);

  // Managing state
  float voltage;
  void updateState(void);
  String printState(void);

  // Write out
  size_t writeDataBytes(unsigned char * buffer, size_t idx);

  int lastExecutionTime = -1;

private:
  int PIN = 1;
};

#endif