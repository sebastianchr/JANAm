function writexplor_edma(filename,rhogrid,cell)
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
fprintf(fid,'%15.6E\n',rhogrid(:,:,k));
end
fclose(fid);

end