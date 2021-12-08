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

    %% Loading the images
    img1 = Screen('MakeTexture', window, imread("img/img1.png"));
    img2 = Screen('MakeTexture', window, imread("img/img2.png"));
    img3 = Screen('MakeTexture', window, imread("img/img3.png"));
    img4 = Screen('MakeTexture', window, imread("img/img4.png"));
    win = Screen('MakeTexture', window, imread("img/win.png"));
    loss = Screen('MakeTexture', window, imread("img/loss.png"));

    %% First, we will give the participant some instructions
    instructions('These are instructions', window, screenYpixels);
    
    %% Now we will start the task

    %% INITAL LEARNING
    for i = 1:exp.blocks(1)
        exp.curr_trial = exp.curr_trial + 1;
        exp.selected(exp.curr_trial) = img(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome(exp, exp.curr_trial, 1);
            img_alpha(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial));
            if exp.outcome(exp.curr_trial) == 1
                sendTrigger()
            end
            img_outcome(img1, img2, img3, img4, win, loss, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial), exp.outcome(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        save(filename, 'exp');
    end

    %% REVERSAL LEARNING
    for i = 1:exp.blocks(2)
        exp.curr_trial = exp.curr_trial + 1;
        exp.selected(exp.curr_trial) = img(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome(exp, exp.curr_trial, 2);
            img_alpha(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial));
            if exp.outcome(exp.curr_trial) == 1
                sendTrigger()
            end
            img_outcome(img1, img2, img3, img4, win, loss, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial), exp.outcome(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        save(filename, 'exp');
    end

    %% DESC
    for i = 1:exp.blocks(3)
        exp.curr_trial = exp.curr_trial + 1;
        exp.selected(exp.curr_trial) = img(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome_desc(exp, exp.curr_trial, 2, i);
            img_alpha(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial));
            if exp.outcome(exp.curr_trial) == 1
                sendTrigger()
            end
            img_outcome(img1, img2, img3, img4, win, loss, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial), exp.outcome(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        save(filename, 'exp');
    end

    %% Learned helplessness
    for i = 1:exp.blocks(4)
        exp.curr_trial = exp.curr_trial + 1;
        exp.selected(exp.curr_trial) = img(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome_lh(exp, exp.curr_trial);
            img_alpha(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial));
            if exp.outcome(exp.curr_trial) == 1
                sendTrigger()
            end
            img_outcome(img1, img2, img3, img4, win, loss, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial), exp.outcome(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        save(filename, 'exp');
    end

    %% REVERSAL LEARNING 2
    for i = 1:exp.blocks(5)
        exp.curr_trial = exp.curr_trial + 1;
        exp.selected(exp.curr_trial) = img(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome(exp, exp.curr_trial, 3);
            img_alpha(img1, img2, img3, img4, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial));
            if exp.outcome(exp.curr_trial) == 1
                sendTrigger()
            end
            img_outcome(img1, img2, img3, img4, win, loss, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial), exp.random(exp.curr_trial), exp.outcome(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        save(filename, 'exp');
    end
    
    %% end of task
    ListenChar(1);
    sca;