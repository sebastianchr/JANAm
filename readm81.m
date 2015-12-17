function  rhogrid=readm81(file)
fid=fopen(file);
if fid==-1
    error('The file was not found')
end
header=fread(fid, 9, 'int32');
nx=header(1); ny=header(2); nz=header(3);
nxny=header(7);
nmap=header(8);
rhogrid=zeros(nx,ny,nz);
fclose(fid);
fid=fopen(file);
fread(fid,nxny, 'float32');
for i=1:nmap
    rhogrid(:,:,i)=reshape(fread(fid,nxny, 'float32'),nx, ny);
end
fclose(fid);
end