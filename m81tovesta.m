function m81tovesta(inputfile,cell)
%function m81tovesta(inputfile,cell)
%cell=[a b c alpha beta gamma]
%

outputfile=regexprep(inputfile,'\.m81','.xplor');
rhogrid=readm81(inputfile);
writexplor(outputfile,rhogrid,cell)

end

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

function writexplor(filename,rhogrid,cell)
%function writexplor(filename,rhogrid,cell)
%Cell is a 6 x 1 vector [a b c alpha beta gamma]
fid=fopen(filename,'w');
fprintf(fid,'\n');
fprintf(fid,'    1\n');
fprintf(fid,'%s\n',filename);

dim=[size(rhogrid,1) 0 size(rhogrid,1)-1 size(rhogrid,2) 0 size(rhogrid,2)-1 size(rhogrid,3) 0 size(rhogrid,3)-1] ;
fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',dim);
fprintf(fid,'%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E\n',[cell]);
fprintf(fid,'ZYX\n');

C=linspace(dim(8),dim(9),dim(7));
for k=1:dim(7)
fprintf(fid,'%5i\n',C(k));
fprintf(fid,'%15.6E%15.6E%15.6E%15.6E%15.6E\n',rhogrid(:,:,k));
   if mod(dim(1)*dim(4),5)~=0
       fprintf(fid,'\n');
   end
   
end
fclose(fid);

end