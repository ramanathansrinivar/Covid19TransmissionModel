% Plot the results

function  Plot_Covid19_Results_MonteCarlo(ProcessedModelDataSet,ModelStdevDataSet,CompareWithData,ActualDataSet)

%[19 49 80 110 141 172 202 233 263 294 325 353 384 414 445 475 506 537 567 598 628 659]
XTickValues = [19 110 202 294 384 475 567 659];
XTickNames = {'Apr 20','Jul 20','Oct 20','Jan 21','Apr 21','Jul 21','Oct 21','Jan 22'};


XMinorTicks = [ 49 80  141 172  233 263  325 353 414 445 506 537 598 628 ];


% First get the data into the respective column vectors

t_Complete=ProcessedModelDataSet(:,1);


Chi_Sus_list = ProcessedModelDataSet(:,2);
Chi_Vac_list = ProcessedModelDataSet(:,3);
Chi_E_list = ProcessedModelDataSet(:,4);
Chi_SQ_list = ProcessedModelDataSet(:,5);
Chi_SNQ_list = ProcessedModelDataSet(:,6);
Chi_AsQ_list = ProcessedModelDataSet(:,7);
Chi_AsNQ_list = ProcessedModelDataSet(:,8);
Chi_SR_list = ProcessedModelDataSet(:,9);
Chi_AsR_list = ProcessedModelDataSet(:,10);
Chi_SD_list = ProcessedModelDataSet(:,11);
Chi_AsD_list = ProcessedModelDataSet(:,12);

Adu_Sus_list = ProcessedModelDataSet(:,13);
Adu_Vac_list = ProcessedModelDataSet(:,14);
Adu_E_list = ProcessedModelDataSet(:,15);
Adu_SQ_list = ProcessedModelDataSet(:,16);
Adu_SNQ_list = ProcessedModelDataSet(:,17);
Adu_AsQ_list = ProcessedModelDataSet(:,18);
Adu_AsNQ_list = ProcessedModelDataSet(:,19);
Adu_SR_list = ProcessedModelDataSet(:,20);
Adu_AsR_list = ProcessedModelDataSet(:,21);
Adu_SD_list = ProcessedModelDataSet(:,22);
Adu_AsD_list = ProcessedModelDataSet(:,23);

Sen_Sus_list = ProcessedModelDataSet(:,24);
Sen_Vac_list = ProcessedModelDataSet(:,25);
Sen_E_list = ProcessedModelDataSet(:,26);
Sen_SQ_list = ProcessedModelDataSet(:,27);
Sen_SNQ_list = ProcessedModelDataSet(:,28);
Sen_AsQ_list = ProcessedModelDataSet(:,29);
Sen_AsNQ_list = ProcessedModelDataSet(:,30);
Sen_SR_list = ProcessedModelDataSet(:,31);
Sen_AsR_list = ProcessedModelDataSet(:,32);
Sen_SD_list = ProcessedModelDataSet(:,33);
Sen_AsD_list = ProcessedModelDataSet(:,34);


All_Sus_list =Chi_Sus_list+Adu_Sus_list+Sen_Sus_list ;

All_Vac_list =Chi_Vac_list+Adu_Vac_list+Sen_Vac_list ;
All_E_list = Chi_E_list +Adu_E_list +Sen_E_list ;
All_SQ_list = Chi_SQ_list +Adu_SQ_list +Sen_SQ_list ;
All_SNQ_list = Chi_SNQ_list +Adu_SNQ_list +Sen_SNQ_list ;
All_AsQ_list = Chi_AsQ_list +Adu_AsQ_list +Sen_AsQ_list ;
All_AsNQ_list = Chi_AsNQ_list +Adu_AsNQ_list +Sen_AsNQ_list ;
All_SR_list = Chi_SR_list +Adu_SR_list +Sen_SR_list ;
All_AsR_list = Chi_AsR_list +Adu_AsR_list +Sen_AsR_list ;
All_SD_list = Chi_SD_list +Adu_SD_list +Sen_SD_list ;
All_AsD_list = Chi_AsD_list +Adu_AsD_list +Sen_AsD_list ;


All_Sym_list = All_SQ_list + All_SNQ_list;

All_Deceased_list = All_SD_list + All_AsD_list;


Chi_Sus_stdev = ModelStdevDataSet(:,2);
Chi_Vac_stdev = ModelStdevDataSet(:,3);
Chi_E_stdev = ModelStdevDataSet(:,4);
Chi_SQ_stdev = ModelStdevDataSet(:,5);
Chi_SNQ_stdev = ModelStdevDataSet(:,6);
Chi_AsQ_stdev = ModelStdevDataSet(:,7);
Chi_AsNQ_stdev = ModelStdevDataSet(:,8);
Chi_SR_stdev = ModelStdevDataSet(:,9);
Chi_AsR_stdev = ModelStdevDataSet(:,10);
Chi_SD_stdev = ModelStdevDataSet(:,11);
Chi_AsD_stdev = ModelStdevDataSet(:,12);

