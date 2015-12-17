function [rhogrid, A]=readcube(filename)
% Description of cube  format found at: 
% http://paulbourke.net/dataformats/cube/

fid=fopen(filename);
[info]=fgetl(fid);
[readingorder]=fgetl(fid);
[temp]=str2num(fgetl(fid));
natoms=temp(1);
origo=temp(2:4);
lat=zeros(3,4);
lat(1,:)=str2num(fgetl(fid));
lat(2,:)=str2num(fgetl(fid));
lat(3,:)=str2num(fgetl(fid));
dim=lat(:,1);
factor_Br2AA=0.529177;  %Å/ Bohr radius, Atomic units to SI
A=(lat(:,2:4).*repmat(dim,1,3))'*factor_Br2AA;  %Do not know what the units are
atoms=zeros(natoms,5);
for i=1:natoms
    atoms(i,:)=str2num(fgetl(fid)); %Format: Atom_number, ??, x, y, z
end
rho=textscan(fid,'%f');
fclose(fid);

rhogrid=reshape(rho{1},[dim(1) dim(2) dim(3)]);
rhogrid=permute(rhogrid,[3 2 1]);
end