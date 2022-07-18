vals = [];
while true
    [~, y, ~, ~] = WinJoystickMex(0);
    vals = [vals, y];
    y_mean = mean(vals);
    y_std = std(vals);
    if y < (y_mean - 2*y_std)
        disp(y)
        %disp("Press")
    else
        disp(y)
        %disp("Unpressed")
    end
    tiledlayout(1,2);
    nexttile;
    plot(vals);
    nexttile;
    histogram(vals);
    drawnow;
end