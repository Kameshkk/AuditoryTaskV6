function [tree, list] = configureAuditoryTaskV6(logic, avConfig, options)
% File for initializing the Auditory Task. This uses the AuditoryLogic
% and AuditoryAV templates which extend Ben's templates for Matt's Helicopter task. These
% templates are meant to collect common code for a broad range of
% predictive inference tasks.
%
% logic -- object that contains most of the mathematical settings and
% variables to store the state of the task
% avConf  -- object that contains the audio-visual settings and objects
% --Kamesh 25/10/12

sc=dotsTheScreen.theObject;
if(options.fullScreen && ~options.usingCRT)
    sc.reset('displayIndex', 1);
elseif(options.usingCRT)
    sc.reset('displayIndex', 2);
end

if nargin < 1 || isempty(logic)
    logic = AuditoryLogic6(options.randSeed);
    logic.blockStds = options.blockStds;
    logic.blockHazards = options.blockHazards;
    logic.trialsPerBlock = options.trialsPerBlock;
    logic.nBlocks = length(options.blockStds);
    logic.safetyTrials = options.safetyTrials;
    logic.sampleHazard = options.sampleHazard;
end

if nargin < 2 || isempty(avConfig)
    avConfig = AuditoryAV6();
    avConfig.logic = logic;
end


% Configuring inputs -- you might want to use the mouse by default
if nargin < 3 || isempty(options) || ~isstruct(options)
    options.isKeyboardTrigger = false;
    options.triggerKeyName = 'KeyboardT';
    options.triggerMaxWait = 5*60;
    options.isPositionMapping = false;
end

if ~isfield(options, 'keyboardKeys')
    options.keyboardKeys.left = 'KeyboardLeftArrow';
    options.keyboardKeys.right = 'KeyboardRightArrow';
    options.keyboardKeys.commit = 'KeyboardSpacebar';
    options.keyboardKeys.info = 'KeyboardI';
    options.keyboardKeys.abort = 'KeyboardQ';
end



% Configuring the eyetracker
if ~isfield(options, 'eyeTracker')
    % No Eye-tracking in this task
    options.eyeTracker.isEyeTracking = false;
end



% Data logging
topsDataLog.flushAllData();
t = topsDataLog.theDataLog;
t.fileWithPath = options.fileName;
% record some global info about the task
if(~(strcmp(options.taskType, 'trainNoFeedback') || ...
        strcmp(options.taskType, 'trainFeedback')))
    t.logDataInGroup(options.trialsPerBlock,'trialsPerBlock');
    t.logDataInGroup(options.blockStds,'blockStds');
    t.logDataInGroup(options.blockHazards,'blockHazards');
else
    t.logDataInGroup(options.trainIterations,'trainIterations');
end
t.logDataInGroup(options.hrir,'hrirNum');
t.logDataInGroup(options.subject,'subject');
t.logDataInGroup(options.taskType,'taskType');
t.logDataInGroup(options.session,'session');
t.logDataInGroup(options.randSeed,'randSeed');



%% TOPS containers for data and objects
list = topsGroupedList();
list{'logic'}{'object'} = logic;
list{'audio-visual'}{'object'} = avConfig;
list{'options'}{'struct'} = options;

%% -----------------------------INPUT------------------------------------
% Try to use a mouse and use a keyboard if not available.
usingMouse = options.usingMouse;

if usingMouse
    % These settings are very specific for the setup I'm using in the
    % psychophysics lab -- my laptop connected to the monitor and a
    % microsoft external mouse
    m = dotsReadableHIDMouse();
    
    
%     % -- don't search for lab specific mouse in development version
%         maxTrials = 50;
%         trials = 0;
%         while (~strcmp(m.deviceInfo.Manufacturer,'Microsoft') && trials < maxTrials)
%             m = dotsReadableHIDMouse();
%             trials = trials + 1;
%         end
%     
%         if(trials >= maxTrials)
%            disp('Could not find Microsoft mouse');
%         end
    m.isExclusive = 1;
    m.isAutoRead = 1;
    m.flushData;
    m.initialize();
    
    
    % undefine any default events
    IDs = m.getComponentIDs();
    for ii = 1:numel(IDs)
        m.undefineEvent(IDs(ii));
    end
    %Define a mouse button press event
    m.defineEvent(3, 'left', 0, 0, true);
    m.defineEvent(4, 'right', 0, 0, true);
    ui = m;
    getInput = @getMouseInput;
    %store the mouse separately in case we need to use it
    list{'input'}{'mouse'} = m;
    
