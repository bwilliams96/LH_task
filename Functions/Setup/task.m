classdef task < handle
    properties
        % If all inputs are not given then default values will be used
        id % subject id
        ntrials % number of trials - note, this should be equally divisable by len
        probs % outcome probabilities - note, the percentage of len for each probability should be an integer, these should also be specified in order of highest to lowest prob of win
        rewards % possible rewards for each option
        blocks % lengths of each block in task
        len % length over which reward probabilities are true
        %% These variables are used to hold task-relevant information
        loc % location of each option for each trial
        order % numbers that match each option to its corresponding out column
        counts % number of times each option has been chosen, updates on each choice
        selected % option selected on each trial
        outcome % outcome of each trial
        random % tracks whether random button was used or not
        learn %possible outcomes for initial and reversal learning periods
        desc %possible outcomes for descent period
        curr_trial %current trial
        pain_pos % position of pain rating [0-10]
        pain_rt % reaction time to give pain rating in seconds
        motiv_pos % position of motivation rating [0-10]
        motiv_rt % reaction time to give motivation rating in seconds
        
        
    end
    
    methods
        %%
        %creates variables when class is called
        function task = task(id, ntrials, probs, rewards, blocks, len)
            
            %set variables based on input
            if nargin < 6
                disp('Not all arguments defined, default values will be used')
                task.id = '';
                task.ntrials = 224;
                task.probs = [75, 25; 
                              50, 50; 
                              25, 75];
                task.rewards = [1, 0];
                task.blocks = [50,50,20,50,50];
                task.len = 4;

            elseif nargin == 6
                task.id = id;
                task.ntrials = ntrials;
                task.probs = probs;
                task.rewards = rewards;
                task.blocks = blocks;
                task.len = len;
                
            elseif nargin > 6
                disp('More than 6 inputs defined. Inputs 6+ will be ignored');
                task.id = id;
                task.ntrials = ntrials;
                task.probs = probs;
                task.rewards = rewards;
                task.blocks = blocks;
                task.len = len;
            end
            
            %%
                     
            % Randomly determine stimulus positioning
            task.loc = mod(bsxfun(@plus, randperm(4), transpose(randperm(task.ntrials))), 4) + 1;
            
            % Set counts for each time an option is chosen
            task.counts = zeros(4,1);
            
            % Initialise variable to hold actions and outcome, and random choices
            task.selected = zeros(task.ntrials,1);
            task.outcome = zeros(task.ntrials,1);
            task.random = zeros(task.ntrials,1);

            % Initialise variable to hold choice and RT for questions
            task.pain_pos = zeros(task.ntrials,1);
            task.pain_rt = zeros(task.ntrials,1);
            task.motiv_pos = zeros(task.ntrials,1);
            task.motiv_rt = zeros(task.ntrials,1);
            
            % Set trial number for first trial 
            task.curr_trial = 0;
            
            %%
            % determine which stimulus will be correct and when
            task.order = [0,0,0;
                          0,0,0;
                          0,0,0;];
            tmp = [1,2,3;
                   1,3,2;
                   2,1,3;
                   2,3,1;
                   3,1,2;
                   3,2,1];
            sums = sum(task.order);
            %sample until unique order is found
            while(sums(1)~= 6 || sums(2) ~= 6 || sums(3) ~= 6)
                rndIDX = randperm(6);
                task.order = tmp(rndIDX(1:3), :); 
                sums = sum(task.order);
            end
            
            %%
            %set possible outcomes for initial and reversal learning phases
            for i=1:3
               % determine rewards for each option
               out = [];
               probs = task.len*task.probs(i,:)/100;
               for ii=1:ceil((task.blocks(1)+task.blocks(2)+task.blocks(5))/task.len)
                   % get rewards that are true over length task.len                   
                   tmp = [];
                   
                   for iii=1:length(probs)
                       % repeat each reward the number of required times
                       tmp = [tmp, [repelem(task.rewards(iii), probs(iii))]];
                       tmp = Shuffle(tmp);
                   end

                   out = [out, tmp];
               end
               out = out.'; % converts from column to row
               task.learn(:,i) = out;
            end
            
            %%
            % set possible outcomes for dsc phase - THIS IS A REALLY
            % INEFFICIENT WAY TO DO THIS BUT IT WORKS
            
            % make temporay variable to hold descending probs
            tmp_p = zeros(3,2,3);
            tmp_p(:,:,1) = task.probs;
            tmp_p(:,:,2) = task.probs;
            tmp_p(1,:,2) = task.probs(2,:);
            tmp_p(1,:,3) = task.probs(3,:);
            tmp_p(2,:,3) = task.probs(3,:);
            tmp_p(3,:,3) = task.probs(3,:);
            
            for i=1:3
               % determine rewards for each option
               out = [];
               probs = task.len*tmp_p(i,:,1)/100;
               for ii=1:(8/task.len) % VALUE OF 8 IS HARD CODED BUT THIS COULD BE SOFT-CODED WITH REWORKING
                   % get rewards that are true over length task.len                   
                   tmp = [];
                   
                   for iii=1:length(probs)
                       % repeat each reward the number of required times
                       tmp = [tmp, [repelem(task.rewards(iii), probs(iii))]];
                       tmp = Shuffle(tmp);
                   end

                   out = [out, tmp];
               end
               out = out.'; % converts from column to row
               one(:,i) = out;
            end
            for i=1:3
               % determine rewards for each option
               out = [];
               probs = task.len*tmp_p(i,:,2)/100;
               for ii=1:(8/task.len) % VALUE OF 8 IS HARD CODED BUT THIS COULD BE SOFT-CODED WITH REWORKING
                   % get rewards that are true over length task.len                   
                   tmp = [];
                   
                   for iii=1:length(probs)
                       % repeat each reward the number of required times
                       tmp = [tmp, [repelem(task.rewards(iii), probs(iii))]];
                       tmp = Shuffle(tmp);
                   end

                   out = [out, tmp];
               end
               out = out.'; % converts from column to row
               two(:,i) = out;
            end
            for i=1:3
               % determine rewards for each option
               out = [];
               probs = task.len*tmp_p(i,:,3)/100;
               for ii=1:(8/task.len) % VALUE OF 8 IS HARD CODED BUT THIS COULD BE SOFT-CODED WITH REWORKING
                   % get rewards that are true over length task.len                   
                   tmp = [];
                   
                   for iii=1:length(probs)
                       % repeat each reward the number of required times
                       tmp = [tmp, [repelem(task.rewards(iii), probs(iii))]];
                       tmp = Shuffle(tmp);
                   end

                   out = [out, tmp];
               end
               out = out.'; % converts from column to row
               three(:,i) = out;
            end
            task.desc = cat(1,one,two,three);
        end       
    end
end
                
                
                
                
                
                
                
                
                
                