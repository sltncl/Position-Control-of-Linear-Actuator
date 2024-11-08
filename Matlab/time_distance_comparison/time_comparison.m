% Author: Nicola Saltarelli
% Summary: This script imports timing data from a microcontroller and a LabVIEW interface,
% calculates the delay between the two sets of times, and plots the comparison. It also
% calculates the root mean square (RMS) of the delay.

% Clearing the workspace, command window, and closing all figures
clc;            % Clear command window
clear all;      % Clear all variables from the workspace
close all;      % Close all open figure windows

% Importing times from the microcontroller
microcontroller_times = import_mcu("./t115200.csv");
times_mcu = microcontroller_times.Time(2:end-1); % Exclude the first and last sample

% Importing distances and times from the LabVIEW interface
interface_value = import_interface("./d115200.csv");
times_interface = diff(milliseconds(interface_value.Time - interface_value.Time(1))); % Convert to milliseconds and normalize
times_interface = times_interface(1:end-1);

% Generating the sample vector
samples = 1:length(times_interface);

% Calculating the delay between microcontroller and interface times for each sample
delay_per_point = times_interface(2:end) - times_mcu(2:end);

% Calculating the Root Mean Square (RMS) of the residual delay
rms_delay = sqrt(mean(delay_per_point.^2));

% Plotting the comparison of times
subplot(211);
plot(samples, times_mcu, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Microcontroller Times');
hold on;
plot(samples, times_interface, 'ro-', 'LineWidth', 1.5, 'DisplayName', 'Interface Times');
xlim([min(samples) max(samples)]);
xlabel('Sample');
ylabel('Time (ms)');
legend('Location', 'best');
grid on;
title('Comparison of Microcontroller and Interface Times Sample by Sample');

% Plotting the cumulative comparison of times
subplot(212);
plot(samples, cumsum(times_mcu)/1000, 'bo', 'LineWidth', 1.5, 'DisplayName', 'Microcontroller Times');
hold on;
plot(samples, cumsum(times_interface)/1000, 'ro', 'LineWidth', 1.5, 'DisplayName', 'Interface Times');
xlim([min(samples) max(samples)]);
xlabel('Sample');
ylabel('Time (s)');
legend('Location', 'best');
grid on;
title('Comparison of Microcontroller and Interface Times');

%% Functions

function microcontroller_times = import_mcu(filename, dataLines)
%IMPORT_MCU Import data from a text file
%  MICROCONTROLLER_TIMES = IMPORT_MCU(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  MICROCONTROLLER_TIMES = IMPORT_MCU(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  microcontroller_times = import_mcu("./times.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 11-May-2024 12:12:40

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
opts.VariableNames = ["Samples", "Time"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
microcontroller_times = readtable(filename, opts);

end

function interface_value = import_interface(filename, dataLines)
%IMPORT_INTERFACE Import data from a text file
%  INTERFACE_VALUE = IMPORT_INTERFACE(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  INTERFACE_VALUE = IMPORT_INTERFACE(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
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
