%%
% RSS feed data reorganization
%
%% 
%Load data into single column from text file
[tid,pth] = uigetfile;
pthn = [pth tid];
fid = fopen(pthn);
C = textscan(fid,'%s','delimiter',',');
%%
raw = C{1,1};
Repx = strfind(raw,'Replicate');
Repi = find(not(cellfun('isempty',Repx)));
RepCount = size(Repi,1);

%% 
Head = [{'DateTime'}];
%%
for Tidx = 1:20;
    Head = [Head, {raw{3*Tidx,1}}];
end



%% Find Tank Headings
TankInd = [];


