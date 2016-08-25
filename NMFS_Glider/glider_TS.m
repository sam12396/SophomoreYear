%% Notes
% Sam Coakley
% Temperature and salinity plots using glider data. Theta_sdiag plots
% contours and you have to scatter the rest of the data yourself using the
% loop.
%% Get the data
clear;close all;

%GLIDER NAME
filename='ru05-298';
load(filename)
dgroup.timestampSensors = 'drv_m_present_time_datenum'; 
dgroup.depthSensors = 'drv_m_pressure'; 
startTimes=dgroup.startDatenums;
endTimes=dgroup.endDatenums;
dgroup.timestampSensors = 'drv_sci_m_present_time_datenum';
dgroup.depthSensors = 'drv_sci_water_pressure'; 
addCtdSensors(dgroup);
processGps(dgroup);
temp=dgroup.toArray('sensors',{'drv_sea_water_temperature'});
sal=dgroup.toArray('sensors',{'drv_sea_water_salinity'});
ii=sal(:,2) < 1;
sal(ii,:)=NaN;
temp(ii,:)=NaN;
depth(ii,:)=NaN;

% ind=find(~isnan(sal(:,3)) & ~isnan(temp(:,3)));
% sal_real=sal(ind,3);
% temp_real=temp(ind,3);

%% Plotting
figure
%have to use loop because theta_sdiag only plots contours
theta_sdiag(temp(:,3),sal(:,3));

cmap=colormap('jet');
if ~isempty(temp) && ~isempty(sal)
        fast_scatter(sal(:,3),temp(:,3),sal(:,2),'colormap',cmap);
%         c.Label.String = 'Water Pressure';
end  
title(['Temperature-Salinity ' filename ' ' datestr(startTimes(1,1),2) '-' datestr(endTimes(end,1),2)]);

print(figure(1),['/Users/samcoa/Documents/MATLAB/Figures/GliderPlots/TS/' filename],'-dpng','-r150');

close all