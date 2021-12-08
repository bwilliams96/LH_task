function instructions(input, window, screenYpixels)
    %Screen('TextSize', window, 70);
    %[screenXpixels, screenYpixels] = Screen('WindowSize', window);
    DrawFormattedText(window, input, 'center', 'center',screenYpixels * 0.75, [0 0 1]);
    Screen('Flip', window);
    KbStrokeWait;