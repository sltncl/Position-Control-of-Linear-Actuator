% Author: Nicola Saltarelli
% Summary: This script imports and plots the distance and speed data from a LabVIEW interface
% for various control methods (PI and different PID settings). It compares the performance of these methods
% over time.

% Clearing the workspace, command window, and closing all figures
clc;            % Clears the command window
clear all;      % Clears all variables from the workspace
close all;      % Closes all open figure windows

% Importing distances and times from the LabVIEW interface for different executions
interface_value1 = import_interface("./dPI.csv");
interface_value2 = import_interface("./dPID001.csv");
interface_value3 = import_interface("./dPID01.csv");
interface_value4 = import_interface("./dPID1.csv");

% Importing speed data for the same executions
speed1 = import_speed("./speed0.csv");
speed2 = import_speed("./speed001.csv");
speed3 = import_speed("./speed01.csv");
speed4 = import_speed("./speed1.csv");

% Plotting the distances over time for each execution
subplot(211);
plot(milliseconds(interface_value1.Time - interface_value1.Time(1))/1000, interface_value1.Distance, 'ro-', 'LineWidth', 1.5, 'DisplayName', 'Interface Value PI');
hold on;
plot(milliseconds(interface_value2.Time - interface_value2.Time(1))/1000, interface_value2.Distance, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Interface Value PID Td = 0.001');
plot(milliseconds(interface_value3.Time - interface_value3.Time(1))/1000, interface_value3.Distance, 'co-', 'LineWidth', 1.5, 'DisplayName', 'Interface Value PID Td = 0.01');
plot(milliseconds(interface_value4.Time - interface_value4.Time(1))/1000, interface_value4.Distance, 'mo-', 'LineWidth', 1.5, 'DisplayName', 'Interface Value PID Td = 0.1');
xlabel('Time (s)');
ylabel('Distance value (cm)');
title('Distance Measurement from the Linear Actuator');
legend('PI', 'PID with Td = 0.001', 'PID with Td = 0.01', 'PID with Td = 0.1');
grid on;

% Plotting the speed over time for each execution
subplot(212);
plot(milliseconds(interface_value1.Time(1:end-1) - interface_value1.Time(1))/1000, speed1.Speed, 'ro-', 'LineWidth', 1.5, 'DisplayName', 'Speed PI');
hold on;
plot(milliseconds(interface_value2.Time(1:end-1) - interface_value2.Time(1))/1000, speed2.Speed, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Speed PID Td = 0.001');
plot(milliseconds(interface_value3.Time(1:end-1) - interface_value3.Time(1))/1000, speed3.Speed, 'co-', 'LineWidth', 1.5, 'DisplayName', 'Speed PID Td = 0.01');
plot(milliseconds(interface_value4.Time(1:end-1) - interface_value4.Time(1))/1000, speed4.Speed, 'mo-', 'LineWidth', 1.5, 'DisplayName', 'Speed PID Td = 0.1');
xlabel('Time (s)');
ylabel('Speed');
title('Control Action Processed by the PI/PID');
legend('PI', 'PID with Td = 0.001', 'PID with Td = 0.01', 'PID with Td = 0.1');
grid on;

%% Functions

function interface_value = import_interface(filename, dataLines)
%IMPORT_INTERFACE Import data from a text file
%  INTERFACE_VALUE = IMPORT_INTERFACE(FILENAME) reads data from text file FILENAME
%  for the default selection. Returns the data as a table.
%
%  INTERFACE_VALUE = IMPORT_INTERFACE(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  interface_value = import_interface("./distance.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 11-May-2024 12:29:18

% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Time", "Distance"];
opts.VariableTypes = ["datetime", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Time", "InputFormat", "HH:mm:ss.SSS");

% Import the data
interface_value = readtable(filename, opts);

end

function speed = import_speed(filename, dataLines)
%IMPORT_SPEED Import data from a text file
%  SPEED = IMPORT_SPEED(FILENAME) reads data from text file FILENAME
%  for the default selection. Returns the data as a table.
%
%  SPEED = IMPORT_SPEED(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  speed = import_speed("./speed.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 17-May-2024 17:11:56

% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Samples", "Speed"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
speed = readtable(filename, opts);

end
