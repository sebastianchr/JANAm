function output=readm41(file)


output=[];

%read m41 file
fid=fopen(file,'r');

%read all as string
if fid==-1; error('Inputfile not found'); return; end
x=fread(fid,'*char')';

%read shift parameters
varkeys={'# Shift parameters - zero, sycos, sysin' ...
    '# Background parameters' ...
    '# Asymmetry parameters' ...
    '# Cell parameters - a,b,c,alpha,beta,gamma' ...
    '# Gaussian parameters - U,V,W,P' ...
    '# Lorentzian parameters - LX,LXe,LY,LYe' ...
    '# Strain parameters'};

varnames={'shift' ...
    'background' ...
    'asymmetry' ...
    'cell' ...
    'gaussian' ...
    'lorentzian' ...
    'strain'};

parnames.shift={'zero', 'sycos','sysin'};
parnames.background={};
parnames.asymmetry={};
parnames.cell={'a','b','c','alpha','beta','gamma',};
parnames.gaussian={'U','V','W','P'};
parnames.lorentzian={'LX','LXe','LY','LYe','Dzeta'};
parnames.strain={ 'St400'    'St310'    'St301' , ...
    'St220'    'St211'    'St202' , ...
    'St130'    'St121'    'St112' , ...
    'St103'    'St040'    'St031' , ...
    'St022'    'St013'    'St004'};


for i=1:length(varkeys)
    if does_parameter_exist(x,varkeys{i});
        [PAR, ESD, FLAGS]=extract_values(x,varkeys{i});
        output.(varnames{i}).par=PAR;
        output.(varnames{i}).esd=ESD;
        output.(varnames{i}).par_refined=PAR(FLAGS);
        output.(varnames{i}).esd_refined=ESD(FLAGS);
        output.(varnames{i}).parameter_names=parnames.(varnames{i});
    end
end
end


function doExist=does_parameter_exist(x,varStr)
temp=regexp(x,varStr,'match');
doExist=isempty(temp)==0;
end


function [PAR, ESD, FLAGS]=extract_values(x,varStr)
T = regexp(x, [varStr '[\n\r]+' '([0-9\-\. \n\r]+)(?=[\n\r]+[#-])'], 'tokens');

par_str=T{1}{1};
float='[ -][0-9]+\.[0-9]*';
a=regexp(par_str, ['([' float ']+)'], 'tokens');

par=[]; flags=[];

for i=1:length(a)
    par_i=regexp(a{i}{1},['([0-9 -\.]+)  [ ]*[01]+'],'tokens');
    flags_i=regexp(a{i}{1},['    ([01])+'],'tokens');
    
    par=[par par_i{1}{1}];
    flags=[flags flags_i{1}{1}];
end

esd_str=T{2}{1};
ESD=str2num(regexprep(esd_str,'[\n\r]',' '));
par=regexprep(par,'-',' -');
PAR=str2num(par);
FLAGS=logical(str2num(flags(:))');
end