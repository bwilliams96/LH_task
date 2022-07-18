
clear all
handgrip_setting = 1; % change to 1 if handgrip is not working
hg_idx = 1; % initialise value

% handgrip test
while hg_idx < 200
    
    handgrip_input = jst;
    handgrip_vals(hg_idx) = handgrip_input(handgrip_setting);
    
    figure(1)
    hold on
    ylim([-2, 2]);
    plot(handgrip_vals, 'Color', 'b')
    hold off
    
    hg_idx = hg_idx + 1;
    
end

close all