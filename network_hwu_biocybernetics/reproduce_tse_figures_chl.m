% Main script
% subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
% Schemas (place,flavor)
schemaA =        [4,4;6,1;13,5;15,3;22,2];
schemaA_newPA =  [4,4;6,1;13,5;20,7;23,6];
schemaA_newPA2 = [4,4;6,1;13,5;10,9;21,8];
%schemaA_newPA = [4,4;6,1;13,5;15,3;22,2;20,7;23,6];
%schemaA_newPA2 = [4,4;6,1;13,5;15,3;22,2;10,9;21,8];
schemaC =        [3,10;9,11;11,12;16,13;24,14];
schemaC_newPA =  [3,10;9,11;11,12;17,15;19,16];
schemaC_newPA2 = [3,10;9,11;11,12;12,17;25,18];
%schemaC_newPA = [3,10;9,11;11,12;16,13;24,14;17,15;19,16];
%schemaC_newPA2 = [3,10;9,11;11,12;16,13;24,14;12,17;25,18];
schemaC_scrambled = [3,14;9,10;11,11;16,12;24,13];
% Neuron sizes
size_flavors = 18;
size_wells = 25;
size_contexts = 10;
size_multimodal = 80;
size_context_pattern = 25;
size_vhipp = 5;
size_dhipp = 40;
% Learning parameters
ts = 5;
lr = 2;
lr_explore = .1;
lr_pattern = .0001;
g = .001;
% Other parameters
num_rats = 20;
P = .3;
default_epochs = 600;
boost_epochs = 2000;%1000
settle_step = 20;
h_min = .90;
boost_familiarity = 8;
constant_epochs = false;

%% Figure 2A, Train Schema A
clearNeurons;
initializeWeights;
total_epochs = 0;
days = 20;
schema = schemaA;
has_hipp = true;
train1Schema;
schema_activityA = schema_activity;
familiarity_activityA = familiarity_activity;
novelty_activityA = novelty_activity;
active_schemaA = active_schema;
mPFC_activityA = mPFC_activity;
vHPC_activityA = vHPC_activity;
dHPC_activityA = dHPC_activity;

scoresA = scores;
[h1,p1] = kstest2(scoresA(2,:),(1-scoresA(2,:))./4)
[h2,p3] = kstest2(scoresA(9,:),(1-scoresA(9,:))./4)
[h3,p3] = kstest2(scoresA(16,:),(1-scoresA(16,:))./4)
figure(2);
subplot(2,3,1);
errors_cued = std(scoresA,0,2)./sqrt(num_rats);
errors_noncued = std(1-scoresA,0,2)./sqrt(num_rats);
performances = mean(scoresA,2);
errorbar(1:days,performances,errors_cued,'o-');
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('A) Performance on Schema A');
xlabel('Trial');
ylabel('Performance');
%
%% Figure 2B, PT, Train Schema A
%
figure(2);
subplot(2,3,2);   
data = [performances(2),(1-performances(2))/4; performances(9),(1-performances(9))/4; performances(16),(1-performances(16))/4];
err = [errors_cued(2), errors_noncued(2)/4; errors_cued(9), errors_noncued(9)/4; errors_cued(16), errors_noncued(9)/4];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('B) PT, training');
legend('Cued','Non-Cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'PT1','PT2','PT3'});
%
%% Figure 2C, PT, Train Schema A with new PAs
%
days = 1;
epochs = 250;
schema = schemaA_newPA;

train1Schema;
schema_activityA = [schema_activityA; schema_activity];
active_schemaA = [active_schemaA; active_schema];
mPFC_activityA = [mPFC_activityA; mPFC_activity];
vHPC_activityA = [vHPC_activityA; vHPC_activity];
dHPC_activityA = [dHPC_activityA; dHPC_activity];
cue = 4;
noncue = 5;
testOnePA;
legend('Cued','Non-Cued','Original');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'PT4'});

figure(2);
subplot(2,3,3);
data = [perf_cued,perf_noncued,(1-perf_cued-perf_noncued)./3; 0, 0, 0];
err = [err_cued,err_noncued,err_orig; 0, 0, 0];
bar_with_error(data,err);
xlim([.5,1.5]);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('C) PT, new PAs');

%
%% Figure 2D-1, PT, Test Schema A, HPC and control
has_hipp = true;
transferIn = false;
transferWeights; % make a copy of weights for control
has_hipp = false;
transferWeights; % make a copy of weights for HPC

schema = schemaA;
has_hipp = true;
transferIn = true;
transferWeights;
clearNeurons;
testSchema;
control_perfAs = score;
[h,p,ci,stats] = ttest(control_perfAs',1-control_perfAs')
[h,p] = kstest2(control_perfAs,(1-control_perfAs)./4)
error_control_cued = std(control_perfAs)./sqrt(num_rats);
error_control_noncued = std((1-control_perfAs)/4)./sqrt(num_rats);
control_perfA = mean(control_perfAs);
transferIn = false;
transferWeights;

has_hipp = false;
transferIn = true;
transferWeights;
clearNeurons;
testSchema;
HPC_perfAs = score;
[h,p,ci,stats] = ttest(HPC_perfAs',1-HPC_perfAs')
[h,p] = kstest2(HPC_perfAs,(1-HPC_perfAs)./4)
[h,p] = kstest2(control_perfAs,HPC_perfAs)
error_HPC_cued = std(control_perfAs)./sqrt(num_rats);
error_HPC_noncued = std((1-control_perfAs)/4)./sqrt(num_rats);
HPC_perfA = mean(HPC_perfAs);
transferIn = false;
transferWeights;

