%% Notes
% Sam Coakley
% 7/20/16
% Same as glider_nmfs_t_min.m but seperates all the data into decadal data
% Adapated from early_late_t_min.m
% Modified for use in making different plots
%% Data
tic
clear  
close all

% NMFS data
readnmfsdata;
clearvars -except botsal bottemp lat lon surfsal surftemp V timeGMT last ...
    maxdepth
% box=[40.391 -73.416;39.133 -73.822;39.026 -72.960 ; 40.320 -72.625];
% box=[39.83 -73.41;39.547 -72.614;38.575 -73.509 ; 38.866 -74.152];
% box=[39.788 , -72.179; 39.513 , -72.537; 38.502 , -73.416 ; 38.759, -73.987];
%box = [39.837 -73.427; 39.541 -72.526; 38.465 -73.427; 38.834 -74.316];
%box #5 7/13
box=[38.547 -73.459;  38.864 -74.294; 39.541 -72.542; 39.854 -73.432];
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
surftemp=surftemp(ind);
clear ind IND INDD indd



Nbt_min=[];
Ns_cp=[];
Ns_max=[];
Ntime_min=[];
Ntime_max=[];
Nst=[];

ct=0;
%To get weekly min temp
for j=1:7:299
    t_min     =nan(10,4);
    s_cp      =nan(10,4);
    time_min     =nan(10,4);
    %Decadal from 1976
    ct=0;
    for kk=1976:2015
        %Need to find a better place to start then jan 1 
        %somewhere that has lowest temps
        %For now ... use March 1
        ct=ct+1;
    ind=find(datenum(V)>=datenum(kk,3,j) & datenum(V)<=datenum(kk,3,j+7));
    bs=botsal(ind);
    bt=bottemp(ind);
    time=V(ind,:);
    %Count is used to fill in four seperate columns each corresponding to a
    %decade
    if ct>=1 & ct<=10
        if sum(isfinite(bt))~=0
            [t_min(ct,1),indd]=min(bt,[],'omitnan');
            s_cp(ct,1)=bs(indd,1);
            time_min(ct,1)=datenum(time(indd,:));
        else
            t_min(ct,1)=nan;
            s_cp(ct,1)=nan;
            time_min(ct,1)=nan;
        end
    end

    if ct>=11 & ct<=20
        if sum(isfinite(bt))~=0
            [t_min(ct-10,2),indd]=min(bt,[],'omitnan');
            s_cp(ct-10,2)=bs(indd,1);
            time_min(ct-10,2)=datenum(time(indd,:));
        else
            t_min(ct-10,2)=nan;
            s_cp(ct-10,2)=nan;
            time_min(ct-10,2)=nan;
        end
    end
    
    if ct>=21 & ct<=30
        if sum(isfinite(bt))~=0
            [t_min(ct-20,3),indd]=min(bt,[],'omitnan');
            s_cp(ct-20,3)=bs(indd,1);
            time_min(ct-20,3)=datenum(time(indd,:));
        else
            t_min(ct-20,3)=nan;
            s_cp(ct-20,3)=nan;
            time_min(ct-20,3)=nan;
        end
    end
    
    if ct>=31 & ct<=40
        if sum(isfinite(bt))~=0
            [t_min(ct-30,4),indd]=min(bt,[],'omitnan');
            s_cp(ct-30,4)=bs(indd,1);
            time_min(ct-30,4)=datenum(time(indd,:));
        else
            t_min(ct-30,4)=nan;
            s_cp(ct-30,4)=nan;
            time_min(ct-30,4)=nan;
        end
    end
    
        clear ind bs bt indd time 
    end

    %Full decadal data set
    V_temp=nan(10,4);
    
    time_temp_1=datevec(time_min(:,1));
    time_temp_2=datevec(time_min(:,2));
    time_temp_3=datevec(time_min(:,3));
    time_temp_4=datevec(time_min(:,4));
    
        V_temp(:,1)=datenum(2000,time_temp_1(:,2),time_temp_1(:,3));
        V_temp(:,2)=datenum(2000,time_temp_2(:,2),time_temp_2(:,3));
        V_temp(:,3)=datenum(2000,time_temp_3(:,2),time_temp_3(:,3));
        V_temp(:,4)=datenum(2000,time_temp_4(:,2),time_temp_4(:,3));
    Nbt_min=[Nbt_min; t_min];
    Ns_cp =[Ns_cp; s_cp];
    Ntime_min =[Ntime_min; V_temp];

    clear t_min s_cp V_min t_std V_temp
