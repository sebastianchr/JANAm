function rhogrid=readxplor(filename)
fid=fopen(filename);
[~]=fgetl(fid);
[~]=fgetl(fid);
[name]=fgetl(fid);
[a]=fgetl(fid);
dim=str2num(a);

amin=dim(2); amax=dim(3); an=dim(1);
bmin=dim(5); bmax=dim(6); bn=dim(4);
cmin=dim(8); cmax=dim(9); cn=dim(7);
fclose(fid);

rho=textread(filename,'%f','headerlines',6);
rho(1:an*bn+1:end)=[];
rhogrid=reshape(rho,[dim(1) dim(4) dim(7)]);
% rhogrid=permute(rhogrid,[2 1 3]);
end