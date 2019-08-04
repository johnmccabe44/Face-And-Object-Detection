load('models\resultsHOGRF.mat')
mdlHOGRF = resultsRF(5).mdl;
save('models\HOGRF.mat','mdlHOGRF');

load('models\resultsSURFRF1000.mat')
mdlSURFRF = resultsRF(5).mdl;
save('models\SURFRF.mat','mdlSURFRF');

clear all;clc;
%%
load('models\HOGRF.mat');
load('models\SURFRF.mat');