%%TS Plots Annually by Season
%Plot temperature and salinity with density contours. Dependent on
%readnmfsdata. Limits the data to the specific time and place then plots
%the figures by year.
%%
clear; close all;
readnmfsdata
%Summer Setup
box=[39.83 -73.41;39.547 -72.614;38.575 -73.509 ; 38.866 -74.152];

% LIMIT BY region
IND=find(inpolygon(lat,lon,box(:,1),box(:,2)));
V=V(IND,:);
timeGMT=timeGMT(IND);
lon=lon(IND);
lat=lat(IND);
surftemp=surftemp(IND);
bottemp=bottemp(IND);
surfsal=surfsal(IND);
botsal=botsal(IND);
maxdepth=maxdepth(IND);
clear IND
%Limit time
s_month=V(:,2);
IND=find(V(:,2)>=6 & V(:,2)<=8);
s_V=V(IND);
s_timeGMT=timeGMT(IND);
s_lon=lon(IND);
s_lat=lat(IND);
s_surftemp=surftemp(IND);
s_bottemp=bottemp(IND);
s_surfsal=surfsal(IND);
s_botsal=botsal(IND);
s_month=s_month(IND);
s_maxdepth=maxdepth(IND);
clear IND
%Fall Setup
%Limit time
f_month=(V(:,2));
IND=find(V(:,2)>=9 & V(:,2)<=11);
f_V=V(IND);
f_timeGMT=timeGMT(IND);
f_lon=lon(IND);
f_lat=lat(IND);
f_surftemp=surftemp(IND);
f_bottemp=bottemp(IND);
f_surfsal=surfsal(IND);
f_botsal=botsal(IND);
f_month=f_month(IND);
f_maxdepth=maxdepth(IND);
clear IND
%% Plotting
%Summer
for y=1973:2014
    ind=find(s_timeGMT>=datenum(y,1,1)&s_timeGMT<=datenum(y+1,1,1));
    s_st=s_surftemp(ind);
    s_ss=s_surfsal(ind);
    s_bt=s_bottemp(ind);
    s_bs=s_botsal(ind);
    
    indnan=find(~isnan(s_st)&~isnan(s_ss));
    s_st=s_st(indnan);
    s_ss=s_ss(indnan);
    clear indnan
    indnan=find(~isnan(s_bt)&~isnan(s_bs));
    s_bt=s_bt(indnan);
    s_bs=s_bs(indnan);
%  subplot(2,1,1)
%          theta_sdiag(s_st,s_ss);
%          title(['Surface' int2str(y)])
%  hold on
%  subplot(2,1,2)

% if ~isempty(s_st) & ~isempty(s_ss)
%     subplot(2,1,1)
%         scatter(s_ss,s_st,160,'r','.')
%         hold on
% end

%fall
    ind=find(f_timeGMT>=datenum(y,1,1)&f_timeGMT<=datenum(y+1,1,1));
    f_st=f_surftemp(ind);
    f_ss=f_surfsal(ind);
    f_bt=f_bottemp(ind);
    f_bs=f_botsal(ind);
    
%     indnan=find(~isnan(f_st)&~isnan(f_ss));
%     f_st=f_st(indnan);
%     f_ss=f_ss(indnan);
    clear indnan
    indnan=find(~isnan(f_bt)&~isnan(f_bs));
    f_bt=f_bt(indnan);
    f_bs=f_bs(indnan);
    
% if ~isempty(f_st) & ~isempty(f_ss)
%     subplot(2,1,1)
%     scatter(f_ss,f_st,160,'b','.')
% hold on
% end

figure
theta_sdiag(s_bt,s_bs);
title(['Bottom T-S' int2str(y)])
hold on
text(25.5,16.3,'Red = Summer','FontWeight','bold');
text(25.5,14.3,'Blue = Fall','FontWeight','bold');

if ~isempty(s_bt) && ~isempty(s_bs)
        scatter(s_bs,s_bt,240,'r','.')
end
theta_sdiag(f_bt,f_bs);
if ~isempty(f_bt) && ~isempty(f_bs)
        scatter(f_bs,f_bt,240,'b','.') 
end  
%Prints empty if no data....could add another if statement
print(figure(1),['/Users/samcoa/Documents/MATLAB/Figures/NMFS_Annual_Plots/TS/bot_ts_studyarea'...
        int2str(y)],'-dpng','-r150');
close all

end