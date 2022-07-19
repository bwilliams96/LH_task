%% DESCRIPTION
% Displays 3 images using psychtoolbox, all images but the selected one are
% greyed out <- grey out currently not working, images disappear instead
%% INPUT:
% img1 = an image file to be displayed
% img2 = an image file to be displayed
% img3 = an image file to be displayed
% positions = vector (length 3) with the order images are displayed. e.g.
% [2,3,1] would order the images: img3, img1, img2.
% window = psychtoolbox window
% screenXpixels = nuber of pixels in x axis
% screenYpixels = nuber of pixels in y axis
% time = time waiting 
% selected = selected image

%% OUTPUT:
% returns selected image based on key pressed on button box (button order:
% blue, yellow, green, red)

function img(img1, img2, img3, positions, window, screenXpixels, screenYpixels, time, selected)

    stimpos{1} = [((screenXpixels/12)*2) (screenYpixels/4) ((screenXpixels/12)*4) (screenYpixels/(4/3))];
    stimpos{2} = [((screenXpixels/12)*5) (screenYpixels/4) ((screenXpixels/12)*7) (screenYpixels/(4/3))];
    stimpos{3} = [((screenXpixels/12)*8) (screenYpixels/4) ((screenXpixels/12)*10) (screenYpixels/(4/3))];
    
    if selected == 1
        Screen('DrawTexture', window, img1, [], stimpos{positions(1)}, 0, [], 1);
        %Screen('DrawTexture', window, img2, [], stimpos{positions(2)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img3, [], stimpos{positions(3)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img4, [], stimpos{positions(4)}, 0, [], 0.5);
    elseif selected == 2
        %Screen('DrawTexture', window, img1, [], stimpos{positions(1)}, 0, [], 0.5);
        Screen('DrawTexture', window, img2, [], stimpos{positions(2)}, 0, [], 1);
        %Screen('DrawTexture', window, img3, [], stimpos{positions(3)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img4, [], stimpos{positions(4)}, 0, [], 0.5);
    elseif selected == 3
        %Screen('DrawTexture', window, img1, [], stimpos{positions(1)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img2, [], stimpos{positions(2)}, 0, [], 0.5);
        Screen('DrawTexture', window, img3, [], stimpos{positions(3)}, 0, [], 1);
        %Screen('DrawTexture', window, img4, [], stimpos{positions(4)}, 0, [], 0.5);
    end

    Screen('Flip', window);
    WaitSecs(time);