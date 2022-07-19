%% DESCRIPTION
% Displays 3 images using psychtoolbox and waits an allotted time for a
% response
%% INPUT:
% img1 = an image file to be displayed
% img2 = an image file to be displayed
% img3 = an image file to be displayed
% positions = vector (length ) with the order images are displayed. e.g.
% [2,3,1] would order the images: img3, img1, img2.
% window = psychtoolbox window
% screenXpixels = nuber of pixels in x axis
% screenYpixels = nuber of pixels in y axis
% time = time waiting for a keypress

%% OUTPUT:
% returns selected image based on key pressed on button box (button order:
% blue, yellow, green, red)

function chosen = img(img1, img2, img3, positions, window, screenXpixels, screenYpixels, time)
    
    keyCode = false;
    countdown_vals = sort(1:time,'descend');

    stimpos{1} = [((screenXpixels/12)*2) (screenYpixels/4) ((screenXpixels/12)*4) (screenYpixels/(4/3))];
    stimpos{2} = [((screenXpixels/12)*5) (screenYpixels/4) ((screenXpixels/12)*7) (screenYpixels/(4/3))];
    stimpos{3} = [((screenXpixels/12)*8) (screenYpixels/4) ((screenXpixels/12)*10) (screenYpixels/(4/3))];

    tStart = GetSecs;
    while GetSecs - tStart < time
        idx = ceil(GetSecs - tStart);
        Screen('DrawTexture', window, img1, [], stimpos{positions(1)}, 0);
        Screen('DrawTexture', window, img2, [], stimpos{positions(2)}, 0);
        Screen('DrawTexture', window, img3, [], stimpos{positions(3)}, 0);
        DrawFormattedText(window, 'Please make a choice', 'center',screenYpixels * 0.2, [0 0 0]);
        if countdown_vals(idx) == 1
            DrawFormattedText(window, append('Time Remaining: ', num2str(countdown_vals(idx)), ' second'), 'center', screenYpixels * 0.23, [0 0 0]);
        else
            DrawFormattedText(window, append('Time Remaining: ', num2str(countdown_vals(idx)), ' seconds'), 'center', screenYpixels * 0.23, [0 0 0]);
        end
        Screen('Flip', window);
        [keyIsDown, ~, keyCode] = KbCheck;
        if(keyIsDown)
            keyCode = KbName(keyCode);
            break
        end
    end

    if keyCode ~= false
        if keyCode == 'b'
            chosen = find(positions == 1);
        elseif keyCode == 'y'
            chosen = find(positions == 2);
        elseif keyCode == 'g'
            chosen = find(positions == 3);
        end
    else 
        chosen = false;
    end
        