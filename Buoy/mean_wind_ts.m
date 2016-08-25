%%Notes
% Sam Coakley
% 
% Using both ndbc buoys for this study, taking the average wind speed by week to 
% see interannual trends.
% Assign all data to one year (2000) and then loop through from March to december
% taking the weekly averages.
% 
% May change to daily averages
%Changed to be full time frame of a year

%% Buoy44009 thredds
%clear;close all;
tic
lname='http://dods.ndbc.noaa.gov//thredds/dodsC/data/stdmet/';
buoyn='44009/';
fname='44009h';
yr=1984:2016;

date=[];
%Gust Speed m/s
G=[];
Wind=[];
air_t=[];
for k=1:length(yr); 
    y=yr(k)
    filename=([lname buoyn fname num2str(yr(k)) '.nc']);

    time_buoy=ncread(filename,'time');
    date1=datenum(1970,0,0,0,0,double(time_buoy));
    W1=squeeze(ncread(filename,'gust'));
    Wdir1=squeeze(ncread(filename,'wind_spd'));
    air_t1=squeeze(ncread(filename,'air_temperature'));       

G=[G ; W1];
Wind=[Wind ;Wdir1];
date=[date; date1];
air_t=[air_t; air_t1];
clear filename time_buoy date1 W1 Wdir1 y air_t1
end

%% Buoy 44025

lname='http://dods.ndbc.noaa.gov//thredds/dodsC/data/stdmet/';
buoyn='44025/';
fname='44025h';
yr1=1975:1980;
yr2=1991:2016;
date2=[];
%Windspeed m/s
G2=[];
Wind2=[];
air_t2=[];
for k=1:length(yr1); 
    y=yr1(k)
    filename=([lname buoyn fname num2str(yr1(k)) '.nc']);

    time_buoy=ncread(filename,'time');
    date1=datenum(1970,0,0,0,0,double(time_buoy));
    W1=squeeze(ncread(filename,'gust'));
   Wdir1=squeeze(ncread(filename,'wind_spd'));
    air_t1=squeeze(ncread(filename,'air_temperature'));       
    
G2=[G2 ; W1];
Wind2=[Wind2 ;Wdir1];
date2=[date2; date1];
air_t2=[air_t2; air_t1];
clear filename time_buoy date1 W1 Wdir1 y air_t1
end
for k=1:length(yr2); 
    y=yr2(k)
    filename=([lname buoyn fname num2str(yr2(k)) '.nc']);

    time_buoy=ncread(filename,'time');
    date1=datenum(1970,0,0,0,0,double(time_buoy));
    W1=squeeze(ncread(filename,'gust'));
   Wdir1=squeeze(ncread(filename,'wind_spd'));
    air_t1=squeeze(ncread(filename,'air_temperature'));       

G2=[G2 ; W1];
Wind2=[Wind2 ;Wdir1];
date2=[date2; date1];
air_t2=[air_t2; air_t1];
clear filename time_buoy date1 W1 Wdir1 y air_t1
end
clear k lname yr yr1 yr2 buoyn fname
%% Data manipulation
%Need to have both buoys in same array and reassign all the dates to be in
%2000

gust=[G;G2];
time=[date;date2];
wd=[Wind; Wind2];
air_temp=[air_t; air_t2];

clear G G2 date date2 Wdir Wdir2 air_t air_t2
%Limit time to only be in range of nmfs data
ind_t=find(time>=datenum(1976,1,1) & time<=datenum(2016,12,31));
gust=gust(ind_t);
time=time(ind_t);
wd=wd(ind_t);
air_temp=air_temp(ind_t);

%Split decadally to match the NMFS decadal data
ind_d=find(time>=datenum(1976,1,1) & time<datenum(1986,1,1));
gust_d_1=gust(ind_d);
time_d_1=time(ind_d);
air_t_d_1=air_temp(ind_d);
wind_d_1=wd(ind_d);
clear ind_d

ind_d=find(time>=datenum(1986,1,1) & time<datenum(1996,1,1));
gust_d_2=gust(ind_d);
time_d_2=time(ind_d);
air_t_d_2=air_temp(ind_d);
wind_d_2=wd(ind_d);
clear ind_d

ind_d=find(time>=datenum(1996,1,1) & time<datenum(2006,1,1));
gust_d_3=gust(ind_d);
time_d_3=time(ind_d);
air_t_d_3=air_temp(ind_d);
wind_d_3=wd(ind_d);
clear ind_d

ind_d=find(time>=datenum(2006,1,1) & time<datenum(2016,1,1));
gust_d_4=gust(ind_d);
time_d_4=time(ind_d);
air_t_d_4=air_temp(ind_d);
wind_d_4=wd(ind_d);
clear ind_d

temp_time_1=datevec(time_d_1);
temp_time_2=datevec(time_d_2);
temp_time_3=datevec(time_d_3);
temp_time_4=datevec(time_d_4);

clear air_temp gust

%Make all years 2000 and put back into matlab time
temp_time_1(:,1)=2000;
fake_time_1=datenum(temp_time_1);
temp_time_2(:,1)=2000;
fake_time_2=datenum(temp_time_2);
temp_time_3(:,1)=2000;
fake_time_3=datenum(temp_time_3);
temp_time_4(:,1)=2000;
fake_time_4=datenum(temp_time_4);
clear temp_time_1 temp_time_2 temp_time_3 temp_time_4 time ind_t ...
    time_d_1 time_d_2 time_d_3 time_d_4