else
    kb = dotsReadableHIDKeyboard();
    
    IDs = kb.getComponentIDs();
    for ii = 1:numel(IDs)
        kb.undefineEvent(IDs(ii));
    end
    isDown = strcmp({kb.components.name}, 'KeyboardDownArrow');
    downKey = kb.components(isDown);
    kb.defineEvent(downKey.ID,'pressed',0,0,true);
    isRight = strcmp({kb.components.name}, 'KeyboardRightArrow');
    rightKey = kb.components(isRight);
    kb.defineEvent(rightKey.ID,'right',0,0,true);
    isLeft = strcmp({kb.components.name}, 'KeyboardLeftArrow');
    leftKey = kb.components(isLeft);
    kb.defineEvent(leftKey.ID,'left',0,0,true);
    isUp = strcmp({kb.components.name}, 'KeyboardUpArrow');
    upKey = kb.components(isUp);
    kb.defineEvent(upKey.ID,'up',0,0,true);
    
    ui = kb;
    getInput = @getKbInput;
    %store the keyboard separately in case we need to use it
    list{'input'}{'keyboard'} = kb;
end


%DEBUG (for wager) -- testing only. Remove in psychophysics comp

kb = dotsReadableHIDKeyboard();
IDs = kb.getComponentIDs();
for ii = 1:numel(IDs)
    kb.undefineEvent(IDs(ii));
end
isDown = strcmp({kb.components.name}, 'KeyboardDownArrow');
downKey = kb.components(isDown);
kb.defineEvent(downKey.ID,'pressed',0,0,true);
isRight = strcmp({kb.components.name}, 'KeyboardRightArrow');
rightKey = kb.components(isRight);
kb.defineEvent(rightKey.ID,'right',0,0,true);
isLeft = strcmp({kb.components.name}, 'KeyboardLeftArrow');
leftKey = kb.components(isLeft);
kb.defineEvent(leftKey.ID,'left',0,0,true);
isUp = strcmp({kb.components.name}, 'KeyboardUpArrow');
upKey = kb.components(isUp);
kb.defineEvent(upKey.ID,'up',0,0,true);

%store the keyboard separately in case we need to use it
list{'input'}{'keyboard'} = kb;




avConfig.ui = ui;
list{'input'}{'controller'} = ui;
%list{'input'}{'mapping'} = uiMap;

%% Set up the eyetracker  -- THIS PART SEEMS OUTDATED!!

%no eye tracking in this task


%% Outline the structure of the exeriment with topsRunnable objects
% visualize the structure with tree.gui()
% run the experiment with tree.run()

% Define nodes of the topsTree tree->session->block->trial
% "tree" is the start point for the whole experiment
tree = topsTreeNode('open/close screen');
tree.iterations = 1;
tree.startFevalable = {@initialize, list};
tree.finishFevalable = {@terminate, list};

% "instructions" is a branch of the tree with an instructional slide show
instructions = topsTreeNode('instructions');
instructions.iterations = 1;
tree.addChild(instructions);

% "session" is a branch of the tree with the task itself
session = topsTreeNode('session');
session.iterations = logic.nBlocks;
session.startFevalable = {@startSession, logic};
session.finishFevalable = {@finishSession, logic};
tree.addChild(session);

% define a 'Block' node : child of session.
block = topsTreeNode('block');
block.iterations = logic.trialsPerBlock;
block.startFevalable = {@startBlock, list};
block.finishFevalable = {@finishBlock, list};
session.addChild(block);


% 'trial' node
% ConcurrentComposite is a collection of topsConcurrent objects which
% can run concurrently. 'trial' runs by running its children.
trial = topsConcurrentComposite('trial');
block.addChild(trial);
% StateMachine defines the flow control within a single trial
trialStates = topsStateMachine('trial states');
trial.addChild(trialStates);


%Store the 'tree' object in our topsList
list{'outline'}{'tree'} = tree;


%% Organize the flow through each trial
% The trial state machine will respond to user input commands
% and control timing.


