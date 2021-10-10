function dy = dyCovid19(t,y,p1,p02,pChi,pAdu,pSen)
dy = zeros(30,1);

N = p1(1); % Total population
F_Sen = p1(2); % Fraction of population that is Senior Citizen
F_Adu = p1(3);% Fraction of population that is Adult
F_Chi = p1(4);% Fraction of population that is Children. This is 1- fraction(SenCitizen) - fraction(Adult)


SymptomaticFraction = p1(5); % how much fraction of infected population shows symptom

Tau_E = p1(6); % Exposed period
Tau_I = p1(7); % infectious period (before recovery)
Tau_R = p1(8); % immunity duration, time spent in recovery period
Tau_V = p1(9); % vaccine immunity duration


Tau_E_Inv = p1(10); % inverse of exposed period
Tau_I_Inv = p1(11); % inverse of infectious period
Tau_R_Inv = p1(12); % inverse of immunity period (time spent on recovery)
Tau_V_Inv = p1(13); % inverse of vaccine immunity period 



% Note: in the main program, the following were arrays, here they are
% scalars
   R0_Symptomatic = p02(1);
   R0_Asymptomatic = p02(2);
   qFractionTreated_Symptomatic= p02(3);
   qFractionTreated_Asymptomatic= p02(4);
   
   
   qFraction_Chi_Vaccinated = p02(5);
   qFraction_Adu_Vaccinated = p02(6);
   qFraction_Sen_Vaccinated = p02(7);
   
   

% Following parameters relate to children
deathrate_Chi_Symptomatic_Quarantined =pChi(1); % death rate of covid infected patients, quarantined, hopefully moderate,
deathrate_Chi_Symptomatic_Nonquarantined =pChi(2); % death rate of covid infected patients, nonquarantined, probably high
deathrate_Chi_Asymptomatic_Quarantined =pChi(3); % death rate of covid infected patients, quarantined, likely very low
deathrate_Chi_Asymptomatic_Nonquarantined =pChi(4); % death rate of covid infected patients, nonquarantined, likely very low

% Following parameters relate to Adults
deathrate_Adu_Symptomatic_Quarantined =pAdu(1); % death rate of covid infected patients, quarantined, hopefully moderate,
deathrate_Adu_Symptomatic_Nonquarantined =pAdu(2); % death rate of covid infected patients, nonquarantined, probably high
deathrate_Adu_Asymptomatic_Quarantined =pAdu(3); % death rate of covid infected patients, quarantined, likely very low
deathrate_Adu_Asymptomatic_Nonquarantined =pAdu(4); % death rate of covid infected patients, nonquarantined, likely very low
% Following parameters relate to Senior Citizen
deathrate_Sen_Symptomatic_Quarantined =pSen(1); % death rate of covid infected patients, quarantined, hopefully moderate,
deathrate_Sen_Symptomatic_Nonquarantined =pSen(2); % death rate of covid infected patients, nonquarantined, probably high
deathrate_Sen_Asymptomatic_Quarantined =pSen(3); % death rate of covid infected patients, quarantined, likely very low
deathrate_Sen_Asymptomatic_Nonquarantined =pSen(4); % death rate of covid infected patients, nonquarantined, likely very low

% beta_Symptomatic = R0_Symptomatic * Tau_I_Inv;
% beta_Asymptomatic = R0_Asymptomatic * Tau_I_Inv;

Chi_Susceptible=y(1); % 
Chi_Vaccinated=y(2);
Chi_Exposed = y(3);

Chi_Symptomatic_Infected_Quarantined = y(4);
Chi_Symptomatic_Infected_NonQuarantined = y(5);

Chi_Asymptomatic_Infected_Quarantined = y(6);
Chi_Asymptomatic_Infected_NonQuarantined = y(7);


Chi_Symptomatic_Recovered = y(8);
Chi_Asymptomatic_Recovered = y(9);

Chi_Symptomatic_Dead = y(10);
Chi_Asymptomatic__Dead = y(11);




Adu_Susceptible=y(12); %
Adu_Vaccinated=y(13);
Adu_Exposed = y(14);

Adu_Symptomatic_Infected_Quarantined = y(15);
Adu_Symptomatic_Infected_NonQuarantined = y(16);

Adu_Asymptomatic_Infected_Quarantined = y(17);
Adu_Asymptomatic_Infected_NonQuarantined = y(18);


Adu_Symptomatic_Recovered = y(19);
Adu_Asymptomatic_Recovered = y(20);

Adu_Symptomatic_Dead = y(21);
Adu_Asymptomatic__Dead = y(22);

