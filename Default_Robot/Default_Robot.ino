/********
Default E80 Code
Current Author:
    Wilson Ives (wives@g.hmc.edu) '20 (contributed in 2018)
Previous Contributors:
    Christopher McElroy (cmcelroy@g.hmc.edu) '19 (contributed in 2017)  
    Josephine Wong (jowong@hmc.edu) '18 (contributed in 2016)
    Apoorva Sharma (asharma@hmc.edu) '17 (contributed in 2016)                    
*/

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

/////////////////////////* Global Variables *////////////////////////

MotorDriver motor_driver;
XYStateEstimator state_estimator;
SurfaceControl surface_control;
SensorGPS gps;
Adafruit_GPS GPS(&UartSerial);
ADCSampler adc;
ErrorFlagSampler ef;
Temp temp;
SensorIMU imu;
Logger logger;
Printer printer;
GPSLockLED led;
Salt salt;
Sonar sonar;

// loop start recorder
int loopStartTime;
int currentTime;
int accOffset;
int current_way_point = 0;
volatile bool EF_States[NUM_FLAGS] = {1,1,1};

// GPS Waypoints
const int number_of_waypoints = 2;
const int waypoint_dimensions = 2;       // waypoints are set to have two pieces of information, x then y.
double waypoints [] = { 0, -10, 0, 0};   // listed as x0,y0,x1,y1, ... etc.

////////////////////////* Setup *////////////////////////////////
void setup() {
  
  logger.include(&imu);
  logger.include(&gps);
  logger.include(&state_estimator);
  logger.include(&surface_control);
  logger.include(&motor_driver);
  logger.include(&adc);
  logger.include(&ef);
  logger.include(&temp);
  logger.include(&salt);
  logger.include(&sonar);
  logger.init();

  printer.init();
  ef.init();
  temp.init();
  salt.init();
  imu.init();
  UartSerial.begin(9600);
  sonar.init();
  gps.init(&GPS);
  motor_driver.init();
  led.init();

  surface_control.init(number_of_waypoints, waypoints, DELAY);
  
  state_estimator.init(); 

  printer.printMessage("Starting main loop",10);
  loopStartTime = millis();
  printer.lastExecutionTime         = loopStartTime - LOOP_PERIOD + PRINTER_LOOP_OFFSET ;
  imu.lastExecutionTime             = loopStartTime - LOOP_PERIOD + IMU_LOOP_OFFSET;
  gps.lastExecutionTime             = loopStartTime - LOOP_PERIOD + GPS_LOOP_OFFSET;
  adc.lastExecutionTime             = loopStartTime - LOOP_PERIOD + ADC_LOOP_OFFSET;
  ef.lastExecutionTime              = loopStartTime - LOOP_PERIOD + ERROR_FLAG_LOOP_OFFSET;
  temp.lastExecutionTime  = loopStartTime - LOOP_PERIOD + TEMP_LOOP_OFFSET;
  salt.lastExecutionTime  = loopStartTime - LOOP_PERIOD + SALT_LOOP_OFFSET;
  state_estimator.lastExecutionTime = loopStartTime - LOOP_PERIOD + XY_STATE_ESTIMATOR_LOOP_OFFSET;
  surface_control.lastExecutionTime        = loopStartTime - LOOP_PERIOD + SURFACE_CONTROL_LOOP_OFFSET;
  logger.lastExecutionTime          = loopStartTime - LOOP_PERIOD + LOGGER_LOOP_OFFSET;
}



//////////////////////////////* Loop */////////////////////////

void loop() {
  currentTime=millis();
  
  if ( currentTime-printer.lastExecutionTime > LOOP_PERIOD ) {
    printer.lastExecutionTime = currentTime;
    printer.printValue(0,adc.printSample());
    printer.printValue(1,ef.printStates());
    printer.printValue(2,logger.printState());
    printer.printValue(3,gps.printState());   
    printer.printValue(4,state_estimator.printState());     
    printer.printValue(5,surface_control.printWaypointUpdate());
    printer.printValue(6,surface_control.printString());
    printer.printValue(7,motor_driver.printState());
    printer.printValue(8,imu.printRollPitchHeading());        
    printer.printValue(9,imu.printAccels()) ;
    printer.printValue(10, temp.printState());
    printer.printValue(11, salt.printState());
    printer.printValue(12, sonar.printState());
    printer.printToSerial();  // To stop printing, just comment this line out
  }

  if ( currentTime-surface_control.lastExecutionTime > LOOP_PERIOD ) {
    surface_control.lastExecutionTime = currentTime;
    surface_control.navigate(&state_estimator.state, &gps.state, DELAY);
    motor_driver.drive(surface_control.uL,surface_control.uR,0);
  }

  if ( currentTime-adc.lastExecutionTime > LOOP_PERIOD ) {
    adc.lastExecutionTime = currentTime;
    adc.updateSample(sonar.dist); 
  }

  if ( currentTime-ef.lastExecutionTime > LOOP_PERIOD ) {
    ef.lastExecutionTime = currentTime;
    attachInterrupt(digitalPinToInterrupt(ERROR_FLAG_A), EFA_Detected, LOW);
    attachInterrupt(digitalPinToInterrupt(ERROR_FLAG_B), EFB_Detected, LOW);
    attachInterrupt(digitalPinToInterrupt(ERROR_FLAG_C), EFC_Detected, LOW);
    delay(5);
    detachInterrupt(digitalPinToInterrupt(ERROR_FLAG_A));
    detachInterrupt(digitalPinToInterrupt(ERROR_FLAG_B));
    detachInterrupt(digitalPinToInterrupt(ERROR_FLAG_C));
    ef.updateStates(EF_States[0],EF_States[1],EF_States[2]);
    EF_States[0] = 1;
    EF_States[1] = 1;
    EF_States[2] = 1;
  }

 // uses the ButtonSampler library to read a button -- use this as a template for new libraries!
  if ( currentTime-temp.lastExecutionTime > LOOP_PERIOD ) {
    temp.lastExecutionTime = currentTime;
    temp.updateState();
  }

  if ( currentTime-salt.lastExecutionTime > LOOP_PERIOD ) {
    salt.lastExecutionTime = currentTime;

    
    salt.updateState();
    
    
  }
  


  if ( currentTime-imu.lastExecutionTime > LOOP_PERIOD ) {
    imu.lastExecutionTime = currentTime;
    imu.read();
  }
  
 
  //if ( currentTime-gps.lastExecutionTime > LOOP_PERIOD ) {
  //  gps.lastExecutionTime = currentTime;
    gps.read(&GPS); // blocking UART calls
  //}
  if(currentTime-sonar.lastExecutionTime > LOOP_PERIOD) {
    sonar.lastExecutionTime = currentTime;
    sonar.read();
  }
  

  if ( currentTime-state_estimator.lastExecutionTime > LOOP_PERIOD ) {
    state_estimator.lastExecutionTime = currentTime;
    state_estimator.updateState(&imu.state, &gps.state);
  }
  
  if ( currentTime-led.lastExecutionTime > LOOP_PERIOD ) {
    led.lastExecutionTime = currentTime;
    led.flashLED(&gps.state);
  }

  if ( currentTime- logger.lastExecutionTime > LOOP_PERIOD && logger.keepLogging ) {
    logger.lastExecutionTime = currentTime;
    logger.log();
  }

  imu.updateFilter(accOffset);
  accOffset++;
}

void EFA_Detected(void){
  EF_States[0] = 0;
}

void EFB_Detected(void){
  EF_States[1] = 0;
}

void EFC_Detected(void){
  EF_States[2] = 0;
}
