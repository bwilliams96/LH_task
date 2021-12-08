function Learned_helplessness()

    %% Miscellaneous setup
    Screen('Preference', 'SkipSyncTests', 1); %%%!!!! ONLY FOR TESTING
    activeKeys = [KbName('b') KbName('y') KbName('g') KbName('r') KbName('t')];
    %medoc = serialport(,9600)
    medoc = 'medoc'
    ListenChar(2);

    %% This will setup the task
    addpath(genpath('./Functions'));
    %id = input('Enter participant ID: ', 's');
    id = 'test' %%%!!!! THIS IS ONLY IN FOR TESTING, DELETE AND UNCOMMENT LINE 4
    exp = task(id,224,[75, 25; 50, 50; 25, 75],[1, 0],[50,50,20,50,50],4);
    filename = [pwd, '/Data/', exp.id, '.mat'];
    save(filename, 'exp');

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
    
    % Get the centre coordinate of the window in pixels.
    % xCenter = screenXpixels / 2
    % yCenter = screenYpixels / 2
    [xCenter, yCenter] = RectCenter(windowRect);
    
    % Query the inter-frame-interval. This refers to the minimum possible time
    % between drawing to the screen
    ifi = Screen('GetFlipInterval', window);
    
    % We can also determine the refresh rate of our screen. The
    % relationship between the two is: ifi = 1 / hertz
    hertz = FrameRate(window);
    
    % We can also query the "nominal" refresh rate of our screen. This is
    % the refresh rate as reported by the video card. This is rounded to the
    % nearest integer. In reality there can be small differences between
    % "hertz" and "nominalHertz"
    % This is nothing to worry about. See Screen FrameRate? and Screen
    % GetFlipInterval? for more information
    nominalHertz = Screen('NominalFrameRate', window);
    
    % Here we get the pixel size. This is not the physical size of the pixels
    % but the color depth of the pixel in bits
    pixelSize = Screen('PixelSize', window);
    
    % Queries the display size in mm as reported by the operating system. Note
    % that there are some complexities here. See Screen DisplaySize? for
    % information. So always measure your screen size directly.
    [width, height] = Screen('DisplaySize', screenNumber);
    
    % Get the maximum coded luminance level (this should be 1)
    maxLum = Screen('ColorRange', window);

    %% Loading the images
    img1 = Screen('MakeTexture', window, imread("img/img1.png"));
    img2 = Screen('MakeTexture', window, imread("img/img2.png"));
    img3 = Screen('MakeTexture', window, imread("img/img3.png"));
    img4 = Screen('MakeTexture', window, imread("img/img4.png"));

    %% First, we will give the participant some instructions
    instructions('These are instructions', window, screenYpixels);
    
    %% Now we will start the task

    for i = 1:exp.blocks(1)/10
        exp.selected(i) = img(img1, img2, img3, img4, exp.loc(i,:), window, screenXpixels, screenYpixels, 2);
        disp(exp.loc(i,:))
        disp(exp.selected(i))
        exp = getOutcome(exp, i, 1);
        img_alpha(img1, img2, img3, img4, exp.loc(i,:), window, screenXpixels, screenYpixels, 2, exp.selected(i), exp.random(i));

        save(filename, 'exp');
    end
    %% end of task
    ListenChar(1);
    sca;