Sen_Susceptible=y(23); % 
Sen_Vaccinated = y(24);
Sen_Exposed = y(25);

Sen_Symptomatic_Infected_Quarantined = y(26);
Sen_Symptomatic_Infected_NonQuarantined = y(27);

Sen_Asymptomatic_Infected_Quarantined = y(28);
Sen_Asymptomatic_Infected_NonQuarantined = y(29);


Sen_Symptomatic_Recovered = y(30);
Sen_Asymptomatic_Recovered = y(31);

Sen_Symptomatic_Dead = y(32);
Sen_Asymptomatic__Dead = y(33);


Chi_Infected_Symptomatic = Chi_Symptomatic_Infected_Quarantined+ Chi_Symptomatic_Infected_NonQuarantined;
Chi_Infected_Asymptomatic = Chi_Asymptomatic_Infected_Quarantined+ Chi_Asymptomatic_Infected_NonQuarantined;

Adu_Infected_Symptomatic = Adu_Symptomatic_Infected_Quarantined+ Adu_Symptomatic_Infected_NonQuarantined;
Adu_Infected_Asymptomatic = Adu_Asymptomatic_Infected_Quarantined+ Adu_Asymptomatic_Infected_NonQuarantined;

Sen_Infected_Symptomatic = Sen_Symptomatic_Infected_Quarantined+ Sen_Symptomatic_Infected_NonQuarantined;
Sen_Infected_Asymptomatic = Sen_Asymptomatic_Infected_Quarantined+ Sen_Asymptomatic_Infected_NonQuarantined;

Infected_Symptomatic = Chi_Infected_Symptomatic * F_Chi + Adu_Infected_Symptomatic * F_Adu + Sen_Infected_Symptomatic * F_Sen;
Infected_Asymptomatic = Chi_Infected_Asymptomatic * F_Chi+ Adu_Infected_Asymptomatic * F_Adu + Sen_Infected_Asymptomatic * F_Sen;


% N = Susceptible + Exposed + Infected + Quarantined + Recovered + Dead;
% number of susceptible people moving to exposed section, and moving from
% recovered to susceptible
dy(1) = Tau_R_Inv * (Chi_Symptomatic_Recovered+ Chi_Asymptomatic_Recovered) +Tau_V_Inv * Chi_Vaccinated ...
- Chi_Susceptible *qFraction_Chi_Vaccinated - Tau_I_Inv * (R0_Symptomatic *  Infected_Symptomatic + R0_Asymptomatic *  Infected_Asymptomatic ) * Chi_Susceptible;

% Vaccinated
dy(2) = Chi_Susceptible *qFraction_Chi_Vaccinated - Tau_V_Inv * Chi_Vaccinated; 
% number of exposed, coming from susceptible and moving to infected
dy(3) = Tau_I_Inv *(R0_Symptomatic *  Infected_Symptomatic + R0_Asymptomatic * Infected_Asymptomatic ) * Chi_Susceptible - Tau_E_Inv * Chi_Exposed;

% number of infected symptomatic, quarantined, coming from exposed and moving to recovered, or dead

dy(4)= SymptomaticFraction * qFractionTreated_Symptomatic * Tau_E_Inv * Chi_Exposed ...
    -  (Tau_I_Inv + deathrate_Chi_Symptomatic_Quarantined) * Chi_Symptomatic_Infected_Quarantined ;

% number of infected symptomatic, nonquarantined, coming from exposed and moving to recovered, or dead
dy(5)= SymptomaticFraction * (1-qFractionTreated_Symptomatic )* Tau_E_Inv * Chi_Exposed ...
    -  (Tau_I_Inv + deathrate_Chi_Symptomatic_Nonquarantined) * Chi_Symptomatic_Infected_NonQuarantined ;

% number of infected asymptomatic, quarantined, coming from exposed and moving to recovered, oror dead

dy(6)= (1-SymptomaticFraction) * qFractionTreated_Asymptomatic * Tau_E_Inv * Chi_Exposed  ...
    - (Tau_I_Inv + deathrate_Chi_Asymptomatic_Quarantined) * Chi_Asymptomatic_Infected_Quarantined ;

% number of infected asymptomatic, nonquarantined, coming from exposed and moving to recovered, or dead
dy(7)= (1-SymptomaticFraction) * (1-qFractionTreated_Asymptomatic )* Tau_E_Inv * Chi_Exposed ...
    -  (Tau_I_Inv + deathrate_Chi_Asymptomatic_Nonquarantined) * Chi_Asymptomatic_Infected_NonQuarantined ;


