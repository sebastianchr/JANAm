%read from prf file
function [tth Int output]=read_prf(inputfile)

fid = fopen(inputfile);
if fid==-1; disp('Inputfile not found'); return; end
x=fread(fid,'*char')';

i_begin=regexp(x, '(?-s)(?m)999\r\n', 'start');
i_end=regexp(x, '(?-s)(?m)999\.\r\n', 'end');

%read reflektion data
refdat=x(1:i_begin-1);
%remove first line
refdat=regexprep(refdat,'.*?\r\n','','once'); %remove first and last line
format='%f';
REFDAT = sscanf(refdat, format);
REFDAT=reshape(REFDAT,9,[])';

hkl=REFDAT(:,1:3);
multiplicity=REFDAT(:,4);
phase=REFDAT(:,5);
tth0=REFDAT(:,6);
width0=REFDAT(:,8);
Int0=REFDAT(:,9);

output=[];
output.hkl=hkl;
output.multiplicity=multiplicity;
output.twotheta_hkl=tth0;
output.peakwidth_hkl=width0;
output.peakintensity_hkl=Int0;


% read diffraction pattern
dat=x(i_begin:i_end);
dat=regexprep(dat,'999[\. \t]*\r\n',''); %remove first and last line
format='%f';
DAT = sscanf(dat, format);
firstline=regexp(dat,'(.*?\r\n)','tokens','once');
number_of_values_per_line=length(regexp(firstline{1},'.*?[ \r]+ '));

switch number_of_values_per_line
    case 9
        
        %I am not sure what all the values are. Finish this
        DAT=reshape(DAT,9,[])';
        tth=DAT(:,1); Int=DAT(:,2);
        output.twotheta_pattern=tth;
        output.intensity_pattern=Int;
        
    case 8
        DAT=reshape(DAT,8,[])';
        tth=DAT(:,1); Int=DAT(:,2);
        output.twotheta_pattern=tth;
        output.intensity_pattern=Int;
end
end