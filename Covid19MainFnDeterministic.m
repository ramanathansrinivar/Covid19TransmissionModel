% % Authors S. Ramanathan , Sujatha Sunil, 
% (C) 2020, All rights reserved
%
% SEIR model  to predict Covid19 effect



function [NumMatrix,ProcessedModelDataSet01,ActualDataSet] = Covid19MainFnDeterministic(p1,p2,pChi,pAdu,pSen,InitConditions,CompareWithData,DataFileName)

N = p1(1); % Total population
F_Sen = p1(2); % Fraction of population that is Senior Citizen
F_Adu = p1(3);% Fraction of population that is Adult
F_Chi = p1(4);% Fraction of population that is Children. This is 1- fraction(SenCitizen) - fraction(Adult)


SymptomaticFraction = p1(5); % how much fraction of infected population shows symptom

Tau_E = p1(6); % Exposed period
Tau_I = p1(7); % infectious period (before recovery)
Tau_R = p1(8); % immunity duration, time spent in recovery period
Tau_V = p1(9); % vaccine immunity duration


% 
Tau_E_Inv = 1/Tau_E; % inverse of exposed period
Tau_I_Inv = 1/Tau_I; % inverse of infectious period
Tau_R_Inv = 1/Tau_R; % inverse of immunity period (time spent on recovery)
Tau_V_Inv = 1/Tau_V; % inverse of vaccine immunity period 

p1(10) = Tau_E_Inv;
p1(11) = Tau_I_Inv;
p1(12) = Tau_R_Inv;
p1(13) = Tau_V_Inv;


% disp(p1)

% initial conditions
    Initial_exposed = InitConditions(1);
    Initial_Vaccinated = InitConditions(2);
    Initial_Symptomatic_Infected_Quarantined =InitConditions(3);
    Initial_Symptomatic_Infected_NonQuarantined =InitConditions(4);
    Initial_Asymptomatic_Infected_Quarantined =InitConditions(5);
    Initial_Asymptomatic_Infected_NonQuarantined =InitConditions(6);
    Initial_Symptomatic_Recovered  =InitConditions(7);
    Initial_Asymptomatic_Recovered =InitConditions(8);
    Initial_Symptomatic_Dead=InitConditions(9);
    Initial_Asymptomatic_Dead=InitConditions(10);
  
  % TimePeriod = 22 months.
  
   R0_Array_Symptomatic = p2{1};
   R0_Array_Asymptomatic = p2{2};
   
  qFractionTreated_Array_Symptomatic= p2{3};
  qFractionTreated_Array_Asymptomatic= p2{4};
  
  qFractionChiVaccinated_Array= p2{5};
  qFractionAduVaccinated_Array= p2{6};
  qFractionSenVaccinated_Array= p2{7};
  
disp(p2{7})
   NumMonths = length(R0_Array_Symptomatic);
   
   %MonthLabel
   MonthLabel{1} = 'Mar-20'; NumDays(1)=31;
   MonthLabel{2} = 'Apr-20';NumDays(2)=30;
   MonthLabel{3} = 'May-20';NumDays(3)=31;
   MonthLabel{4} = 'Jun-20';NumDays(4)=30;
   MonthLabel{5} = 'Jul-20';NumDays(5)=31;
   MonthLabel{6} = 'Aug-20';NumDays(6)=31;
   MonthLabel{7} = 'Sep-20';NumDays(7)=30;
   MonthLabel{8} = 'Oct-20';NumDays(8)=31;
   MonthLabel{9} = 'Nov-20';NumDays(9)=30;
   MonthLabel{10} = 'Dec-20';NumDays(10)=31;
   MonthLabel{11} = 'Jan-21';NumDays(11)=31;
   MonthLabel{12} = 'Feb-21';NumDays(12)=28;
   MonthLabel{13} = 'Mar-21';NumDays(13)=31;
   MonthLabel{14} = 'Apr-21';NumDays(14)=30;
   MonthLabel{15} = 'May-21';NumDays(15)=31;
   MonthLabel{16} = 'Jun-21';NumDays(16)=30;
   MonthLabel{17} = 'Jul-21';NumDays(17)=31;
   MonthLabel{18} = 'Aug-21';NumDays(18)=31;
   MonthLabel{19} = 'Sep-21';NumDays(19)=30;
   MonthLabel{20} = 'Oct-21';NumDays(20)=31;
   MonthLabel{21} = 'Nov-21';NumDays(21)=30;
   MonthLabel{22} = 'Dec-21';NumDays(22)=31;
