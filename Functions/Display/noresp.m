function noresp(window, screenYpixels)
    DrawFormattedText(window, 'No choice made', 'center', 'center',[0 0 0], [0 0 1]);
    Screen('Flip', window);