function rhogrid=readdensity(filename)

%determine filetype

a=regexp(filename,'\.(m81|xplor|asc)','tokens');
if isempty(a)
    error('Unknown fileformat')
end
filetype=a{1}{1};

switch filetype
    case 'm81'
        rhogrid=readm81(filename);
    case 'xplor'
        rhogrid=readxplor(filename);
    case 'asc'
        rhogrid=readasc(filename);
end

end