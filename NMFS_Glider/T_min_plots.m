%% Notes
% Sam Coakley
%Plot 2006 NMFS data to look for a trend in bottom temperature through the
%course of one year. Add bottom glider data.
%Then plot all the years at once on a time series with only bottom

%Plot with (start with 2006) all of the bottom temp data by month one year time series
%Does it look like Tmin. mimic houghton figure
%Nmfs first then glider 
%In study area // just use min temps for glider // bottom 10% of temps
%%  NMFS limiting
clear  
close all
tic
% NMFS data
readnmfsdata;
clearvars -except botsal bottemp lat lon surfsal surftemp V timeGMT start last ...
    maxdepth
% box=[40.391 -73.416;39.133 -73.822;39.026 -72.960 ; 40.320 -72.625];
% box=[39.83 -73.41;39.547 -72.614;38.575 -73.509 ; 38.866 -74.152];
box=[39.788 , -72.179; 39.513 , -72.537; 38.502 , -73.416 ; 38.759, -73.987];

N_lat=lat;
N_lon=lon;
%Limit Spatially
ind=find(inpolygon(N_lat,N_lon,box(:,1),box(:,2)));
% ind=find(N_lat>=37&N_lat<=40.4);
N_lat=N_lat(ind,1);
N_lon=N_lon(ind,1);
V=V(ind,:);
timeGMT=timeGMT(ind);
botsal=botsal(ind);
bottemp=bottemp(ind);

%limit by time
indd=find(V(:,1)==2006);
botsal=botsal(indd);
bottemp=bottemp(indd);
N_lat=N_lat(indd,1);
N_lon=N_lon(indd,1);
V=V(indd,:);
timeGMT=timeGMT(indd);
%LIMIT BY SEASON
% month=(V(:,2));
% IND=find(V(:,2)>=6 & V(:,2)<=8);
% V=V(IND,:);
% timeGMT=timeGMT(IND);
% botsal=botsal(IND);
% month=month(IND);
% bottemp=bottemp(IND);

%LIMIT TO 10 C
% INDD=find(bottemp<=10);
% V=V(INDD,:);
% timeGMT=timeGMT(INDD);
% surfsal=surfsal(INDD);
% botsal=botsal(INDD);
% month=month(INDD);
% surftemp=surftemp(INDD);
% bottemp=bottemp(INDD);
clear ind IND INDD indd

t_min=nan(52,1);
s_cp=nan(52,1);
V_min=nan(52,1);
test=0;
for j=1:7:358
    ind=find(datenum(V)>=datenum(2006,1,j) & datenum(V)<=datenum(2006,1,j+7));
    bs=botsal(ind);
    bt=bottemp(ind);
    
    if 1==1
        test=test+1;
    end
    if sum(isfinite(bt))~=0
        [t_min(test,1),indd]=min(bt,[],'omitnan');
        s_cp(test,1)=bs(indd,1);
    else
        t_min(test,1)=nan;
        s_cp(test,1)=nan;
    end
    V_min(test,1)=mean(V(ind,2),'omitnan');
    clear ind bs bt indd
end
toc
%% Glider Data
for j=0:3;
    if j==0
        filename='ru07-288'; 
    end
    
    if j==1
        filename='jane-290'; 
    end
    
    if j==2
        filename='ru05-253'; 
    end
    
    if j==3
        filename='ru05-298'; 
    end
%GLIDER NAME
load(filename);
startTimes=dgroup.startDatenums;
endTimes=dgroup.endDatenums;
dgroup.timestampSensors = 'drv_m_present_time_datenum';
dgroup.depthSensors = 'drv_sci_water_pressure'; 
addCtdSensors(dgroup);
processGps(dgroup);
temp=dgroup.toArray('sensors',{'drv_sea_water_temperature'});
sal=dgroup.toArray('sensors',{'drv_sea_water_salinity'});
ii=sal(:,2) < 1;
sal(ii,:)=NaN;
temp(ii,:)=NaN;
depth(ii,:)=NaN;
    if j==0
        temp_288=temp;
        sal_288=sal;
        depth_288=depth;
    end
    
    if j==1
        temp_290 =temp;
        sal_290  =sal;
        depth_290=depth;        
    end
    
    if j==2
        temp_253 =temp;
        sal_253  =sal;
        depth_253=depth;
    end
    
    if j==3
        temp_298 =temp;
        sal_298  =sal;
        depth_298=depth;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Remember to add new vars to the -except below  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
close all;clearvars -except temp_288 sal_288 depth_288 temp_290 sal_290 depth_290 ...
    temp_253 sal_253 depth_253 temp_298 sal_298 depth_298 botsal bottemp lat lon surfsal surftemp V timeGMT start last ...
    maxdepth t_min V_min s_cp;
end

%Glider mins
[tm_288,I_288]=min(temp_288(:,3));
[tm_290,I_290]=min(temp_290(:,3));
[tm_253,I_253]=min(temp_253(:,3));
[tm_298,I_298]=min(temp_298(:,3));

%Glider Temp / Glider Sal
gs=[sal_288(I_288,1),sal_288(I_288,3);sal_290(I_290,1),sal_290(I_290,3); ...
    sal_253(I_253,1),sal_253(I_253,3);sal_298(I_298,1),sal_298(I_298,3)];
gt=[temp_288(I_288,1),tm_288;temp_290(I_290,1),tm_290;temp_253(I_253,1),tm_253 ...
    ;temp_298(I_298,1),tm_298];
%% Plotting
figure(1)
scatter(datenum(2006,V_min,1),t_min,36,'b','*')
hold on
scatter(gt(:,1),gt(:,2),36,'r','*');
xlim([datenum(2005, 12, 29) datenum(2006, 12 ,4)])
ylim([2 11])
datetick('x','keeplimits');
legend('NMFS Temp', 'Glider Temp');
title('T-min Time Series: 2006')
figure(2)
scatter(datenum(2006,V_min,1),s_cp,36,'b','o')
hold on
scatter(gs(:,1),gs(:,2),36,'r','o');
xlim([datenum(2005, 12, 29) datenum(2006, 12 ,4)])
ylim([30 35])
datetick('x','keeplimits');
legend('NMFS Sal', 'Glider Sal');
title('Salinity of T-min Time Series: 2006')


print(figure(1),'/Users/samcoa/Documents/MATLAB/Figures/t_min_glider_nmfs','-dpng','-r150');
print(figure(2),'/Users/samcoa/Documents/MATLAB/Figures/t_min_sal_glider_nmfs','-dpng','-r150');

close all



