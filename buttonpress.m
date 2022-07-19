function [allvec, waitvec, pressvec, rt, rt_intime, squeezetime, force, falsestart, time] = buttonpress()

    clear;
    clc;

    %% Miscellaneous setup
    Screen('Preference', 'SkipSyncTests', 1); %%%!!!! ONLY FOR TESTING
    KbName('UnifyKeyNames');
    activeKeys = [KbName('b') KbName('y') KbName('g') KbName('r') KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    %medoc = serialport(,9600)
    medoc = 'medoc';
    %ListenChar(2);
    HideCursor;

    %% Now we will setup psychtoolbox
    % Psychtoolbox setup options from https://peterscarfe.com/insertedCode/TotallyMinimalWithInfoDemo.html
   
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    % Get the screen numbers. 
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen. If I were to select the minimum of these numbers then I would be
    % displaying on the physical screen of my laptop.
    screenNumber = max(screens);
    
    % Define black and white (white will be 1 and black 0). This is because
    % luminace values are genrally defined between 0 and 1.
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    
    % Do a simply calculation to calculate the luminance value for grey. This
    % will be half the luminace value for white
    grey = white / 2;
    
    % Open an on screen window and color it grey. 
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
    
    % Get the size of the on screen window in pixels, these are the last two
    % numbers in "windowRect" 
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);

    %% RUN THE FUNCTION
    addpath(genpath('./Functions/joystick'));
    waittime = normrnd(1, 0.005);
    max_rt = duration(0,0,2);
    [allvec, waitvec, pressvec, rt, rt_intime, squeezetime, force, falsestart, time] = squeezeptb(window, screenYpixels, waittime, max_rt);
    %% end of task
    ListenChar(1);
    sca;