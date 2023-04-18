#ifndef __SENSOR_IMU_H__
#define __SENSOR_IMU_H__

#include <Arduino.h>
#include <Wire.h>
#include <LSM303AGR_ACC_Sensor.h>
#include <LSM303AGR_MAG_Sensor.h>
#include "DataSource.h"


typedef struct {
  float accelX;   // [mg] (g=acceleration due to gravity)
  float accelY;   // [mg]
  float accelZ;   // [mg]
  float rawX;
  float rawY;
  float rawZ;
  float magX;     // [Gauss]
  float magY;     // [Gauss]
  float magZ;     // [Gauss]
  float roll;     // [degrees]
  float pitch;    // [degrees]
  float heading;  // [degrees]
} imu_state_t;

// Define a Sensor to include both the Accelerometer and Magnetometer 
typedef struct LSM303AGR{
  TwoWire *dev_i2c = &Wire;
  LSM303AGR_ACC_Sensor *Acc = new LSM303AGR_ACC_Sensor(dev_i2c);
  LSM303AGR_MAG_Sensor *Mag = new LSM303AGR_MAG_Sensor(dev_i2c);
} LSM303AGR;

class SensorIMU : public DataSource {
public:
  SensorIMU(void);

  // Starts the connection to the sensor
  void init(void);

  void updateFilter(int readOffset);

  // Reads data from the sensor
  void read(void);

  void getOrientation(float ax, float ay, float az, float mx, float my, float mz); 

  // Latest reported orientation data is stored here
  imu_state_t state; 

  // prints state to serial
  String printRollPitchHeading(void);
  String printAccels(void);

  // from DataSource
  size_t writeDataBytes(unsigned char * buffer, size_t idx);

  int lastExecutionTime = -1;

private:

  // Create sensor instance
  LSM303AGR myIMU;

  static const int window = 50;
  float movingAccX[window];
  float movingAccY[window];
  float movingAccZ[window];

  // Offsets applied to raw x/y/z accel values
  float accel_offsets[3]      = { 18.7F, 24.25F, 30.5F };

  // Offsets applied to raw x/y/z mag values
  float mag_offsets[3]        = {8.6159, 13.3141, -9.1117};
  
  // Soft iron error compensation matrix
  float mag_ironcomp[3][3] =  { {0.0220,    0.0003,    0},
                                {0,    0.0227,   -0.0009},
                                {0,         0,    0.0226} };
  

};

#endif