end
%To get weekly max temp
for j=1:7:299
    s_max        =nan(10,4);
    time_min     =nan(10,4);
    t_max        =nan(10,4);
    %Decadal from 1976
    ct=0;
    for kk=1976:2015
        %Need to find a better place to start then jan 1 
        %somewhere that has lowest temps
        %For now ... use March 1
        ct=ct+1;
    ind=find(datenum(V)>=datenum(kk,3,j) & datenum(V)<=datenum(kk,3,j+7));
    ss=surfsal(ind);
    st=surftemp(ind);
    time=V(ind,:);
    %Count is used to fill in four seperate columns each corresponding to a
    %decade
    if ct>=1 & ct<=10
        if sum(isfinite(st))~=0
            [t_max(ct,1),indd]=max(st,[],'omitnan');
            s_max(ct,1)=ss(indd,1);
            time_max(ct,1)=datenum(time(indd,:));
        else
            t_max(ct,1)=nan;
            s_max(ct,1)=nan;
            time_max(ct,1)=nan;
        end
    end
    
    if ct>=11 & ct<=20
        if sum(isfinite(st))~=0
            [t_max(ct-10,2),indd]=max(st,[],'omitnan');
            s_max(ct-10,2)=ss(indd,1);
            time_max(ct-10,2)=datenum(time(indd,:));
        else
            t_max(ct-10,2)=nan;
            s_max(ct-10,2)=nan;
            time_max(ct-10,2)=nan;
        end
    end
    
    if ct>=21 & ct<=30
        if sum(isfinite(st))~=0
            [t_max(ct-20,3),indd]=max(st,[],'omitnan');
            s_max(ct-20,3)=ss(indd,1);
            time_max(ct-20,3)=datenum(time(indd,:));
        else
            t_max(ct-20,3)=nan;
            s_max(ct-20,3)=nan;
            time_max(ct-20,3)=nan;
        end
    end
    
    if ct>=31 & ct<=40
        if sum(isfinite(st))~=0
            [t_max(ct-30,4),indd]=max(st,[],'omitnan');
            s_max(ct-30,4)=ss(indd,1);
            time_max(ct-30,4)=datenum(time(indd,:));
        else
            t_max(ct-30,4)=nan;
            s_max(ct-30,4)=nan;
            time_max(ct-30,4)=nan;
        end
    end
    
        clear ind bs bt indd time st ss 
    end

    %Full decadal data set
    V_temp=nan(10,4);
    
    time_temp_1=datevec(time_max(:,1));
    time_temp_2=datevec(time_max(:,2));
    time_temp_3=datevec(time_max(:,3));
    time_temp_4=datevec(time_max(:,4));
    
        V_temp(:,1)=datenum(2000,time_temp_1(:,2),time_temp_1(:,3));
        V_temp(:,2)=datenum(2000,time_temp_2(:,2),time_temp_2(:,3));
        V_temp(:,3)=datenum(2000,time_temp_3(:,2),time_temp_3(:,3));
        V_temp(:,4)=datenum(2000,time_temp_4(:,2),time_temp_4(:,3));
    Ns_max =[Ns_max; s_max];
    Ntime_max =[Ntime_max; V_temp];
    Nst=[Nst; t_max];
    clear t_max s_max V_max t_std V_temp
end
clear j botsal bottemp count dni kk lat lon maxdepth s_cp t_min V_min V_temp ...
    surfsal surftemp V

%% Glider Data
g_btemp=[];
g_stemp=[];
g_sal =[];
gbt_fin=[];
gs_min_fin=[];
gs_max_fin=[];
gst_fin=[];
gtime_min_fin=[];
gtime_max_fin=[];
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
g_btemp=temp(ddni,3);
g_stemp=temp(ddni,3);
g_sal=sal(ddni,3);
g_depth=depth(ddni);
clear ddni


