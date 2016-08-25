%% Notes
% Sam Coakley
% 7/6/16
% To make plots of NMFS t_min alongside glider data in the region
% Takes the minimum temperatures within each week from EVERY year of data
% and plots them all together

%To add more gliders, just change the range of the glder data loop to be
%larger 

%Currently set to start at March 1 and run into December

%% Read in data

clear  
close all
tic
% NMFS data
readnmfsdata;
clearvars -except botsal bottemp lat lon surfsal surftemp V timeGMT start last ...
    maxdepth
% box=[40.391 -73.416;39.133 -73.822;39.026 -72.960 ; 40.320 -72.625];
% box=[39.83 -73.41;39.547 -72.614;38.575 -73.509 ; 38.866 -74.152];
% box=[39.788 , -72.179; 39.513 , -72.537; 38.502 , -73.416 ; 38.759, -73.987];
%box = [39.837 -73.427; 39.541 -72.526; 38.465 -73.427; 38.834 -74.316];
%box #5 7/13
box=[39.541 -72.542;39.854 -73.432 ; 38.864 -74.294; 38.547 -73.459];
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

clear ind IND INDD indd


% mean_t_min=nan(52,1);
% mean_s_cp =nan(52,1);
% mean_V=nan(52,1);
t_min_new=[];
s_cp_new=[];
V_new=[];
count=0;
for j=1:7:299
    t_min     =nan(38,1);
    s_cp      =nan(38,1);
    V_min     =nan(38,6);
    
    for kk=1976:2014
        
        %Need to find a better place to start then jan 1 
        %somewhere that has lowest temps
        %For now ... use March 1
    ind=find(datenum(V)>=datenum(kk,3,j) & datenum(V)<=datenum(kk,3,j+7));
    bs=botsal(ind);
    bt=bottemp(ind);
    time=V(ind,:);
    if sum(isfinite(bt))~=0
        [t_min(kk-1975,1),indd]=min(bt,[],'omitnan');
        s_cp(kk-1975,1)=bs(indd,1);
        V_min(kk-1975,:)=time(indd,:);
    else
        t_min(kk-1975,1)=nan;
        s_cp(kk-1975,1)=nan;
        V_min(kk-1975,:)=nan;
    end
    
        clear ind bs bt indd time 
    end
    t_std=nanstd(t_min);
    dni  = t_min < (nanmean(t_min)+1*abs(t_std)) & t_min > (nanmean(t_min)-1*abs(t_std));
    t_min=t_min(dni);
    s_cp =s_cp(dni);
    V_min=V_min(dni,:);
     
    if min(t_min)<=3
        j
    end
    
    V_temp=datenum(2000,V_min(:,2),V_min(:,3));
    t_min_new=[t_min_new; t_min];
    s_cp_new =[s_cp_new; s_cp];
    V_new    =[V_new; V_temp];
%     mean_t_min(count,1)=mean(t_min,'omitnan');
%     mean_s_cp (count,1)=mean(s_cp,'omitnan');
%     mean_V(count,1)=datenum(2000,1,j);
%     clear V_min s_cp t_min
end
clear j botsal bottemp count dni kk lat lon maxdepth s_cp t_min V_min V_temp ...
    surfsal surftemp V


%% Glider Data
g_temp=[];
g_sal =[];
gt_fin=[];
gs_fin=[];
gtime_fin=[];
for j=1:43;
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

%GLIDER NAME
load(filename);
dgroup.timestampSensors = 'drv_sci_m_present_time_datenum';
dgroup.depthSensors = 'drv_sci_water_pressure'; 
addCtdSensors(dgroup);
processGps(dgroup,'interp','linear');
temp=dgroup.toArray('sensors',{'drv_sea_water_temperature'});
sal=dgroup.toArray('sensors',{'drv_sea_water_salinity'});
lat=dgroup.toArray('sensors',{'drv_latitude'});
lon=dgroup.toArray('sensors',{'drv_longitude'});

ii=sal(:,2) < 1;
sal(ii,:)=NaN;
temp(ii,:)=NaN;
depth(ii,:)=NaN;
lat(ii,:)=nan;
lon(ii,:)=nan;

iinn=find(inpolygon(lat(:,3),lon(:,3),box(:,1),box(:,2)));
temp=temp(iinn,:);
sal=sal(iinn,:);
lat=lat(iinn,:);
lon=lon(iinn,:);
depth=depth(iinn,:);

ddni=isfinite(temp(:,3));
g_times=temp(ddni,1);
g_temp=temp(ddni,3);
g_sal=sal(ddni,3);
clear ddni

for jj=1:7:299
    
    gt_min=nan(15,1);
    gs_min=nan(15,1);
    gtime =nan(15,1);
    
    for kk=2000:2014 
    ind=find((g_times>=datenum(kk,3,jj) & g_times<=datenum(kk,3,jj+7)));
    temp_g_temp=g_temp(ind);
%     if kk==2006
%         sum(isfinite(temp_g_temp))
%         whos temp_g_temp
%     end
    if sum(isfinite(temp_g_temp))~=0
        [gt_min(kk-1999), dni]=min(temp_g_temp,[],'omitnan');
        gs_min(kk-1999)=g_sal(ind(dni));
        gtime(kk-1999)=g_times(ind(dni));
    else
        gt_min(kk-1999)=nan;
        gs_min(kk-1999)=nan;
        gtime(kk-1999)=nan;
    end

    end
    datevec(gtime);
    gt_fin   =[gt_fin; gt_min];
    gs_fin   =[gs_fin; gs_min];
    gtime_fin=[gtime_fin; gtime];
    clear ind gt_min gs_min gtime temp_g_temp
end
clear g_sal g_temp g_times
close all; clear depth dgroup filename ii sal temp lat lon
end
clear j
    gt_std=nanstd(gt_fin);
    dni  = gt_fin < (nanmean(gt_fin)+1*abs(gt_std)) & gt_fin > (nanmean(gt_fin)-1*abs(gt_std));
    gt_fin=gt_fin(dni);
    gs_fin =gs_fin(dni);
    gtime_fin=gtime_fin(dni,:);
temp_time=datevec(gtime_fin);
g_fake_time=datenum(2000,temp_time(:,2),temp_time(:,3));
%% Plotting

figure(1)
scatter(V_new,t_min_new,36,'b','*')
hold on
scatter(g_fake_time,gt_fin,36,'r','*')
% xlim([datenum(2000, 12, 29) datenum(2001, 12 ,4)])
ylim([2 15])
datetick('x','keeplimits');
legend('NMFS Temp' , 'Glider Temp')
title('Weekly T-min NMFS/Glider Time Series');
print(figure(1),'/Users/samcoa/Documents/MATLAB/Figures/t_min/wk_nmfs_glide_temp','-dpng','-r150');
close

figure(2)
scatter(V_new,s_cp_new,36,'b','o')
hold on
scatter(g_fake_time,gs_fin,36,'r','o')
% xlim([datenum(2000, 12, 29) datenum(2001, 12 ,4)])
ylim([30 35])
datetick('x','keeplimits');
legend('NMFS Sal' , 'Glider Sal')
title('Salinity of T-min NMFS/Glider Time Series')
print(figure(2),'/Users/samcoa/Documents/MATLAB/Figures/t_min/wk_nmfs_glide_sal','-dpng','-r150');
close all
toc