Adu_Sus_stdev = ModelStdevDataSet(:,13);
Adu_Vac_stdev = ModelStdevDataSet(:,14);
Adu_E_stdev = ModelStdevDataSet(:,15);
Adu_SQ_stdev = ModelStdevDataSet(:,16);
Adu_SNQ_stdev = ModelStdevDataSet(:,17);
Adu_AsQ_stdev = ModelStdevDataSet(:,18);
Adu_AsNQ_stdev = ModelStdevDataSet(:,19);
Adu_SR_stdev = ModelStdevDataSet(:,20);
Adu_AsR_stdev = ModelStdevDataSet(:,21);
Adu_SD_stdev = ModelStdevDataSet(:,22);
Adu_AsD_stdev = ModelStdevDataSet(:,23);

Sen_Sus_stdev = ModelStdevDataSet(:,24);
Sen_Vac_stdev = ModelStdevDataSet(:,25);
Sen_E_stdev = ModelStdevDataSet(:,26);
Sen_SQ_stdev = ModelStdevDataSet(:,27);
Sen_SNQ_stdev = ModelStdevDataSet(:,28);
Sen_AsQ_stdev = ModelStdevDataSet(:,29);
Sen_AsNQ_stdev = ModelStdevDataSet(:,30);
Sen_SR_stdev = ModelStdevDataSet(:,31);
Sen_AsR_stdev = ModelStdevDataSet(:,32);
Sen_SD_stdev = ModelStdevDataSet(:,33);
Sen_AsD_stdev = ModelStdevDataSet(:,34);


All_Sus_list =Chi_Sus_list+Adu_Sus_list+Sen_Sus_list ;
All_Vac_list =Chi_Vac_list+Adu_Vac_list+Sen_Vac_list ;
All_E_list = Chi_E_list +Adu_E_list +Sen_E_list ;
All_SQ_list = Chi_SQ_list +Adu_SQ_list +Sen_SQ_list ;
All_SNQ_list = Chi_SNQ_list +Adu_SNQ_list +Sen_SNQ_list ;
All_AsQ_list = Chi_AsQ_list +Adu_AsQ_list +Sen_AsQ_list ;
All_AsNQ_list = Chi_AsNQ_list +Adu_AsNQ_list +Sen_AsNQ_list ;
All_SR_list = Chi_SR_list +Adu_SR_list +Sen_SR_list ;
All_AsR_list = Chi_AsR_list +Adu_AsR_list +Sen_AsR_list ;
All_SD_list = Chi_SD_list +Adu_SD_list +Sen_SD_list ;
All_AsD_list = Chi_AsD_list +Adu_AsD_list +Sen_AsD_list ;


All_Sym_list = All_SQ_list + All_SNQ_list;

All_Deceased_list = All_SD_list + All_AsD_list;


All_SQ_stdev = Chi_SQ_stdev+Adu_SQ_stdev+Sen_SQ_stdev;
All_SR_stdev = Chi_SR_stdev+Adu_SR_stdev+Sen_SR_stdev;
All_SD_stdev = Chi_SD_stdev+Adu_SD_stdev+Sen_SD_stdev;

% Calculate the upper limit
All_SQ_UL = All_SQ_list + All_SQ_stdev;
All_SR_UL = All_SR_list + All_SR_stdev;
All_SD_UL = All_SD_list + All_SD_stdev;

% Calculate the lower limit

All_SQ_LL = All_SQ_list - All_SQ_stdev;
All_SR_LL = All_SR_list - All_SR_stdev;
All_SD_LL = All_SD_list - All_SD_stdev;


figure100= figure;%('position',[470 300 500 500],'name','ALL');
x1 = get(gcf,'position');axes('position',[0.2 0.2 0.7 0.7]);
set(gcf,'color','w');

plot1001A = plot(t_Complete,All_SQ_list);hold on;
plot1001B = plot(t_Complete,All_SR_list);hold on;

plot1001AUL = plot(t_Complete,All_SQ_UL);hold on;
plot1001ALL = plot(t_Complete,All_SQ_LL);hold on;
shade(t_Complete,All_SQ_UL,t_Complete,All_SQ_LL,'FillType',[1 2;2 1], 'FillColor',[0.5 0.5 1],'FillAlpha',0.2);

plot1001BUL = plot(t_Complete,All_SR_UL);hold on;
plot1001BLL = plot(t_Complete,All_SR_LL);hold on;



shade(t_Complete,All_SR_UL,t_Complete,All_SR_LL,'FillType',[1 2;2 1],'FillColor', [0.5 1 0.5], 'FillAlpha',0.3);
hold on;

% plot1001C = plot(t_Complete,All_SD_list);hold on;