% number recovered,  who were originally symptomatic 
% quanratined and nonquarantined
% minus moving to susceptible
dy(8) = Tau_I_Inv  * (  Chi_Symptomatic_Infected_Quarantined +   Chi_Symptomatic_Infected_NonQuarantined)... 
     - Tau_R_Inv * Chi_Symptomatic_Recovered;

% number recovered,  who were originally asymptomatic 
% quanratined and nonquarantined
% minus moving to susceptible
dy(9) = Tau_I_Inv * ( Chi_Asymptomatic_Infected_Quarantined + Chi_Asymptomatic_Infected_NonQuarantined) ... 
     - Tau_R_Inv * Chi_Asymptomatic_Recovered;


% number dead, symptomatic 
dy(10) = deathrate_Chi_Symptomatic_Quarantined * Chi_Symptomatic_Infected_Quarantined ...
    +   deathrate_Chi_Symptomatic_Nonquarantined * Chi_Symptomatic_Infected_NonQuarantined;
    
% number dead, asymptomatic 

dy(11) =   deathrate_Chi_Asymptomatic_Quarantined * Chi_Asymptomatic_Infected_Quarantined ...
    + deathrate_Chi_Asymptomatic_Nonquarantined * Chi_Asymptomatic_Infected_NonQuarantined; 




%% ADULTS
% N = Susceptible + Exposed + Infected + Quarantined + Recovered + Dead;
% number of susceptible people moving to exposed section, and moving from
% recovered to susceptible
dy(12) = Tau_R_Inv * (Adu_Symptomatic_Recovered+ Adu_Asymptomatic_Recovered) +Tau_V_Inv * Adu_Vaccinated ...
- Adu_Susceptible *qFraction_Adu_Vaccinated - Tau_I_Inv *(R0_Symptomatic * Infected_Symptomatic + R0_Asymptomatic * Infected_Asymptomatic ) * Adu_Susceptible;


%Adu vaccinated
dy(13) =Adu_Susceptible *qFraction_Adu_Vaccinated - Tau_V_Inv * Adu_Vaccinated; 
% number of exposed, coming from susceptible and moving to infected
dy(14) = Tau_I_Inv * (R0_Symptomatic * Infected_Symptomatic + R0_Asymptomatic * Infected_Asymptomatic ) * Adu_Susceptible - Tau_E_Inv * Adu_Exposed;

% number of infected symptomatic, quarantined, coming from exposed and moving to recovered, or dead

dy(15)= SymptomaticFraction * qFractionTreated_Symptomatic * Tau_E_Inv * Adu_Exposed ...
    -  (Tau_I_Inv + deathrate_Adu_Symptomatic_Quarantined) * Adu_Symptomatic_Infected_Quarantined ;

% number of infected symptomatic, nonquarantined, coming from exposed and moving to recovered, or dead
dy(16)= SymptomaticFraction * (1-qFractionTreated_Symptomatic)* Tau_E_Inv * Adu_Exposed ...
    -  (Tau_I_Inv + deathrate_Adu_Symptomatic_Nonquarantined) * Adu_Symptomatic_Infected_NonQuarantined ;

% number of infected asymptomatic, quarantined, coming from exposed and moving to recovered, oror dead

dy(17)= (1-SymptomaticFraction) * qFractionTreated_Asymptomatic* Tau_E_Inv * Adu_Exposed  ...
    - (Tau_I_Inv + deathrate_Adu_Asymptomatic_Quarantined) * Adu_Asymptomatic_Infected_Quarantined ;

% number of infected asymptomatic, nonquarantined, coming from exposed and moving to recovered, or dead
dy(18)= (1-SymptomaticFraction) * (1-qFractionTreated_Asymptomatic)* Tau_E_Inv * Adu_Exposed ...
    -  (Tau_I_Inv + deathrate_Adu_Asymptomatic_Nonquarantined) * Adu_Asymptomatic_Infected_NonQuarantined ;


% number recovered,  who were originally symptomatic 
% quanratined and nonquarantined
% minus moving to susceptible
dy(19) = Tau_I_Inv   *(  Adu_Symptomatic_Infected_Quarantined +   Adu_Symptomatic_Infected_NonQuarantined)... 
     - Tau_R_Inv * Adu_Symptomatic_Recovered;

% number recovered,  who were originally asymptomatic 
% quanratined and nonquarantined
% minus moving to susceptible
dy(20) = Tau_I_Inv * ( Adu_Asymptomatic_Infected_Quarantined + Adu_Asymptomatic_Infected_NonQuarantined) ... 
     - Tau_R_Inv * Adu_Asymptomatic_Recovered;


