tic
while toc <= 0.5
    [~, y, ~, ~] = WinJoystickMex(0);
    allvec = [allvec, y];
    time = [time, datetime(now, 'ConvertFrom','datenum', 'Format', 'HH:mm:ss.SSS')];
end