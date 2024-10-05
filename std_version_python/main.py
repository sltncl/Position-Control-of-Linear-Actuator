# This Python script interacts with an Arduino microcontroller through serial communication.
# It sends a target position to the microcontroller, reads 100 distance values and the standard deviation from the microcontroller,
# and then writes these values along with the target position into a CSV file named 'data.csv'.

import serial  # Library for serial communication
import csv     # Library for reading and writing CSV files

# Set the correct serial port and baud rate for communication with the Arduino
ser = serial.Serial('COM3', 9600)  # Change 'COM3' with the correct serial port and 9600 with the baud rate

# Function to send the target position to the Arduino
def send_target_position(target):
    # Converts the target position to a string, appends a newline character, encodes it to bytes, and sends it to the Arduino
    ser.write((str(target) + '\n').encode())

# Function to read 100 distance values from the Arduino
def read_distances():
    # Initializes an empty list to store the distance values
    distances = []
    # Loops 100 times to read each distance value from the Arduino
    for _ in range(100):
        # Reads a line from the serial port, decodes it from bytes to string, and removes any leading/trailing whitespaces
        distance_str = ser.readline().decode().strip()
        # Converts the string distance value to a float and appends it to the distances list
        distances.append(float(distance_str))
    # Returns the list of distance values
    return distances

# Function to read the standard deviation from the Arduino
def read_standard_deviation():
    # Reads a line from the serial port, decodes it from bytes to string, and removes any leading/trailing whitespaces
    standard_deviation_str = ser.readline().decode().strip()
    # Converts the string standard deviation value to a float and returns it
    return float(standard_deviation_str)

# Main function to execute the script
def main():
    # Loops indefinitely until a valid target position is entered
    while True:
        # Prompts the user to enter a target position within the range 7.0 - 16.0
        target = float(input("Enter the target position (7.0 - 16.0): "))
        # Checks if the entered target position is within the valid range
        if 7.0 <= target < 16.01:
            # Sends the target position to the Arduino
            send_target_position(target)
            # Opens 'data.csv' file in append mode for writing
            with open('data.csv', 'a', newline='') as csvfile:
                # Creates a CSV writer object
                csv_writer = csv.writer(csvfile)
                # Reads 100 distance values from the Arduino
                distances = read_distances()
                # Reads the standard deviation from the Arduino
                standard_deviation = read_standard_deviation()
                # Writes the target position, distance values, and standard deviation into the CSV file as a row
                csv_writer.writerow([target, distances, standard_deviation])
                # Prints the distance values and standard deviation for the user
                print("Distance values:", distances)
                print("Standard deviation:", standard_deviation)
            # Breaks out of the loop once the data is successfully recorded
            break
        else:
            # Prints a message for an invalid target position and continues the loop
            print("Invalid target position. Please try again.")

# Entry point of the script, calls the main function
if __name__ == "__main__":
    main()
