%% DONT USE THIS!!!



function [allvec, waitvec, pressvec, rt, squeezetime, force, falsestart] = squeezeptb_old(window, screenYpixels, waittime)

    waitvec = []; % just values for 'Ready...' period
    allvec = []; % all values output by squeeze button
    pressvec = []; % values output when squeezing
    falsestart = false; % sets value of false in case of no false start
    readymessage = 'Ready...';
    
    % display ready message for 'waittime' seconds and read output from
    % squeeze button when no response is being made
    tic
    while toc <= waittime
        DrawFormattedText(window, readymessage, 'center', 'center',screenYpixels * 0.75, [0 0 1]);
        Screen('Flip', window);
        [~, y, ~, ~] = WinJoystickMex(0);
        if y < 62000
            readymessage = 'Ready... \n PLEASE RELEASE THE BUTTON';
            falsestart = true;
        end
        waitvec = [waitvec, y];
        allvec = [allvec, y];
    end

    % calculate mean and sd for 'waittime', display message to go, and
    % begin counting for reaction time
    y_median = median(waitvec); % using median in case of false starts
    y_std = 50; % hardcoded as 50 as this is roughly 1sd when no buttons are pressed
    DrawFormattedText(window, 'Go!', 'center', 'center',screenYpixels * 0.75, [0 0 1]);
    Screen('Flip', window);
    tic
    
    while true
        [~, y, ~, ~] = WinJoystickMex(0);
        allvec = [allvec, y];
        if y < (y_median - 10*y_std) % when button is pressed, break loop
            DrawFormattedText(window, 'Pressed', 'center', 'center',screenYpixels * 0.75, [0 0 1]);
            Screen('Flip', window);
            rt = toc; % record reaction time 
            pressvec = [pressvec, y];
            tic
            break
        end
    end
    
    % record output of squeeze button to pressvec while values are less
    % than 2sd below mean
    while y < (y_median - 10*y_std)
        [~, y, ~, ~] = WinJoystickMex(0);
        pressvec = [pressvec, y];
        allvec = [allvec, y];
    end
    squeezetime = toc; % record amount of time button was squeezed for
    force = min(pressvec); % the maximum force applied on this trial
    
    % record data for an extra 0.5 second
    tic
    while toc <= 0.5
        [~, y, ~, ~] = WinJoystickMex(0);
        allvec = [allvec, y];
    end

%    if min(waitvec) < (y_median - 10*y_std)
%        falsestart = true;
%   else
%        falsestart = false;
%    end


    tiledlayout(2,2); nexttile; plot(waitvec); nexttile; plot(pressvec); nexttile; plot(allvec); nexttile; plot(allvec(length(waitvec):end));