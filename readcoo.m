function [output]=readcoo(filename)
str = fileread(filename);
%a=regexp(str,'x[ \t]*y[ \t]*z[ \t]*x_coc[ \t]*y_coc[ \t]*z_coc[ \t]*charge[ \t]*density[ \t]*vol.[ \t]*\n[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)[ \t]*([0-9\.\-]+)','tokens')

% a=regexp(str,'x[ \t]*y[ \t]*z[ \t]*x_coc[ \t]*y_coc[ \t]*z_coc[ \t]*charge[ \t]*density[ \t]*vol.[ \t]*\n[ \t]*( ([0-9\.\-]+[ \t]*[0-9\.\-]+[ \t]*[0-9\.\-]+[ \t]*[0-9\.\-]+[ \t]*[0-9\.\-]+[ \t]*[0-9\.\-]+[ \t]*[0-9\.\-]+[ \t]*[0-9\.\-]+[ \t]*[0-9\.\-]+)|[ \t]*(no maximum found))','tokens');

n_start_maxima=regexp(str,'#  maxima:.*?\n','end');
n_end_maxima=regexp(str,'#  maxima:.*?[\n\r] [\n\r]','end');

str_maxima=str(n_start_maxima:n_end_maxima);
%read first line  
[header_str, header_end]=regexp(str_maxima,'#(.*?)[\n\r]','tokens','end');

str_maxima=str_maxima(header_end:end);
parameters=regexp(header_str{1}{1},'(\S+)','tokens');

n_parameters=length(parameters);
dat=reshape(sscanf(str_maxima,'%f'),n_parameters,[])';

for i=1:n_parameters; names{i}=parameters{i}{1}; end

output.maxima.data=dat;
output.maxima.names=names;

for i=1:n_parameters; 
    redname=regexprep(names{i},'\W','');
    output.maxima.(redname)=dat(:,i);
end


%1:3 coordinates of maxima
%4:6 coordiantes of centerof charge 
%7   charge
%8   density
%9   vol






end