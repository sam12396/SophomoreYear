%%Notes
% Sam Coakley
% Making plots of climatological indices
% NAO: Fill value is -99.90
% ENSO: Missing values are blank // start is 1950 with second column being
%       DEC-JAN, then third Jan-Feb etc.
%%
load('nao');
load('enso');

%Remove fill values
ind1=find(nao(:,3)==-99.90);
nao(ind1,3)=nan;
clear ind1

%Loop ends with 2016
n_i_annual=[];
e_i_annual=[];
for i=1:67
    %Find yearly average of indices for NAO
    ind=find(nao(:,1)==i+1949);
    n_i=nanmean(nao(ind,3));
    
    %n_i_annual is the annual mean of the indices
    n_i_annual=[n_i_annual; n_i];
    clear n_i ind
    
    %Find yearly average of indices for ENSO
    e_i=nanmean(enso(i,2:13));
    e_i_annual=[e_i_annual; e_i];
    clear e_i
end
clear enso nao

%% Stat work
%Use t_dif from AnomaliesNMFSGliders.m script
%Need all vars to be from 1976 to 2015 so they are same length as t_dif
n_nmfs=n_i_annual(28:67,1);
e_nmfs=e_i_annual(28:67,1);

%Find correlation coeff
[rn,pn]=corrcoef(t_dif,n_nmfs);
[re,pe]=corrcoef(t_dif,e_nmfs);


correlation=[rn(1,2),pn(1,2);re(1,2),pe(1,2)];