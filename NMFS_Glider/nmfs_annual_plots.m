clear var
close all
readnmfsdata
load('bathymetry_USeastcoast.mat');
%Limits
low_s=26;
hi_s=35;
low_bt=4;
hi_bt=15;
low_st=15;
hi_st=28;

goodbotsal=find(~isnan(botsal));
goodsurfsal=find(~isnan(surfsal));
goodsurftemp=find(~isnan(surftemp));
goodbottemp=find(~isnan(bottemp));

for y=1973:2014
    ind=find(timeGMT>=datenum(y,1,1)&timeGMT<=datenum(y+1,1,1));
    
    %Surf Temp
    subplot(2,2,1)
    
    scatter(lon(intersect(ind,goodsurftemp),1), ...
        lat(intersect(ind,goodsurftemp),1),9,surftemp(intersect(ind,goodsurftemp),1),'filled');
    caxis([low_st,hi_st]);
    title(['Surface Temp Fall ' int2str(y)]);
    hold on
    colorbar();
    contour(loni,lati,depthi,[0 0],'k');
    contour(loni,lati,depthi,[-20 -50 -100],'r','LineWidth',1);
    xlim([-78 -65]);
    ylim([35 42]);
    
    %Surf Sal
    subplot(2,2,2)
    
    scatter(lon(intersect(ind,goodsurfsal),1),...
        lat(intersect(ind,goodsurfsal),1),9,surfsal(intersect(ind,goodsurfsal),1),'filled');
    caxis([low_s,hi_s]);
    title(['Surface Salinity Fall ' int2str(y)])
    hold on
    colorbar();
    contour(loni,lati,depthi,[0 0],'k');
    contour(loni,lati,depthi,[-20 -50 -100],'r','LineWidth',1);
    xlim([-78 -65]);
    ylim([35 42]);
    
    %Bot Temp
    subplot(2,2,3)
    
    scatter(lon(intersect(ind,goodbottemp),1),...
        lat(intersect(ind,goodbottemp),1),9,bottemp(intersect(ind,goodbottemp),1),'filled');
    caxis([low_bt,hi_bt]);
    title(['Bottom Temp Fall ' int2str(y)]);
    hold on
    colorbar();
    contour(loni,lati,depthi,[0 0],'k');
    contour(loni,lati,depthi,[-20 -50 -100],'r','LineWidth',1);
    xlim([-78 -65]);
    ylim([35 42]);
    
    %Bot Sal
    subplot(2,2,4)
    
    scatter(lon(intersect(ind,goodbotsal),1),...
        lat(intersect(ind,goodbotsal),1),9,botsal(intersect(ind,goodbotsal),1),'filled');
    caxis([low_s,hi_s]);
    title(['Bottom Salinity Fall ' int2str(y)]);
    hold on
    colorbar();
    contour(loni,lati,depthi,[0 0],'k');
    contour(loni,lati,depthi,[-20 -50 -100],'r','LineWidth',1);
    xlim([-78 -65]);
    ylim([35 42]);
    
    %Printing
    print('-dpng','-r150',['/Users/samcoa/Documents/MATLAB/NMFS_Annual_Plots/Fall/nmfs_' int2str(y)]);
    close all
end