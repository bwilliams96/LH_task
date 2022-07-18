wait_time = abs(normrnd(2,0.5));
max_rt = duration(0,0,2);
waitvec = []; % just values for 'Ready...' period
allvec = []; % all values output by squeeze button
pressvec = []; % values output when squeezing
time = []; % save current time associated with values in allvec

tic 
while true
    while toc < wait_time
        disp('ready...')
        [~, y, ~, ~] = WinJoystickMex(0);
        waitvec = [waitvec, y];
        allvec = [allvec, y];
        time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
        go_time = time(end);
        time_length = length(time);
    end
    
    gate = false;
    while datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS') < go_time + max_rt*1.5
        disp('Go!')
        [~, y, ~, ~] = WinJoystickMex(0);
        pressvec = [pressvec, y];
        allvec = [allvec, y];
        time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
        if datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS') >= go_time + max_rt
            if gate == false
                disp('slow')
                rt_time_length = length(time);
                gate = true;
            end
        end
    end

    change = findchangepts(pressvec,'MaxNumChanges',3,'Statistic',"linear");
    if time_length + change(1) <= rt_time_length
        rt = true;
    else
        rt = false;
    end
    
    falsestart = findchangepts(waitvec,'MaxNumChanges',3,'Statistic',"linear");
    if (mean(waitvec) - 3*std(waitvec)) > waitvec(falsestart(2))
        falsestart = true
    else
        falsestart = false
    end
    break
end

tiledlayout(2,2); nexttile; plot(waitvec); nexttile; plot(pressvec); nexttile; plot(allvec); nexttile; plot(allvec(length(waitvec):end));