for jj=1:7:299
    
    gt_min=nan(20,4);
    gs_min=nan(20,4);
    gtime_min =nan(20,4);
    ct=0;
    for kk=1996:2015 
        ct=ct+1;
    ind=find((g_times>=datenum(kk,3,jj) & g_times<=datenum(kk,3,jj+7)));
    temp_g_btemp=g_btemp(ind);
%     if kk==2006
%         sum(isfinite(temp_g_temp))
%         whos temp_g_temp
%     end
%start at column 3 b/c there is no data from the first two decades
        if ct==1:10
            if sum(isfinite(temp_g_btemp))~=0
                [gt_min(ct,3), dni]=min(temp_g_btemp,[],'omitnan');
                gs_min(ct,3)=g_sal(ind(dni));
                gtime_min(ct,3)=g_times(ind(dni));
            else
                gt_min(ct,3)=nan;
                gs_min(ct,3)=nan;
                gtime_min(ct,3)=nan;
            end
        end

        if ct==11:20
            if sum(isfinite(temp_g_btemp))~=0
                [gt_min(ct-10,4), dni]=min(temp_g_btemp,[],'omitnan');
                 gs_min(ct-10,4)=g_sal(ind(dni));
                 gtime_min(ct-10,4)=g_times(ind(dni));
            else
                gt_min(ct-10,4)=nan;
                gs_min(ct-10,4)=nan;
                gtime_min(ct-10,4)=nan;
            end
        end
    end
    datevec(gtime_min);
    gbt_fin   =[gbt_fin; gt_min];
    gs_min_fin   =[gs_min_fin; gs_min];
    gtime_min_fin=[gtime_min_fin; gtime_min];
    clear ind gt_min gs_min gtime_min temp_g_temp
end

for jj=1:7:299
    
    gt_max=nan(20,4);
    gs_max=nan(20,4);
    gtime_max =nan(20,4);
    ct=0;
    for kk=1996:2015 
        ct=ct+1;
    ind=find((g_times>=datenum(kk,3,jj) & g_times<=datenum(kk,3,jj+7)));
    temp_g_stemp=g_stemp(ind);
%     if kk==2006
%         sum(isfinite(temp_g_temp))
%         whos temp_g_temp
%     end
%start at column 3 b/c there is no data from the first two decades
        if ct==1:10
            if sum(isfinite(temp_g_stemp))~=0
                [gt_max(ct,3), dni]=max(temp_g_stemp,[],'omitnan');
                gs_max(ct,3)=g_sal(ind(dni));
                gtime_max(ct,3)=g_times(ind(dni));
            else
                gt_max(ct,3)=nan;
                gs_max(ct,3)=nan;
                gtime_max(ct,3)=nan;
            end
        end

        if ct==11:20
            if sum(isfinite(temp_g_stemp))~=0
                [gt_max(ct-10,4), dni]=max(temp_g_stemp,[],'omitnan');
                 gs_max(ct-10,4)=g_sal(ind(dni));
                 gtime_max(ct-10,4)=g_times(ind(dni));
            else
                gt_max(ct-10,4)=nan;
                gs_max(ct-10,4)=nan;
                gtime_max(ct-10,4)=nan;
            end
        end
    end
    datevec(gtime_max);
    gst_fin  =[gst_fin; gt_max];
    gs_max_fin   =[gs_max_fin; gs_max];
    gtime_max_fin=[gtime_max_fin; gtime_max];
    clear ind gt_max gs_max gtime_max temp_g_stemp
end
clear g_sal g_temp g_times
close all; clear depth dgroup filename ii sal temp lat lon
end
clear j
%     gt_std=nanstd(gt_fin);
%     dni  = gt_fin < (nanmean(gt_fin)+1*abs(gt_std)) & gt_fin > (nanmean(gt_fin)-1*abs(gt_std));
%     gt_fin=gt_fin(dni);
%     gs_fin =gs_fin(dni);
%     gtime_fin=gtime_fin(dni,:);

