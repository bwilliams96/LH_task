%% DESCRIPTION
% Waits an allotted time for a keypress
%% INPUT:
% waitTime = time (in seconds) to wait for a keypress)
%% OUTPUT:
% returns the pressed key if a response is made in the allotted time, else
% false is returned. 

function keyCode = wait4key(waitTime)
    tStart = GetSecs;
    timeout = false;
    while timeout == false
        [keyIsDown, keyTime, keyCode] = KbCheck;
        if(keyIsDown)
            keyCode = KbName(keyCode);
            break
        end

        if GetSecs - tStart > waitTime
            keyCode = false;
            timeout = true;
        end
    end