function main()
    clear; clc
    %% Miscellaneous setup
    Screen('Preference', 'SkipSyncTests', 1); %%%!!!! ONLY FOR TESTING
    KbName('UnifyKeyNames');
    activeKeys = [KbName('a') KbName('s') KbName('d') KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    medoc = serialport("COM4",2400);
    %medoc = 'medoc';
    %ListenChar(2);
    HideCursor;

    %% This will setup the task
    addpath(genpath('./Functions'));
    id = input('Enter participant ID: ', 's');
    question_trials = 1:4:221; % Rating questions will only be asked on certain trials
                               % defined using this variable. Note, because trial indexing
                               % starts at 1, the number for the last trial is 221. If you
                               % want questions on every trial set the middle number to 1.

    %id = 'test' %%%!!!! THIS IS ONLY IN FOR TESTING, ALSO DELETE AND UNCOMMENT LINE 4
    exp = task(id,224,[80, 20; 50, 50; 20, 80],[1, 0],[50,50,20,50,50],10);
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
    win = Screen('MakeTexture', window, imread("img/win.png"));
    loss = Screen('MakeTexture', window, imread("img/loss.png"));
    squeezebutton = Screen('MakeTexture', window, imread("img/grip.png"));

    %% Setup for ratings
    question_pain  = ['At this moment how' '\n intense is your current pain?'];
    question_motiv  = ['At this moment how' '\n motivated are you for pain relief?'];
    question_agency = ['At this moment how' '\n much control do you feel you have over your pain relief?'];
    endPoints = {'0', '5', '10'};
    position_pain = 0;
    position_motiv = 0;

    %% First, we will give the participant some instructions
    instructions('When the trial begins, you will be firstly be instructed to squeeze the joystick\n After this you will be shown three jars, and instructed to choose one\n Use the keys A, S and D to make a selection of a jar\n The keys correspond to the position of the jar on the screen\n If you make the correct selection, you will receive relief from the thermal stimulation to your forearm\n You will then be asked how much pain you are currently in, use the A and D keys to respond on the scale\n You will also be asked how motivated you are for pain relief, use the A and D keys to respond on the scale\n Then the next trial will begin', window, screenYpixels);
    
    %% Now we will start the task

    %% INITAL LEARNING
    for i = 1:exp.blocks(1)
        exp.curr_trial = exp.curr_trial + 1;
        waittime = normrnd(1, 0.005);
        max_rt = duration(0,0,1);
        [exp.allvec{exp.curr_trial}, exp.waitvec{exp.curr_trial}, exp.pressvec{exp.curr_trial}, exp.rt(exp.curr_trial), exp.rt_intime(exp.curr_trial), exp.squeezetime(exp.curr_trial), exp.force(exp.curr_trial), exp.falsestart(exp.curr_trial), exp.time{exp.curr_trial}] = squeezeptb(window, screenYpixels, waittime, max_rt);
        exp.selected(exp.curr_trial) = img(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 10);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome(exp, exp.curr_trial, 1);
            img_alpha(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        if ismember(exp.curr_trial, question_trials)
            [position_pain, RT_pain, answer] = slideScale(window, question_pain, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_pain, 'range', 2, 'aborttime', 5, 'slidercolor', [0 211 206]);
            [position_motiv, RT_motiv, answer] = slideScale(window, question_motiv, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [255 0 0]);%[169 48 236]);
            [position_agency, RT_agency, answer] = slideScale(window, question_agency, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [255 180 0]);
            exp.pain_pos(exp.curr_trial) = position_pain/10;
            exp.pain_rt(exp.curr_trial) = RT_pain/1000;
            exp.motiv_pos(exp.curr_trial) = position_motiv/10;
            exp.motiv_rt(exp.curr_trial) = RT_motiv/1000;
            exp.agency_pos(exp.curr_trial) = position_agency/10;
            exp.agency_rt(exp.curr_trial) = RT_agency/1000;
        end
        save(filename, 'exp');
        if exp.selected(exp.curr_trial) ~= 0
            if exp.outcome(exp.curr_trial) == 1 && exp.rt_intime(exp.curr_trial) == 1
                sendTrigger(medoc)
            end
            img_outcome(img1, img2, img3, win, loss, window, screenXpixels, screenYpixels, 4, exp.selected(exp.curr_trial), exp.outcome(exp.curr_trial), squeezebutton, exp.rt_intime(exp.curr_trial));
        end
    end

    %% REVERSAL LEARNING
    for i = 1:exp.blocks(2)
        exp.curr_trial = exp.curr_trial + 1;
        waittime = normrnd(1, 0.005);
        max_rt = duration(0,0,1);
        [exp.allvec{exp.curr_trial}, exp.waitvec{exp.curr_trial}, exp.pressvec{exp.curr_trial}, exp.rt(exp.curr_trial), exp.rt_intime(exp.curr_trial), exp.squeezetime(exp.curr_trial), exp.force(exp.curr_trial), exp.falsestart(exp.curr_trial), exp.time{exp.curr_trial}] = squeezeptb(window, screenYpixels, waittime, max_rt);
        exp.selected(exp.curr_trial) = img(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 10);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome(exp, exp.curr_trial, 2);
            img_alpha(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        if ismember(exp.curr_trial, question_trials)
            [position_pain, RT_pain, answer] = slideScale(window, question_pain, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_pain, 'range', 2, 'aborttime', 5, 'slidercolor', [0 211 206]);
            [position_motiv, RT_motiv, answer] = slideScale(window, question_motiv, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [169 48 236]);
            [position_agency, RT_agency, answer] = slideScale(window, question_agency, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [255 180 0]);
            exp.pain_pos(exp.curr_trial) = position_pain/10;
            exp.pain_rt(exp.curr_trial) = RT_pain/1000;
            exp.motiv_pos(exp.curr_trial) = position_motiv/10;
            exp.motiv_rt(exp.curr_trial) = RT_motiv/1000;
            exp.agency_pos(exp.curr_trial) = position_agency/10;
            exp.agency_rt(exp.curr_trial) = RT_agency/1000;
        end
        save(filename, 'exp');
        if exp.selected(exp.curr_trial) ~= 0
            if exp.outcome(exp.curr_trial) == 1 && exp.rt_intime(exp.curr_trial) == 1
                sendTrigger(medoc)
            end
            img_outcome(img1, img2, img3, win, loss, window, screenXpixels, screenYpixels, 4, exp.selected(exp.curr_trial), exp.outcome(exp.curr_trial), squeezebutton, exp.rt_intime(exp.curr_trial));
        end
    end

    %% DESC
    for i = 1:exp.blocks(3)
        exp.curr_trial = exp.curr_trial + 1;
        waittime = normrnd(1, 0.005);
        max_rt = duration(0,0,1);
        [exp.allvec{exp.curr_trial}, exp.waitvec{exp.curr_trial}, exp.pressvec{exp.curr_trial}, exp.rt(exp.curr_trial), exp.rt_intime(exp.curr_trial), exp.squeezetime(exp.curr_trial), exp.force(exp.curr_trial), exp.falsestart(exp.curr_trial), exp.time{exp.curr_trial}] = squeezeptb(window, screenYpixels, waittime, max_rt);
        exp.selected(exp.curr_trial) = img(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 10);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome_desc(exp, exp.curr_trial, 2, i);
            img_alpha(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        if ismember(exp.curr_trial, question_trials)
            [position_pain, RT_pain, answer] = slideScale(window, question_pain, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_pain, 'range', 2, 'aborttime', 5, 'slidercolor', [0 211 206]);
            [position_motiv, RT_motiv, answer] = slideScale(window, question_motiv, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [169 48 236]);
            [position_agency, RT_agency, answer] = slideScale(window, question_agency, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [255 180 0]);
            exp.pain_pos(exp.curr_trial) = position_pain/10;
            exp.pain_rt(exp.curr_trial) = RT_pain/1000;
            exp.motiv_pos(exp.curr_trial) = position_motiv/10;
            exp.motiv_rt(exp.curr_trial) = RT_motiv/1000;
            exp.agency_pos(exp.curr_trial) = position_agency/10;
            exp.agency_rt(exp.curr_trial) = RT_agency/1000;
        end
        save(filename, 'exp');
        if exp.selected(exp.curr_trial) ~= 0
            if exp.outcome(exp.curr_trial) == 1 && exp.rt_intime(exp.curr_trial) == 1
                sendTrigger(medoc)
            end
            img_outcome(img1, img2, img3, win, loss, window, screenXpixels, screenYpixels, 4, exp.selected(exp.curr_trial), exp.outcome(exp.curr_trial), squeezebutton, exp.rt_intime(exp.curr_trial));
        end
    end

    %% Learned helplessness
    for i = 1:exp.blocks(4)
        exp.curr_trial = exp.curr_trial + 1;
        waittime = normrnd(1, 0.005);
        max_rt = duration(0,0,1);
        [exp.allvec{exp.curr_trial}, exp.waitvec{exp.curr_trial}, exp.pressvec{exp.curr_trial}, exp.rt(exp.curr_trial), exp.rt_intime(exp.curr_trial), exp.squeezetime(exp.curr_trial), exp.force(exp.curr_trial), exp.falsestart(exp.curr_trial), exp.time{exp.curr_trial}] = squeezeptb(window, screenYpixels, waittime, max_rt);
        exp.selected(exp.curr_trial) = img(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 10);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome_lh(exp, exp.curr_trial);
            img_alpha(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        if ismember(exp.curr_trial, question_trials)
            [position_pain, RT_pain, answer] = slideScale(window, question_pain, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_pain, 'range', 2, 'aborttime', 5, 'slidercolor', [0 211 206]);
            [position_motiv, RT_motiv, answer] = slideScale(window, question_motiv, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [169 48 236]);
            [position_agency, RT_agency, answer] = slideScale(window, question_agency, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [255 180 0]);
            exp.pain_pos(exp.curr_trial) = position_pain/10;
            exp.pain_rt(exp.curr_trial) = RT_pain/1000;
            exp.motiv_pos(exp.curr_trial) = position_motiv/10;
            exp.motiv_rt(exp.curr_trial) = RT_motiv/1000;
            exp.agency_pos(exp.curr_trial) = position_agency/10;
            exp.agency_rt(exp.curr_trial) = RT_agency/1000;
        end
        save(filename, 'exp');
        if exp.selected(exp.curr_trial) ~= 0
            if exp.outcome(exp.curr_trial) == 1 && exp.rt_intime(exp.curr_trial) == 1
                sendTrigger(medoc)
            end
            img_outcome(img1, img2, img3, win, loss, window, screenXpixels, screenYpixels, 4, exp.selected(exp.curr_trial), exp.outcome(exp.curr_trial), squeezebutton, exp.rt_intime(exp.curr_trial));
        end
    end

    %% REVERSAL LEARNING 2
    for i = 1:exp.blocks(5)
        exp.curr_trial = exp.curr_trial + 1;
        waittime = normrnd(1, 0.005);
        max_rt = duration(0,0,1);
        [exp.allvec{exp.curr_trial}, exp.waitvec{exp.curr_trial}, exp.pressvec{exp.curr_trial}, exp.rt(exp.curr_trial), exp.rt_intime(exp.curr_trial), exp.squeezetime(exp.curr_trial), exp.force(exp.curr_trial), exp.falsestart(exp.curr_trial), exp.time{exp.curr_trial}] = squeezeptb(window, screenYpixels, waittime, max_rt);
        exp.selected(exp.curr_trial) = img(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 10);
        if exp.selected(exp.curr_trial) ~= 0
            exp = getOutcome(exp, exp.curr_trial, 3);
            img_alpha(img1, img2, img3, exp.loc(exp.curr_trial,:), window, screenXpixels, screenYpixels, 2, exp.selected(exp.curr_trial));
        else
            noresp(window, screenYpixels);
            WaitSecs(2);
        end
        if ismember(exp.curr_trial, question_trials)
            [position_pain, RT_pain, answer] = slideScale(window, question_pain, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_pain, 'range', 2, 'aborttime', 5, 'slidercolor', [0 211 206]);
            [position_motiv, RT_motiv, answer] = slideScale(window, question_motiv, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [169 48 236]);
            [position_agency, RT_agency, answer] = slideScale(window, question_agency, windowRect, endPoints, 'device', 'keyboard', 'stepsize', 15, 'responseKeys', [activeKeys(2) activeKeys(1) activeKeys(3)], 'startposition', position_motiv, 'range', 2, 'aborttime', 5, 'slidercolor', [255 180 0]);
            exp.pain_pos(exp.curr_trial) = position_pain/10;
            exp.pain_rt(exp.curr_trial) = RT_pain/1000;
            exp.motiv_pos(exp.curr_trial) = position_motiv/10;
            exp.motiv_rt(exp.curr_trial) = RT_motiv/1000;
            exp.agency_pos(exp.curr_trial) = position_agency/10;
            exp.agency_rt(exp.curr_trial) = RT_agency/1000;
        end
        save(filename, 'exp');
        if exp.selected(exp.curr_trial) ~= 0
            if exp.outcome(exp.curr_trial) == 1 && exp.rt_intime(exp.curr_trial) == 1
                sendTrigger(medoc)
            end
            img_outcome(img1, img2, img3, win, loss, window, screenXpixels, screenYpixels, 4, exp.selected(exp.curr_trial), exp.outcome(exp.curr_trial), squeezebutton, exp.rt_intime(exp.curr_trial));
        end
    end
    
    %% end of task
    ListenChar(1);
    sca;