%    
   TotalNumDays(1) = 0+NumDays(1);
    timePeriod{1} = 0:1:(NumDays(1)-1);
    RealTimePeriod{1} = timePeriod{1}+0;
    

   
   for i1 = 2: NumMonths

        TotalNumDays(i1) = TotalNumDays(i1-1)+ NumDays(i1);
        timePeriod{i1} = 0:1:(NumDays(i1)-1);
        RealTimePeriod{i1} = timePeriod{i1} + TotalNumDays(i1-1);

   end
    
   

    for i1=2:(NumMonths-1)
        
    end
    
  
   

NChi = N * F_Chi;
NAdu = N * F_Adu;
NSen = N  * F_Sen;

% Starting point
Initial_susceptible = N - Initial_exposed -Initial_Vaccinated...
    - Initial_Symptomatic_Infected_Quarantined - Initial_Symptomatic_Infected_NonQuarantined ...
    - Initial_Asymptomatic_Infected_Quarantined - Initial_Asymptomatic_Infected_NonQuarantined ...
    -Initial_Symptomatic_Recovered  - Initial_Asymptomatic_Recovered ...
    - Initial_Symptomatic_Dead  -Initial_Asymptomatic_Dead; 


% Generic Y_init (after this, we will distribute it among children, adult
% etc.

Y_init = [Initial_susceptible ; Initial_Vaccinated;
    Initial_exposed ;
    Initial_Symptomatic_Infected_Quarantined ;
    Initial_Symptomatic_Infected_NonQuarantined ;
    Initial_Asymptomatic_Infected_Quarantined ;
    Initial_Asymptomatic_Infected_NonQuarantined ;
    Initial_Symptomatic_Recovered  ;
    Initial_Asymptomatic_Recovered;
    Initial_Symptomatic_Dead;
    Initial_Asymptomatic_Dead ] / N;

% We assume that the fraction of each group remains the same among adult,
% child and senior citizen

Y_init_Chi = Y_init ;
Y_init_Adu = Y_init ;
Y_init_Sen = Y_init ;

% Init, with 30 variable values.
Y_init_Complete = [Y_init_Chi ; Y_init_Adu ; Y_init_Sen];

% Y_init_at_Zero = Y_init_Complete * N;

options = odeset('RelTol',1e-12,'AbsTol',1e-12);



   for i1 = 1:NumMonths

       % in each iteration, we need to set the following four parameters
       % and initial values
       
   p02(1) = R0_Array_Symptomatic(i1);
   p02(2) = R0_Array_Asymptomatic(i1);
   p02(3) = qFractionTreated_Array_Symptomatic(i1);
   p02(4) = qFractionTreated_Array_Asymptomatic(i1);
   p02(5) = qFractionChiVaccinated_Array(i1)/NumDays(i1);  % convert from "per month" to "per day"   
   p02(6) = qFractionAduVaccinated_Array(i1)/NumDays(i1);% convert from "per month" to "per day"
   p02(7) = qFractionSenVaccinated_Array(i1)/NumDays(i1); % convert from "per month" to "per day"
    timePeriod{i1} = 0:1:NumDays(i1);
%  s(Y_init_Complete)
       
[t{i1},Result{i1}] = ode15s(@(t,y)dyCovid19(t,y,p1,p02,pChi,pAdu,pSen),timePeriod{i1},Y_init_Complete,options);

%%

Chi_Susceptible{i1} = NChi * Result{i1}(:,1);
Chi_Vaccinated{i1} = NChi * Result{i1}(:,2);
Chi_Exposed{i1} = NChi * Result{i1}(:,3);
Chi_Symptomatic_Infected_Quarantined{i1}= NChi * Result{i1}(:,4);
Chi_Symptomatic_Infected_NonQuarantined{i1}=NChi * Result{i1}(:,5);
Chi_Asymptomatic_Infected_Quarantined{i1}=NChi * Result{i1}(:,6);
Chi_Asymptomatic_Infected_NonQuarantined{i1}=NChi * Result{i1}(:,7);
Chi_Symptomatic_Recovered{i1} = NChi * Result{i1}(:,8);
Chi_Asymptomatic_Recovered{i1} = NChi * Result{i1}(:,9);
Chi_Symptomatic_Dead{i1}= NChi * Result{i1}(:,10);
Chi_Asymptomatic_Dead{i1}= NChi * Result{i1}(:,11);



Adu_Susceptible{i1} = NAdu * Result{i1}(:,12);
Adu_Vaccinated{i1} = NAdu * Result{i1}(:,13);

Adu_Exposed{i1} = NAdu * Result{i1}(:,14);
Adu_Symptomatic_Infected_Quarantined{i1}= NAdu * Result{i1}(:,15);
Adu_Symptomatic_Infected_NonQuarantined{i1}=NAdu * Result{i1}(:,16);
Adu_Asymptomatic_Infected_Quarantined{i1}=NAdu * Result{i1}(:,17);
Adu_Asymptomatic_Infected_NonQuarantined{i1}=NAdu * Result{i1}(:,18);
Adu_Symptomatic_Recovered{i1} = NAdu * Result{i1}(:,19);
Adu_Asymptomatic_Recovered{i1} = NAdu * Result{i1}(:,20);
Adu_Symptomatic_Dead{i1}= NAdu * Result{i1}(:,21);
Adu_Asymptomatic_Dead{i1}= NAdu * Result{i1}(:,22);



Sen_Susceptible{i1} = NSen * Result{i1}(:,23);
Sen_Vaccinated{i1} = NSen * Result{i1}(:,24);
Sen_Exposed{i1} = NSen * Result{i1}(:,25);
Sen_Symptomatic_Infected_Quarantined{i1}= NSen * Result{i1}(:,26);
Sen_Symptomatic_Infected_NonQuarantined{i1}=NSen * Result{i1}(:,27);
Sen_Asymptomatic_Infected_Quarantined{i1}=NSen * Result{i1}(:,28);
Sen_Asymptomatic_Infected_NonQuarantined{i1}=NSen * Result{i1}(:,29);
Sen_Symptomatic_Recovered{i1} = NSen * Result{i1}(:,30);
Sen_Asymptomatic_Recovered{i1} = NSen * Result{i1}(:,31);
Sen_Symptomatic_Dead{i1}= NSen * Result{i1}(:,32);
Sen_Asymptomatic_Dead{i1}= NSen * Result{i1}(:,33);


% If any exposed or infected population is less than one, then set it to
% zero

if (Chi_Exposed{i1}(end) < 1)
    Chi_Exposed{i1}(end) =0;
end

if (Chi_Vaccinated{i1}(end) < 1)
    Chi_Vaccinated{i1}(end) =0;
end


if (Chi_Symptomatic_Infected_Quarantined{i1}(end) < 1) 
    Chi_Symptomatic_Infected_Quarantined{i1}(end) =0;
end

if (Chi_Symptomatic_Infected_NonQuarantined{i1}(end) < 1) 
    Chi_Symptomatic_Infected_NonQuarantined{i1}(end) =0;
end

if (Chi_Asymptomatic_Infected_Quarantined{i1}(end) < 1) 
    Chi_Asymptomatic_Infected_Quarantined{i1}(end) =0;
end

if (Chi_Asymptomatic_Infected_NonQuarantined{i1}(end) < 1) 
    Chi_Asymptomatic_Infected_NonQuarantined{i1}(end) =0;
end



if (Adu_Exposed{i1}(end) < 1)
    Adu_Exposed{i1}(end) =0;
end
if (Adu_Vaccinated{i1}(end) < 1)
    Adu_Vaccinated{i1}(end) =0;
end

if (Adu_Symptomatic_Infected_Quarantined{i1}(end) < 1)
    Adu_Symptomatic_Infected_Quarantined{i1}(end) =0;
end

if (Adu_Symptomatic_Infected_NonQuarantined{i1}(end) < 1) 
    Adu_Symptomatic_Infected_NonQuarantined{i1}(end) =0;
end

if (Adu_Asymptomatic_Infected_Quarantined{i1}(end) < 1) 
    Adu_Asymptomatic_Infected_Quarantined{i1}(end) =0;
end

if (Adu_Asymptomatic_Infected_NonQuarantined{i1}(end) < 1) 
    Adu_Asymptomatic_Infected_NonQuarantined{i1}(end) =0;
end




if (Sen_Exposed{i1}(end) < 1)
    Sen_Exposed{i1}(end) =0;
end
if (Sen_Vaccinated{i1}(end) < 1)
    Sen_Vaccinated{i1}(end) =0;
end

if (Sen_Symptomatic_Infected_Quarantined{i1}(end) < 1)
    Sen_Symptomatic_Infected_Quarantined{i1}(end) =0;
end

if (Sen_Symptomatic_Infected_NonQuarantined{i1}(end) < 1) 
    Sen_Symptomatic_Infected_NonQuarantined{i1}(end) =0;
end

if (Sen_Asymptomatic_Infected_Quarantined{i1}(end) < 1) 
    Sen_Asymptomatic_Infected_Quarantined{i1}(end) =0;
end

if (Sen_Asymptomatic_Infected_NonQuarantined{i1}(end) < 1) 
    Sen_Asymptomatic_Infected_NonQuarantined{i1}(end) =0;
end

% Set the initial values for the next iteration

Y_init_Chi = [Chi_Susceptible{i1}(end) Chi_Vaccinated{i1}(end) Chi_Exposed{i1}(end)...
    Chi_Symptomatic_Infected_Quarantined{i1}(end) Chi_Symptomatic_Infected_NonQuarantined{i1}(end) ...
Chi_Asymptomatic_Infected_Quarantined{i1}(end) Chi_Asymptomatic_Infected_NonQuarantined{i1}(end) ...
Chi_Symptomatic_Recovered{i1}(end) Chi_Asymptomatic_Recovered{i1}(end) ...
Chi_Symptomatic_Dead{i1}(end) Chi_Asymptomatic_Dead{i1}(end)]/NChi;

Y_init_Adu = [Adu_Susceptible{i1}(end) Adu_Vaccinated{i1}(end) Adu_Exposed{i1}(end)...
    Adu_Symptomatic_Infected_Quarantined{i1}(end) Adu_Symptomatic_Infected_NonQuarantined{i1}(end) ...
Adu_Asymptomatic_Infected_Quarantined{i1}(end) Adu_Asymptomatic_Infected_NonQuarantined{i1}(end) ...
Adu_Symptomatic_Recovered{i1}(end) Adu_Asymptomatic_Recovered{i1}(end) ...
Adu_Symptomatic_Dead{i1}(end) Adu_Asymptomatic_Dead{i1}(end)]/NAdu;

Y_init_Sen = [Sen_Susceptible{i1}(end) Sen_Vaccinated{i1}(end) Sen_Exposed{i1}(end)...
    Sen_Symptomatic_Infected_Quarantined{i1}(end) Sen_Symptomatic_Infected_NonQuarantined{i1}(end) ...
Sen_Asymptomatic_Infected_Quarantined{i1}(end) Sen_Asymptomatic_Infected_NonQuarantined{i1}(end) ...
Sen_Symptomatic_Recovered{i1}(end) Sen_Asymptomatic_Recovered{i1}(end) ...
Sen_Symptomatic_Dead{i1}(end) Sen_Asymptomatic_Dead{i1}(end)]/NSen;

% This sets the initial value for the next iteration


Y_init_Complete = [Y_init_Chi';  Y_init_Adu';  Y_init_Sen'];
   end % of for i1 = 1..

   
   %% Stitch the results so that the last element is removed in each month (except the last month), this is to prevent overlap of the month end with the beginning of next month.

   Chi_Sus_list = Chi_Susceptible{1}(1:(end-1));
   Chi_Vac_list = Chi_Vaccinated{1}(1:(end-1));
   Chi_E_list   = Chi_Exposed{1}(1:(end-1));
   Chi_SQ_list  = Chi_Symptomatic_Infected_Quarantined{1}(1:(end-1));
   Chi_SNQ_list = Chi_Symptomatic_Infected_NonQuarantined{1}(1:(end-1));
   Chi_AsQ_list = Chi_Asymptomatic_Infected_Quarantined{1}(1:(end-1));
   Chi_AsNQ_list= Chi_Asymptomatic_Infected_NonQuarantined{1}(1:(end-1));
   Chi_SR_list  = Chi_Symptomatic_Recovered{1}(1:(end-1));
   Chi_AsR_list = Chi_Asymptomatic_Recovered{1}(1:(end-1));
   Chi_SD_list  = Chi_Symptomatic_Dead{1}(1:(end-1));
   Chi_AsD_list = Chi_Asymptomatic_Dead{1}(1:(end-1));
   
   Adu_Sus_list = Adu_Susceptible{1}(1:(end-1));
   Adu_Vac_list = Adu_Vaccinated{1}(1:(end-1));
   Adu_E_list   = Adu_Exposed{1}(1:(end-1));
   Adu_SQ_list  = Adu_Symptomatic_Infected_Quarantined{1}(1:(end-1));
   Adu_SNQ_list = Adu_Symptomatic_Infected_NonQuarantined{1}(1:(end-1));
   Adu_AsQ_list = Adu_Asymptomatic_Infected_Quarantined{1}(1:(end-1));
   Adu_AsNQ_list= Adu_Asymptomatic_Infected_NonQuarantined{1}(1:(end-1));
   Adu_SR_list  = Adu_Symptomatic_Recovered{1}(1:(end-1));
   Adu_AsR_list = Adu_Asymptomatic_Recovered{1}(1:(end-1));
   Adu_SD_list  = Adu_Symptomatic_Dead{1}(1:(end-1));
   Adu_AsD_list = Adu_Asymptomatic_Dead{1}(1:(end-1));
   
   Sen_Sus_list = Sen_Susceptible{1}(1:(end-1));
   Sen_Vac_list = Sen_Vaccinated{1}(1:(end-1));
   Sen_E_list   = Sen_Exposed{1}(1:(end-1));
   Sen_SQ_list  = Sen_Symptomatic_Infected_Quarantined{1}(1:(end-1));
   Sen_SNQ_list = Sen_Symptomatic_Infected_NonQuarantined{1}(1:(end-1));
   Sen_AsQ_list = Sen_Asymptomatic_Infected_Quarantined{1}(1:(end-1));
   Sen_AsNQ_list= Sen_Asymptomatic_Infected_NonQuarantined{1}(1:(end-1));
   Sen_SR_list  = Sen_Symptomatic_Recovered{1}(1:(end-1));
   Sen_AsR_list = Sen_Asymptomatic_Recovered{1}(1:(end-1));
   Sen_SD_list  = Sen_Symptomatic_Dead{1}(1:(end-1));
   Sen_AsD_list = Sen_Asymptomatic_Dead{1}(1:(end-1));
   

   
   for i1=2:(NumMonths-1)


   Chi_Sus_list = [Chi_Sus_list ; Chi_Susceptible{i1}(1:(end-1))];
   Chi_Vac_list = [Chi_Vac_list ; Chi_Vaccinated{i1}(1:(end-1))];
   Chi_E_list = [Chi_E_list ; Chi_Exposed{i1}(1:(end-1))];
   Chi_SQ_list =[Chi_SQ_list; Chi_Symptomatic_Infected_Quarantined{i1}(1:(end-1))];
   Chi_SNQ_list = [ Chi_SNQ_list ;Chi_Symptomatic_Infected_NonQuarantined{i1}(1:(end-1))];
   Chi_AsQ_list = [ Chi_AsQ_list ;Chi_Asymptomatic_Infected_Quarantined{i1}(1:(end-1))];
   Chi_AsNQ_list = [Chi_AsNQ_list; Chi_Asymptomatic_Infected_NonQuarantined{i1}(1:(end-1))];
   Chi_SR_list   = [Chi_SR_list ;  Chi_Symptomatic_Recovered{i1}(1:(end-1))];
   Chi_AsR_list  = [Chi_AsR_list ; Chi_Asymptomatic_Recovered{i1}(1:(end-1))];
   Chi_SD_list   = [Chi_SD_list ;  Chi_Symptomatic_Dead{i1}(1:(end-1))];
   Chi_AsD_list  = [Chi_AsD_list ; Chi_Asymptomatic_Dead{i1}(1:(end-1))];
   
   Adu_Sus_list = [Adu_Sus_list ; Adu_Susceptible{i1}(1:(end-1))];
   Adu_Vac_list = [Adu_Vac_list ; Adu_Vaccinated{i1}(1:(end-1))];
   Adu_E_list = [Adu_E_list; Adu_Exposed{i1}(1:(end-1))];
   Adu_SQ_list =[Adu_SQ_list; Adu_Symptomatic_Infected_Quarantined{i1}(1:(end-1))];
   Adu_SNQ_list = [ Adu_SNQ_list; Adu_Symptomatic_Infected_NonQuarantined{i1}(1:(end-1))];
   Adu_AsQ_list = [ Adu_AsQ_list; Adu_Asymptomatic_Infected_Quarantined{i1}(1:(end-1))];
   Adu_AsNQ_list = [Adu_AsNQ_list; Adu_Asymptomatic_Infected_NonQuarantined{i1}(1:(end-1))];
   Adu_SR_list   = [Adu_SR_list ;  Adu_Symptomatic_Recovered{i1}(1:(end-1))];
   Adu_AsR_list  = [Adu_AsR_list ; Adu_Asymptomatic_Recovered{i1}(1:(end-1))];
   Adu_SD_list   = [Adu_SD_list ;  Adu_Symptomatic_Dead{i1}(1:(end-1))];
   Adu_AsD_list  = [Adu_AsD_list ; Adu_Asymptomatic_Dead{i1}(1:(end-1))];
   
   
   Sen_Sus_list = [Sen_Sus_list ; Sen_Susceptible{i1}(1:(end-1))];
   Sen_Vac_list = [Sen_Vac_list ; Sen_Vaccinated{i1}(1:(end-1))];
   Sen_E_list = [Sen_E_list; Sen_Exposed{i1}(1:(end-1))];
   Sen_SQ_list =[Sen_SQ_list ;Sen_Symptomatic_Infected_Quarantined{i1}(1:(end-1))];
   Sen_SNQ_list = [ Sen_SNQ_list; Sen_Symptomatic_Infected_NonQuarantined{i1}(1:(end-1))];
   Sen_AsQ_list = [ Sen_AsQ_list; Sen_Asymptomatic_Infected_Quarantined{i1}(1:(end-1))];
   Sen_AsNQ_list = [Sen_AsNQ_list; Sen_Asymptomatic_Infected_NonQuarantined{i1}(1:(end-1))];
   Sen_SR_list   = [Sen_SR_list ;  Sen_Symptomatic_Recovered{i1}(1:(end-1))];
   Sen_AsR_list  = [Sen_AsR_list ; Sen_Asymptomatic_Recovered{i1}(1:(end-1))];
   Sen_SD_list   = [Sen_SD_list ;  Sen_Symptomatic_Dead{i1}(1:(end-1))];
   Sen_AsD_list  = [Sen_AsD_list ; Sen_Asymptomatic_Dead{i1}(1:(end-1))];
   
   end
   
   %% Final month. Use till the end
   
   i1 = NumMonths;
   Chi_Sus_list = [Chi_Sus_list ; Chi_Susceptible{i1}];
   Chi_Vac_list = [Chi_Vac_list ; Chi_Vaccinated{i1}];
   
   Chi_E_list = [Chi_E_list ; Chi_Exposed{i1}];
   Chi_SQ_list =[Chi_SQ_list; Chi_Symptomatic_Infected_Quarantined{i1}];
   Chi_SNQ_list = [ Chi_SNQ_list ;Chi_Symptomatic_Infected_NonQuarantined{i1}];
   Chi_AsQ_list = [ Chi_AsQ_list ;Chi_Asymptomatic_Infected_Quarantined{i1}];
   Chi_AsNQ_list = [Chi_AsNQ_list; Chi_Asymptomatic_Infected_NonQuarantined{i1}];
   Chi_SR_list   = [Chi_SR_list ;  Chi_Symptomatic_Recovered{i1}];
   Chi_AsR_list  = [Chi_AsR_list ; Chi_Asymptomatic_Recovered{i1}];
   Chi_SD_list   = [Chi_SD_list ;  Chi_Symptomatic_Dead{i1}];
   Chi_AsD_list  = [Chi_AsD_list ; Chi_Asymptomatic_Dead{i1}];
   
   Adu_Sus_list = [Adu_Sus_list ; Adu_Susceptible{i1}];
   Adu_Vac_list = [Adu_Vac_list ; Adu_Vaccinated{i1}];
   Adu_E_list = [Adu_E_list; Adu_Exposed{i1}];
   Adu_SQ_list =[Adu_SQ_list; Adu_Symptomatic_Infected_Quarantined{i1}];
   Adu_SNQ_list = [ Adu_SNQ_list; Adu_Symptomatic_Infected_NonQuarantined{i1}];
   Adu_AsQ_list = [ Adu_AsQ_list; Adu_Asymptomatic_Infected_Quarantined{i1}];
   Adu_AsNQ_list = [Adu_AsNQ_list; Adu_Asymptomatic_Infected_NonQuarantined{i1}];
   Adu_SR_list   = [Adu_SR_list ;  Adu_Symptomatic_Recovered{i1}];
   Adu_AsR_list  = [Adu_AsR_list ; Adu_Asymptomatic_Recovered{i1}];
   Adu_SD_list   = [Adu_SD_list ;  Adu_Symptomatic_Dead{i1}];
   Adu_AsD_list  = [Adu_AsD_list ; Adu_Asymptomatic_Dead{i1}];
   
   
   Sen_Sus_list = [Sen_Sus_list ; Sen_Susceptible{i1}];
   Sen_Vac_list = [Sen_Vac_list ; Sen_Vaccinated{i1}];
   Sen_E_list = [Sen_E_list; Sen_Exposed{i1}];
   Sen_SQ_list =[Sen_SQ_list ;Sen_Symptomatic_Infected_Quarantined{i1}];
   Sen_SNQ_list = [ Sen_SNQ_list; Sen_Symptomatic_Infected_NonQuarantined{i1}];
   Sen_AsQ_list = [ Sen_AsQ_list; Sen_Asymptomatic_Infected_Quarantined{i1}];
   Sen_AsNQ_list = [Sen_AsNQ_list; Sen_Asymptomatic_Infected_NonQuarantined{i1}];
   Sen_SR_list   = [Sen_SR_list ;  Sen_Symptomatic_Recovered{i1}];
   Sen_AsR_list  = [Sen_AsR_list ; Sen_Asymptomatic_Recovered{i1}];
   Sen_SD_list   = [Sen_SD_list ;  Sen_Symptomatic_Dead{i1}];
   Sen_AsD_list  = [Sen_AsD_list ; Sen_Asymptomatic_Dead{i1}];
  
  


t_Complete = RealTimePeriod{1};

for i1=2:NumMonths
t_Complete = [t_Complete RealTimePeriod{i1}];
end

lastValue = t_Complete(end) +1;
t_Complete =[t_Complete lastValue];


% Assemble the results in NumMatrix
NumMatrix = [t_Complete' Chi_Sus_list Chi_Vac_list Chi_E_list Chi_SQ_list Chi_SNQ_list ...
    Chi_AsQ_list Chi_AsNQ_list Chi_SR_list Chi_AsR_list Chi_SD_list Chi_AsD_list ...
    Adu_Sus_list Adu_Vac_list Adu_E_list Adu_SQ_list Adu_SNQ_list...
        Adu_AsQ_list Adu_AsNQ_list Adu_SR_list Adu_AsR_list Adu_SD_list Adu_AsD_list ...
    Sen_Sus_list Sen_Vac_list Sen_E_list Sen_SQ_list Sen_SNQ_list...
        Sen_AsQ_list Sen_AsNQ_list Sen_SR_list Sen_AsR_list Sen_SD_list Sen_AsD_list ];



ModelDataSet = NumMatrix;

ModelDataSet(:,2:12) = ModelDataSet(:,2:12)/NChi;
ModelDataSet(:,13:23) = ModelDataSet(:,13:23)/NAdu;
ModelDataSet(:,24:34) = ModelDataSet(:,24:34)/NSen;


% The above data shows the # of suspectible, exposed, etc. in a given day (and NOT the 
%number of susceptible, exposed etc. added on that day). In order to get that,
% We use NumberAddedEveryDay function.

j1 = 0;
       for i1=1:NumMonths
       
   p02(1) = R0_Array_Symptomatic(i1);
   p02(2) = R0_Array_Asymptomatic(i1);
   p02(3) = qFractionTreated_Array_Symptomatic(i1);
   p02(4) = qFractionTreated_Array_Asymptomatic(i1);
   p02(5) = qFractionChiVaccinated_Array(i1);   
   p02(6) = qFractionAduVaccinated_Array(i1);
   p02(7) = qFractionSenVaccinated_Array(i1); 
   
           for k1 = 0:1:(NumDays(i1)-1)
               
           j1 = j1+1;
            y=ModelDataSet(j1,2:34)';
            dyPositive= NumberAddedEveryDay(p1,p02,pChi,pAdu,pSen,y);
            ProcessedModelDataSet (j1,:) = dyPositive';
           end
           


       end
       
       % Work on the last row
        j1 = j1+1;
%            disp(['Month=' num2str(i1) ', j1 = ' num2str(j1)]);
               
            y=ModelDataSet(j1,2:34)';
            dyPositive= NumberAddedEveryDay(p1,p02,pChi,pAdu,pSen,y);
            ProcessedModelDataSet (j1,:) = dyPositive';
            
           
        % get the numbers as fractions, and then get back to
       % numbers
       ProcessedModelDataSet(:,1:11) = ProcessedModelDataSet(:,1:11)*NChi; 
       ProcessedModelDataSet(:,12:22) = ProcessedModelDataSet(:,12:22)*NAdu; 
       ProcessedModelDataSet(:,23:33) = ProcessedModelDataSet(:,23:33)*NSen; 
       

% If the choice is to compare with data, then load data
       
 if CompareWithData

     
try
    
     A = readtable(DataFileName);



NumDaysValues = A{:,'NumDays'};
ConfirmedValues = A{:,'Confirmed'};
RecoveredValues= A{:,'Recovered'};
DeceasedValues= A{:,'Deceased'};

ActualDataSet = [NumDaysValues  ConfirmedValues RecoveredValues DeceasedValues] ;

catch ME

uiwait(warndlg(strcat(ME.message,sprintf('\nProblem in Reading the data file\r\n'),DataFileName,sprintf('\nPlease correct this and re-run'))));

end


 else
       
       ActualDataSet = 0;
       % do nothing
 end
 
% Round the number of persons to integers
 NumMatrix = round(NumMatrix,0);
 ProcessedModelDataSet = round(ProcessedModelDataSet,0);
 ProcessedModelDataSet01 =[t_Complete' ProcessedModelDataSet];
%   Plot_Covid19_Results01(NumMatrix);



end % main function