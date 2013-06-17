

% This is an extension of the Auditory Task with the provisions for
% pupilometry measurements. This version of the task uses SnowDots ver 1.0
% and does not rely on the Psychophysics toolbox.

% Task types:
% 1- 'fullTask' - full task (predict, estimate, feedback)
% 2- 'estimateTask' - no prediction, just estimate, feedback (w/ CP structure)
% 3- 'trainNoFeedback' - meas. percp. accuracy w/o CP structure. No feedback
% 4- 'trainFeedback' - meas. percp. accuracy w/o CP structure. w/ feedback

% Typical order of doing these tasks:
% Day/Session 1 : subject does 4,2 & 1 (in that order)
% Day/Session 2 : subject does 3 & 1/2
% Day/Session 3 : subject does 3 & 2/1 (which was not done on Day2)

% -- Kamesh Krishnamurthy (kameshkk@gmail.com) U.Penn. 2012


clear classes; disp('clearing workspace!');

%preTaskScreen;

% CRT/Local screen and fullscreen/window
options.fullScreen = false;
options.usingCRT = false;

%HRIR number used for the subject Use the best HRIR for each subject
options.hrir = 1023;

%subject ID
options.subject = 'Subj0KK';

%task type & session number. Task type is variant of the task we are
%running on the subject
options.session = 'test';
options.taskType = 'fullTask';

%specify standard deviations for each block
%There will be one block for each std-dev.
stdevs = 10; %[10 20 10 20];
options.blockStds = stdevs(randperm(length(stdevs)));

%specify the hazard rate (one element for each block)
options.blockHazards = 0.2; %[0.15 0.15 0.15 0.15];

%sample hazard
options.sampleHazard = 0.15;

%how many trials before a change-point
options.safetyTrials = 0; %5

%How many trials per block?
if((strcmp(options.taskType, 'trainNoFeedback') || ...
        strcmp(options.taskType, 'trainFeedback')))
    %how many training iterations?
    options.trainIterations = 6;     % no. of iterations for likelihood meas.
    options.trialsPerBlock = 180/15; %Do not change this
else
    options.trialsPerBlock = 80;  %100 % for tasks w/ CP structure change this
end

%seed for the random number generator
%options.randSeed = 23232;
rng shuffle;
aux = rng;
options.randSeed = aux.Seed;
fprintf('Random number seed --> %d\n',aux.Seed);

% Mouse or keyboard
options.usingMouse = true;


%path to data log file
logPath = '~/Code/MATLAB/GoldLab/AuditoryTaskV6/Data/';
options.fileName = [logPath  options.subject ...
    options.session options.taskType '(' date() ').mat'];

if(length(options.blockStds) ~= length(options.blockHazards))
    error('blockStds and blockHazards must be of the same size');
end
[tree list] = configureAuditoryTaskV6([], [], options);
tree.run();

