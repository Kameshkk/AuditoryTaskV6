% Code for behavior analysis (post COSYNE)

clear all
figure;

% subjectList = {'BhvSubj1PVD3S2fullTask(07-Mar-2013)',...
%     'BhvSubj2KKD2S2fullTask(06-Mar-2013)',...
%     'BhvSubj3LinosD2S2fullTask(06-Mar-2013)',...
%     'BhvSubj4PratikD3S2fullTask(08-Mar-2013)'};
% ID = [1 2 3 4];


subjectList = {...
                'Subj6RahelD3S2fullTask(04-Apr-2013)'};
%     'Subj1DanONeilD2S2fullTask(20-Mar-2013)',...
%     'Subj1DanONeilD3S2fullTask(21-Mar-2013)',...
%     'Subj2AnthonyD2S2fullTask(19-Mar-2013)',...
%     'Subj2AnthonyD3S2fullTask(20-Mar-2013)',...
%     'Subj3LucyD3S2fullTask(21-Mar-2013)',...
%     'Subj3LucyD2S2fullTask(20-Mar-2013)'};

ID = [1];
numTAC = 7;

allData = [];
allOutcome = [];
allEstimate = [];
allPrediction = [];
allMean = [];
allStd = [];
allCp = [];
allTAC = [];
subjID = [];
allUpdate = [];
allPredErr = [];
zsUpdate = [];
zsPercpErr = []; %z-scored(by subject) perceptual error
zsPredErr = []; %z-scored(by subject) prediction error
zsCpAlignedPredErr5 = [];
zsCpAlignedPredErr15 = [];



for i1 = 1:length(subjectList)
    
    aux = load([subjectList{i1} '.mat']);
    data = aux.data;
    allData = [allData data];
    
    idx1 = strcmp('outcome',{data.group});
    outcome = data(idx1);
    outcome = cell2mat({outcome.item});
    allOutcome = [allOutcome outcome];
    
    subjID  = [subjID ID(i1)*ones(1,length(outcome))];
    
    idx2 = strcmp('percept',{data.group});
    estimate = data(idx2);
    estimate = cell2mat({estimate.item});
    estimate = estimate*180/pi;
    allEstimate = [allEstimate estimate];
    
    idx3 = strcmp('prediction',{data.group});
    prediction = data(idx3);
    prediction = cell2mat({prediction.item});
    prediction = prediction*180/pi;
    allPrediction = [allPrediction prediction];
    
    idx4 = strcmp('mean',{data.group});
    Mean = data(idx4);
    Mean = cell2mat({Mean.item});
    allMean = [allMean Mean];
    
    idx5 = strcmp('std',{data.group});
    Std = data(idx5);
    Std = cell2mat({Std.item});
    allStd = [allStd Std];
    
    cp = [1 diff(Mean)];
    cp = logical(cp);
    allCp = [allCp cp];
    
    update = [diff(prediction) 0];
    allUpdate = [allUpdate update];
    zUpdate = (update - nanmean(update))/std(update);
    zsUpdate = [zsUpdate zUpdate];
    
    
    %z-scored perceptual and prediction errors
    zPercep = outcome - estimate;
    zPred =  outcome - prediction;
    allPredErr = [allPredErr zPred];
    zPercep = (zPercep -  nanmean(zPercep))/std(zPercep);
    zPred = (zPred - nanmean(zPred))/std(zPred);
    zsPercpErr = [zsPercpErr zPercep];
    zsPredErr = [zsPredErr zPred];
    
    
    
    % running total of number of trials after change point, where cp = 0
    TAC = nan(1,length(Mean));
    TAC(1)=0;
    for i = 2:length(Mean)
        if Mean(i) ~= Mean(i-1)
            TAC(i) = 0;
        else
            TAC(i) = TAC(i-1)+1;
        end
    end
    allTAC = [allTAC TAC];
    
    
    %Change-point aligned prediction errors
    zsCPPredErr5 = [];
    zsCPPredErr15 = [];
    cpIdx = find(TAC==0);
    selSTD = Std == 15;
    auxZpred15 = outcome(selSTD) - prediction(selSTD);
    selSTD = Std ==5;
    auxZpred5 = outcome(selSTD) - prediction(selSTD);
    zPred5 = (auxZpred5 - nanmean(auxZpred5))/std(auxZpred5);
    zPred15 = (auxZpred15 - nanmean(auxZpred15))/std(auxZpred15);
    auxPredErr = outcome - prediction;
    for i2 = 1:length(cpIdx)
        auxIdx = cpIdx(i2):min(200,cpIdx(i2)+10);
        t = length(auxIdx);
        %auxErr = outcome(auxIdx) - prediction(auxIdx);
        if(Std(cpIdx(i2)) == 5)
            zsCPPredErr5(end+1,:) =  [auxPredErr(auxIdx) nan(1,11-t)];
        else
            zsCPPredErr15(end+1,:) =   [auxPredErr(auxIdx) nan(1,11-t)];
        end
    end
    zsCpAlignedPredErr5 = [zsCpAlignedPredErr5; zsCPPredErr5];
    zsCpAlignedPredErr15 = [zsCpAlignedPredErr15; zsCPPredErr15];
    
