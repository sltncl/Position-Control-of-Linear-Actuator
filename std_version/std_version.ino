#include "SR04.h"
#include <math.h>

// Definition of pins for motors and ultrasonic sensor
#define RPWM        10
#define LPWM        11
#define ECHO_PIN    12 
#define TRIG_PIN    13

// Instantiation of the SR04 object for the ultrasonic sensor
SR04 sr04 = SR04(ECHO_PIN, TRIG_PIN);

// Declaration of global variables
float distance; // Variable for distance measured by the sensor
float targetPosition = 0.0; // Initial target position
float tolerance = 0.05; // Tolerance for reaching the target position
int Speed = 128; // Maximum motor speed

// Setup function for initialization
void setup() {
  Serial.begin(9600); // Initialize serial communication
  pinMode(RPWM, OUTPUT); // Set RPWM pin as output
  pinMode(LPWM, OUTPUT); // Set LPWM pin as output
}

// Function to move the actuator to the desired position
void moveActuator(float target) {
  // Measure the current distance from the ultrasonic sensor
  distance = sr04.Distance();
  delay(50); // Wait for measurement stability
  
  // Continue moving the actuator until it reaches the target position within the specified tolerance
  while (abs(distance - target) > tolerance) {
    if (distance < target) {
      // Extend the actuator if the measured distance is less than the target position
      analogWrite(RPWM, 0);
      analogWrite(LPWM, Speed);
    } else {
      // Retract the actuator if the measured distance is greater than the target position
      analogWrite(RPWM, Speed);
      analogWrite(LPWM, 0);
    }
    // Measure the distance again after movement
    distance = sr04.Distance();
    delay(50); // Wait for measurement stability
  }
  // Stop the actuator when the desired position is reached
  analogWrite(RPWM, 0);
  analogWrite(LPWM, 0);

  // Calculate the standard deviation based on 100 measurements
  float measurements[100];
  float sum = 0;
  for (int i = 0; i < 100; i++) {
    measurements[i] = sr04.Distance();
    Serial.println(measurements[i]); // Print measurements for debugging
    sum += measurements[i];
    delay(50); // Wait for measurement stability
  }
  float mean = sum / 100; // Calculate the mean value of measurements
  float variance = 0;
  // Calculate the variance of measurements from the mean
  for (int i = 0; i < 100; i++) {
    variance += pow(measurements[i] - mean, 2);
  }
  // Calculate the standard deviation as the square root of the average variance
  float standardDeviation = sqrt(variance / 100);
  Serial.println(standardDeviation); // Print standard deviation for debugging
}

// Main loop function
void loop() {
  // Check if there are data available on the serial port
  if (Serial.available() > 0) {
    // Read the value of the target position from the serial port
    targetPosition = Serial.parseFloat();
    // Consume any remaining characters in the serial port buffer
    while (Serial.available() > 0) {
      Serial.read();
    }
    // Check if the target position is within the allowed range
    if (targetPosition >= 7 && targetPosition < 16.01) {
      // Move the actuator only if the target position is valid
      moveActuator(targetPosition);
    }
  }
}