%Make them all the same year so it is plotted nicely MIN
    time_temp_1=datevec(gtime_min_fin(:,1));
    time_temp_2=datevec(gtime_min_fin(:,2));
    time_temp_3=datevec(gtime_min_fin(:,3));
    time_temp_4=datevec(gtime_min_fin(:,4));
    g_fake_time_min=nan(length(gtime_min_fin),4);
        g_fake_time_min(:,1)=datenum(2000,time_temp_1(:,2),time_temp_1(:,3));
        g_fake_time_min(:,2)=datenum(2000,time_temp_2(:,2),time_temp_2(:,3));
        g_fake_time_min(:,3)=datenum(2000,time_temp_3(:,2),time_temp_3(:,3));
        g_fake_time_min(:,4)=datenum(2000,time_temp_4(:,2),time_temp_4(:,3));

%Make them all the same year so it is plotted nicely MAX
    time_temp_1=datevec(gtime_max_fin(:,1));
    time_temp_2=datevec(gtime_max_fin(:,2));
    time_temp_3=datevec(gtime_max_fin(:,3));
    time_temp_4=datevec(gtime_max_fin(:,4));
    g_fake_time_max=nan(length(gtime_max_fin),4);
         g_fake_time_max(:,1)=datenum(2000,time_temp_1(:,2),time_temp_1(:,3));
         g_fake_time_max(:,2)=datenum(2000,time_temp_2(:,2),time_temp_2(:,3));
         g_fake_time_max(:,3)=datenum(2000,time_temp_3(:,2),time_temp_3(:,3));
         g_fake_time_max(:,4)=datenum(2000,time_temp_4(:,2),time_temp_4(:,3));

%% All_data manipulation
%al=all
al_btemp=[Nbt_min ; gbt_fin];
al_stemp=[Nst; gst_fin];
al_sal_min=[Ns_cp ; gs_min_fin];
al_sal_max=[Ns_max ; gs_max_fin];
al_time_min=[Ntime_min ; g_fake_time_min];
al_time_max=[Ntime_max ; g_fake_time_max];

%Limit by 3 stdevs MIN
btemp_std=nanstd(al_btemp(:));
btemp_mean=nanmean(al_btemp(:));

lengt=length(al_btemp);
al_btemp_vec=al_btemp(:);
al_sal_vec=al_sal_min(:);
al_time_min_vec=al_time_min(:);
al_stemp_vec=al_stemp(:);

dni= find(al_btemp_vec>= (btemp_mean+(3*abs(btemp_std))) & al_btemp_vec <= (btemp_mean-(3*abs(btemp_std))));
al_btemp_vec(dni)=nan;
al_sal_vec(dni)=nan;
al_time_min_vec(dni)=nan;

al_btemp_f=reshape(al_btemp_vec,[lengt,4]);
al_sal_min_f=reshape(al_sal_vec,[lengt,4]);
al_time_min_f=reshape(al_time_min_vec,[lengt,4]);

clear  lengt al_sal_vec dni
%Limit by 3 stdevs MAX
stemp_std=nanstd(al_stemp(:));
stemp_mean=nanmean(al_stemp(:));

lengt=length(al_stemp);
al_sal_vec=al_sal_min(:);
al_time_max_vec=al_time_max(:);
al_stemp_vec=al_stemp(:);

dni= find(al_stemp_vec>= (stemp_mean+(3*abs(stemp_std))) & al_stemp_vec <= (stemp_mean-(3*abs(stemp_std))));
al_stemp_vec(dni)=nan;
al_sal_vec(dni)=nan;
al_time_max_vec(dni)=nan;

al_sal_max_f=reshape(al_sal_vec,[lengt,4]);
al_time_max_f=reshape(al_time_max_vec,[lengt,4]);
al_stemp_f=reshape(al_stemp_vec,[lengt,4]);

temp_al_min=nan(lengt.*4,1);
temp_al_max=nan(lengt.*4,1);
al_t_dif_vec=nan(lengt.*4,1);

ind=find(al_time_min_vec==al_time_max_vec);
temp_al_min(ind)=al_btemp_vec(ind);
temp_al_max(ind)=al_stemp_vec(ind);

ind2=find(isfinite(temp_al_max(:))==1 & isfinite(temp_al_min(:))==1);
al_t_dif_vec(ind2)=temp_al_max(ind2)-temp_al_min(ind2);
al_t_dif=reshape(al_t_dif_vec,[lengt,4]);


