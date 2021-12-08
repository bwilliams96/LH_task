function noresp(window, screenYpixels)
    DrawFormattedText(window, 'No choice made', 'center', 'center',screenYpixels * 0.75, [0 0 1]);
    Screen('Flip', window);