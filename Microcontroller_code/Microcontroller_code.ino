#include "SR04.h" // Include the SR04 library for the ultrasonic sensor

// Definition of pins
#define RPWM        10
#define LPWM        11
#define ECHO_PIN    12 
#define TRIG_PIN    13

// Definition of constant values
const int MAX_SPEED = 255; // Maximum speed for the actuator
const float INITIAL_POSITION = 0.0; // Initial target position
const float TARGET_TOLERANCE = 0.3; // Tolerance for reaching the target position
const float MIN_TARGET_POSITION = 7.0; // Minimum allowed target position
const float MAX_TARGET_POSITION = 16.1; // Maximum allowed target position

SR04 sr04 = SR04(ECHO_PIN, TRIG_PIN); // Initialize the ultrasonic sensor
float distance; // Variable to store the distance measured by the sensor
float targetPosition = INITIAL_POSITION; // Initial target position
float end = 1.0; // Placeholder variable
int Speed = MAX_SPEED; // Current speed of the actuator

unsigned long lastCurrentMillis = 0; // Time of the last distance update
unsigned long currentMillis = 0; // Current time

void setup() {
  Serial.begin(9600); // Initialize serial communication with baud rate 9600
  pinMode(RPWM, OUTPUT); // Set RPWM pin as output
  pinMode(LPWM, OUTPUT); // Set LPWM pin as output
}

// Function to move the actuator to the desired position
void moveActuator(float target) {
  distance = sr04.Distance(); // Read the current distance from the sensor
  currentMillis = millis(); // Get the current time
  Serial.print(currentMillis - lastCurrentMillis); // Print the time elapsed since the last update
  lastCurrentMillis = currentMillis; // Update the time of the last update
  Serial.print(", ");
  Serial.println(distance); // Print the current distance
  delay(50); // Delay for stability

  // Loop until the target position is reached within the tolerance
  while (abs(distance - target) > TARGET_TOLERANCE) {
    if (distance < target) {
      // Extend the actuator if the distance is less than the target position
      analogWrite(RPWM, 0);
      analogWrite(LPWM, Speed);
    } else {
      // Retract the actuator if the distance is greater than the target position
      analogWrite(RPWM, Speed);
      analogWrite(LPWM, 0);
    }
    // Measure the new distance
    distance = sr04.Distance();
    currentMillis = millis(); // Get the current time
    Serial.print(currentMillis - lastCurrentMillis); // Print the time elapsed since the last update
    lastCurrentMillis = currentMillis; // Update the time of the last update
    Serial.print(", ");
    Serial.println(distance); // Print the current distance

    // Check if there are new speed commands from the serial input
    if (Serial.available() > 1) {
      Speed = Serial.parseInt(); // Parse the new speed value
    }
    delay(50); // Delay for stability
  }
  Serial.print(end); // Placeholder print
  Serial.print(", ");
  Serial.println(end); // Placeholder print

  // Stop the actuator when the target position is reached
  analogWrite(RPWM, 0);
  analogWrite(LPWM, 0);
  // Consume any remaining characters in the serial buffer
  while (Serial.available() > 0) {
    Serial.read();
  }
}

void loop() {
  if (Serial.available() > 0) {
    targetPosition = Serial.parseFloat(); // Read the target position from serial input
    Speed = MAX_SPEED; // Reset speed to maximum
    // Consume any remaining characters in the serial buffer
    while (Serial.available() > 0) {
      Serial.read();
    }
    // Move the actuator only if the target position is within the valid range
    if (targetPosition >= MIN_TARGET_POSITION && targetPosition < MAX_TARGET_POSITION) {
      lastCurrentMillis = millis(); // Initialize the time of the last update
      moveActuator(targetPosition); // Move the actuator to the target position
    }
  }
}