end

uniqueStds = unique(allStd);


% % *** Model Predictions *** --- neeed to average
% numreps = 10;
% mod2percp = zeros(1,length(allStd));
% mod3percp = zeros(1,length(allStd));
% mod2pred = zeros(1,length(allStd));
% mod3pred = zeros(1,length(allStd));
% for i = 1:numreps
% clear simBehav
% audTaskPriorModeling;
% mod2percp = mod2percp + simBehav.mod2.perc';
% mod2pred = mod2pred + simBehav.mod2.pred';
% mod3percp = mod3percp + simBehav.mod3.perc;
% mod3pred = mod3pred + simBehav.mod3.pred';
% end
% mod2percp = mod2percp/numreps;
% mod3percp = mod3percp/numreps;
% mod2pred = mod2pred/numreps;
% mod3pred = mod3pred/numreps;






%set up default parameters for figures.
mattPlotParameters;

% %********************* Percp. err vs. TAC *******************************
figure
selSTD = allStd==uniqueStds(1);
percpErr = abs(allEstimate(selSTD)-allOutcome(selSTD));
[b preLockQualPoints1] = makeTACfig(percpErr, allTAC(selSTD)+1, 8, 1, 'b', 10, 0,'k');

selSTD = allStd==uniqueStds(2);
percpErr = abs(allEstimate(selSTD)-allOutcome(selSTD));
[b preLockQualPoints2] = makeTACfig(percpErr, allTAC(selSTD)+1, 8, 1, 'c', 10, 0,'k');

ylabel('perceptual Error');
xlabel('Trials after change-point');
title('Perceptual error after a change-point')
xlim([0 7.5])
set(gca, 'box', 'off')
legend([preLockQualPoints1(1),preLockQualPoints2(1)], 'Std 10','Std 20');


%********************* Pred. err vs. TAC *******************************
figure
selSTD = allStd==uniqueStds(1);
predErr = abs(allPrediction(selSTD)-allMean(selSTD));
[b preLockQualPoints1] = makeTACfig(predErr, allTAC(selSTD)+1, 8, 1, 'b', 10, 0,'k');

selSTD = allStd==uniqueStds(2);
predErr = abs(allPrediction(selSTD)-allMean(selSTD));
[b preLockQualPoints2] = makeTACfig(predErr, allTAC(selSTD)+1, 8, 1, 'c', 10, 0,'k');

ylabel('prediction Error');
xlabel('Trials after change-point');
title('Prediction error after a change-point')
xlim([0 7.5])
set(gca, 'box', 'off')
legend([preLockQualPoints1(1),preLockQualPoints2(1)], 'Std 10','Std 20');

