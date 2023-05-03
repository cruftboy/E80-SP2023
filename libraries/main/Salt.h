#ifndef __SALT_h__
#define __SALT_h__

#include <Arduino.h>
#include "DataSource.h"
#include "Pinouts.h"

/*
 * Salt implements SD logging for the salinity sensor
 */


class Salt : public DataSource
{
public:
  Salt(void);

  void init(void);
  // Managing state
  float voltage;
  
  void updateState(void);
  String printState(void);

  // Write out
  size_t writeDataBytes(unsigned char * buffer, size_t idx);

  int lastExecutionTime = -1;

private:
  int PIN = 0;
};

#endif