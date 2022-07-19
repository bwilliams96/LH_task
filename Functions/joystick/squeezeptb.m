function [allvec, waitvec, pressvec, rt, rt_intime, squeezetime, force, falsestart, time] = squeezeptb(window, screenYpixels, waittime, max_rt)

    waitvec = []; % just values for 'Ready...' period
    allvec = []; % all values output by squeeze button
    pressvec = []; % values output when squeezing
    time = []; % save current time associated with values in allvec
    
    tic

    while true
        % display ready during waittime and record from joystick
        DrawFormattedText(window, 'Ready...', 'center', 'center',screenYpixels * 0.75, [0 0 1]);
        Screen('Flip', window);
        while toc < waittime
            [~, y, ~, ~] = WinJoystickMex(0);
            waitvec = [waitvec, y];
            allvec = [allvec, y];
            time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
        end
        
        % these values are used in the next section for accurate timing etc
        go_time = time(end);
        time_length = length(time);

        % this is used as part of the check to see if response was given
        % within rt
        gate = false;

        % loop over response time, note, this is 1.5x maximum rt in length
        DrawFormattedText(window, 'Go!', 'center', 'center',screenYpixels * 0.75, [0 0 1]);
        Screen('Flip', window);
        while datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS') < go_time + max_rt*1.5    
            [~, y, ~, ~] = WinJoystickMex(0);
            pressvec = [pressvec, y];
            allvec = [allvec, y];
            time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];

        % get length of the time array at maximum rt to determine if
        % response is given in time
            if datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS') >= go_time + max_rt
                if gate == false
                    rt_time_length = length(time);
                    gate = true;
                end
            end
        end

        % find where button was pressed and return true if it is within the
        % maximum rt, otherwise return false
        change = findchangepts(pressvec,'MaxNumChanges',3,'Statistic',"linear");
        rt = milliseconds(time(time_length + change(1)) - go_time);
        if time_length + change(1) <= rt_time_length
            rt_intime = true;
        else
            rt_intime = false;
        end
    
        % determine if a false start was given, note, this is data driven and
        % based on a point being < 2sd from mean
        falsestart = findchangepts(waitvec,'MaxNumChanges',3,'Statistic',"linear");
        if length(falsestart) ~= 3 
            falsestart = false;
        else
            if (mean(waitvec) - 2*std(waitvec)) > waitvec(falsestart(2))
                falsestart = true;
            else
                falsestart = false;
            end
        end
        
        if length(change) == 3
            squeezetime = milliseconds(time(time_length + change(3)) - time(time_length + change(1))); % record amount of time button was squeezed for
            force = pressvec(change(1)) - pressvec(change(2));
        else
            squeezetime = nan;
            force = nan;
        end
        break
    end

% tiledlayout(2,2); nexttile; plot(waitvec); nexttile; plot(pressvec); nexttile; plot(allvec); nexttile; plot(allvec(length(waitvec):end));