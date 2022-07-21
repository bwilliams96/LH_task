%% DESCRIPTION
% Displays 3 images using psychtoolbox, all images but the selected one are
% greyed out <- grey out currently not working, images disappear instead
%% INPUT:
% img1 = an image file to be displayed
% img2 = an image file to be displayed
% img3 = an image file to be displayed
% win = image displayed for a win
% loss = image displayed for a loss
% [2,3,1] would order the images: img3, img1, img2.
% window = psychtoolbox window
% screenXpixels = nuber of pixels in x axis
% screenYpixels = nuber of pixels in y axis
% time = time waiting 
% selected = selected image
% outcome = outcome of choice
% squeezebutton = squeeze button image to be displayed
% squeezeoutcome = outcome of squeezing in time

%% OUTPUT:
% returns selected image based on key pressed on button box (button order:
% blue, yellow, green, red)

function img_outcome(img1, img2, img3, win, loss, window, screenXpixels, screenYpixels, time, selected, outcome, squeezebutton, squeezeoutcome)

    stimpos1 = [((screenXpixels/12)*3) (screenYpixels/4) ((screenXpixels/12)*5) (screenYpixels/(4/3))];
    stimpos2 = [((screenXpixels/12)*3.5) ((screenYpixels/8)*6) ((screenXpixels/12)*4.5) ((screenYpixels/8)*7)];
    stimpos3 = [((screenXpixels/12)*7.5) (screenYpixels/4) ((screenXpixels/12)*8.5) (screenYpixels/(4/3))];
    stimpos4 = [((screenXpixels/12)*7.5) ((screenYpixels/8)*6) ((screenXpixels/12)*8.5) ((screenYpixels/8)*7)];
    
    if selected == 1
        Screen('DrawTexture', window, img1, [], stimpos1, 0, [], 1);
    elseif selected == 2
        Screen('DrawTexture', window, img2, [], stimpos1, 0, [], 1);
    elseif selected == 3
        Screen('DrawTexture', window, img3, [], stimpos1, 0, [], 1);
    end

    Screen('DrawTexture', window, squeezebutton, [], stimpos3, 0, [], 1);

    if outcome == 1
        Screen('DrawTexture', window, win, [], stimpos2, 0, [], 1);
    elseif outcome == 0 
        Screen('DrawTexture', window, loss, [], stimpos2, 0, [], 1);
    end

    if squeezeoutcome == true
        Screen('DrawTexture', window, win, [], stimpos4, 0, [], 1);
    elseif squeezeoutcome == false 
        Screen('DrawTexture', window, loss, [], stimpos4, 0, [], 1);
    end

    Screen('Flip', window);
    WaitSecs(time);