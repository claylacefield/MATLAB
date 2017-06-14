function [nvGpSyncStruc] = procNvistaGPIOsyncMat()

% Clay 2016
% This function imports an nVista GPIO file, saved as .csv from Mosaic,
% then finds frame times (in ms) and event times on all GPIO ports.
% Results are output as structure.

% import nVista GPIO
[nvGpioStruc] = importNvistaGPIO();
syncBin = nvGpioStruc.syncBin;
gpio1bin = nvGpioStruc.gpio1bin;
nvTimeSec = nvGpioStruc.nvTimeSec;

if syncBin(1) == 1
    nvFrInd = [1 find(diff(syncBin)==1)+1]; % get nVista frame ind
else
    nvFrInd = find(diff(syncBin)==1)+1;
end

nvEthoOutOFFind = find(diff(double(gpio1bin))==-1)+1;   % find GPIO 1 event times (in ms)

nvEthoOutONind = find(diff(gpio1bin)==1)+1; % if nVista starts during first pulse, won't include this ON

% gp2evTimes = find(diff(gpio2bin)==1);

% extTrigTimes = find(diff(extBin)==1);
% if extBin(1) == 1
%    extTrigTimes = [0; extTrigTimes];    % if extTrig HIGH at beginning, add this time 
% end

nvGpSyncStruc.nvTimeSec = nvTimeSec;
nvGpSyncStruc.nvFrInd = nvFrInd;
nvGpSyncStruc.nvEthoOutOFFind = nvEthoOutOFFind;
nvGpSyncStruc.nvEthoOutONind = nvEthoOutONind;
% nvGpStruc.gp2evTimes = gp2evTimes;
% nvGpStruc.extTrigTimes = extTrigTimes;

nvGpSyncStruc.nvDelay = 1033-nvEthoOutOFFind(1); % NOTE: this may differ so isn't a great measure

nvGpSyncStruc.nvGpioStruc = nvGpioStruc;
