function rhogrid=readgrd(filename)
fid=fopen(filename);
[~]=fgetl(fid);
[~]=fgetl(fid);
[~]=fgetl(fid);
[~]=fgetl(fid);
dim=str2num(fgetl(fid));
[~]=fgetl(fid);
[~]=fgetl(fid);
[~]=fgetl(fid);
natoms=str2num(fgetl(fid));
fclose(fid);

rho=textread(filename,'%f','headerlines',9+natoms+3);
rhogrid=reshape(rho,[ dim(1) dim(2)  dim(3)]);
end