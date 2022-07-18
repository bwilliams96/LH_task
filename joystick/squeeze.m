function [allvec, waitvec, pressvec, rt, squeezetime, force, falsestart, time] = squeeze(waittime)

    waitvec = []; % just values for 'Ready...' period
    allvec = []; % all values output by squeeze button
    pressvec = []; % values output when squeezing
    time = []; % save current time associated with values in allvec
    falsestart = false; % sets value of false in case of no false start
    
    % wait for squeeze button to come to initial rest, max 5 seconds
    tic
    [~, y, ~, ~] = WinJoystickMex(0);
    while y < 61700
        [~, y, ~, ~] = WinJoystickMex(0);
        disp('Please release your grip')
        if toc > 5
            break
        end
    end
    
    % display ready message for 'waittime' seconds and read output from
    % squeeze button when no response is being made
    tic
    while toc <= waittime
        disp('Ready...')
        [~, y, ~, ~] = WinJoystickMex(0);
        if y < 61000
            disp('Please release your grip')
            falsestart = true;
        end
        waitvec = [waitvec, y];
        allvec = [allvec, y];
        time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
    end

    % calculate mean and sd for 'waittime', display message to go, and
    % begin counting for reaction time
    y_median = median(waitvec); % using median in case of false starts
    y_std = 50; % hardcoded as 50 as this is roughly 1sd when no buttons are pressed
    disp('Go!')
    tic
    
    while true
        [~, y, ~, ~] = WinJoystickMex(0);
        allvec = [allvec, y];
        time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
        if y < (y_median - 5*y_std) % when button is pressed, break loop
            disp('Pressed')
            rt = toc; % record reaction time 
            pressvec = [pressvec, y];
            tic
            break
        end
    end
    
    % record output of squeeze button to pressvec while values are less
    % than 2sd below mean
    while y < (y_median - 5*y_std)
        [~, y, ~, ~] = WinJoystickMex(0);
        pressvec = [pressvec, y];
        allvec = [allvec, y];
        time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
    end
    squeezetime = toc; % record amount of time button was squeezed for
    force = min(pressvec); % the maximum force applied on this trial
    
    % record data for an extra 0.5 second
    tic
    while toc <= 0.5
        [~, y, ~, ~] = WinJoystickMex(0);
        allvec = [allvec, y];
        time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
    end

%    if min(waitvec) < (y_median - 10*y_std)
%        falsestart = true;
%   else
%        falsestart = false;
%    end


    tiledlayout(2,2); nexttile; plot(waitvec); nexttile; plot(pressvec); nexttile; plot(allvec); nexttile; plot(allvec(length(waitvec):end));