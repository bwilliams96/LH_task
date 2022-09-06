%% DESCRIPTION
% Sends a 't' trigger to a serial port
%% INPUT:
% device = serial port that trigger is sent to. Note, this should be setup
% using the serialport function

function sendTrigger(device)
    write(device,'t',"char");
    %disp('t'); %only in for testing purposes when no serial port configured