%% Plotting
% 
figure(1)
scatter(al_time_min_f(:,1),al_btemp_f(:,1),36,'b','*')
hold on
scatter(al_time_min_f(:,2),al_btemp_f(:,2),36,'g','*')
scatter(al_time_min_f(:,3),al_btemp_f(:,3),36,'r','*')
scatter(al_time_min_f(:,4),al_btemp_f(:,4),36,'k','*')

plot([datenum(2000,4,1), datenum(2000,7,16), datenum(2000,10,16)], ...
    [5.84,6.23,9.07],'b');
plot([datenum(2000,4,1), datenum(2000,7,16), datenum(2000,10,16)], ...
    [6.13,7,8.98],'g');
plot([datenum(2000,4,1), datenum(2000,7,16), datenum(2000,10,16)], ...
    [6.41,7.59,8.92],'r');
plot([datenum(2000,4,1), datenum(2000,7,16), datenum(2000,10,16)], ...
    [6.26,7.54,9.72],'k');

ylim([2 15])
ylabel('Temperature (°C)')
datetick('x','keeplimits');
legend('Minimum Temp 1976-1985','Minimum Temp 1986-1995','Minimum Temp 1996-2005','Minimum Temp 2006-2015','Location','NorthWest')
title('Minimum temperature by week ');
print(figure(1),'/Users/samcoa/Documents/MATLAB/Figures/MTS/decadal_t_min','-dpng','-r500');
close all
% 
% % figure(2)
% % scatter(al_time_min_f(:,1),al_sal_min_f(:,1),36,'b','o')
% % hold on
% % scatter(al_time_min_f(:,2),al_sal_min_f(:,2),36,'g','o')
% % scatter(al_time_min_f(:,3),al_sal_min_f(:,3),36,'r','o')
% % scatter(al_time_min_f(:,4),al_sal_min_f(:,4),36,'k','o')
% % ylim([31.5 35.5])
% % ylabel('Salinity (PSU)')
% % datetick('x','keeplimits');
% % legend('T-Min Salinity 1976-1985','T-Min Salinity 1986-1995','T-Min Salinity 1996-2005','T-Min Salinity 2006-2015')
% % title('Salinity associated with T-min by week NMFS/Glider Time Series');
% % print(figure(2),'/Users/samcoa/Documents/MATLAB/Figures/MTS/decadal_sal_t_min','-dpng','-r300');
% % close all
% 
% 
% % figure(3)
% % scatter(al_time_max_f(:,1),al_stemp_f(:,1),36,'b','^')
% % hold on
% % scatter(al_time_max_f(:,2),al_stemp_f(:,2),36,'g','^')
% % scatter(al_time_max_f(:,3),al_stemp_f(:,3),36,'r','^')
% % scatter(al_time_max_f(:,4),al_stemp_f(:,4),36,'k','^')
% % ylim([1 30])
% % ylabel('Temperature (°C)')
% % datetick('x','keeplimits');
% % legend('Maximum Temperature 1976-1985','Maximum Temperature 1986-1995',...
% %     'Maximum Temperature 1996-2005','Maximum Temperature 2006-2015','Location','NorthWest')
% % title('Maximum Temperature by week NMFS/Glider Time Series');
% % print(figure(3),'/Users/samcoa/Documents/MATLAB/Figures/MTS/decadal_t_max','-dpng','-r300');
% % close all
% 
% % figure(4)
% % scatter(al_time_min(:,1),al_t_dif(:,1),36,'b','x');
% % hold on
% % scatter(al_time_min(:,2),al_t_dif(:,2),36,'g','x');
% % scatter(al_time_min(:,3),al_t_dif(:,3),36,'r','x');
% % scatter(al_time_min(:,4),al_t_dif(:,4),36,'k','x');
% % ylim([-5 25])
% % ylabel('Difference in Temperature (°C)')
% % datetick('x','keeplimits');
% % legend('T-Max minus T-Min 1976-1985','T-Max minus T-Min 1986-1995',...
% %     'T-Max minus T-Min 1996-2005','T-Max minus T-Min 2006-2015','Location','NorthWest')
% % title('Difference between Maximum and Minimum Temp by week NMFS/Glider Time Series');
% % print(figure(4),'/Users/samcoa/Documents/MATLAB/Figures/MTS/decadal_t_dif','-dpng','-r300');
% % close all
% 
% 
% figure(5)
% for p=1:4
% scatter(al_time_min(:,p),al_t_dif(:,p),36,'k','x');
% hold on
% scatter(al_time_max_f(:,p),al_stemp_f(:,p),36,'b','^')
% scatter(al_time_min_f(:,p),al_btemp_f(:,p),36,'g','*')
% end
% legend('Difference Between T-Max and T-Min','T-Max','T-Min','location','NorthWest');
% ylim([-4 28])
% ylabel('Temperature (°C)')
% datetick('x','keeplimits');
% title('Maximum and minimum temperature by week');
% print(figure(5),'/Users/samcoa/Documents/MATLAB/Figures/MTS/decadal_all_temps','-dpng','-r500');
% close all