%************************* Prior wt. vs TAC ******************************
% %combining statistics
% clear Tcoef TcoefInt
% figure;
% xx = 7;
% cols = {'r' 'g' 'b'};
% count = 1;
% pointHandles = [];
% delta = [0 0.1];
% for std1 = [5 15]
%
%     Tcoef = nan(xx,length(ID));
%     TcoefInt = nan(xx,2*length(ID));
%
%     for subj = 1:length(ID)
%         selSTD = allStd==std1 & subjID == ID(subj);
%         priorErr = allOutcome(selSTD) - allPrediction(selSTD);
%         postErr = allOutcome(selSTD) - allEstimate(selSTD);
%         priorErr = zsPredErr(selSTD);
%         postErr = zsPercpErr(selSTD);
%
%         for i =1:xx
%             if i < xx
%                 sel = allTAC(selSTD) == i-1;
%             else
%                 %sel = values.std==20&TAC(selSTD) >= (xx-1); %& highN'==0;
%                 sel = allTAC(selSTD) >= (xx-1);
%             end
%             if sum(sel) > 5
%                 [B,BINT,R,RINT,STATS] = regress(postErr(sel)', [priorErr(sel)']);
%                 %[B stats] = robustfit(postErr(sel)', [priorErr(sel)'],[],[],'off');
%                 %BINT = [B-stats.se B+stats.se];
%                 %, ones(sum(sel),1)
%             else
%                 B = nan(size(B));
%                 BINT = nan(size(BINT));
%             end
%             Tcoef(i,subj) = B(end);
%             TcoefInt(i,(subj-1)*2+1:2*subj) = BINT(end,:);
%         end
%
%     end
%     aux = (diff(TcoefInt'))';
%     aux = aux(:,1:2:end);
%     aux2 = bsxfun(@times,aux,Tcoef);
%     allTcoef = sum(aux2,2)./sum(aux,2);
%     allTcoefInt(:,1) = sum(TcoefInt(:,1:2:end),2)/6;
%     allTcoefInt(:,2) = sum(TcoefInt(:,2:2:end),2)/6;
%
%     hold on
%     plot([0 xx], [0 0], '--k')
%     plot(repmat((1:xx)+delta(count), 2, 1), allTcoefInt', 'k')
%     pointHandles(end+1) = plot((1:xx)+delta(count), allTcoef, 'ok', 'markerEdgeColor', 'k', 'markerFaceColor', cols{count},...
%         'lineWidth', 1, 'markerSize', 8)
%     count = count + 1;
% end
% ylabel('Prior Weight')
% xlabel('Trials after changepoint')
% title('How much does prior influence the decision after a change point?')
% legend(pointHandles,'Std 5', 'Std 15');
% xlim([0 xx+1]);



%combining raw data
clear Tcoef TcoefInt
figure;
xx = numTAC;
cols = {'r' 'g' 'b'};
count = 1;
pointHandles = [];
delta = [0 0.1];
for std1 = uniqueStds
    
    Tcoef = nan(xx,1);
    TcoefInt = nan(xx,2);
    selSTD = allStd==std1;
    priorErr = allOutcome(selSTD) - allPrediction(selSTD);
    postErr = allOutcome(selSTD) - allEstimate(selSTD);
    %priorErr = allOutcome(selSTD) - mod3pred(selSTD);
    %postErr = allOutcome(selSTD) - mod3percp(selSTD);
    %priorErr = zsPredErr;
    %postErr = zsPercpErr;
    %priorErr = mod2pred(selSTD) - allPrediction(selSTD);
    %postErr = mod2percp(selSTD) - allEstimate(selSTD);
    
    for i =1:xx
        if i < xx
            sel = allTAC(selSTD) == i-1;
        else
            %sel = values.std==20&TAC(selSTD) >= (xx-1); %& highN'==0;
            sel = allTAC(selSTD) == (xx-1);
        end
        if sum(sel) > 5
            [B,BINT,R,RINT,STATS] = regress(postErr(sel)', [priorErr(sel)']);
            %, ones(sum(sel),1)
        else
            B = nan(size(B));
            BINT = nan(size(BINT));
        end
        Tcoef(i) = B(end);
        TcoefInt(i,:) = BINT(end,:);
    end
    
    
    hold on
    plot([0 xx], [0 0], '--k')
    plot(repmat((1:xx)+delta(count), 2, 1), TcoefInt', 'k')
    pointHandles(end+1) = plot((1:xx)+delta(count), Tcoef, 'ok', 'markerEdgeColor', 'k', 'markerFaceColor', cols{count},...
        'lineWidth', 1, 'markerSize', 8)
    count = count + 1;
end
ylabel('Prior Weight')
xlabel('Trials after changepoint')
title('How much does prior influence the decision after a change point?')
legend(pointHandles,'Std 10', 'Std 20');
xlim([0 xx+1]);






%
%
%********************* "Learning Rate" vs. TAC **************
clear Tcoef TcoefInt
figure;
xx = numTAC;
cols = {'r' 'g' 'b'};
count = 1;
pointHandles = [];
delta = [0 0.1];
for std1 = uniqueStds;
    selSTD = allStd==std1;
    update = allUpdate(selSTD);
    percpErr = allPredErr(selSTD);
    
    for i =1:xx
        if i < xx
            sel = allTAC(selSTD) == i-1;
        else
            %sel = values.std==20&TAC(selSTD) >= (xx-1); %& highN'==0;
            sel = allTAC(selSTD) == (xx-1);
        end
        if sum(sel) > 5
            [B,BINT,R,RINT,STATS] = regress(update(sel)', [percpErr(sel)']);
        else
            B = nan(size(B));
            BINT = nan(size(BINT));
        end
        Tcoef(i) = B(end);
        TcoefInt(i,:) = BINT(end,:);
    end
    
    hold on
    plot([0 xx], [0 0], '--k')
    plot(repmat((1:xx)+delta(count), 2, 1), TcoefInt', 'k')
    pointHandles(end+1) = plot((1:xx)+delta(count), Tcoef, 'ok', 'markerEdgeColor', 'k', 'markerFaceColor', cols{count},...
        'lineWidth', 1, 'markerSize', 8)
    count = count + 1;
end
ylabel('Learning Rate')
xlabel('Trials after changepoint')
title('Learning Rate vs. TAC')
legend(pointHandles,'Std 10', 'Std 20');
xlim([0 xx+1]);





% % ************************ Model Predictions on same outcomes**********
% figure
% numReps = 50;
% stdGen = 20;
% stdLocalization = 15;
% numTrials = length(allStd);
% trialsPerBlock = 1600;
% drift = 0;
% likeWeight = 1;
% trueRun = 0;
% hazard = 0.15;
% safetyPeriod = 0;
% xx = numTAC;  %how many trials after change-point do we care about?
% avgTcoef = cell(length(stdGen),1);
% avgTcoefInt = cell(length(stdGen),1);
% for i1 = 1:length(stdGen)
%     avgTcoef{i1} = zeros(xx,1);  %avg slopes of PredErr vs. PercpErr
%     avgTcoefInt{i1} = zeros(xx,2); %avg conf. ints of the slopes
% end
% 
% 
% %evaluate some book-keeping variables
% %DEBUG -- dirty way to combine blocks
% aux1 = [];
% aux2 = [];
% aux3 = [];
% aux4 = [];
% for std1 = uniqueStds
%     idx = allStd == std1;
%     aux1 = [aux1 allStd(idx)];
%     aux2 = [aux2 allOutcome(idx)];
%     aux3 = [aux3 allMean(idx)];
%     aux4 = [aux4 allTAC(idx)];
% end
% allStd = aux1';
% allMean = aux3';
% allOutcome = aux2';
% allTAC = aux4';
% blockBegs=[1 ;find(diff(allStd)~=0)+1];
% blockEnds=[find(diff(allStd)~=0) ;length(allStd)];
% expTAC=allTAC;
% expTAC(blockBegs)=nan;
% allTAC(blockBegs)=nan;
% cpTrials=find(expTAC==0);
% expTAC(cpTrials)=expTAC(cpTrials-1)+1;
% 
% for i1 = 1:numReps
%     modR = nan(numTrials,1);  %run-length estimate output by model
%     modPCha = nan(numTrials,1); %change-point probability
%     modSig = nan(numTrials,1);   % variance of mu_hat calc by model
%     modelPreds = nan(numTrials,1);
%     modelPercep = nan(numTrials,1);
%     
%     for i2 = 1:length(blockBegs)
%         
%         %First calculate the model prior
%         clear B R totSig pCha postMean postS
%         selIdx = blockBegs(i2):blockEnds(i2);
%         blockOutcomes = allOutcome(selIdx);
%         blockStd = unique(allStd(selIdx));
%         blockMeans = allMean(selIdx);
%         initialGuess = blockMeans(1);
%         [B, totSig, R, pCha] = frugFun5(blockOutcomes,hazard,blockStd,drift,...
%             likeWeight,trueRun, initialGuess, .1);
%         
%         modelPreds(selIdx) =  B(1:end-1)';
%         modSig(selIdx) = totSig;       % total variance (in estimate of mean)
%         modR(selIdx) = R(1:end-1);     % run length estimates
%         modPCha(selIdx) = pCha;       % change-point probability
%         
%         %Now calculate the model predictions
%         postMean = nan(trialsPerBlock,1);
%         postS = nan(trialsPerBlock,1);    %posterior over binary latent change-point variable
%         
%         %Computing the model posterior
%         %assume that the neural location is Gaussian centered at the true
%         %location
%         internalLocation = normrnd(blockOutcomes, stdLocalization*ones(trialsPerBlock,1));
%         %internalLocation = trialOutcomes;
%         internalLocation(internalLocation > 180) = 180;
%         internalLocation(internalLocation < 0) = 0;
%         
%         %the model always gets the true hazard rate
%         for i3 = 1:trialsPerBlock
%             if expTAC(i3) < safetyPeriod*-1
%                 [postMean(i3), postS(i3)]=combinePriorAndLike(B(i3), modSig(i3).^2,...
%                     internalLocation(i3), stdLocalization.^2, 0);
%             else
%                 [postMean(i3), postS(i3)]=combinePriorAndLike(B(i3), modSig(i3).^2,...
%                     internalLocation(i3), stdLocalization.^2, hazard);
%             end
%         end
%         
%         modelPercep(selIdx) = postMean;
%     end
%     
%      %plot(allOutcomes,'b*'); hold on
%      %plot(allMeans,'r-','linewidth',2)
%      %plot(modelPreds,'g-x','linewidth',1.5);
%      %plot(modelPercep,'m.')
%     disp('OK')
%     
%     
%     %Calculate the prior weights for the model
%     
%     count = 1;
%     for std1 = stdGen
%         clear Tcoef TcoefInt B BINT
%         Tcoef = nan(xx,1);
%         TcoefInt = nan(xx,2);
%         selSTD = allStd==std1;
%         priorErr = allOutcome(selSTD) - modelPreds(selSTD);
%         postErr = allOutcome(selSTD) - modelPercep(selSTD);
%         for i2 =1:xx
%             if i2 < xx
%                 sel = allTAC(selSTD) == i2-1;
%             else
%                 %sel = values.std==20&TAC(selSTD) >= (xx-1); %& highN'==0;
%                 sel = allTAC(selSTD) == (xx-1);
%             end
%             if sum(sel) > 5
%                 [B,BINT,R,RINT,STATS] = regress(postErr(sel), priorErr(sel));
%             else
%                 B = nan(size(B));
%                 BINT = nan(size(BINT));
%                 disp('not enough samples!')
%             end
%             Tcoef(i2) = B(end);
%             TcoefInt(i2,:) = BINT(end,:);
%         end
%         avgTcoefInt{count} = avgTcoefInt{count} + TcoefInt;
%         avgTcoef{count} = avgTcoef{count} + Tcoef;
%         count = count + 1;
%     end
%     
% end %numReps loop
%     
% 
% %Plot the model-predicted prior weights
% xx = numTAC;
% cols = { 'g'};
% pointHandles = [];
% delta = 0:0.1:0.1*length(stdGen);
% count =1;
% for std1 = stdGen
%     hold on
%     aux1 = avgTcoefInt{count}/numReps;
%     aux2 = avgTcoef{count}/numReps;
%     plot([0 xx], [0 0], '--k')
%     plot(repmat((1:xx)+delta(count), 2, 1), aux1', 'k')
%     pointHandles(end+1) = plot((1:xx)+delta(count), aux2, 'ok', 'markerEdgeColor', 'k', 'markerFaceColor', cols{count},...
%         'lineWidth', 1, 'markerSize', 8);
%     count = count + 1;
% end
% ylabel('Prior Weight')
% xlabel('Trials after changepoint')
% titleStr = ['Hazard-' num2str(hazard) ' safety-' num2str(safetyPeriod) ...
%     ' stdLoc-' num2str(stdLocalization) ' trials/block-' ...
%     num2str(trialsPerBlock)];
% title(titleStr)
% legendStr = cell(length(stdGen),1);
% for i1 = 1:length(stdGen)
%     legendStr{i1} = ['Std ' num2str(stdGen(i1)) ];
% end
% legend(pointHandles,legendStr);
% xlim([0 xx+1]);
