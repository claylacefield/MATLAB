function [frTimes, syncOnTimes, syncOffTimes] = processNVgpioPy() % time, sync, io1) % (pyGpioStruc)

% Clay 2017
% This is a function to take output from the export_gpio.py script from
% Inscopix, imported to MATLAB with the import wizard, and to process
% nVista frame times and med associates sync signals (io1). 
% This is a bit tricky because of the way that the signals are represented
% in the TXT file output by the python script. Basically, the signals are
% only recorded when there is a change in any of the input signals, and
% this is given a timestamp. This can be a frame change, trigger, or any
% input signal. Here are a few notes on this:
% 1.) While frame tells the frame number (since the system is started, not
% from the beginning of actual capture), the sync signal is not "1" on the 
% first row for that frame, but the second
% 2.) Time is represented from the system time, so you have to subtract the
% first time from the time array to get the time relative to the start time
% 3.) Time is in secs.

[filename, path] = uigetfile('.txt', 'Select TXT file of exported nVista gpio');

dataTable = readtable(filename);
time = dataTable{:,2};
sync = dataTable{:,3};
io1 = dataTable{:,5};

%% extract values from pyGpioStruc
% frame = pyGpioStruc.frame;
% sync = pyGpioStruc.sync;
% trig = pyGpioStruc.trigger;
% io1 = pyGpioStruc.io1;


t1 = time;%-time(1); % subtract first time to have adjusted time array (event based)
frInds = find(diff(sync)==1)+1; % find indices of frame trigger pulses
%frInds = [1; frInds];
frTimes = t1(frInds);   % then use these indices to find the times of these events


syncOnInds = find(diff(io1)==1)+1; %LocalMinima(diff(io1), 50, -0.5)+1;  % find onsets of negative-going MedAssoc sync
syncOffInds = find(diff(io1)==-1)+1;
syncOnTimes = t1(syncOnInds);   % and then the times
syncOffTimes = t1(syncOffInds);





