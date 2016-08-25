%program to compute theta-s diagram
function theta_sdiag(theta,s)
%% generating background density contours

theta=theta(:);
s=s(:);
%BOUNDS TO MAKE SURE MAX AND MIN ARE INCLUDED
% smin=min(s)-0.01.*min(s);  
% smax=max(s)+0.01.*max(s);
% thetamin=min(theta)-0.1*max(theta);
% thetamax=max(theta)+0.1*max(theta);
smin=25;
smax=37;
thetamin=0;
thetamax=30;
xdim=round((smax-smin)./0.1+1);
ydim=round((thetamax-thetamin)+1);
dens=zeros(ydim,xdim);
thetai=((1:ydim)-1)*1+thetamin;
si=((1:xdim)-1)*0.1+smin;
disp(xdim);disp(ydim);
for j=1:ydim
    for i=1:xdim
        dens(j,i)=sw_dens(si(i),thetai(j),0);
    end
end

dens=dens-1000;
[c,h]=contour(si,thetai,dens,'k');
clabel(c,h,'LabelSpacing',1000);
xlabel('Salinity (PSU)','FontWeight','bold','FontSize',12)
ylabel('Theta (^oC)','FontWeight','bold','FontSize',12)
hold on
%% plotting scatter plot of theta and s;
% hold on;
% scatter(s,theta,'.');
% clear s theta;