set(plot1001A,'linewidth',2,'linestyle','-','color',[0 0 1], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001B,'linewidth',2,'linestyle','-','color',[0 0.5 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001AUL,'linewidth',1,'linestyle','--','color',[0 0 1], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001BUL,'linewidth',1,'linestyle','--','color',[0 0.5 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001ALL,'linewidth',1,'linestyle','--','color',[0 0 1], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001BLL,'linewidth',1,'linestyle','--','color',[0 0.5 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );

% set(plot1001C,'linewidth',2,'linestyle','-','color',[0 0. 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );

if CompareWithData
    NumDays = ActualDataSet(:,1);
    ConfirmedValues =ActualDataSet(:,2);
    RecoveredValues =ActualDataSet(:,3);
    DeceasedValues =ActualDataSet(:,4);
    
plot1001D = plot(NumDays,ConfirmedValues); hold on;
plot1001E = plot(NumDays,RecoveredValues); hold on;
% plot1001F = plot(NumDays,DeceasedValues ); hold on;
set(plot1001D,'linewidth',1,'linestyle','none','color',[0 0 1], 'marker','o','markerfacecolor',[0.6 0.6 1],'MarkerSize',2,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001E,'linewidth',1,'linestyle','none','color',[0 0.5 0], 'marker','s','markerfacecolor',[0.6 1 0.6],'MarkerSize',2,'MarkerEdgeColor',[  0 0.5 0]    );
% set(plot1001F,'linewidth',1,'linestyle','none','color',[0 0. 0], 'marker','v','markerfacecolor',[0.6 0.6 0.6],'MarkerSize',2,'MarkerEdgeColor',[  0 0 0]    );

end


xlabel('time (days)');
ylabel('Number of people');

legend([plot1001A plot1001B  ],{'Confirmed','Recovered'});
set(gca,'fontsize',14);

set(gca,'XTick',XTickValues);
set(gca,'XTickLabel',XTickNames)
set(gca,'xticklabelrotation',45);
set(gca,'TickLength',[0.05, 0.1]);
hA = get(gca);
hA.XAxis.MinorTickValues = XMinorTicks;
hA.XAxis.MinorTick = 'On';
set(gca,'xlim',[1 680]);


figure101= figure;%('position',[920 300 500 500],'name','Deceased');
% locate this plot slightly away from the first one
x2 = x1 + [50 -50 0 0];
set(gcf,'position',x2);axes('position',[0.2 0.2 0.7 0.7]);
set(gcf,'color','w');

plot1001C = plot(t_Complete,All_SD_list);hold on;
plot1001CUL = plot(t_Complete,All_SD_UL);hold on;
plot1001CLL = plot(t_Complete,All_SD_LL);hold on;

shade(t_Complete,All_SD_UL,t_Complete,All_SD_LL,'FillType',[1 2;2 1]);

% set(plot1001A,'linewidth',2,'linestyle','-','color',[0 0 1], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
% set(plot1001B,'linewidth',2,'linestyle','-','color',[0 0.5 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001C,'linewidth',2,'linestyle','-','color',[0 0. 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001CUL,'linewidth',0.5,'linestyle','--','color',[0 0. 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );
set(plot1001CLL,'linewidth',0.5,'linestyle','--','color',[0 0. 0], 'marker','none','markerfacecolor',[0.6 0.6 1],'MarkerSize',8,'MarkerEdgeColor',[  0 0 1]    );

if CompareWithData
    NumDays = ActualDataSet(:,1);
    ConfirmedValues =ActualDataSet(:,2);
    RecoveredValues =ActualDataSet(:,3);
    DeceasedValues =ActualDataSet(:,4);
    
% plot1001D = plot(NumDays,ConfirmedValues); hold on;
% plot1001E = plot(NumDays,RecoveredValues); hold on;
plot1001F = plot(NumDays,DeceasedValues ); hold on;
% set(plot1001D,'linewidth',1,'linestyle','none','color',[0 0 1], 'marker','o','markerfacecolor',[0.6 0.6 1],'MarkerSize',2,'MarkerEdgeColor',[  0 0 1]    );
% set(plot1001E,'linewidth',1,'linestyle','none','color',[0 0.5 0], 'marker','s','markerfacecolor',[0.6 1 0.6],'MarkerSize',2,'MarkerEdgeColor',[  0 0.5 0]    );
set(plot1001F,'linewidth',1,'linestyle','none','color',[0 0. 0], 'marker','v','markerfacecolor',[0.6 0.6 0.6],'MarkerSize',2,'MarkerEdgeColor',[  0 0 0]    );

end


xlabel('time (days)');
ylabel('Number of people');

legend([ plot1001C ],{'Deceased'});
set(gca,'fontsize',14);
set(gca,'XTick',XTickValues);
set(gca,'XTickLabel',XTickNames)
set(gca,'xticklabelrotation',45);
set(gca,'TickLength',[0.05, 0.1]);
hA = get(gca);
hA.XAxis.MinorTickValues = XMinorTicks;
hA.XAxis.MinorTick = 'On';
set(gca,'xlim',[1 680]);


end
