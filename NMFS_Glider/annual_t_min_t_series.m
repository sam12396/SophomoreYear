%% Notes
% Sam Coakley
% Used to plot annual min bottom temps and their associated salinities. 
% Limited to study area
% Used to find normal trend in min temp

%% Read in data

clear  
close all

% NMFS data
readnmfsdata;
clearvars -except botsal bottemp lat lon surfsal surftemp V timeGMT start last ...
    maxdepth
% box=[40.391 -73.416;39.133 -73.822;39.026 -72.960 ; 40.320 -72.625];
box=[39.83 -73.41;39.547 -72.614;38.575 -73.509 ; 38.866 -74.152];
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

for kk=1976:2014
kk
t_min=nan(52,1);
s_cp=nan(52,1);
V_min=nan(52,1);
for j=1:7:358
    ind=find(datenum(V)>=datenum(kk,1,j) & datenum(V)<=datenum(kk,1,j+7));
    bs=botsal(ind);
    bt=bottemp(ind);
    if sum(isfinite(bt))~=0
        [t_min(j,1),indd]=min(bt,[],'omitnan');
        s_cp(j,1)=bs(indd,1);
    else
        t_min(j,1)=nan;
        s_cp(j,1)=nan;
    end
    V_min(j,1)=mean(V(ind,2),'omitnan');
    clear ind bs bt indd
end
%% Plotting
figure(1)
scatter(datenum(kk,V_min,1),t_min,36,'b','*')
xlim([datenum(kk-1, 12, 29) datenum(kk, 12 ,4)])
ylim([2 11])
datetick('x','keeplimits');
title(['T-min NMFS Time Series: ' int2str(kk)]);
print(figure(1),['/Users/samcoa/Documents/MATLAB/Figures/NMFS_TimeS/t_min/t_min_nmfs_' int2str(kk)],'-dpng','-r150');
close

figure(2)
scatter(datenum(kk,V_min,1),s_cp,36,'b','o')
xlim([datenum(kk-1, 12, 29) datenum(kk, 12 ,4)])
ylim([31 35])
datetick('x','keeplimits');
legend('NMFS Sal');
title(['Salinity of T-min NMFS Time Series: ' int2str(kk)])
print(figure(2),['/Users/samcoa/Documents/MATLAB/Figures/NMFS_TimeS/t_min/t_min_sal_nmfs_' int2str(kk)],'-dpng','-r150');
close all

clear s_cp t_min indd V_min j
end
