function [nvGpStruc] = procNvistaGPIO()

% Clay 2016
% This function imports an nVista GPIO file, saved as .csv from Mosaic,
% then finds frame times (in ms) and event times on all GPIO ports.
% Results are output as structure.

% [filename, pathname] = uigetfile('.hdf5', 'Select HDF5 file to read');
[filename, pathname] = uigetfile('.csv', 'Select CSV file to read');
cd(pathname);

% info = h5info(filename);
% data = h5read(filename, '/anc_data');

% import nVista GPIO .csv (with automatically generated script)
[time,gpio1bin,gpio2bin,syncBin,extBin] = importNvistaGPIO(filename);

frTimes = [0; find(diff(syncBin)==1)]; % get nVista frame times

gp1evTimes = find(diff(gpio1bin)==1);   % find GPIO 1 event times (in ms)
gp2evTimes = find(diff(gpio2bin)==1);

extTrigTimes = find(diff(extBin)==1);
if extBin(1) == 1
   extTrigTimes = [0; extTrigTimes];    % if extTrig HIGH at beginning, add this time 
end

nvGpStruc.time = time;
nvGpStruc.frTimes = frTimes;
nvGpStruc.gp1evTimes = gp1evTimes;
nvGpStruc.gp2evTimes = gp2evTimes;
nvGpStruc.extTrigTimes = extTrigTimes;

