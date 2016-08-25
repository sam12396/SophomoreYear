%% Notes
% Sam Coakley
% 7/18
% Used to make plots of anomalies from the mean of bottom temperatures/salinities
% 
% Utilizes nmfs and glider data to find a mean bottom temp and sal and then finds the differences
% from that mean.
% Mean is the mean of all data for bottom (all years). This mean is then applied
% to annual data.
%A limit of 3 stdevs is used. The limit is applied to annual data 
%Only inside the study area (box)

%% Read in the NMFS Data
readnmfsdata
clearvars -except botsal bottemp lat lon surfsal surftemp V timeGMT start last ...
    maxdepth
clear surfsal surftemp start last maxdepth
%box #5 7/13
box=[39.541 -72.542;39.854 -73.432 ; 38.864 -74.294; 38.547 -73.459];
N_lat=lat;
N_lon=lon;
%Limit Spatially
ind=find(inpolygon(N_lat,N_lon,box(:,1),box(:,2)));
N_lat=N_lat(ind,1);
N_lon=N_lon(ind,1);
V=V(ind,:);
timeGMT=timeGMT(ind);
botsal=botsal(ind);
bottemp=bottemp(ind);
clear ind

%% Read in the Glider Data
% load('glider_bottom_tstime.mat');
%Create empty arrays to be concatenated
g_temp=[];
g_sal =[];
gt_fin=[];
gs_fin=[];
gtime_fin=[];
gdepth_fin=[];
tic
for j=1:43;
    tic
    j
    %2006
    if j==1
        filename='jane-290'; 
    end
    
    if j==2
        filename='ru05-253'; 
    end
   
    if j==3
        filename='ru05-298'; 

    end
    
    if j==4
        filename='ru07-288'; 
    end
 %2013   
    if j==5
        filename='ru23-386'; 
    end
    
    if j==6
        filename='ru23-399'; 
    end
 %2014   
    if j==7
        filename='ru23-421'; 
    end
 %2015   
    if j==8
        filename='ru23-463'; 
    end
    
    if j==9
        filename='ud_134-464'; 
    end
%2012
    if j==10
        filename='ru10-339'; 
    end
%2011    
    if j==11
        filename='ru15-226'; 
    end
    
    if j==12
        filename='ru22-219'; 
    end
%2010
    if j==13
        filename='ru01-163'; 
    end
%2009
   if j==14
        filename='ru05-73'; 
    end
   if j==15
       filename='ru06-257'; 
    end
    if j==16
        filename='ru07-60'; 
    end
    if j==17
        filename='ru21-72'; 
    end
    if j==18
        filename='ru22-77'; 
    end
    if j==19
        filename='ru23-71'; 
    end
    if j==20
        filename='ru23-76'; 
    end
    
%2008    
    if j==21
        filename='ru15-162'; 
    end
    if j==22
        filename='ru20-121'; 
    end
    if j==23
        filename='ru22-127'; 
    end
%2007
    if j==24
        filename='ru17-328'; 
    end
    if j==25
        filename='ru15-332'; 
    end
    if j==26
%         filename='ru07-324'; 
          j=27
    end
    if j==27
        filename='ru15-160'; 
    end
    if j==28
        filename='ru06-322'; 
    end
%2006 cont.
    if j==29
        filename='ru05-307'; 
    end
    if j==30
        filename='ru01-303'; 
    end
    if j==31
        filename='ru12-304'; 
    end
    if j==32
        filename='ru07-302'; 
    end
    if j==33
        filename='ru11-301'; 
    end
    if j==34
        filename='ru09-299'; 
    end
    if j==35
        filename='ru12-295'; 
    end
    if j==36
        filename='ru11-293'; 
    end
    if j==37
        filename='ru10-294'; 
    end
    if j==38
        filename='ru01-291'; 
    end
    if j==39
        filename='ru07-282'; 
    end
    if j==40
        filename='ru07-255'; 
    end
    if j==41
        filename='ru05-251'; 
    end

%2005
    if j==42
        filename='ru01-94'; 
    end
    if j==43
        filename='ru01-95'; 
    end
%     if j==44
% %         filename='ru05-238'; 
%        
%     end

%Loads in glider data
load(filename);
dgroup.timestampSensors = 'drv_sci_m_present_time_datenum';
dgroup.depthSensors = 'drv_sci_water_pressure'; 
addCtdSensors(dgroup);
processGps(dgroup,'interp','linear');
vars=dgroup.toProfiles('sensors',{'drv_sea_water_temperature','drv_sea_water_salinity' ...
    ,'drv_latitude','drv_longitude'});

%Depth stored in col 2 of all vars
%Empty arrays to be concat-ed
g_bottemp=[];
g_botsal=[];
g_bottime=[];
g_botdepth=[];
count=1:100:length(vars);
for k=1:length(vars)
%selects a particular profile from each variable
    temp=vars(k).drv_sea_water_temperature;
    sal=vars(k).drv_sea_water_salinity;
    lat=vars(k).drv_latitude;
    lon=vars(k).drv_longitude;
    depth=vars(k).depth;
    time=vars(k).timestamp;
    
    
        %Box only
    ii=find(inpolygon(lat,lon,box(:,1),box(:,2)));
    temp=temp(ii,:);
    sal=sal(ii,:);
    lat=lat(ii,:);
    lon=lon(ii,:);
    depth=depth(ii,:);
    time=time(ii,:);
    
    %only want bottom temperatures so limit depth to 35
    %Our study area has a min depth of ~38
    i= depth <= 35;
    sal(i,:)=NaN;
    temp(i,:)=NaN;
    lat(i,:)=nan;
    lon(i,:)=nan;
    depth(i,:)=nan;
    time(i,:)=nan;
    
