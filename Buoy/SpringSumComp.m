%%
% Sam Coakley
% Notes: Plotting buoy data in april to find a minimum temp and compare that temp to 
% minimum bottom temperatures collected in the summer by the NMFS survey.
% Also used to find relationship between April Buoy temps and summer cold
% pool temps.
% If it crashes on ncread for a particular year, just clear all and
% re-establish the connection by running it again.
%%
clear;close all;

lname='http://dods.ndbc.noaa.gov//thredds/dodsC/data/stdmet/';
buoyn='44025/';
fname='44025h';
yr=1991:2015;

readnmfsdata;

%Study Area Definition 
% box=[40.391 -73.416;39.133 -73.822;39.026 -72.960 ; 40.320 -72.625];
% box=[39.83 -73.41;39.547 -72.614;38.575 -73.509 ; 38.866 -74.152];
%box=[39.788 , -72.179; 39.513 , -72.537; 38.502 , -73.416 ; 38.759, -73.987];

N_lat=lat;
N_lon=lon;
%Limit Spatially
ind=find(inpolygon(N_lat,N_lon,box(:,1),box(:,2)));
% ind=find(N_lat>=37&N_lat<=40.4);
N_lat=N_lat(ind,1);
N_lon=N_lon(ind,1);
V=V(ind,:);
timeGMT=timeGMT(ind);
surfsal=surfsal(ind);
botsal=botsal(ind);
surftemp=surftemp(ind);
bottemp=bottemp(ind);

date=[];
sst=[];
%Windspeed m/s
W=[];
Wdir=[];
nmfs_lowt=nan(25,1);
buoy_avg=nan(25,1);
buoy_med=nan(25,1);

for k=1:length(yr); 
    y=yr(k)

filename=([lname buoyn fname num2str(y) '.nc']);

%Read in Buoy data
time_buoy=ncread(filename,'time');
date=datenum(1970,0,0,0,0,double(time_buoy));
sst1=squeeze(ncread(filename,'sea_surface_temperature'));
% W1=squeeze(ncread(filename,'wind_spd'));
% Wdir1=squeeze(ncread(filename,'wind_dir'));
% air_t=squeeze(ncread(filename,'air_temperature'));

%Limit to April to find the coldest temps
ii=find(date>=datenum(y,4,15) & date<datenum(y,4,30));
date1=date(ii);
sst2=sst1(ii);

%Fill arrays with averages

buoy_avg(k,1)=mean(sst2,'omitnan');
buoy_med(k,1)=median(sst2,'omitnan');



%Limit to summer and remove nans from NMFS
iii=find(timeGMT>= datenum(y,6,1) & timeGMT<= datenum(y,8,31));
g_surftemp=surftemp(iii);
g_bottemp=bottemp(iii);
t_timeGMT=timeGMT(iii);
g_botsal=botsal(iii);
g_surfsal=surfsal(iii);

ind1=find(~isnan(g_surftemp));
g_surftemp=g_surftemp(ind1);
g_bottemp=g_bottemp(ind1);
g_botsal=g_botsal(ind1);
g_surfsal=g_surfsal(ind1);
t_timeGMT=t_timeGMT(ind1);

% ind2=find(~isnan(g_surfsal));
% g_surftemp=g_surftemp(ind2);
% g_bottemp=g_bottemp(ind2);
% g_botsal=g_botsal(ind2);
% g_surfsal=g_surfsal(ind2);
% t_timeGMT=t_timeGMT(ind2);


%%%%%%Get the minimum bottom temps
%Minimum temp is defined as mean of the lowest 10 percent to make sure its
%only the cold pool
low_bt=prctile(g_bottemp,10);
bot_bt=mean(g_bottemp,'omitnan');
low_bs=prctile(g_botsal,10);
bot_bs=mean(g_botsal,'omitnan');

nmfs_lowt(k,1)=low_bt;
nmfs_lows(k,1)=low_bs;

% clear sst1 bot_bt low_bt
INDD=find(low_bt==g_bottemp);
L_timeGMT=t_timeGMT(INDD);
% indd=find(L_timeGMT==t_timeGMT);
% t_botsal=g_botsal(indd);

figure
subplot(2,2,[1,2])
plot(date,sst1,'k');
legend('Sea Surface Temp');
line([datenum(y,3,28) datenum(y,5,5)],[bot_bt bot_bt],'linewidth',1,'color','b'...
       ,'linestyle','-.');
   text(datenum(y,4,20),bot_bt-0.5,'Minimum Summer Bottom Temp')
title(['Buoy Data ' num2str(y)]);
xlim([datenum(y,3,28) datenum(y,5,5)]);
ylim([3 14]);
datetick('x',6, 'keeplimits', 'keepticks');
hold on

subplot(2,2,4)
scatter(t_timeGMT,g_botsal,20,'b','filled');
% scatter(t_timeGMT,t_botsal,20,'r','filled');
xlim([datenum(y,5,30) datenum(y,8,35)]);
ylim([20,40]);
datetick('x',6, 'keeplimits', 'keepticks');
title('Bottom Salinity')
hold on

subplot(2,2,3)
scatter(t_timeGMT,g_bottemp,20,'b','filled');
% scatter(t_timeGMT,low_bt,20,'r','filled');
xlim([datenum(y,5,30) datenum(y,8,35)]);
datetick('x',6, 'keeplimits', 'keepticks');
title('Bottom Temperature');
ylim([0,20]);

print(['/Users/samcoa/Documents/MATLAB/Figures/Buoy_NMFS/spr_sum_comp_44025_' num2str(y)],'-dpng','-r150');
close all
end
% 
% % [buoy_s,I]=sort(buoy_avg);
% % nmfs_s=nmfs_low(I);
% figure
% scatter(nmfs_lowt,buoy_avg);
% legend('Averages');
% % for p=1:11
% % plot(nmfs_lowt,buoy_avg(:,p),'+')
% % hold on
% % jj=isfinite(nmfs_lowt+buoy_avg(:,p));
% % myfit = polyfit(nmfs_lowt(jj), buoy_avg(jj,p),1);
% % test(p)=myfit(1);
% % plot(x,myfit(1)*x+myfit(2));
% % end
% xlabel('NMFS 10th Percentile')
% ylabel('Buoy Averaged From 4/15 to 4/30')
% xlim([5 11])
% ylim([5 11])
% title('NMFS Compared against Buoy')
% print('-dpng','-r150',['/Users/samcoa/Documents/MATLAB/Figures/BuoyNMFSComparison']);
% close all