% clearvars -except al_time_min al_t_dif
%check to see if mean_wind_ts is doing daily or weekly averages
%CURRENTLY RUNNING WEEKLY MEANS
% mean_wind_ts
%Plot time by difference in temp and gust speed
% subplot(3,1,1)
% plot(time(:,1),air(:,1),'LineWidth',1.5,'Color','r')
% hold on
% plot(time(:,2),air(:,2),'LineWidth',1.5,'Color','b')
% plot(time(:,3),air(:,3),'LineWidth',1.5,'Color','k')
% plot(time(:,4),air(:,4),'LineWidth',1.5,'Color','g')
% xlim([datenum(2000,2,15) datenum(2000,11,20)])
% ylim([3 24])
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
% xlim([datenum(2000,2,15) datenum(2000,11,20)])
% ylim([5 12.5])
% datetick('x','keeplimits')
% title('44009/44025 Weekly Averaged Gust Data from 1975-2016')
% ylabel('Gust Speed (m/s)')
% subplot(3,1,3)
% scatter(al_time_min(:,1),al_t_dif(:,1),10,'r','filled','MarkerEdgeColor','r');
% hold on
% scatter(al_time_min(:,2),al_t_dif(:,2),10,'b','filled','MarkerEdgeColor','b');
% scatter(al_time_min(:,3),al_t_dif(:,3),10,'k','filled','MarkerEdgeColor','k');
% scatter(al_time_min(:,4),al_t_dif(:,4),10,'g','filled','MarkerEdgeColor','g');
% xlim([datenum(2000,2,15) datenum(2000,11,20)])
% ylim([-3 23])
% datetick('x','keeplimits')
% title('Difference between maximum and minimum temperature')
% ylabel('Temperature difference (°C)')
% print('/Users/samcoa/Documents/MATLAB/Figures/MTS/t_dif_and_gust','-dpng','-r500');
% close all
% toc

%Just gust and t-dif
% time_2=[];
% gust_2=[];
% for j=1:52
%     time_2(1,j)=nanmean(time(j,:));
%     
%     gust_2(1,j)=nanmean(gust(j,:));
% end
% clear j
% subplot(2,1,1)
% plot(time_2(1,:),gust_2(1,:),'LineWidth',1.5,'Color','b')
% hold on
% xlim([datenum(2000,2,15) datenum(2000,11,20)])
% ylim([5 12.5])
% datetick('x','keeplimits')
% title('44009/44025 Weekly Averaged Gust Data from 1975-2016')
% ylabel('Gust Speed (m/s)')
% subplot(2,1,2)
% for j=1:4
% scatter(al_time_min(:,j),al_t_dif(:,j),10,'r','filled','MarkerEdgeColor','r');
% hold on
% end
% xlim([datenum(2000,2,15) datenum(2000,11,20)])
% ylim([-3 23])
% box on
% datetick('x','keeplimits')
% title('Difference between maximum and minimum temperature')
% ylabel('Temperature difference (°C)')
% print('/Users/samcoa/Documents/MATLAB/Figures/MTS/t_dif_and_gust_2','-dpng','-r500');
% close all
% toc