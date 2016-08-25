% super roundabout, overly complicated way to read in nmfs data...but I
% don't know a better way to get it into matlab, so here goes


% nmfsfile='/Users/palamara/Documents/coca/nmfstrawl.txt';
% nmfsfile='/Users/palamara/Documents/OS2016/butters_nmfs.txt';
nmfsfile='/Users/samcoa/Documents/MATLAB/Data/nmfs_alltows.txt';

% open the file and get the info on the header to see how many columns
% there are - each will be read in as a cell array of strings
fid=fopen(nmfsfile);
header=textscan(fid,'%s');
fclose(fid);
header=header{1};
numcol=length(find(header{1}==','));
format=[];
for n=1:numcol+1
    format=[format '%s'];
end

% read in all data
fid=fopen(nmfsfile);
data=textscan(fid,format,'delimiter',',');
fclose(fid);

clear fid numcol format header

% assign each column to its variable name (defined by the column header)
for n=1:length(data)
    v=data{n};
    eval([genvarname(v{1}) '=v(2:end);']);
end

% this section would limit it to a specific type of trawl - I believe 10 is
% the typical spring and fall cruise and 60 is a summer scallop cruise -
% but you shouldn't need to do this anyway
%
% ind=strcmp(purposecode,'10');
% for n=1:length(data)
%     v=data{n};
%     eval([genvarname(v{1}) '=' genvarname(v{1}) '(ind);']);
% end

% % limit it to seasonal tows
% ind=strcmp(season,'FALL');
% for n=1:length(data)
%     v=data{n};
%     eval([genvarname(v{1}) '=' genvarname(v{1}) '(ind);']);
% end

% convert time to matlab
startdateGMT=[char(startdateGMT) char(32*ones(size(timeGMT))) char(timeGMT)];
timeGMT=nan(size(startdateGMT,1),1);
ind=find(startdateGMT(:,1)~=' ');
timeGMT(ind)=datenum(startdateGMT(ind,:),'dd-mmm-yyyy HH:MM:SS');
clear start*GMT ind


% list numeric variables
numvars={'botsal','bottemp','endlat','endlon',...
    'expcatchwt','expcatnum','lat','lon','maxdepth',...
    'surfsal','surftemp'};
allvars=[numvars,{'catchsex','cruise6','crunum','purposecode','season',...
    'spp_name','station','statuscode','stratum','svspp','svvessel','timeGMT','tow'}];

% convert numeric variables to numeric arrays
for n=1:length(numvars)
    eval(['ind=find(strcmp(' numvars{n} ',''''));']);
    eval([numvars{n} '(ind)={''nan''};']);
    eval([numvars{n} '=char(' numvars{n} ');']);
    eval([numvars{n} '=str2num(' numvars{n} ');']);
end


% limit to data between 35 and 42 N
ind=find(lat>=35&lat<=42);
for n=1:length(allvars)
    eval([allvars{n} '=' allvars{n} '(ind);']);
end

start=datestr(min(timeGMT),29);
last=datestr(max(timeGMT),29);

ind=find(surftemp(:,1)<=0);
surftemp(ind,1)=nan;
clear ind

ind=find(surfsal(:,1)<=0 | surfsal(:,1)>40);
surfsal(ind,1)=NaN;
clear ind

ind=find(botsal(:,1)<=0 | botsal(:,1)>40);
botsal(ind,1)=NaN;
clear ind

%Limit data by months
V=datevec(timeGMT);