figure(2);
subplot(2,3,4);
data = [HPC_perfA, (1-HPC_perfA)/4; control_perfA, (1-control_perfA)/4];
err = [error_HPC_cued, error_HPC_noncued/4; error_control_cued, error_control_noncued/4];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('D) Post-lesion PT, Schema A');
legend('Cued','Non-Cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'HPC','Control'});

%
%% Figure 2D-2, PT, Test Schema A with new PAs, HPC and control
%
days = 1;
epochs = 250;
schema = schemaA_newPA;

has_hipp = true;
transferIn = true;
transferWeights;
clearNeurons;
cue = 4;
noncue = 5;
testOnePA;
control_perfA_newPA_cued = perf_cued;
control_perfA_newPA_noncued = perf_noncued;
error_control_perfA_newPA_cued = err_cued;
error_control_perfA_newPA_noncued = err_noncued;
error_control_perfA_newPA_orig = err_orig;
transferIn = false;
transferWeights;

has_hipp = false;
transferIn = true;
transferWeights;
clearNeurons;
cue = 4;
noncue = 5;
testOnePA;
HPC_perfA_newPA_cued = perf_cued;
HPC_perfA_newPA_noncued = perf_noncued;
error_HPC_perfA_newPA_cued = err_cued;
error_HPC_perfA_newPA_noncued = err_noncued;
error_HPC_perfA_newPA_orig = err_orig;
transferIn = false;
transferWeights;
    
figure(2);
subplot(2,3,5);
data = [HPC_perfA_newPA_cued, HPC_perfA_newPA_noncued, (1-HPC_perfA_newPA_cued-HPC_perfA_newPA_noncued)/3; control_perfA_newPA_cued, control_perfA_newPA_noncued, (1-control_perfA_newPA_cued-control_perfA_newPA_noncued)/3];
err = [error_HPC_perfA_newPA_cued, error_HPC_perfA_newPA_noncued, error_HPC_perfA_newPA_orig; error_control_perfA_newPA_cued, error_control_perfA_newPA_noncued, error_control_perfA_newPA_orig];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('E) Post-lesion PT, Schema A, new PAs');
legend('New cued','New non-cued','Original non-cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'HPC','Control'});
%
%% Figure 2E, PT, Train Schema A with new PAs, HPC and control
%
days = 1;
epochs = 250;% default value
schema = schemaA_newPA2;

has_hipp = true;
transferIn = true;
transferWeights;
train1Schema;
schema_activityA = [schema_activityA; schema_activity];
familiarity_activityA = [familiarity_activityA; familiarity_activity];
novelty_activityA = [novelty_activityA; novelty_activity];
active_schemaA = [active_schemaA; active_schema];
mPFC_activityA = [mPFC_activityA; mPFC_activity];
vHPC_activityA = [vHPC_activityA; vHPC_activity];
dHPC_activityA = [dHPC_activityA; dHPC_activity];
testOnePA;
control_perfA_newPA_cued = perf_cued;
control_perfA_newPA_noncued = perf_noncued;
error_control_perfA_newPA_cued = err_cued;
error_control_perfA_newPA_noncued = err_noncued;
error_control_perfA_newPA_orig =  err_orig;
transferIn = false;
transferWeights;

has_hipp = false;
transferIn = true;
transferWeights;
train1Schema;
schema_activity_newPA2 = schema_activity;
testOnePA;
HPC_perfA_newPA_cued = perf_cued;
HPC_perfA_newPA_noncued = perf_noncued;
error_HPC_perfA_newPA_cued = err_cued;
error_HPC_perfA_newPA_noncued = err_noncued;
error_HPC_perfA_newPA_orig =  err_orig;
transferIn = false;
transferWeights;
    
figure(2);
subplot(2,3,6);
data = [HPC_perfA_newPA_cued, HPC_perfA_newPA_noncued, (1-HPC_perfA_newPA_cued-HPC_perfA_newPA_noncued)/3; control_perfA_newPA_cued, control_perfA_newPA_noncued, (1-control_perfA_newPA_cued-control_perfA_newPA_noncued)/3];
err = [error_HPC_perfA_newPA_cued, error_HPC_perfA_newPA_noncued, error_HPC_perfA_newPA_orig; error_control_perfA_newPA_cued, error_control_perfA_newPA_noncued, error_control_perfA_newPA_orig];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('F) Post-lesion PT, Schema A, new PAs (2)');
legend('New cued','New non-cued','Original non-cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'HPC','Control'});

figure(1);
subplot(2,3,1);
imagesc(w_pattern_context(:,:,1));
caxis([0 1])
xlabel('Context Pattern');
ylabel('mPFC');
subplot(2,3,2);
imagesc(w_flavor_multimodal(:,:,1));
caxis([0 1])
xlabel('Cue');
ylabel('AC');
subplot(2,3,3);
imagesc(w_context_multimodal(:,:,1));
caxis([0 1])
xlabel('mPFC');
ylabel('AC');
subplot(2,3,4);
imagesc(w_multimodal_well(:,:,1));
caxis([0 1])
xlabel('AC');
ylabel('Action');
subplot(2,3,5);
imagesc([w_vhipp_dhipp(:,:,1) w_flavor_dhipp(:,:,1) w_well_dhipp(:,:,1)]);
caxis([0 1])
xlabel('vHPC, Cue, Action');
ylabel('dHPC');
subplot(2,3,6);
imagesc(w_context_vhipp(:,:,1));
xlabel('mPFC');
ylabel('vHPC');
%{
% don't plot for now
figure(4);
subplot(2,3,1);
plot(1:(size(schema_activityA,1)),schema_activityA);
ylim([2000 4000]);
title('LC activity');
xlabel('Trial');
ylabel('LC');
subplot(2,3,2);
plot(1:(size(active_schemaA,1)),active_schemaA);
ylim([0 size_contexts]);
title('Active schema');
xlabel('Trial');
ylabel('Schema');
%}
% Plot to demonstrate how familiarity and novelty combine
figure(9);
subplot(3,1,1);
plot(1:(size(familiarity_activityA,1)),familiarity_activityA);
xlim([0 21]);
title('A) Familiarity');
xlabel('Trial');
ylabel('Activity');
subplot(3,1,2);
plot(1:(size(novelty_activityA,1)),novelty_activityA);
xlim([0 21]);
title('B) Novelty');
xlabel('Trial');
ylabel('Activity');
subplot(3,1,3);
plot(1:(size(schema_activityA,1)),schema_activityA);
xlim([0 21]);
title('C) Neuromodulator');
xlabel('Trial');
ylabel('Activity');

save('checkpoint2.mat');
%
%% Figure 3A, Train Schema B, HPC and control
%
days = 16;
schema = schemaC;

has_hipp = true;
transferIn = true;
transferWeights;
train1Schema;
schema_activityC_control = schema_activity;
active_schemaC_control = active_schema;
mPFC_activityC_control = mPFC_activity;
vHPC_activityC_control = vHPC_activity;
dHPC_activityC_control = dHPC_activity;
control_performances = scores;
anova1(control_performances')
[h,p]=kstest2(control_performances(16,:),(1-control_performances(16,:))./4)
errors_control_cued = std(control_performances,0,2)./sqrt(num_rats);
errors_control_noncued = std(1-control_performances,0,2)./sqrt(num_rats);
control_performances = mean(control_performances,2);
transferIn = false;
transferWeights;

has_hipp = false;
transferIn = true;
transferWeights;
train1Schema;
schema_activityC_HPC = schema_activity;
active_schemaC_HPC = active_schema;
mPFC_activityC_HPC = mPFC_activity;
vHPC_activityC_HPC = vHPC_activity;
dHPC_activityC_HPC = dHPC_activity;
HPC_performances = scores;
anova1(HPC_performances')
[h,p]=kstest2(HPC_performances(16,:),(1-HPC_performances(16,:))./4)
[h,p]=kstest2(HPC_performances(16,:),control_performances(16,:))
errors_HPC_cued = std(HPC_performances,0,2)./sqrt(num_rats);
errors_HPC_noncued = std(1-HPC_performances,0,2)./sqrt(num_rats);
HPC_performances = mean(HPC_performances,2);
transferIn = false;
transferWeights;

figure(3);
subplot(2,2,1);
errorbar(1:days,HPC_performances,errors_HPC_cued,'or-');
hold on;
errorbar(1:days,control_performances,errors_control_cued,'ob-');
ylim([0 1]);
xlim([0,length(control_performances)]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
legend('HPC','Control');
title('A) Performance on Schema B');
xlabel('Trial');
ylabel('Performance');
hold off;
%
%% Figure 3C, PT, Test Schema B, HPC and control
%
figure(3);
subplot(2,2,2);
data = [HPC_performances(16), (1-HPC_performances(16))/4; control_performances(16), (1-control_performances(16))/4];
err = [errors_HPC_cued(16), errors_HPC_noncued(16)/4; errors_control_cued(16), errors_control_noncued(16)/4];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('B) Post-training probe test of Schema B');
legend('Cued','Non-Cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'HPC','Control'});
%
%% Figure 3D, Retrain Schema A, HPC and control
%
days = 7;
schema = schemaA;

has_hipp = true;
transferIn = true;
transferWeights;
train1Schema;
schema_activityC_control = [schema_activityC_control; schema_activity];
active_schemaC_control = [active_schemaC_control; active_schema];
mPFC_activityC_control = [mPFC_activityC_control; mPFC_activity];
dHPC_activityC_control = [dHPC_activityC_control; dHPC_activity];
vHPC_activityC_control = [vHPC_activityC_control; vHPC_activity];
control_performances = scores;
anova1(control_performances')
[h,p]=kstest2(control_performances(7,:),(1-control_performances(7,:))./4)
errors_control_cued = std(control_performances,0,2)./sqrt(num_rats);
errors_control_noncued = std(1-control_performances,0,2)./sqrt(num_rats);
control_performances = mean(control_performances,2);
transferIn = false;
transferWeights;

has_hipp = false;
transferIn = true;
transferWeights;
train1Schema;
schema_activityC_HPC = [schema_activityC_HPC; schema_activity];
active_schemaC_HPC = [active_schemaC_HPC; active_schema];
mPFC_activityC_HPC = [mPFC_activityC_HPC; mPFC_activity];
dHPC_activityC_HPC = [dHPC_activityC_HPC; dHPC_activity];
vHPC_activityC_HPC = [vHPC_activityC_HPC; vHPC_activity];
HPC_performances = scores;
anova1(HPC_performances')
[h,p]=kstest2(HPC_performances(7,:),(1-HPC_performances(7,:))./4)
[h,p]=kstest2(HPC_performances(7,:),control_performances(7,:))
errors_HPC_cued = std(HPC_performances,0,2)./sqrt(num_rats);
errors_HPC_noncued = std(1-HPC_performances,0,2)./sqrt(num_rats);
HPC_performances = mean(HPC_performances,2);
transferIn = false;
transferWeights;

figure(3);
subplot(2,2,3);
errorbar(1:days,HPC_performances,errors_HPC_cued,'or-');
hold on;
errorbar(1:days,control_performances,errors_control_cued,'ob-');
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
legend('HPC','Control');
title('C) Performance retraining on Schema A');
xlabel('Day');
ylabel('Performance');
hold off;
%
%% Figure 3E, PT, Test Schema B, HPC and control
%
figure(3);
subplot(2,2,4);
data = [HPC_performances(7), (1-HPC_performances(7))/4; control_performances(7), (1-control_performances(7))/4];
err = [errors_HPC_cued(7), errors_HPC_noncued(7)/4; errors_control_cued(7), errors_control_noncued(7)/4];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('D) Post-retraining probe test of Schema A');
legend('Cued','Non-Cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'HPC','Control'});

figure(1);
has_hipp = true;
transferIn = true;
transferWeights;
subplot(2,3,1);
imagesc(w_pattern_context(:,:,1));
caxis([0 1])
xlabel('Context Pattern');
ylabel('mPFC');
subplot(2,3,2);
imagesc(w_flavor_multimodal(:,:,1));
caxis([0 1])
xlabel('Cue');
ylabel('AC');
subplot(2,3,3);
imagesc(w_context_multimodal(:,:,1));
caxis([0 1])
xlabel('mPFC');
ylabel('AC');
subplot(2,3,4);
imagesc(w_multimodal_well(:,:,1));
caxis([0 1])
xlabel('AC');
ylabel('Action');
subplot(2,3,5);
imagesc([w_vhipp_dhipp(:,:,1) w_flavor_dhipp(:,:,1) w_well_dhipp(:,:,1)]);
caxis([0 1])
xlabel('vHPC, Cue, Action');
ylabel('dHPC');
subplot(2,3,6);
imagesc(w_context_vhipp(:,:,1));
xlabel('mPFC');
ylabel('vHPC');

figure(4);
schema_activity_1_2 = [schema_activityA; schema_activityC_control];
active_schema_1_2 = [active_schemaA; active_schemaC_control];
mPFC_activity_1_2 = [mPFC_activityA; mPFC_activityC_control];
dHPC_activity_1_2 = [dHPC_activityA; dHPC_activityC_control];
vHPC_activity_1_2 = [vHPC_activityA; vHPC_activityC_control];
subplot(2,2,1);
plot([22.5,22.5],[2500,0],'k');
hold on;
plot(1:(size(schema_activity_1_2,1)),schema_activity_1_2);
ylim([0 2500]);
title('A) LC activity, experiments 1 and 2');
xlabel('Trial');
ylabel('LC');
hold off;
subplot(2,2,3);
plot([22.5,22.5],[2500,0],'k');
hold on;
plot(1:size(active_schema_1_2,1),active_schema_1_2);
ylim([0 size_contexts + 1]);
title('B) Active schema, experiments 1 and 2');
xlabel('Trial');
ylabel('Schema');
hold off;
figure(7)
subplot(3,1,1);
plot(1:(size(mPFC_activity_1_2,1)),mPFC_activity_1_2);
hold on;
for i = 1:size(schema_activity_1_2,1)
    line_val = sum(schema_activity_1_2(1:i,1));
    plot([line_val, line_val],[2.5,0],'k');
end
ylim([0 2.5]);
xlim([0 size(mPFC_activity_1_2,1)]);
hold off;
title('A) mPFC activity');
xlabel('Epoch');
ylabel('Activity');
subplot(3,1,2);
plot(1:(size(vHPC_activity_1_2,1)),vHPC_activity_1_2);
hold on;
for i = 1:size(schema_activity_1_2,1)
    line_val = sum(schema_activity_1_2(1:i,1));
    plot([line_val, line_val],[2.5,0],'k');
end
ylim([0 2.5]);
xlim([0 size(vHPC_activity_1_2,1)]);
hold off;
title('B) vHPC activity');
xlabel('Epoch');
ylabel('Activity');
subplot(3,1,3);
plot(1:100,dHPC_activity_1_2(1:100,:));
ylim([0 2.5]);
title('C) dHPC activity');
xlabel('Epoch');
ylabel('Activity');
save('checkpoint3.mat');
%
%% Figure 5A, Train consistent and inconsistent schemas
%
clearNeurons;
initializeWeights;
has_hipp = true;
num_trials = 40;
performances = zeros(num_trials,num_rats);
performances_new_cued = zeros(num_trials,num_rats);
performances_new_noncued = zeros(num_trials,num_rats);
error_new_cued = zeros(num_trials,num_rats);
error_new_noncued = zeros(num_trials,num_rats);
A_trials = [1:6 13:16 21:22 25 29 35];
C_trials = [7:12 17:20 23:24 27 32 38];
C_scram_trials = [9 12 19 24];
A_newPA_trials = [30];
A_newPA2_trials = [36];
C_newPA_trials = [33];
C_newPA2_trials = [39];
A_test = [26];
A_newPA_test = [31];
A_newPA2_test = [37];
C_test = [28];
C_newPA_test = [34];
C_newPA2_test = [40];
schema_activity_3 = [];
index_activity_3 = [];
active_schema_3 = [];
mPFC_activity_3 = [];
dHPC_activity_3 = [];
vHPC_activity_3 = [];
days = 1;

for trial = 1:num_trials
    trial
    % Statement block for trials with training and testing
    if ismember(trial,A_trials)
        schema = schemaA;
        train1Schema;
        performances(trial,:) = scores;
        schema_activity_3 = [schema_activity_3; schema_activity];
        active_schema_3 = [active_schema_3; active_schema];
        mPFC_activity_3 = [mPFC_activity_3; mPFC_activity];
        dHPC_activity_3 = [dHPC_activity_3; dHPC_activity];
        vHPC_activity_3 = [vHPC_activity_3; vHPC_activity];
    elseif ismember(trial,C_scram_trials)
        schema = schemaC_scrambled;
        train1Schema;
        performances(trial,:) = scores;
        schema_activity_3 = [schema_activity_3; schema_activity];
        active_schema_3 = [active_schema_3; active_schema];
        mPFC_activity_3 = [mPFC_activity_3; mPFC_activity];
        dHPC_activity_3 = [dHPC_activity_3; dHPC_activity];
        vHPC_activity_3 = [vHPC_activity_3; vHPC_activity];
    elseif ismember(trial,C_trials)
        schema = schemaC;
        train1Schema;
        performances(trial,:) = scores;
        schema_activity_3 = [schema_activity_3; schema_activity];
        active_schema_3 = [active_schema_3; active_schema];
        mPFC_activity_3 = [mPFC_activity_3; mPFC_activity];
        dHPC_activity_3 = [dHPC_activity_3; dHPC_activity];
        vHPC_activity_3 = [vHPC_activity_3; vHPC_activity];
    elseif ismember(trial,A_newPA_trials)
        schema = schemaA_newPA;
        train1Schema;
        performances(trial,:) = scores;
        schema_activity_3 = [schema_activity_3; schema_activity];
        active_schema_3 = [active_schema_3; active_schema];
        mPFC_activity_3 = [mPFC_activity_3; mPFC_activity];
        dHPC_activity_3 = [dHPC_activity_3; dHPC_activity];
        vHPC_activity_3 = [vHPC_activity_3; vHPC_activity];
    elseif ismember(trial,A_newPA2_trials)
        schema = schemaA_newPA2;
        train1Schema;
        performances(trial,:) = scores;
        schema_activity_3 = [schema_activity_3; schema_activity];
        active_schema_3 = [active_schema_3; active_schema];
        mPFC_activity_3 = [mPFC_activity_3; mPFC_activity];
        dHPC_activity_3 = [dHPC_activity_3; dHPC_activity];
        vHPC_activity_3 = [vHPC_activity_3; vHPC_activity];
    elseif ismember(trial,C_newPA_trials)
        schema = schemaC_newPA;
        train1Schema;
        performances(trial,:) = scores;
        schema_activity_3 = [schema_activity_3; schema_activity];
        active_schema_3 = [active_schema_3; active_schema];
        mPFC_activity_3 = [mPFC_activity_3; mPFC_activity];
        dHPC_activity_3 = [dHPC_activity_3; dHPC_activity];
        vHPC_activity_3 = [vHPC_activity_3; vHPC_activity];
    elseif ismember(trial,C_newPA2_trials)
        schema = schemaC_newPA2;
        train1Schema;
        performances(trial,:) = scores;
        schema_activity_3 = [schema_activity_3; schema_activity];
        active_schema_3 = [active_schema_3; active_schema];
        mPFC_activity_3 = [mPFC_activity_3; mPFC_activity];
        dHPC_activity_3 = [dHPC_activity_3; dHPC_activity];
        vHPC_activity_3 = [vHPC_activity_3; vHPC_activity];
    end
    
    % Statement block for trials with just testing
    if ismember(trial,A_test)
        schema = schemaA;
        testSchema;
        performances(trial,:) = scores;
        disp 'A test ttest'
        [h,p,ci,stats] = ttest(scores,1-scores)
        [h,p] = kstest2(scores,(1-scores)./4)
        A_scores = scores;
    elseif ismember(trial,A_newPA_test)
        schema = schemaA_newPA;
        cue = 4;
        noncue = 5;
        testOnePA;
        performances_new_cued(trial,:) = perf_cued;
        performances_new_noncued(trial,:) = perf_noncued;
        error_new_cued(trial,:) = err_cued;
        error_new_noncued(trial,:) = err_noncued;
    elseif ismember(trial,A_newPA2_test)
        schema = schemaA_newPA2;
        cue = 4;
        noncue = 5;
        testOnePA;
        performances_new_cued(trial,:) = perf_cued;
        performances_new_noncued(trial,:) = perf_noncued;
        error_new_cued(trial,:) = err_cued;
        error_new_noncued(trial,:) = err_noncued;
        disp 'A new PA ttest'
        [h,p,ci,stats] = ttest((performances_new_cued(31,:)+perf_cued)./2,(performances_new_noncued(31,:)+perf_noncued)./2)
        [h,p] = kstest2((performances_new_cued(31,:)+perf_cued)./2,(performances_new_noncued(31,:)+perf_noncued)./2)
    elseif ismember(trial,C_test)
        schema = schemaC;
        testSchema;
        performances(trial,:) = scores;
        disp 'C test ttest'
        [h,p,ci,stats] = ttest(scores,(1-scores)./4)
        [h,p] = kstest2(scores,1-scores)
        [h,p] = kstest2(scores,A_scores)
    elseif ismember(trial,C_newPA_test)
        schema = schemaC_newPA;
        cue = 4;
        noncue = 5;
        testOnePA;
        performances_new_cued(trial,:) = perf_cued;
        performances_new_noncued(trial,:) = perf_noncued;
        error_new_cued(trial,:) = err_cued;
        error_new_noncued(trial,:) = err_noncued;
    elseif ismember(trial,C_newPA2_test)
        schema = schemaC_newPA2;
        cue = 4;
        noncue = 5;
        testOnePA;
        performances_new_cued(trial,:) = perf_cued;
        performances_new_noncued(trial,:) = perf_noncued;
        error_new_cued(trial,:) = err_cued;
        error_new_noncued(trial,:) = err_noncued;
        disp 'C new PA ttest'
        [h,p,ci,stats] = ttest((performances_new_cued(34,:)+perf_cued)./2,(performances_new_noncued(34,:)+perf_noncued)./2)
        [h,p] = kstest2((performances_new_cued(34,:)+perf_cued)./2,(performances_new_noncued(34,:)+perf_noncued)./2)
    end
end

error_cued = std(performances,0,2)/sqrt(num_rats);
error_noncued = std((1-performances)/4,0,2)/sqrt(num_rats);
performances_orig_noncued =(1-performances_new_cued-performances_new_noncued)/3;
error_orig_noncued = std(performances_orig_noncued,0,2)/sqrt(num_rats);
performances = mean(performances,2);
figure(5);
subplot(1,3,1);
errorbar(1:6,performances(1:6),error_cued(1:6),'or-');
hold on;
errorbar(7:12,performances(7:12),error_cued(7:12),'ob-');
errorbar(13:16,performances(13:16),error_cued(13:16),'or-');
errorbar(17:20,performances(17:20),error_cued(17:20),'ob-');
errorbar(21:22,performances(21:22),error_cued(21:22),'or-');
errorbar(23:24,performances(23:24),error_cued(23:24),'ob-');
errorbar(25:26,performances(25:26),error_cued(25:26),'or-');
errorbar(27:28,performances(27:28),error_cued(27:28),'ob-');
errorbar(29:30,performances(29:30),error_cued(29:30),'or-');
errorbar(32:33,performances(32:33),error_cued(32:33),'ob-');
errorbar(35:36,performances(35:36),error_cued(35:36),'or-');
errorbar(38:39,performances(38:39),error_cued(38:39),'ob-');
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
legend('Consistent','Inconsistent');
title('A) Performance on consistent and inconsistent schemas');
xlabel('Trial');
ylabel('Performance');
hold off;
%
%% Figure 5C, PT, Test consistent and inconsistent schemas
%
figure(5);
subplot(1,3,2);
data = [performances(26),(1-performances(26))/4;performances(28),(1-performances(28))/4];
err = [error_cued(26),error_noncued(26);error_cued(28),error_noncued(28)];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('B) Probe tests');
legend('Cued','Non-Cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'PT1 (Consistent)','PT2 (Inconsistent)'});
%
%% Figure 5D, PT, Test consistent and inconsistent schemas with new PAs
%
figure(5);
subplot(1,3,3);
error_new_cued_3_5 = mean([error_new_cued(31) error_new_cued(37)]);
error_new_noncued_3_5 = mean([error_new_noncued(31) error_new_noncued(37)]);
error_orig_noncued_3_5 = mean([error_orig_noncued(31) error_orig_noncued(37)]);
error_new_cued_4_6 = mean([error_new_cued(34) error_new_cued(40)]);
error_new_noncued_4_6 = mean([error_new_noncued(34) error_new_noncued(40)]);
error_orig_noncued_4_6 = mean([error_orig_noncued(34) error_orig_noncued(40)]);
perf_cued_3_5 = mean([performances_new_cued(31) performances_new_cued(37)]);
perf_noncued_3_5 = mean([performances_new_noncued(31) performances_new_noncued(37)]);
perf_cued_4_6 = mean([performances_new_cued(34) performances_new_cued(40)]);
perf_noncued_4_6 = mean([performances_new_noncued(34) performances_new_noncued(40)]);
data = [perf_cued_3_5,perf_noncued_3_5,(1-perf_cued_3_5-perf_noncued_3_5)/3;perf_cued_4_6,perf_noncued_4_6,(1-perf_cued_4_6-perf_noncued_4_6)/3];
err = [error_new_cued_3_5,error_new_noncued_3_5,error_orig_noncued_3_5;error_new_cued_4_6,error_new_noncued_4_6,error_orig_noncued_4_6];
bar_with_error(data,err);
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('C) Probe test after training 2 new PAs');
legend('New cued','New non-cued','Original non-cued');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'PT3-5 (Consistent)','PT4-6 (Inconsistent)'});

figure(4);
subplot(2,2,2);
fill([6.5, 12.5, 12.5, 6.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
hold on;
fill([16.5, 20.5, 20.5, 16.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([22.5, 24.5, 24.5, 22.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([25.5, 26.5, 26.5, 25.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([28.5, 30.5, 30.5, 28.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([32.5, 34, 34, 32.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
plot(1:(size(schema_activity_3,1)),schema_activity_3);
xlim([0 size(schema_activity_3,1)]);
ylim([0 2500]);
title('C) LC activity, experiment 3');
xlabel('Trial');
ylabel('LC');
hold off;
subplot(2,2,4);
fill([6.5, 12.5, 12.5, 6.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
hold on;
fill([16.5, 20.5, 20.5, 16.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([22.5, 24.5, 24.5, 22.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([25.5, 26.5, 26.5, 25.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([28.5, 30.5, 30.5, 28.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
fill([32.5, 34, 34, 32.5],[4000, 4000, 0, 0],[.8 .8 .8],'EdgeColor','none');
plot(1:size(active_schema_3,1),active_schema_3);
xlim([0 size(schema_activity_3,1)]);
ylim([0 size_contexts+1]);
title('D) Active schema, experiment 3');
xlabel('Trial');
ylabel('Schema');
hold off;

figure(7)
subplot(3,1,1);
plot(1:(size(mPFC_activity_3,1)),mPFC_activity_3);
hold on;
for i = 1:size(schema_activity_3,1)
    line_val = sum(schema_activity_3(1:i,1));
    plot([line_val, line_val],[2.5,0],'k');
end
ylim([0 2.5]);
xlim([0 size(mPFC_activity_3,1)]);
hold off;
title('A) mPFC activity');
xlabel('Epoch');
ylabel('Activity');
subplot(3,1,2);
plot(1:(size(vHPC_activity_3,1)),vHPC_activity_3);
hold on;
for i = 1:size(schema_activity_3,1)
    line_val = sum(schema_activity_3(1:i,1));
    plot([line_val, line_val],[2.5,0],'k');
end
ylim([0 2.5]);
xlim([0 size(vHPC_activity_3,1)]);
hold off;
title('B) vHPC activity');
xlabel('Epoch');
ylabel('Activity');
subplot(3,1,3);
plot(1:100,dHPC_activity_3(1:100,:));
ylim([0 2.5]);
title('C) dHPC activity');
xlabel('Epoch');
ylabel('Activity');

figure(1);
subplot(2,3,1);
imagesc(w_pattern_context(:,:,1));
caxis([0 1])
xlabel('Context Pattern');
ylabel('mPFC');
subplot(2,3,2);
imagesc(w_flavor_multimodal(:,:,1));
caxis([0 1])
xlabel('Cue');
ylabel('AC');
subplot(2,3,3);
imagesc(w_context_multimodal(:,:,1));
caxis([0 1])
xlabel('mPFC');
ylabel('AC');
subplot(2,3,4);
imagesc(w_multimodal_well(:,:,1));
caxis([0 1])
xlabel('AC');
ylabel('Action');
subplot(2,3,5);
imagesc([w_vhipp_dhipp(:,:,1) w_flavor_dhipp(:,:,1) w_well_dhipp(:,:,1)]);
caxis([0 1])
xlabel('vHPC, Cue, Action');
ylabel('dHPC');
subplot(2,3,6);
imagesc(w_context_vhipp(:,:,1));
xlabel('mPFC');
ylabel('vHPC');
%
%% Train 2 schemas in succession with different sparsities
%
days = 20;
schema = schemaA;
has_hipp = true;
sparsity_conditions = [0 .01 .05 .1 .2 .3 .4 1];
for k = 1:length(sparsity_conditions)
    P = sparsity_conditions(k);
    clearNeurons;
    initializeWeights;
    train2Schemas;
    figure(6); % plot performances
    subplot(2,ceil(length(sparsity_conditions)/2),k);
    errA = std(scoresA,0,2)/num_rats;
    errC = std(scoresC,0,2)/num_rats;
    scoresA = mean(scoresA,2);
    scoresC = mean(scoresC,2);
    errorbar(1:days,scoresA,errA,'ro-');
    hold on;
    errorbar(1:days,scoresC,errC,'bo-');
    ylim([0 1]);
    hline = refline([0 1/size(schemaA,1)]);
    hline.LineStyle = '--';
    hline.Color = 'k';
    title(['P = '  num2str(P)])
    xlabel('Trial')
    ylabel('Performance')
    legend('Schema A','Schema B');
    hold off;
    figure(4); % plot activities
    subplot(2,length(sparsity_conditions),k);
    plot(1:(size(schema_activity,1)),schema_activity);
    %ylim([1000 2200]);
    title(['LC activity, P = ' num2str(P)]);
    xlabel('Trial');
    ylabel('LC');
    subplot(2,length(sparsity_conditions),k+length(sparsity_conditions));
    plot(1:size(active_schema,1),active_schema);
    ylim([0 size_contexts+1]);
    title(['Active schema, P = ' num2str(P)]);
    xlabel('Trial');
    ylabel('Schema');
    figure(7); % plot traces
    subplot(3,length(sparsity_conditions),k);
    plot(1:(size(mPFC_activity,1)),mPFC_activity);
    hold on;
    for i = 1:size(schema_activity,1)
        line_val = sum(schema_activity(1:i,1));
        plot([line_val, line_val],[2.5,0],'k');
    end
    ylim([0 2.5]);
    xlim([0 size(mPFC_activity,1)]);
    hold off;
    title(['mPFC activity, P = ' num2str(P)]);
    xlabel('Epoch');
    ylabel('Activity');
    subplot(3,length(sparsity_conditions),k+length(sparsity_conditions));
    plot(1:(size(vHPC_activity,1)),vHPC_activity);
    hold on;
    for i = 1:size(schema_activity,1)
        line_val = sum(schema_activity(1:i,1));
        plot([line_val, line_val],[2.5,0],'k');
    end
    ylim([0 2.5]);
    xlim([0 size(vHPC_activity,1)]);
    hold off;
    title(['vHPC activity, P = ' num2str(P)]);
    xlabel('Epoch');
    ylabel('Activity');
    subplot(3,length(sparsity_conditions),k+2*length(sparsity_conditions));
    plot(1:100,dHPC_activity(1:100,:));
    ylim([0 2.5]);
    title(['dHPC activity, P = ' num2str(P)]);
    xlabel('Epoch');
    ylabel('Activity');
end
figure(1);
subplot(2,3,1);
imagesc(w_pattern_context(:,:,1));
caxis([0 1])
xlabel('Context Pattern');
ylabel('mPFC');
subplot(2,3,2);
imagesc(w_flavor_multimodal(:,:,1));
caxis([0 1])
xlabel('Cue');
ylabel('AC');
subplot(2,3,3);
imagesc(w_context_multimodal(:,:,1));
caxis([0 1])
xlabel('mPFC');
ylabel('AC');
subplot(2,3,4);
imagesc(w_multimodal_well(:,:,1));
caxis([0 1])
xlabel('AC');
ylabel('Action');
subplot(2,3,5);
imagesc([w_vhipp_dhipp(:,:,1) w_flavor_dhipp(:,:,1) w_well_dhipp(:,:,1)]);
caxis([0 1])
xlabel('vHPC, Cue, Action');
ylabel('dHPC');
subplot(2,3,6);
imagesc(w_context_vhipp(:,:,1));
xlabel('mPFC');
ylabel('vHPC');

save('checkpoint4.mat');
%
%% Repeat experiment 1 with different LC conditions
P = .3; % set P back to original conditions
clearNeurons;
initializeWeights;
epochs_param_conditions = [0,400,800,1600]
days1 = 20;
days2 = 1;
%scoresA = zeros(days1,num_rats,length(a_conditions));
%perf_cuedA = zeros(length(a_conditions),1);
%perf_noncuedA = zeros(length(a_conditions),1);
%err_cuedA = zeros(length(a_conditions),1);
%err_noncuedA = zeros(length(a_conditions),1);
%err_origA = zeros(length(a_conditions),1);
scoresA = zeros(days1,num_rats,length(epochs_param_conditions));
perf_cuedA = zeros(length(epochs_param_conditions),1);
perf_noncuedA = zeros(length(epochs_param_conditions),1);
err_cuedA = zeros(length(epochs_param_conditions),1);
err_noncuedA = zeros(length(epochs_param_conditions),1);
err_origA = zeros(length(epochs_param_conditions),1);
%for k = 1:length(a_conditions)
for k = 1:length(epochs_param_conditions)
    total_epochs = 0;
    if k==1
        constant_epochs = false;
    else
        constant_epochs = true;
        epochs_param = epochs_param_conditions(k);
    end
    % Train Schema A
    clearNeurons;
    initializeWeights;
    days = days1;
    schema = schemaA;
    has_hipp = true;
    train1Schema;
    scoresA(:,:,k) = scores;

    % PT, Train Schema A with new PAs
    days = days2;
    schema = schemaA_newPA;
    train1Schema;
    total_epochs
    cue = 4;
    noncue = 5;
    testOnePA;
    perf_cuedA(k) = perf_cued;
    perf_noncuedA(k) = perf_noncued;
    err_cuedA(k) = err_cued;
    err_noncuedA(k) = err_noncued;
    err_origA(k) = err_orig;
end

% Plot results
figure(8);
subplot(1,2,1);
errors_cuedA = std(scoresA,0,2)./sqrt(num_rats);
errors_noncuedA = std(1-scoresA,0,2)./sqrt(num_rats);
performancesA = mean(scoresA,2);
%for k = 1:length(a_conditions)
for k = 1:length(epochs_param_conditions)
    errorbar(1:days1,performancesA(:,:,k),errors_cuedA(:,:,k),'o-');
    hold on;
    ylim([0 1]);
end
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('A) Performance on Schema A');
xlabel('Trial');
ylabel('Performance');
legend('Original','400','800','1600');
hold off;

subplot(1,2,2);
data = [perf_cuedA,perf_noncuedA,(1-perf_cuedA-perf_noncuedA)./3];
err = [err_cuedA,err_noncuedA,err_origA];
bar_with_error(data,err);
hold on;
ylim([0 1]);
hline = refline([0 1/size(schemaA,1)]);
hline.LineStyle = '--';
hline.Color = 'k';
title('B) PT, new PAs');
legend('Cued','Non-Cued','Original');
xlabel('Epochs per trial (Avg total epochs)');
ylabel('Dig Time (%)');
set(gca,'xticklabel',{'Original (13875)','400 (8400)','800 (16800)','1600 (33600)'});
hold off;