%Make Time always real
    ddni=isfinite(time);
    g_time=time(ddni);
    g_temp=temp(ddni);
    g_sal=sal(ddni);
    g_depth=depth(ddni);
    g_lat=lat(ddni);
    g_lon=lon(ddni);
    
    %Make sure the temps aren't too crazy to be bottom temp  %%%%% 15 %%%%%
    ddni1=find(g_temp>=15);
    g_sal(ddni1,:)=NaN;
    g_temp(ddni1,:)=NaN;
    g_lat(ddni1,:)=nan;
    g_lon(ddni1,:)=nan;
    g_depth(ddni1,:)=nan;
    g_time(ddni1,:)=nan;
    
    %no longer need lat lon
    clear g_lat g_lon
    %Find max depth by profile and record that as bottom temperature
    [maxdepth iii]=max(g_depth,[],'omitnan');
    bt=g_temp(iii);
    bs=g_sal(iii);
    btime=g_time(iii);
    
    %no longer need depth
    clear g_depth
    
    %Concat's bot temp from every profile from one glider mission
    %and associated salinity and time
    g_bottemp=[g_bottemp;bt];
    g_botsal=[g_botsal;bs];
    g_bottime=[g_bottime;btime];
    

%     g_botdepth=[g_botdepth;maxdepth];

clear ddni iii ii i bt bs btime maxdepth k g_depth g_lat ...
    g_lon g_sal g_temp g_time temp time sal
end
%Creates bottom glider data set by concat-ing each gliders full bottom set
%into one array for each var

gt_fin=[gt_fin; g_bottemp];
gs_fin=[gs_fin; g_botsal];
gtime_fin=[gtime_fin; g_bottime];

% gdepth_fin=[gdepth_fin; g_botdepth];
clear g_temp g_times g_sal lat lon depth ii iinn filename ...
    dgroup g_bottemp g_botsal g_bottime g_botdepth
toc
end
toc
%This section takes ~45 min so saved variables to not have to run it more
%than once
save('/Users/samcoa/Documents/MATLAB/Data/glider_bottom_tstime.mat', 'gt_fin', 'gs_fin', 'gtime_fin');
% load('glider_bottom_tstime.mat');
%% Manipulation
alltemp=[];
allsal=[];
t_alltime=[];
s_alltime=[];
y_t_mean=nan(40,1);
y_s_mean=nan(40,1);
y_t_median=nan(40,1);
y_s_median=nan(40,1);
for jj=1976:2015
    
    %Limit by year and study time frame
    %Used March 1 to Dec 1 to make sure we were only looking at potential
    %cold pool times
    ind1=find(timeGMT(:)>= datenum(jj,3,1) & timeGMT(:)<=datenum(jj,12,1));
    N_bt_1=bottemp(ind1);
    N_bs_1=botsal(ind1);
    N_time_1=timeGMT(ind1);
    
    dni1=find(gtime_fin(:)>= datenum(jj,3,1) & gtime_fin(:)<=datenum(jj,12,1));
    G_temp_1=gt_fin(dni1);
    G_sal_1= gs_fin(dni1);
    G_time_1=gtime_fin(dni1);
    
    %Puts NMFS and Glider together
    t_temp=[N_bt_1 ; G_temp_1];
    t_sal=[N_bs_1 ; G_sal_1];
    a_time=[N_time_1 ; G_time_1];
    
    %Make stats for full data 
    %y_t= yearly temp // y_s=yearly salinity
    y_t_mean(jj-1975,1)=nanmean(t_temp);
    y_s_mean(jj-1975,1)=nanmean(t_sal);
    y_t_median(jj-1975,1)=nanmedian(t_temp);
    y_s_median(jj-1975,1)=nanmedian(t_sal);
    y_t_std= nanstd(t_temp);
    y_s_std= nanstd(t_sal); 
    
    %Concat's each years data from  both data sets into one array per var
    alltemp=[alltemp; t_temp];
    allsal =[allsal ; t_sal];
    t_alltime=[t_alltime; a_time];
    s_alltime=[s_alltime; a_time];
    clear ind1 ind2 ind3 dni1 dni2 dni3
end
t_mean=nanmean(y_t_mean);
s_mean=nanmean(y_s_mean);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Difference is DATA MINUS MEAN%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_dif=y_t_mean-t_mean;
s_dif=y_s_mean-s_mean;

temp_time=datevec(t_alltime);
sal_time=datevec(s_alltime);

%Load in climate indices
% clim_ind_work
%% Plotting
% figure
% subplot(3,1,1)
% bar(1976:2015,t_dif);
% xlim([1975 2016])
% title('Bottom Temperature Anomalies');
% ylabel('Difference from mean (°C)');
% hold on
% subplot(3,1,2)
% bar(1950:2016,n_i_annual)
% xlim([1975 2016]);
% title('NAO Indices');
% ylim([-2 2])
% hold on
% subplot(3,1,3)
% bar(1950:2016,e_i_annual)
% xlim([1975 2016]);
% title('ENSO Indices');
% ylim([-2 2])
% 
% print('/Users/samcoa/Documents/MATLAB/Figures/MTS/anom_clim_ind','-dpng','-r500');
% close all

figure
subplot(2,1,1)
bar(1976:2015,t_dif);
xlim([1975 2016])
title('Bottom Temperature Anomalies');
ylabel('Difference from mean (°C)');
hold on
subplot(2,1,2)
bar(1976:2015,s_dif);
xlim([1975 2016])
title('Bottom Salinity Anomalies');
ylabel('Difference from mean (PSU)');

print('/Users/samcoa/Documents/MATLAB/Figures/MTS/t_s_anomalies','-dpng','-r500');
close all