gust=nan(52,4);
time=nan(52,4);
air=nan(52,4);
windy=nan(52,4);
%Starts in March to match other scripts
% Based off on decadal_t_min.m
for jj=1:4
% create vars to be loaded with weekly means
g_mean=[];
w_mean=[];
t_mean=[];
at_mean=[];
%Use jj as decadal index
    if jj==1
        for j=1:7:358
        ind=find(fake_time_1>=datenum(2000,1,j) & fake_time_1<datenum(2000,1,j+7));
        gm=nanmean(gust_d_1(ind));
        wm=nanmean(wind_d_1(ind));
        tm=nanmean(fake_time_1(ind));
        am=nanmean(air_t_d_1(ind));

         g_mean=[g_mean; gm];
         w_mean=[w_mean; wm];
         t_mean=[t_mean; tm];
         at_mean=[at_mean; am];
    
         clear gm dm tm ind am
        end  
        gust(:,1)=g_mean;
        time(:,1)=t_mean;
        air(:,1)=at_mean;
        windy(:,1)=w_mean;
    end
    if jj==2
        for j=1:7:358
        ind=find(fake_time_2>=datenum(2000,1,j) & fake_time_2<datenum(2000,1,j+7));
        gm=nanmean(gust_d_2(ind));
        wm=nanmean(wind_d_2(ind));
        tm=nanmean(fake_time_2(ind));
        am=nanmean(air_t_d_2(ind));

         g_mean=[g_mean; gm];
         w_mean=[w_mean; wm];
         t_mean=[t_mean; tm];
         at_mean=[at_mean; am];
    
         clear gm dm tm ind am
        end    
        gust(:,2)=g_mean;
        time(:,2)=t_mean;
        air(:,2)=at_mean;
        windy(:,2)=w_mean;

    end
    if jj==3
        for j=1:7:358
        ind=find(fake_time_3>=datenum(2000,1,j) & fake_time_3<datenum(2000,1,j+7));
        gm=nanmean(gust_d_3(ind));
        wm=nanmean(wind_d_3(ind));
        tm=nanmean(fake_time_3(ind));
        am=nanmean(air_t_d_3(ind));

         g_mean=[g_mean; gm];
         w_mean=[w_mean; wm];
         t_mean=[t_mean; tm];
         at_mean=[at_mean; am];
    
         clear gm dm tm ind am
        end    
        gust(:,3)=g_mean;
        time(:,3)=t_mean;
        air(:,3)=at_mean;
        windy(:,3)=w_mean;        
    end
    if jj==4
        for j=1:7:358
        ind=find(fake_time_4>=datenum(2000,1,j) & fake_time_4<datenum(2000,1,j+7));
        gm=nanmean(gust_d_4(ind));
        wm=nanmean(wind_d_4(ind));
        tm=nanmean(fake_time_4(ind));
        am=nanmean(air_t_d_4(ind));

         g_mean=[g_mean; gm];
         w_mean=[w_mean; wm];
         t_mean=[t_mean; tm];
         at_mean=[at_mean; am];
    
         clear gm dm tm ind am
        end    
        gust(:,4)=g_mean;
        time(:,4)=t_mean;
        air(:,4)=at_mean;
        windy(:,4)=w_mean        
    end
clear j 
end
clearvars -except air gust time windy al_time_min al_t_dif

%% Plotting
% subplot(3,1,1)
% plot(time(:,1),air(:,1),'LineWidth',1.5,'Color','r')
% hold on
% plot(time(:,2),air(:,2),'LineWidth',1.5,'Color','b')
% plot(time(:,3),air(:,3),'LineWidth',1.5,'Color','k')
% plot(time(:,4),air(:,4),'LineWidth',1.5,'Color','g')
% xlim([datenum(2000,1,1) datenum(2000,12,31)])
% ylim([-1 25])
% legend('1976-1985','1986-1995','1996-2005','2006-2015');
% datetick('x','keeplimits')
% title('44009/44025 Weekly Averaged Air Temperature from 1975-2016')
% ylabel('Air Temperature (°C)')
% subplot(3,1,2)
% plot(time(:,1),gust(:,1),'LineWidth',1.5,'Color','r')
% hold on
% plot(time(:,2),gust(:,2),'LineWidth',1.5,'Color','b')
% plot(time(:,3),gust(:,3),'LineWidth',1.5,'Color','k')
% plot(time(:,4),gust(:,4),'LineWidth',1.5,'Color','g')
% xlim([datenum(2000,1,1) datenum(2000,12,31)])
% ylim([4 12.5])
% datetick('x','keeplimits')
% title('44009/44025 Weekly Averaged Gust Data from 1975-2016')
% ylabel('Gust Speed (m/s)')
% subplot(3,1,3)
% plot(time(:,1),windy(:,1),'LineWidth',1.5,'Color','r')
% hold on
% plot(time(:,2),windy(:,2),'LineWidth',1.5,'Color','b')
% plot(time(:,3),windy(:,3),'LineWidth',1.5,'Color','k')
% plot(time(:,4),windy(:,4),'LineWidth',1.5,'Color','g')
% xlim([datenum(2000,1,1) datenum(2000,12,31)])
% ylim([3 10])
% datetick('x','keeplimits')
% title('44009/44025 Weekly Averaged Wind Data from 1975-2016')
% ylabel('Wind Speed (m/s)')
% print('/Users/samcoa/Documents/MATLAB/Figures/atime_wind_air_gust','-dpng','-r500');
% close all

toc