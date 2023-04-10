
#include <Arduino.h>
#include <Wire.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include <Pinouts.h>
#include <TimingOffsets.h>
#include <SensorGPS.h>
#include <SensorIMU.h>
#include <XYStateEstimator.h>
#include <ADCSampler.h>
#include <ErrorFlagSampler.h>
#include <Temp.h> // A template of a data source library
#include <MotorDriver.h>
#include <Logger.h>
#include <Printer.h>
#include <Salt.h>
#include <SurfaceControl.h>
#include <Sonar.h>
#define UartSerial Serial1
#define DELAY 0
#include <GPSLockLED.h>


void setup() {
  // put your setup code here, to run once:

}

void loop() {
  Serial.println("test");

}