% number dead, symptomatic 
dy(21) = deathrate_Adu_Symptomatic_Quarantined * Adu_Symptomatic_Infected_Quarantined ...
    +   deathrate_Adu_Symptomatic_Nonquarantined * Adu_Symptomatic_Infected_NonQuarantined;
    
% number dead, asymptomatic 

dy(22) =   deathrate_Adu_Asymptomatic_Quarantined * Adu_Asymptomatic_Infected_Quarantined ...
    + deathrate_Adu_Asymptomatic_Nonquarantined * Adu_Asymptomatic_Infected_NonQuarantined; 


%% Senior Citizens
% N = Susceptible + Exposed + Infected + Quarantined + Recovered + Dead;
% number of susceptible people moving to exposed section, and moving from
% recovered to susceptible
dy(23) = Tau_R_Inv * (Sen_Symptomatic_Recovered+ Sen_Asymptomatic_Recovered) +Tau_V_Inv * Sen_Vaccinated ...
- Sen_Susceptible *qFraction_Sen_Vaccinated - Tau_I_Inv *(R0_Symptomatic *  Infected_Symptomatic + R0_Asymptomatic * Infected_Asymptomatic ) * Sen_Susceptible;



% Senior citizens vaccinated
dy(24)=Sen_Susceptible *qFraction_Sen_Vaccinated - Tau_V_Inv * Sen_Vaccinated;
% number of exposed, coming from susceptible and moving to infected
dy(25) = Tau_I_Inv * (R0_Symptomatic * Infected_Symptomatic + R0_Asymptomatic * Infected_Asymptomatic ) * Sen_Susceptible - Tau_E_Inv * Sen_Exposed;

% number of infected symptomatic, quarantined, coming from exposed and moving to recovered, or dead

dy(26)= SymptomaticFraction * qFractionTreated_Symptomatic * Tau_E_Inv * Sen_Exposed ...
    -  (Tau_I_Inv + deathrate_Sen_Symptomatic_Quarantined) * Sen_Symptomatic_Infected_Quarantined ;

% number of infected symptomatic, nonquarantined, coming from exposed and moving to recovered, or dead
dy(27)= SymptomaticFraction * (1-qFractionTreated_Symptomatic) * Tau_E_Inv * Sen_Exposed ...
    -  (Tau_I_Inv + deathrate_Sen_Symptomatic_Nonquarantined) * Sen_Symptomatic_Infected_NonQuarantined ;

% number of infected asymptomatic, quarantined, coming from exposed and moving to recovered, oror dead

dy(28)= (1-SymptomaticFraction) *qFractionTreated_Asymptomatic* Tau_E_Inv * Sen_Exposed  ...
    - (Tau_I_Inv + deathrate_Sen_Asymptomatic_Quarantined) * Sen_Asymptomatic_Infected_Quarantined ;

% number of infected asymptomatic, nonquarantined, coming from exposed and moving to recovered, or dead
dy(29)= (1-SymptomaticFraction) * (1-qFractionTreated_Asymptomatic) * Tau_E_Inv * Sen_Exposed ...
    -  (Tau_I_Inv + deathrate_Sen_Asymptomatic_Nonquarantined) * Sen_Asymptomatic_Infected_NonQuarantined ;


% number recovered,  who were originally symptomatic 
% quanratined and nonquarantined
% minus moving to susceptible
dy(30) = Tau_I_Inv   *(  Sen_Symptomatic_Infected_Quarantined +   Sen_Symptomatic_Infected_NonQuarantined)... 
     - Tau_R_Inv * Sen_Symptomatic_Recovered;

% number recovered,  who were originally asymptomatic 
% quanratined and nonquarantined
% minus moving to susceptible
dy(31) = Tau_I_Inv * ( Sen_Asymptomatic_Infected_Quarantined + Sen_Asymptomatic_Infected_NonQuarantined) ... 
     - Tau_R_Inv * Sen_Asymptomatic_Recovered;


% number dead, symptomatic 
dy(32) = deathrate_Sen_Symptomatic_Quarantined * Sen_Symptomatic_Infected_Quarantined ...
    +   deathrate_Sen_Symptomatic_Nonquarantined * Sen_Symptomatic_Infected_NonQuarantined;
    
% number dead, asymptomatic 

dy(33) =   deathrate_Sen_Asymptomatic_Quarantined * Sen_Asymptomatic_Infected_Quarantined ...
    + deathrate_Sen_Asymptomatic_Nonquarantined * Sen_Asymptomatic_Infected_NonQuarantined; 
dy;

end