
%load data
load('HS.mat');
load('SME.mat');
load('SB.mat');
load('TF.mat');
load('AG.mat');

%calculate beta
[mea1,med1,sd1,ske1,kur1,l11,l21]=beta(data,0.25,0.75);

[mea2,med2,sd2,ske2,kur2,l12,l22]=beta(SME,0.25 ,0.75);

[mea3,med3,sd3,ske3,kur3,l13,l23]=beta(SB,0.25 ,0.75);

[mea4,med4,sd4,ske4,kur4,l14,l24]=beta(TF,0.25,0.75);

[mea5,med5,sd5,ske5,kur5,l15,l25]=beta(AG,0.25 ,0.75);



