classdef AuditoryAV6 < handle
    % Template for predictive inference task audio-visual behaviors.
    % TO DO : Include pupilometry settings.
    % --Kamesh 25/10/12
    
    properties
        
        % hrir ID picked
        hrirID = 1005;
        
        %which type of task is being run?
        % Task types:
        % 1- 'fullTask' - full task (predict, estimate, feedback)
        % 2- 'estimateTask' - no prediction, just estimate, feedback (w/ CP structure)
        % 3- 'trainNoFeedback' - meas. percp. accuracy w/o CP structure. No feedback
        % 4- 'trainFeedback' - meas. percp. accuracy w/o CP structure. w/ feedback
        taskType;
        
        % a PredInfLogic object to work with
        logic;
        
        % a gray color that might be described as "light"
        lightGray = [1 1 1]*0.25;
        
        % a gray color that might be described as "medium"
        mediumGray = [1 1 1]*0.5;
        
        % a gray color that might be described as "dark"
        darkGray = [1 1 1]*0;
        
        arcColor =  [0 128 64]*0.5; % bluish
        
        estColor = [1 0 0.6];
        
        predColor = [1 0.5625 0];
        
        outcomeColor = [1 0 0];
        
        %Colors for isoluminant checkerboard
        isoColor1 = [30 30 30];
        isoColor2 = [40 40 40];
        isoColor3 = [40 40 40]*1.12/255;
        isoColor4 = [40 40 40]*1.15/255;
        isoColor5 = [40 40 40]*1.4/255
        isoColor6 = [21 21 21]*1.2/255;
        
        % degrees visual angle width of fixation point
        fixationSize = 1;
        
        % limits for drawing the arc
        arcLeftLimit = 200;
        arcRightLimit = -20;
        %inner and outer diameter for the arc
        arcRInner = 2.5;
        arcROuter = 2.57;
        arcRPrevCues1 = 3.5;  %arc for displaying prev. pred., outcome, est.
        arcRPrevCues2 = 3.8;
        
        
        %estimate made by subject
        estimate;
        
        %prediction made by subject
        prediction;
        
        
        %For post-decision wagering
        wArc;  %arc for wager window
        wText; %text at the bottom indicating 'HIGH' or 'LOW' wager
        wArcInner = 2.3;
        wArcOuter = 2.45;
        
        % fontsize for angles on ticks. This is different from the default
        % text 'fontsize' property. Two choices for different screen sizes
        tickFontSize1 = 20;
        tickFontSize2 = 32;
        
        fontSize1 = 36;
        fontSize2 = 64;
        fontSize3 = 20;
        
        % diameter for drawable targets
        estSides = 3;
        predSides = 4;
        prevPredSides = 4;
        dotSides = 30;
        dotHeight = 0.3;
        dotWidth = 0.3;
        prevDotHeight = 0.3;
        prevDotWidth = 0.3;
        
        %checker board settings
        checkerH = 10;
        checkerW = 10;
        
        % should the task run fullscreen
        isFullScreen = false;
        
        %fixation box dimensions
        fixX = 3;
        fixY = 3;
        
        %path to the sound file
        dataPath  = ['Data/WavFiles/subj' num2str(1005) '/'];
        
        
        %data input device
        ui;
        
        % how long to let the subject sit idle
        tIdle = 30;
        
        % how long to indicate that its time to predict
        tPredict = 0;
        
        % how long to let the subject update predictions
        tUpdate = 30;
        
        % how long to indicate subject commitment
        tCommit = 1;
        
        % how long to indicate the trial outcome
        tOutcome = 1;
        
        % how long to indicate the trial "delta" error
        tDelta = 1;
        
        % how long to indicate trial success
        tSuccess = 1;
        
        % how long to indicate trial failure
        tFailure = 1;
        
        % width of the task area in degrees visual angle
        width = 30;
        
        % height of the task area in degrees visual angle
        height = 20;
        
        % a string instructing the subject to wait, please
        pleaseWaitString = 'Please wait.';
        
        % a string instructing the subject to press a button
        pleasePressString = 'Press when ready.';
        
        % font size for all texts
        fontSize = 24;
        
        
        %EYE TRACKING RELATED
        %ASL eye tracker object
        eyeTracker;
        isEyeTracking;
        pupilMeasFcn;   %function that record pupil dia. when the sound is playing
        
        %for self-paced fixation
        fixDuration;
        lastFixTime;
        pacedEtData;
        
        %tops classification object for fixation
        fixRegion;
        
        %auxiliary flag that keeps track of broken fixation during outcome
        %fixation
        isFixed;
        
        %tops groupedList object to access snowdots data structures
        list;
        
        %Is this a regular trial or a wager trial?
        isWagerTrial;
        
        %wager window size in degrees
        wagerWindowSize = 20;
        
        %low and high wager amoutns
        wagerLow = 5;
        wagerHigh = 15;
        
        %total score text
        scoreText;
        
        
        
    end
    
    
    properties(SetAccess = protected)
        
        % whether doing graphics remotely (true) or locally (false)
        isClient = false;
        
        %Have one ensemble which holds all drawables objects and
        %reference these objects by indexing into this ensemble.
        %Same idea for playables etc.
        
        % ensemble object for drawable objects
        drawables;
        
        %texture object for checkerboard texture
        checkTexture;
        
        %inter-block text string
        interBlockText;
        
        % fixation point (drawables index)
        fixation;
        
        % Arc (drawables index)
        arc;
        
        % Ticks (drawables index)
        ticks;
        
        % cursor indicating what the subject should do (drawables index)
        cursor;
        
        % estimator dot & line (drawables index) -- used to indicate posterior
        estimator;
        estLine;
        prevEstLine;
        prevEstText;
        
        % predictor dot & line (drawables index) -- used to indicate prior
        predictor;
        predLine;
        prevPredText;
        prevPredLine;
        prevPredText1;
        prevPredLine1;
        prevPredAngle;
        
        % center point (drawables index)
        center;
        
        %string which shows input angle
        angleText;
        
        
        % outcome dot (drawables index)  -- used to indicate actual outcome
        outcome;
        prevOutcomeLine;
        prevOutcomeText;
        
        
        % show last Nprev outcomes
        nPrev = 5;
        prevOutcomes = [];
        prevOutcomeTicks;
        rPrevOutTicks = 2.4; %Should be smaller than arcRInner
        
        
        
        %fixation window outline(drawables index)
        fixWindow;
        
        % ensemble object for playable objects
        playables;
        
        % sound to play with the trial outcome (playables index)
        outcomeSound;
        
        % display translation/centering related variables
        dispWidth;
        dispHeight;
        xShift;
        yShift;
        
        %are you predicting or estimating
        isPredicting;
        
        
        
        
        
    end
    
    methods
        
        %Constructor
        function self = AuditoryAV6(isClient)
            
            disp('--> constructor called');
            if nargin < 1 || isempty(isClient)
                isClient = false;
            end
            self.isClient = isClient;
            self.isEyeTracking = false;
            
            %Default text font size
            self.fontSize = 48;
            
            % ensemble for grouping drawables
            self.drawables = dotsEnsembleUtilities.makeEnsemble( ...
                'drawables', self.isClient);
            
            % ensemble for grouping playables
            self.playables = dotsEnsembleUtilities.makeEnsemble( ...
                'playables', self.isClient);
            
            % tell the ensemble how to open and close a window
            self.drawables.addCall({@dotsTheScreen.openWindow}, 'open');
            self.drawables.addCall({@dotsTheScreen.closeWindow}, 'close');
            % 'open' and 'close' won't run whenever the ensemble is run;
            % you need to invoke them explicitly
            self.drawables.setActiveByName(false, 'open');
            self.drawables.setActiveByName(false, 'close');
            
            
        end
        
        % Set up audio-visual resources as needed.
        function initialize(self)
            disp('Initializing->');
            
            % create a 'playables' object for the outcome
            self.playables = dotsPlayableFile();
            self.playables.isBlocking = 0;
            
            self.prevPredAngle = pi/2;
            
            
            %----------------- Drawables objects ----------------------
            %texture object
            checkTexture1 = dotsDrawableTextures();
            checkTexture1.textureMakerFevalable = {@kameshTextureMaker,...
                self.checkerH,self.checkerW,...
                [],[],self.isoColor1,self.isoColor2};
            
            
            self.checkTexture = self.drawables.addObject(checkTexture1);
            
            %Text for inter-block screen
            interBlockText1 = dotsDrawableText();
            interBlockText1.color = self.isoColor3;
            interBlockText1.fontSize = self.fontSize;
            interBlockText1.string = 'Proceed When Ready!';
            self.interBlockText =  self.drawables.addObject(interBlockText1);
            
            %strings for prediction and estimation angles
            angleText1 = dotsDrawableText();
            angleText1.color = self.isoColor3;
            angleText1.fontSize = self.fontSize1;
            angleText1.isBold = true;
            angleText1.string = '';
            angleText1.x = 0; angleText1.y = -0.5;
            self.angleText = self.drawables.addObject(angleText1);
            
            
            
            % fixation target
            fix = dotsDrawableTargets();
            fix.colors = self.mediumGray;
            fix.width = self.fixationSize;
            fix.height = self.fixationSize;
            self.fixation = self.drawables.addObject(fix);
            
            % estimator dot
            est = dotsDrawableTargets();
            est.nSides = self.estSides;
            est.width = self.dotWidth;
            est.height = self.dotHeight;
            %est.colors = self.estColor;
            est.colors =  self.isoColor3; %self.isoColor2*1.1/255.0;
            self.estimator = self.drawables.addObject(est);
            
            %estimator line
            estLine1 = dotsDrawableLines();
            estLine1.isSmooth = true;
            estLine1.pixelSize = 2;
            estLine1.xFrom = 0; estLine1.yFrom = 0;
            estLine1.colors = est.colors;
            self.estLine = self.drawables.addObject(estLine1);
            
            
            %DEBUG -- show previous quantities
            %previous estimate text
            prevEstText1 = dotsDrawableText();
            prevEstText1.color = self.isoColor3;
            prevEstText1.fontSize = self.fontSize3;
            prevEstText1.string = 'E';
            prevEstText1.isBold = true;
            prevEstText1.isVisible = false;
            prevEstText1.x = 0; prevEstText1.y = 0;
            self.prevEstText = self.drawables.addObject(prevEstText1);
            
            %previous estimate guide line
            prevEstLine1 = dotsDrawableLines();
            prevEstLine1.pixelSize = 3;
            prevEstLine1.isSmooth = true;
            prevEstLine1.xFrom = 0; prevEstLine1.yFrom = 0;
            prevEstLine1.colors = est.colors;
            prevEstLine1.isVisible = false;
            self.prevEstLine = self.drawables.addObject(prevEstLine1);
            
            % predictor dot
            pred = dotsDrawableTargets();
            pred.height = self.dotHeight;
            pred.width = self.dotWidth;
            pred.nSides = self.predSides;
            %pred.colors = self.predColor;
            pred.colors = self.isoColor3; %self.isoColor2*1.1/255.0;
            self.predictor = self.drawables.addObject(pred);
            
            %DEBUG -- showing previous quantities
            %previous prediction text 1
            prevPredText1 = dotsDrawableText();
            prevPredText1.color = self.isoColor4;
            prevPredText1.fontSize = self.fontSize3;
            prevPredText1.string = 'P';
            prevPredText1.isBold = true;
            prevPredText1.x = 0; prevPredText1.y = 0;
            self.prevPredText = self.drawables.addObject(prevPredText1);
            
            %previous prediction guide line 1
            prevPredLine1 = dotsDrawableLines();
            prevPredLine1.pixelSize = 3;
            prevPredLine1.isSmooth = true;
            prevPredLine1.xFrom = 0; prevPredLine1.yFrom = 0;
            prevPredLine1.colors = self.isoColor4;
            self.prevPredLine = self.drawables.addObject(prevPredLine1);
            
            %previous prediction text 2
            prevPredText1 = dotsDrawableText();
            prevPredText1.color = self.isoColor6;
            prevPredText1.fontSize = self.fontSize3;
            prevPredText1.string = 'P';
            prevPredText1.isBold = true;
            prevPredText1.x = 0; prevPredText1.y = 0;
            self.prevPredText1 = self.drawables.addObject(prevPredText1);
            
            %previous prediction guide line 2
            prevPredLine1 = dotsDrawableLines();
            prevPredLine1.pixelSize = 3;
            prevPredLine1.isSmooth = true;
            prevPredLine1.xFrom = 0; prevPredLine1.yFrom = 0;
            prevPredLine1.colors = self.isoColor6;
            self.prevPredLine1 = self.drawables.addObject(prevPredLine1);
            
            %predictor line
            predLine1 = dotsDrawableLines();
            predLine1.pixelSize = 2;
            predLine1.isSmooth = true;
            predLine1.xFrom = 0; predLine1.yFrom = 0;
            predLine1.colors = pred.colors;
            self.predLine = self.drawables.addObject(predLine1);
            
            % outcome dot
            outcom1 = dotsDrawableTargets();
            outcom1.nSides = self.dotSides;
            outcom1.height = self.dotHeight;
            outcom1.width = self.dotWidth;
            %outcom1.colors = self.outcomeColor;
            outcom1.colors = self.isoColor3; %self.isoColor2*1.1/255.0;
            self.outcome = self.drawables.addObject(outcom1);
            
            % previous outcome text
            prevOutcomeText1 = dotsDrawableText();
            prevOutcomeText1.color = self.isoColor6;
            prevOutcomeText1.fontSize = self.fontSize3;
            prevOutcomeText1.string = 'O';
            prevOutcomeText1.isBold = true;
            prevOutcomeText1.x = 0; prevOutcomeText1.y = -1.5;
            self.prevOutcomeText = self.drawables.addObject(prevOutcomeText1);
            
            % previous outcome guide line
            prevOutcomeLine1 = dotsDrawableLines();
            prevOutcomeLine1.pixelSize = 2;
            prevOutcomeLine1.isSmooth = true;
            prevOutcomeLine1.xFrom = 0; prevOutcomeLine1.yFrom = 0;
            prevOutcomeLine1.colors = self.isoColor6;
            self.prevOutcomeLine = self.drawables.addObject(prevOutcomeLine1);
            
            %fixation window outline
            fix1 = dotsDrawableLines();
            fix1.colors = self.isoColor2;
            fix1.x = [-self.fixX -self.fixX -self.fixX self.fixX self.fixX self.fixX...
                self.fixX -self.fixX];
            fix1.y = [-self.fixY self.fixY  self.fixY self.fixY self.fixY...
                -self.fixY -self.fixY -self.fixY];% + self.arcRInner/2; %vertical offset
            fix1.colors = self.isoColor2*1.1/255;
            fix1.isSmooth = true;
            fix1.isVisible = false;
            fix1.pixelSize = 3;
            self.fixWindow = self.drawables.addObject(fix1);
            
            
            
            %Post-decision wager stuff
            %wager window arc
            wArc1 = dotsDrawableArcs();
            wArc1.colors = self.isoColor3;
            wArc1.startAngle = 80;
            wArc1.sweepAngle = self.wagerWindowSize;
            wArc1.isSmooth = true;
            wArc1.nPieces = 30;
            wArc1.rInner = self.wArcInner;
            wArc1.rOuter = self.wArcOuter;
            self.wArc = self.drawables.addObject(wArc1);
            
            %wager text
            wText1 = dotsDrawableText();
            wText1.color = self.isoColor3;
            wText1.fontSize = self.fontSize1;
            wText1.isBold = true;
            wText1.string = '';
            wText1.x = 0; wText1.y = -0.5;
            self.wText = self.drawables.addObject(wText1);
            
            
            %Total score text
            sText1 = dotsDrawableText();
            sText1.color = self.isoColor3;
            sText1.fontSize = self.fontSize1;
            sText1.isBold = true;
            sText1.string = '';
            sText1.x = 0; sText1.y = -0.5;
            self.scoreText = self.drawables.addObject(sText1);
            
            %             % DEBUG (Kamesh) Showing sequence of previous outcomes
            %             aux1 = dotsDrawableLines();
            %             aux1.pixelSize = 4;
            %             aux1.isSmooth = true;
            %             aux1.colors = self.isoColor4;
            %             xFrom = zeros(self.nPrev,1); xTo = xFrom;
            %             yFrom = zeros(self.nPrev,1); yTo = yFrom;
            %             self.prevOutcomeTicks;
            %             for i1 = 1:self.nPrev
            %                 self.prevOutcomes(end+1) = 90 + 5*randn;
            %
            %             end
            
            
            %Arc and ticks
            arc1 = dotsDrawableArcs();
            %arc1.colors = self.arcColor;
            arc1.colors = self.isoColor3; %self.isoColor2*1.1/255.0;
            arc1.startAngle = self.arcRightLimit;
            arc1.sweepAngle = self.arcLeftLimit - self.arcRightLimit;
            arc1.isSmooth = true;
            arc1.nPieces = 100;
            arc1.rInner = self.arcRInner;
            arc1.rOuter = self.arcROuter;
            self.arc = self.drawables.addObject(arc1);
            
            ticks1 = dotsDrawableLines();
            ticks1.pixelSize = 3;
            ticks1.isSmooth = true;
            ticks1.colors = arc1.colors;
            nTicks = 23;
            step = (self.arcLeftLimit - self.arcRightLimit)/(nTicks-1);
            rDot = (arc1.rInner+arc1.rOuter)/2;
            xTo = zeros(1,nTicks); xFrom = xTo;
            yFrom = zeros(1,nTicks); yTo = yFrom;
            for i1 = 1:nTicks
                xFrom(i1) = rDot*cos(((i1-1)*step+self.arcRightLimit)*pi/180);
                yFrom(i1) = rDot*sin(((i1-1)*step+self.arcRightLimit)*pi/180);
                if(mod(i1-1,2)==0)
                    xTo(i1) = (rDot+0.4)*cos(((i1-1)*step+self.arcRightLimit)*pi/180);
                    yTo(i1) = (rDot+0.4)*sin(((i1-1)*step+self.arcRightLimit)*pi/180);
                else
                    xTo(i1) = (rDot+0.2)*cos(((i1-1)*step+self.arcRightLimit)*pi/180);
                    yTo(i1) = (rDot+0.2)*sin(((i1-1)*step+self.arcRightLimit)*pi/180);
                end
            end
            ticks1.xTo = xTo; ticks1.xFrom = xFrom;
            ticks1.yTo = yTo; ticks1.yFrom = yFrom;
            self.ticks = self.drawables.addObject(ticks1);
            
            %Cursor
            curs = dotsDrawableTargets();
            curs.yCenter = 0.1*self.height;
            curs.colors = self.mediumGray;
            curs.width = self.fixationSize/2;
            curs.height = self.fixationSize/2;
            self.cursor = self.drawables.addObject(curs);
            
            
            
            % automate the task of drawing task graphics
            %[self.fixation, self.cursor, ...
            inds = [ self.checkTexture, self.predictor, self.outcome, ...
                self.arc, self.estimator, ...
                self.ticks, self.estLine, self.predLine, self.fixWindow, ...
                self.angleText];
            
            %For post-decision wager
            inds = [inds, self.wArc, self.wText];
            
            %include previous estimate
            inds = [inds, self.prevEstLine, self.prevEstText];
            
            
            self.drawables.automateObjectMethod( ...
                'drawTask', @dotsDrawable.drawFrame, {}, inds, ...
                true);
            
            
            % open a drawing window and let objects react to it
            self.drawables.callByName('open');
            self.drawables.callObjectMethod(@prepareToDrawInWindow);
            
        end
        
        % Clean up audio-visual resources as needed.
        function terminate(self)
            self.drawables.callByName('close');
        end
        
        % Return concurrent objects, like ensembles, if any.
        function concurrents = getConcurrents(self)
            % TO CHECK -- where is this used? (Kamesh)
            concurrents = {self.drawables, self.playables};
        end
        
        
        
        
        % ------- state transition functions will be rewritten for the
        %-------- Auditory task (Kamesh)
        
        % Here's a description:
        % setupPrediction : function that sets up the screen for the prediction
        %                   task
        % setupOutcome : function that prepares the playable object and sets up the
        %                screen for outcome
        % doOutcome : play the sound file
        % setupEstimate : set up the screen for estimation
        % updateEstimate : function that records the subject's latest estimate
        % doSuccess : will show prediction, estimation and outcome
        % getInput will update the prediciton/estimation
        
        function setupPrediction(self)
            
            %Put this outside the IF statement for bookkeeping
            self.isPredicting = true;
            
            %make the sound blocking
            playables = self.playables;
            playables.isBlocking = 0;
            
            %hide the text strings
            angleText = self.drawables.getObject(self.angleText);
            angleText.isVisible = false;
            
            % hide the estimator
            est = self.drawables.getObject(self.estimator);
            estLine = self.drawables.getObject(self.estLine);
            est.isVisible = false;
            estLine.isVisible = false;
            
            %hide outcome
            out = self.drawables.getObject(self.outcome);
            out.isVisible = false;
            
            %Show the outcome cues
            prevOutText = self.drawables.getObject(self.prevOutcomeText);
            prevOutLine = self.drawables.getObject(self.prevOutcomeLine);
            prevOutLine.isVisible = true;
            prevOutText.isVisible = true;
            
            
            % center the predictor
            pred = self.drawables.getObject(self.predictor);
            predLine = self.drawables.getObject(self.predLine);
            pred.isVisible = true;
            predLine.isVisible = true;
            pred.xCenter = 0;
            pred.yCenter = 0;
            predLine.xTo = pred.xCenter;
            predLine.yTo = pred.yCenter;
            
            
            %                 % keep the predictor at the previous prediction
            %                 prevPredLine1 = self.drawables.getObject(self.prevPredLine1);
            %                 pred = self.drawables.getObject(self.predictor);
            %                 predLine = self.drawables.getObject(self.predLine);
            %                 pred.isVisible = true;
            %                 predLine.isVisible = true;
            %                 pred.xCenter = prevPredLine1.xFrom;
            %                 pred.yCenter = prevPredLine1.yFrom;
            %                 predLine.xTo = pred.xCenter;
            %                 predLine.yTo = pred.yCenter;
            
            
            self.drawables.callByName('drawTask');
            self.drawables.getObject(self.checkTexture);
            
            
        end
        
        %for post-decision wager
        function setupWager(self)
            
            if(self.logic.isWagerTrial)
                
                % hide the predictor
                pred = self.drawables.getObject(self.predictor);
                predLine = self.drawables.getObject(self.predLine);
                pred.isVisible = false;
                predLine.isVisible = false;
                
                %hide outcome
                out = self.drawables.getObject(self.outcome);
                outcome = self.logic.getCurrentOutcome();
                rDot = (self.arcRInner + self.arcROuter)/2;
                out.xCenter = rDot*cos(outcome*pi/180);
                out.yCenter = rDot*sin(outcome*pi/180);
                out.isVisible = false;
                
                %hide the angle text strings
                angleText = self.drawables.getObject(self.angleText);
                angleText.isVisible = false;
                
                %show the wager arc
                wArc = self.drawables.getObject(self.wArc);
                if(self.arcRightLimit > self.estimate - self.wagerWindowSize/2)
                   wArc.startAngle = self.arcRightLimit;
                   wArc.sweepAngle = self.estimate+self.wagerWindowSize/2 ...
                                      - self.arcRightLimit;
                elseif(self.arcLeftLimit < self.estimate + self.wagerWindowSize/2)
                    wArc.startAngle = self.estimate - self.wagerWindowSize/2;
                    wArc.sweepAngle = self.arcLeftLimit - ...
                                      (self.estimate - self.wagerWindowSize/2);
                else
                    wArc.startAngle = self.estimate - self.wagerWindowSize/2;
                    wArc.sweepAngle = self.wagerWindowSize;
                end
                wArc.isVisible = true;
                
                %show the wager text strings
                wText = self.drawables.getObject(self.wText);
                wText.string = 'wager';
                wText.isVisible = true;
                
                %Show estimate guide line
                prevEstText = self.drawables.getObject(self.prevEstText);
                prevEstLine = self.drawables.getObject(self.prevEstLine);
                prevEstLine.isVisible = true;
                prevEstText.isVisible = true;
                
                self.drawables.callByName('drawTask');
                
            end
        end
        
        
        
        
        function setupOutcome(self)
            % hide the predictor
            pred = self.drawables.getObject(self.predictor);
            predLine = self.drawables.getObject(self.predLine);
            pred.isVisible = false;
            predLine.isVisible = false;
            
            %hide outcome
            out = self.drawables.getObject(self.outcome);
            outcome = self.logic.getCurrentOutcome();
            rDot = (self.arcRInner + self.arcROuter)/2;
            out.xCenter = rDot*cos(outcome*pi/180);
            out.yCenter = rDot*sin(outcome*pi/180);
            out.isVisible = false;
            
            
            %hide the text strings
            angleText = self.drawables.getObject(self.angleText);
            angleText.isVisible = false;
            
            %post-decision wager stuff
            %hide the wager string
            wText = self.drawables.getObject(self.wText);
            wText.isVisible = false;
            %hide the wager arc
            wArc = self.drawables.getObject(self.wArc);
            wArc.isVisible = false;
            
            
            %hide the outcome cues
            rCue = self.arcRPrevCues2*1.1;
            prevOutText = self.drawables.getObject(self.prevOutcomeText);
            prevOutLine = self.drawables.getObject(self.prevOutcomeLine);
            prevOutText.x = rCue*cos(outcome*pi/180);
            prevOutText.y = rCue*sin(outcome*pi/180);
            prevOutText.rotation = outcome - 90;
            prevOutLine.xFrom = rDot*cos(outcome*pi/180);
            prevOutLine.xTo = 0.9*rCue*cos(outcome*pi/180);
            prevOutLine.yFrom = rDot*sin(outcome*pi/180);
            prevOutLine.yTo = 0.9*rCue*sin(outcome*pi/180);
            prevOutLine.isVisible = false;
            prevOutText.isVisible = false;
            
            %hide the estimator guide lines
            prevEstText = self.drawables.getObject(self.prevEstText);
            prevEstLine = self.drawables.getObject(self.prevEstLine);
            prevEstLine.isVisible = false;
            prevEstText.isVisible = false;
            
            %center the estimator
            est = self.drawables.getObject(self.estimator);
            estLine = self.drawables.getObject(self.estLine);
            est.isVisible = true;
            estLine.isVisible = true;
            est.xCenter = 0;
            est.yCenter = 0;
            estLine.xTo = est.xCenter;
            estLine.yTo = est.yCenter;
            
            self.drawables.callByName('drawTask');
            
            % DEBUG -- try to play the sound file while entering the state
            % ********* this is to account for audioplayer latency
            self.isPredicting = false;
            playables = self.playables;
            %DEBUG
            topsDataLog.logDataInGroup(topsClock(), 'debugEnterOutcome');
            %log the outcome at the right time(just before playing)
            topsDataLog.logDataInGroup(self.logic.getCurrentOutcome(),...
                'outcome');
            playables.play();
            %DEBUG
            topsDataLog.logDataInGroup(topsClock(), 'debugLeaveOutcome');
        end
        
        
        function prepareSoundFile(self)
            
            %prepare the soundfile
            outcome = self.logic.getCurrentOutcome();
            playables = self.playables;
            auxOutcome = mod(outcome+270,360);
            fileName = [self.dataPath 'subj' num2str(self.hrirID) ...
                '_az' num2str(auxOutcome) '_v1.wav'];
            %fileName = 'test.wav';
            playables.fileName = fileName;
            playables.prepareToPlay();
            
        end
        
        % ****** NOT USING THIS DUE TO AUDIOPLAYER LATENCY c.f. NOTES
        %         function doOutcome(self)
        %             %play the file
        %             self.isPredicting = false;
        %             %pause(0.35);  -- use delays in stateMachine
        %             playables = self.playables;
        %             if(self.isEyeTracking)
        %                 playables.player.TimerFcn = self.pupilMeasFcn;
        %                 playables.player.TimerPeriod = 1/120;  %use the same sample rate as ET
        %             end
        %             %log the outcome at the right time(just before playing)
        %             topsDataLog.logDataInGroup(self.logic.getCurrentOutcome(),...
        %                 'outcome');
        %             % DEBUG --
        %             topsDataLog.logDataInGroup(topsClock(), 'debugEnterOutcome');
        %
        %             playables.play();
        %             % DEBUG --
        %             topsDataLog.logDataInGroup(topsClock(), 'debugLeaveOutcome');
        %         end
        
        
        
        
        
        function doSuccess(self)
            
            if(self.logic.isWagerTrial)
                %reveal the wager arc
                wArc = self.drawables.getObject(self.wArc);
                wArc.isVisible = true;
                
                %reveal total score text
                sText = self.drawables.getObject(self.scoreText);
                sText.isVisible = true;
                
                %hide the wager text
                wText = self.drawables.getObject(self.wText);
                wText.isVisible = false;
            end
            
            %reveal outcome
            out = self.drawables.getObject(self.outcome);
            out.isVisible = true;
            
            %reveal outcome cues
            prevOutText = self.drawables.getObject(self.prevOutcomeText);
            prevOutLine = self.drawables.getObject(self.prevOutcomeLine);
            prevOutLine.isVisible = true;
            prevOutText.isVisible = true;
            prevEstText = self.drawables.getObject(self.prevEstText);
            prevEstLine = self.drawables.getObject(self.prevEstLine);
            prevEstLine.isVisible = true;
            prevEstText.isVisible = true;
            
            %self.drawables.callByName('drawTask');
            s = dotsTheScreen.theObject;
            
            %texture
            tx = self.drawables.getObject(self.checkTexture);
            tx.draw;
            
            arc = self.drawables.getObject(self.arc);
            ticks = self.drawables.getObject(self.ticks);
            ticks.draw; arc.draw;
            if(self.taskType == 1)
                %pred.draw; predLine.draw;
            end
            
            out.draw;
            
            if(self.logic.isWagerTrial)
                wArc.draw; sText.draw;
            end
            %angleText.draw; %outcomeText.draw;
            
            %DEBUG -- show previous quantities
            prevOutText.draw();
            prevOutLine.draw();
            prevEstLine.draw();
            prevEstText.draw();
            s.nextFrame();
            
            
            
        end
        
        %Read input from the mouse
        function state = getMouseInput(self)
            
            %reveal the angle text string
            angleText = self.drawables.getObject(self.angleText);
            angleText.isVisible = true;
            
            %texture
            tx = self.drawables.getObject(self.checkTexture);
            
            m = self.ui;
            m.flushData;
            s = dotsTheScreen.theObject;
            arc = self.drawables.getObject(self.arc);
            rDot = (arc.rInner+arc.rOuter)/2;
            
            %DEBUG -- show previous quantities
            prevOutText = self.drawables.getObject(self.prevOutcomeText);
            prevOutLine = self.drawables.getObject(self.prevOutcomeLine);
            prevOutLine.isVisible = false;
            prevOutText.isVisible = false;
            prevEstText = self.drawables.getObject(self.prevEstText);
            prevEstLine = self.drawables.getObject(self.prevEstLine);
            
            if(self.isPredicting)
                %no prediction here
                
            else
                %DEBUG -- show the guide lines
                rCue = self.arcRPrevCues2;
                cueText = self.drawables.getObject(self.prevEstText);
                cueText.isVisible = true;
                cueLine = self.drawables.getObject(self.prevEstLine);
                cueLine.isVisible = true;
                prevOutLine.isVisible = false;
                prevOutText.isVisible = false;
                
                dot = self.drawables.getObject(self.estimator);
                l = self.drawables.getObject(self.estLine);
            end
            ticks = self.drawables.getObject(self.ticks);
            scaleFac = s.pixelsPerDegree;
            mXprev = m.x/scaleFac;
            mYprev = m.y/scaleFac;
            sensitivityFac =   0.6*0.9; %1.5*0.9; -- might want to lower this for motor error
            %theta = self.prevPredAngle; %start the pointer at the previous
            %predition ?
            theta = pi/2;
            state = [];
            while(isempty(state))
                m.read();
                state = m.getNextEvent();
                mXcurr = m.x/scaleFac; mYcurr = -m.y/scaleFac;
                dTheta = sensitivityFac*[mXcurr-mXprev mYcurr-mYprev]*...
                    [-dot.yCenter dot.xCenter]'/(rDot^2);
                %[ theta dTheta mXcurr mYcurr m.isAvailable]
                if(theta + dTheta >= (self.arcRightLimit*pi/180) && ...
                        theta + dTheta <= (self.arcLeftLimit*pi/180))
                    theta = theta + dTheta;
                end
                
                %update the angleText
                angleText.string =  sprintf('%3.0f',theta*180/pi);
                dot.xCenter = rDot*cos(theta);
                dot.yCenter = rDot*sin(theta);
                l.xTo = dot.xCenter;
                l.yTo = dot.yCenter;
                
                %DEBUG -- show previous quantities
                %update the cue text and line
                cueText.x = rCue*cos(theta);
                cueText.y = rCue*sin(theta);
                cueText.rotation = 1*theta*180/pi - 90;
                cueLine.xFrom = rDot*cos(theta);
                cueLine.xTo = 0.9*rCue*cos(theta);
                cueLine.yFrom = rDot*sin(theta);
                cueLine.yTo = 0.9*rCue*sin(theta);
                
                %texture
                tx.draw;
                
                ticks.draw; arc.draw; dot.draw; l.draw; angleText.draw;
                
                s.nextFrame();
                mXprev = mXcurr;
                mYprev = mYcurr;
            end
            
            
            %log data
            if(self.isPredicting)
                topsDataLog.logDataInGroup(theta,'prediction');
                self.prediction = theta*180/pi;
                
            else
                topsDataLog.logDataInGroup(theta,'percept');
                self.estimate = theta*180/pi;
                % TO REMOVE (this is done in logETData) record good trial -- doing it here instead of 'doSuccess'
                %topsDataLog.logDataInGroup(1,'isFixedTrial');
            end
            
        end
        
        %Read input from keyboard
        function state  = getKbInput(self)
            
            %texture
            tx = self.drawables.getObject(self.checkTexture);
            
            kb = self.ui;
            kb.flushData;
            s = dotsTheScreen.theObject;
            arc = self.drawables.getObject(self.arc);
            rDot = (arc.rInner+arc.rOuter)/2;
            if(self.isPredicting)
                dot = self.drawables.getObject(self.predictor);
                l = self.drawables.getObject(self.predLine);
            else
                dot = self.drawables.getObject(self.estimator);
                l = self.drawables.getObject(self.estLine);
            end
            tick = self.drawables.getObject(self.ticks);
            scaleFac = s.pixelsPerDegree;
            thetaStep = 2e-2;
            kb.read();
            state = kb.getNextEvent();
            while(isempty(state))
                kb.read();state = kb.getNextEvent();
            end
            theta = pi/2;
            if(strcmp(state,'right'))
                theta = 0;
                dot.xCenter = rDot*cos(theta);
                dot.yCenter = rDot*sin(theta);
                l.xTo = dot.xCenter;
                l.yTo = dot.yCenter;
                
                %texture
                tx.draw;
                
                tick.draw;arc.draw; dot.draw; l.draw;
                s.nextFrame();
            elseif(strcmp(state,'left'))
                theta = pi;
                dot.xCenter = rDot*cos(theta);
                dot.yCenter = rDot*sin(theta);
                l.xTo = dot.xCenter;
                l.yTo = dot.yCenter;
                
                %texture
                tx.draw;
                
                tick.draw;arc.draw; dot.draw; l.draw;
                s.nextFrame();
            elseif(strcmp(state,'up'))
                theta = pi/2;
                dot.xCenter = rDot*cos(theta);
                dot.yCenter = rDot*sin(theta);
                l.xTo = dot.xCenter;
                l.yTo = dot.yCenter;
                
                %texture
                tx.draw;
                
                tick.draw;arc.draw; dot.draw; l.draw;
                s.nextFrame();
            end
            while(~strcmp(state,'pressed'))
                kb.read();
                state=kb.getNextEvent();
                if(strcmp(state,'right') || ...
                        dotsReadableHIDKeyboard.isEventHappening(kb,'right'))
                    if(theta - thetaStep >= 0 && theta - thetaStep <= pi)
                        theta = theta - thetaStep;
                        dot.xCenter = rDot*cos(theta);
                        dot.yCenter = rDot*sin(theta);
                        l.xTo = dot.xCenter;
                        l.yTo = dot.yCenter;
                        
                        %texture
                        tx.draw;
                        
                        tick.draw;arc.draw; dot.draw; l.draw;
                        s.nextFrame();
                    end
                elseif(strcmp(state,'left') || ...
                        dotsReadableHIDKeyboard.isEventHappening(kb,'left'))
                    if(theta + thetaStep >= 0 && theta + thetaStep <= pi)
                        theta = theta + thetaStep;
                        dot.xCenter = rDot*cos(theta);
                        dot.yCenter = rDot*sin(theta);
                        l.xTo = dot.xCenter;
                        l.yTo = dot.yCenter;
                        
                        %texture
                        tx.draw;
                        
                        tick.draw;arc.draw; dot.draw; l.draw;
                        s.nextFrame();
                    end
                end
            end
            
            %log data
            if(self.isPredicting)
                topsDataLog.logDataInGroup(theta,'prediction');
            else
                topsDataLog.logDataInGroup(theta,'percept');
                % TO REMOVE (this is done in logETData) record good trial -- doing it here instead of 'doSuccess'
                %topsDataLog.logDataInGroup(1,'isFixedTrial');
            end
        end
        
        % wait for the user to press some relevant key
        function state = waitForUser(self)
            ui = self.ui;
            ui.flushData;
            state = '';
            while(isempty(state))
                ui.read();
                state = ui.getNextEvent();
            end
        end
        
        
        %This is for post-decision wager -- get high or low wager
        %(TO BE CHANGED):
        % I want to implement this with mouse right & left clicks
        % but dotsReadableHIDMouse only detects one button in my Mac
        % trackpad. So I'm doing this with the keyboard for now, but we
        % should use the mouse in the psychophysics computer.
        
        function state = getWager(self)
            
            if(self.logic.isWagerTrial)
                
                %reveal the wager text string
                wText = self.drawables.getObject(self.wText);
                wText.isVisible = true;
                %wText.string = 'enter wager'; %Done earlier in setupWager
                
                %reveal the wager windo
                wArc = self.drawables.getObject(self.wArc);
                wArc.isVisible = true;
                
                %Estimate made by subject
                prevEstText = self.drawables.getObject(self.prevEstText);
                prevEstLine = self.drawables.getObject(self.prevEstLine);
                prevEstLine.isVisible = true;
                prevEstText.isVisible = true;
                
                %Update the score for this wager inside this function
                score = self.logic.blockScore;
                outcome = self.logic.getCurrentOutcome();
                wagerWindow = self.wagerWindowSize/2;
                winWager = (outcome - wagerWindow <= self.estimate) && ...
                             (self.estimate <= outcome + wagerWindow);
                
                %ticks
                ticks = self.drawables.getObject(self.ticks);
                
                %texture
                tx = self.drawables.getObject(self.checkTexture);
                
                
                kb = self.list{'input'}{'keyboard'};
                kb.flushData;
                s = dotsTheScreen.theObject;
                arc = self.drawables.getObject(self.arc);
                rDot = (arc.rInner+arc.rOuter)/2;
                
                state ='';
                
                while(~(strcmp(state,'left') || strcmp(state,'right')))
                    kb.read();
                    state = kb.getNextEvent();
                    
                    if(strcmp(state,'right') || ...
                            dotsReadableHIDKeyboard.isEventHappening(kb,'right'))
                        %Wager high
                        wText.string = 'HIGH';
                        %log the wager
                        topsDataLog.logDataInGroup(1,'wager');
                        %update score
                        if(winWager)
                            score = score + self.wagerHigh;
                        else
                            score = score - self.wagerHigh;
                        end
                    elseif(strcmp(state,'left') || ...
                            dotsReadableHIDKeyboard.isEventHappening(kb,'left'))
                        %Wager Low
                        wText.string = 'LOW';
                        %log the wager
                        topsDataLog.logDataInGroup(0,'wager');
                        %update score
                        if(winWager)
                            score = score + self.wagerLow;
                        else
                            score = score - self.wagerLow;
                        end
                    end
                    
                    %update the score text and the total score
                    self.logic.blockScore = score;
                    sText = self.drawables.getObject(self.scoreText);
                    sText.string = num2str(score);
                    
                    tx.draw;
                    ticks.draw; arc.draw; wText.draw;
                    wArc.draw;
                    prevEstText.draw; prevEstLine.draw;
                    s.nextFrame();
                end
                
                tx.draw;
                ticks.draw; arc.draw; wText.draw;
                wArc.draw;
                prevEstText.draw; prevEstLine.draw;
                s.nextFrame();
                
            else
                state = '';
            end
        end
        
        
        % Give a message to the subject.
        function doMessage(self, message)
            disp('doMessage->');
            if nargin > 1
                disp(message);
            end
        end
        
        
        %Indicate failure trial
        function doFailure(self)
            disp('Failure trial!');
            
            %hide the fixation window;
            fixWindow = self.drawables.getObject(self.fixWindow);
            fixWindow.isVisible = false;
            self.drawables.callByName('drawTask');
            
            pause(0.7);
            aux = wavread('failure.wav');
            sound(aux);
            
            %make the subject repeat the failed outcome
            self.logic.fixedOutcomeIndex =  self.logic.fixedOutcomeIndex-1;
            self.logic.blockCompletedTrials = self.logic.blockCompletedTrials - 1;
            self.logic.blockTotalTrials = self.logic.blockTotalTrials - 1;
            
            %need to do this so that the 'block' tree node runs its child
            %'trial' the correct number of times
            tree = self.list{'outline'}{'tree'};
            n = tree.children{2}.children{1}.iterations;  %rhs is block.iterations
            tree.children{2}.children{1}.iterations = n+1;
            %fprintf('block iteration %d\n',tree.children{2}.children{1}.iterationCount);
            
            %TO REMOVE -- don't do this here. We record this in logETData
            %topsDataLog.logDataInGroup(0,'isFixedTrial');
            
        end
        
        
        %Draws the interblock screen and waits for user to proceed
        function waitForBlockStart(self)
            %texture
            tx = self.drawables.getObject(self.checkTexture);
            %text
            ibText = self.drawables.getObject(self.interBlockText);
            ibText.isVisible = true;
            s = dotsTheScreen.theObject;
            tx.draw; ibText.draw;
            s.nextFrame();
            ui = self.ui;
            ui.flushData;
            state = '';
            while(isempty(state))
                ui.read();
                state = ui.getNextEvent();
            end
            ibText.isVisible = false;
        end
        
        
        %EYE TRACKING
        %set up the fixation window and the classification region
        function doEyeTracking(self, et)
            self.isEyeTracking = true;
            self.eyeTracker = et;
            
            %tops classification region
            fix = topsClassification('fixation check');
            nPoints = 100;
            %arguments 3,4 : min & max x(y) values
            fix.addSource('x',@()(et.getValue(1)), -18, 18, nPoints);
            fix.addSource('y',@()(et.getValue(2)), -18, 18, nPoints);
            bl = topsRegion('fixation window1', fix.space);
            %bl = bl.setRectangle('x', 'y', [-4.5 -4.5 9 9] , 'out');
            bl = bl.setRectangle('x', 'y', [-10 -10 20 20] , 'in');
            b2 = topsRegion('fixation window2', fix.space);
            b2 = b2.setRectangle('x', 'y', [-10 -10 20 20] , 'out');
            fix.addOutput(bl.name, bl, 1);
            fix.addOutput(b2.name, b2, 0);
            self.fixRegion = fix;
            
            % DO NOT USE THE TIMERFCN -- latency issues w/ audioplayer
            %include callback function in the playables object
            %TIMERFCN
            %self.pupilMeasFcn = @(varargin)(pupilMeasDuringSound(fix,self,...
            %    varargin));
            
        end
        
        %set up display for fixation
        function setupFixation(self)
            
            % DEBUG -- how long does this take?
            %topsDataLog.logDataInGroup(topsClock(), 'debugEnterFixation');
            
            %DEBUG -- flush the et history and buffer before every fixation
            %this is important for accurate ET data loggin!!!
            self.eyeTracker.flushData;
            
            %this is for 'checkPacedFixation'
            self.fixDuration = 0;
            
            %set the isFixed flag to true; it will be flipped if fixation
            %is broken
            self.isFixed = true;
            
            %hide the text strings
            angleText = self.drawables.getObject(self.angleText);
            angleText.isVisible = false;
            outcomeText = self.drawables.getObject(self.outcomeText);
            outcomeText.isVisible = false;
            
            %reveal the fixation window;
            fixWindow = self.drawables.getObject(self.fixWindow);
            fixWindow.isVisible = true;
            fixWindow.colors = self.isoColor2*1.1/255;
            
            % hide the predictor
            pred = self.drawables.getObject(self.predictor);
            predLine = self.drawables.getObject(self.predLine);
            pred.isVisible = false;
            predLine.isVisible = false;
            
            %hide outcome
            out = self.drawables.getObject(self.outcome);
            outcome = self.logic.getCurrentOutcome();
            rDot = (self.arcRInner + self.arcROuter)/2;
            out.xCenter = rDot*cos(outcome*pi/180);
            out.yCenter = rDot*sin(outcome*pi/180);
            out.isVisible = false;
            
            
            %center the estimator
            est = self.drawables.getObject(self.estimator);
            estLine = self.drawables.getObject(self.estLine);
            est.isVisible = true;
            estLine.isVisible = true;
            est.xCenter = 0;
            est.yCenter = 0; %self.arcRInner/2;
            estLine.xTo = est.xCenter;
            estLine.yTo = est.yCenter;
            
            self.drawables.callByName('drawTask');
            
            % DEBUG -- how long does this take?
            %topsDataLog.logDataInGroup(topsClock(), 'debugLeaveFixation');
            
        end
        
        %function that checks self-paced fixation
        function state =  checkPacedFixation(self)
            auxTime = topsClock;
            fixR = self.fixRegion;
            
            %DEBUG -- don't log data from getValue()
            %reset container for self-paced ET data
            %self.pacedEtData = [];
            %etTimes = [];
            
            %make self-paced fixation time 0.5 seconds
            while(fixR.getOutput() &&  self.fixDuration < 0.5 )
                t = topsClock;
                self.fixDuration = (t - auxTime);
                %DEBUG -- don't log data from getValue()
                %self.pacedEtData(end+1) = self.eyeTracker.getValue(3);
                %etTimes(end+1) = t;
            end
            
            % proceed to outcome if fixated for more than 500 ms(in while
            % loop above)
            if(self.fixDuration > 0.5)
                hist = self.eyeTracker.history;
                timedFrames = self.eyeTracker.timedFrames;
                topsDataLog.logDataInGroup({hist, timedFrames},'pacedETData');
                state = 'outcome';
            else
                state = 'else';
                
                %leaving this place blank for now
                
                %DEBUG -- don't log data from getValue
                %self.pacedEtData = [];
            end
        end
        
        %function that checks fixation
        function fixed =  checkFixation(self)
            fixR = self.fixRegion;
            fixed = fixR.getOutput();
            
            if(fixed == 0)
                %DEBUG -- don't log data from getValue
                %                 topsDataLog.logDataInGroup(self.eyeTracker.getValue(3),...
                %                     'ETData');
                %                 topsDataLog.logDataInGroup(self.eyeTracker.getValue(1),...
                %                     'ETDataX');
                %                 topsDataLog.logDataInGroup(self.eyeTracker.getValue(2),...
                %                     'ETDataY');
                self.isFixed = false;  %record the broken fixation. This will be logged in logETData
            end
            pause(0.035); %Pause for ~40 ms to avoid excessive calls to fixR.getOutput()
        end
        
        
        %function that checks fixation
        function fixed =  checkTrainingFixation(self)
            fixR = self.fixRegion;
            fixed = fixR.getOutput();
            if(fixed == 0)
                %DEBUG -- don't log data from getValue
                %                 topsDataLog.logDataInGroup(self.eyeTracker.getValue(3),...
                %                     'ETData');
                %                 topsDataLog.logDataInGroup(self.eyeTracker.getValue(1),...
                %                     'ETDataX');
                %                 topsDataLog.logDataInGroup(self.eyeTracker.getValue(2),...
                %                     'ETDataY');
                self.isFixed = false;  %record the broken fixation. This will be logged in logETData
                fixed = 'badFixation';
            end
            pause(0.035); %Pause for ~40 ms to avoid excessive calls to fixR.getOutput()
        end
        
        
        %log all the eye tracker history during second fixation
        % (outcome -> estimate). Also record broken fixations during the
        % trial
        function logETData(self)
            hist = self.eyeTracker.history;
            timedFrames = self.eyeTracker.timedFrames;
            topsDataLog.logDataInGroup({hist, timedFrames},'trialETData');
            topsDataLog.logDataInGroup(self.isFixed,'isFixedTrial');
        end
        
        %log all the eye tracker history during second fixation in training
        % (outcome -> estimate). Also record broken fixations during the
        % trial
        function logTrainingETData(self)
            hist = self.eyeTracker.history;
            timedFrames = self.eyeTracker.timedFrames;
            topsDataLog.logDataInGroup({hist, timedFrames},'trainingETData');
            topsDataLog.logDataInGroup(self.isFixed,'isFixedTrial');
        end
        
    end
end