switch options.taskType
    case 'fullTask'
        
        avConfig.taskType = 1;   %objects displayed depend on task type
        
        states = { ...
            'name'         'next'      'timeout'      'entry'                         'exit'                    'input'; ...
            'start'        'outcome'      0.1         {}                              {}                        {};...
            'outcome'      'estimate'     0           {@setupOutcome avConfig}        {@pause 0.5}              {}; ...
            'estimate'     'wager'        0           {}                              {}                        {getInput avConfig};...
            'wager'        'success'      0           {@setupWager avConfig}          {}                        {@getWager avConfig};...
            'success'      ''             0.5         {@doSuccess avConfig}           {}                        {}; ...
            };
        
        
    case 'estimateTask'
        
        avConfig.taskType = 2;
        states = { ...
            'name'         'next'      'timeout'      'entry'                         'exit'                    'input'; ...
            'start'        'outcome'      0.1           {}                              {}                         {};...
            'outcome'      'estimate'     0           {@setupOutcome avConfig}        {@pause 1.1}                        {}; ...
            'estimate'     'success'      0           {}                              {}                        {getInput avConfig};...
            'success'      ''             0.15           {@doSuccess avConfig}           {}                        {}; ...
            };
        
    case 'trainFeedback'
        avConfig.taskType = 4;
        logic.isChangePointTask = false;
        logic.nBlocks = options.trainIterations;
        session.iterations = logic.nBlocks;
        fixedOutcomes = zeros(logic.nBlocks, options.trialsPerBlock);
        aux = 0:15:180;
        for i1 = 1:logic.nBlocks
            idx = randperm(options.trialsPerBlock);
            fixedOutcomes(i1,:) = aux(idx);
        end
        fixedOutcomes = fixedOutcomes';
        logic.fixedOutcomes = fixedOutcomes(:);
        states = { ...
            'name'          'next'      'timeout'      'entry'                      'exit'                          'input'; ...
            'start'        'outcome'      0.3         {}                              {}                         {};...
            'outcome'       'estimate'    0           {@setupOutcome avConfig}      {@pause 1.1}                            {}; ...
            'estimate'      'success'     0           {}                            {}                            {getInput avConfig};...
            'success'       ''            0.6         {@doSuccess avConfig}         {}                            {}; ...
            };
        %@waitForUser avConfig  -- removed this from the initial state
    case 'trainNoFeedback'
        avConfig.taskType = 3;
        logic.nBlocks = options.trainIterations;
        session.iterations = logic.nBlocks;
        logic.isChangePointTask = false;
        fixedOutcomes = zeros(logic.nBlocks, options.trialsPerBlock);
        aux = 0:15:180;
        for i1 = 1:logic.nBlocks
            idx = randperm(options.trialsPerBlock);
            fixedOutcomes(i1,:) = aux(idx);
        end
        fixedOutcomes = fixedOutcomes';
        logic.fixedOutcomes = fixedOutcomes(:);
        states = { ...
            'name'          'next'      'timeout'      'entry'                      'exit'                          'input'; ...
            'start'        'outcome'      0.9           {}                              {}                         {};...
            'outcome'       'estimate'    0           {@setupOutcome avConfig}      {@pause 1.1}                            {}; ...
            'estimate'      ''            0           {}                            {}                            {getInput avConfig};...
            };
    otherwise
        error('Enter a valid task type');
end


trialStates.addMultipleStates(states);
trialStates.startFevalable = {@startTrial list};
trialStates.finishFevalable = {@finishTrial list};

avConfig.list = list;




%% Helper functions
function startTrial(list)
logic = list{'logic'}{'object'};
logic.startTrial();  %This will generate outcome for the trial

av = list{'audio-visual'}{'object'};
av.prepareSoundFile();  %load the sound file before trial begins

ui = list{'input'}{'controller'};
ui.flushData();

if(av.isEyeTracking)
    et = list{'input'}{'eye tracker'};
    et.flushData();
    av.pacedEtData = [];    %flush et data for prediction phase
end


function finishTrial(list)
logic = list{'logic'}{'object'};
logic.finishTrial();

function startBlock(list)
%Draw the background and wait for user to proceed
av = list{'audio-visual'}{'object'};
av.waitForBlockStart();

logic = list{'logic'}{'object'};
logic.startBlock();

function finishBlock(list)
%place holder for finish blcok function
av = list{'audio-visual'}{'object'};
logic = list{'logic'}{'object'};


function initialize(list)
%place holder for tree initialization
av = list{'audio-visual'}{'object'};
av.initialize();

function terminate(list)
%place holder for tree termination
av = list{'audio-visual'}{'object'};
av.terminate();
topsDataLog.writeDataFile();
opt = list{'options'}{'struct'};
fileName = opt.fileName;
data = topsDataLog.getSortedDataStruct;
save(fileName,'data','-append');
