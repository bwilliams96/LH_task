%% DESCRIPTION
% Displays 4 images using psychtoolbox, all images but the selected one are
% greyed out <- grey out currently not working, images disappear instead
%% INPUT:
% img1 = an image file to be displayed
% img2 = an image file to be displayed
% img3 = an image file to be displayed
% img4 = an image file to be displayed
% positions = vector (length 4) with the order images are displayed. e.g.
% [2,3,1,4] would order the images: img3, img1, img2, img4.
% window = psychtoolbox window
% screenXpixels = nuber of pixels in x axis
% screenYpixels = nuber of pixels in y axis
% time = time waiting 
% selected = selected image

%% OUTPUT:
% returns selected image based on key pressed on button box (button order:
% blue, yellow, green, red)

function img(img1, img2, img3, img4, positions, window, screenXpixels, screenYpixels, time, selected, random)

    stimpos{1} = [(screenXpixels/13) (screenYpixels/4) ((screenXpixels/13)*3) (screenYpixels/(4/3))];
    stimpos{2} = [((screenXpixels/13)*4) (screenYpixels/4) ((screenXpixels/13)*6) (screenYpixels/(4/3))];
    stimpos{3} = [((screenXpixels/13)*7) (screenYpixels/4) ((screenXpixels/13)*9) (screenYpixels/(4/3))];
    stimpos{4} = [((screenXpixels/13)*10) (screenYpixels/4) ((screenXpixels/13)*12) (screenYpixels/(4/3))];
    
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
    elseif selected == 4
        %Screen('DrawTexture', window, img1, [], stimpos{positions(1)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img2, [], stimpos{positions(2)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img3, [], stimpos{positions(3)}, 0, [], 0.5);
        Screen('DrawTexture', window, img4, [], stimpos{positions(4)}, 0, [], 1);
        if random == 1
            Screen('DrawTexture', window, img1, [], stimpos{positions(1)}, 0, [], 0.5);
        elseif random == 2
            Screen('DrawTexture', window, img2, [], stimpos{positions(2)}, 0, [], 0.5);
        elseif random == 3
            Screen('DrawTexture', window, img3, [], stimpos{positions(3)}, 0, [], 0.5);
        end
        
    else
        %next line a tempoary fix
        instructions('No choice made', window, screenYpixels);
        %Screen('DrawTexture', window, img1, [], stimpos{positions(1)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img2, [], stimpos{positions(2)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img3, [], stimpos{positions(3)}, 0, [], 0.5);
        %Screen('DrawTexture', window, img4, [], stimpos{positions(4)}, 0, [], 0.5);
    end

    Screen('Flip', window);
    WaitSecs(time);