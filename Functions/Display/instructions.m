function instructions(input, window, screenYpixels)
    %Screen('TextSize', window, 70);
    %[screenXpixels, screenYpixels] = Screen('WindowSize', window);
    DrawFormattedText(window, input, 'center', 'center',[1 1 1], [0 0 1], 0, 0, 3);
    Screen('Flip', window);
    KbStrokeWait;       