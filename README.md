# Linear Actuator Control System

This repository contains the project materials for the Linear Actuator Control System, implemented by Nicola Saltarelli. The project focuses on controlling the position of a linear actuator using a combination of hardware components and a user-friendly software interface.

## Project Overview

The system integrates an **HC-SR04 ultrasonic sensor**, an **ELEGOO UNO R3 microcontroller**, and a **motor control board** based on the Dual H-Bridge L298N driver. To enhance user interaction and control, an intuitive interface has been developed using **LabVIEW**. This software provides operators with an efficient tool to accurately adjust actuator positioning, ensuring smooth and reliable control.

![work_table](https://github.com/user-attachments/assets/56247e93-e493-4b58-bd73-eb22a3a6f1e0)

## Repository Structure

- **Documentation.pdf**: Complete documentation of the project, including system design, implementation details, and performance analysis.

- **LabVIEW_Interface.vi**: The LabVIEW-based user interface developed for controlling the actuator.

- **Matlab Folder**: Contains two subfolders for generating the charts included in the documentation:
  - **precision_analysis**: Used for generating the boxplot for precision analysis.
  - **time_distance_comparison**: Used for creating charts that compare delay, position, and velocity, both in manual control and PID automatic control modes.

- **Microcontroller_code Folder**: Contains the main code uploaded to the microcontroller, responsible for controlling the actuator.

- **std_version Folder**: Contains the microcontroller code used for precision studies.

- **std_version_python Folder**: Contains the Python script that reads data from the microcontroller (using the code from the `std_version` folder) and generates a dataset with the collected values.

## Requirements

- **LabVIEW**: For running the user interface.
- **Matlab**: For generating the charts from precision and performance data.
- **Python 3.x**: For running the Python script in the `std_version_python` folder.

This repository provides all the necessary files and instructions to replicate the system and evaluate its performance.
