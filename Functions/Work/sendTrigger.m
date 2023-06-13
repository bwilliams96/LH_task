%% DESCRIPTION
% Sends a 't' trigger to a serial port
%% INPUT:
% device = serial port that trigger is sent to. Note, this should be setup
% using the serialport function

function sendTrigger(device)
    if device == "medoc"
        disp("t")
    else
        write(device,'t',"char");
    end