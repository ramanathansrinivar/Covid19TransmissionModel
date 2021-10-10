% Authors S. Ramanathan , Sujatha Sunil, 
% (C) 2020, All rights reserved
%
% SEIR model  to predict Covid19 effect



function [NumMatrix,ProcessedModelDataSet01,ModelStdevDataSet,ActualDataSet] = Covid19MainFnMonteCarlo(p1,p2,pChi,pAdu,pSen,InitConditions,CompareWithData,DataFileName,VariationPercent,NumRuns)


% vary the paramters within the % and then 
% Call deterministic function, organize the results
% and then finally plot

% We will vary the parameters

for i1 = 1:NumRuns
% p1New = p1 .* (1+ (rand(length(p1),1)-0.5)*VariationPercent/100);


p1New = p1;


% N = p1(1); % Total population
% F_Sen = p1(2); % Fraction of population that is Senior Citizen
% F_Adu = p1(3);% Fraction of population that is Adult
% F_Chi = p1(4);% Fraction of population that is Children. This is 1- fraction(SenCitizen) - fraction(Adult)


SymptomaticFraction = p1(5); % how much fraction of infected population shows symptom
Tau_E = p1(6); % Exposed period
Tau_I = p1(7); % infectious period (before recovery)
Tau_R = p1(8); % immunity duration, time spent in recovery period
Tau_V = p1(9); % vaccine immunity duration

SymptomaticFractionNew = SymptomaticFraction .* (1+ (rand(length(SymptomaticFraction),1)-0.5)*VariationPercent/100);
Tau_ENew = Tau_E .* (1+ (rand(length(Tau_E),1)-0.5)*VariationPercent/100);
Tau_INew = Tau_I .* (1+ (rand(length(Tau_I),1)-0.5)*VariationPercent/100);
Tau_RNew = Tau_R .* (1+ (rand(length(Tau_R),1)-0.5)*VariationPercent/100);
Tau_VNew = Tau_V .* (1+ (rand(length(Tau_V),1)-0.5)*VariationPercent/100);



p1New(5) =SymptomaticFractionNew ; % how much fraction of infected population shows symptom
p1New(6) =Tau_ENew ; % Exposed period
p1New(7) =Tau_INew ; % infectious period (before recovery)
p1New(8) =Tau_RNew ; % immunity duration, time spent in recovery period
p1New(9) =Tau_VNew ; % vaccine immunity duration


% p2 is a cell, has to be handled correctly
   R0_Array_Symptomatic = p2{1};
   R0_Array_Asymptomatic = p2{2};
   
  qFractionTreated_Array_Symptomatic= p2{3};
  qFractionTreated_Array_Asymptomatic= p2{4};
  qFractionChiVaccinated_Array= p2{5};
  qFractionAduVaccinated_Array= p2{6};
  qFractionSenVaccinated_Array= p2{7};
  
  
   R0_Array_SymptomaticNew = R0_Array_Symptomatic .* (1+ (rand(length(R0_Array_Symptomatic),1)-0.5)*VariationPercent/100);
   R0_Array_AsymptomaticNew =R0_Array_Asymptomatic .* (1+ (rand(length(R0_Array_Asymptomatic),1)-0.5)*VariationPercent/100); 
   
  qFractionTreated_Array_SymptomaticNew= qFractionTreated_Array_Symptomatic .* (1+ (rand(length(qFractionTreated_Array_Symptomatic),1)-0.5)*VariationPercent/100);
  qFractionTreated_Array_AsymptomaticNew= qFractionTreated_Array_Asymptomatic .* (1+ (rand(length(qFractionTreated_Array_Asymptomatic),1)-0.5)*VariationPercent/100);
 
 qFractionChiVaccinated_ArrayNew= qFractionChiVaccinated_Array .* (1+ (rand(length(qFractionChiVaccinated_Array),1)-0.5)*VariationPercent/100);
 qFractionAduVaccinated_ArrayNew= qFractionAduVaccinated_Array .* (1+ (rand(length(qFractionAduVaccinated_Array),1)-0.5)*VariationPercent/100);
 qFractionSenVaccinated_ArrayNew= qFractionSenVaccinated_Array.* (1+ (rand(length(qFractionSenVaccinated_Array),1)-0.5)*VariationPercent/100);
  
  
p2New{1} = R0_Array_SymptomaticNew;
p2New{2} = R0_Array_AsymptomaticNew;
p2New{3} = qFractionTreated_Array_SymptomaticNew;
p2New{4} = qFractionTreated_Array_AsymptomaticNew;
p2New{5} = qFractionChiVaccinated_ArrayNew;
p2New{6} = qFractionAduVaccinated_ArrayNew;
p2New{7} = qFractionSenVaccinated_ArrayNew;

pChiNew = pChi .* (1+ (rand(length(pChi),1)-0.5)*VariationPercent/100);
pAduNew = pAdu .* (1+ (rand(length(pAdu),1)-0.5)*VariationPercent/100);
pSenNew = pSen .* (1+ (rand(length(pSen),1)-0.5)*VariationPercent/100);


[NumMatrixIndividual(:,:,i1),ProcessedModelDataSetIndividual(:,:,i1),ActualDataSet] = Covid19MainFnDeterministic(p1New,p2New,pChiNew,pAduNew,pSenNew,InitConditions,CompareWithData,DataFileName); 

% disp(num2str(i1));
% size(NumMatrixIndividual)
% size(ProcessedModelDataSetIndividual)
end

NumMatrix = mean(NumMatrixIndividual,3);
ProcessedModelDataSet01= round(mean(ProcessedModelDataSetIndividual,3),0);
ModelStdevDataSet= round(std(ProcessedModelDataSetIndividual,0,3),0);




end % main function