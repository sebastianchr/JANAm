function output=readm40(file, nheader)


%read m40 file

fid=fopen(file,'r');

%read and save the headerlines
header={};

for k=1:nheader
    header{k}=fgetl(fid);
end

%read first line of header
line1=textscan(header{1},'%f');
Natom=line1{1}(1);
line2=textscan(header{2},'%f');
overall_scalefactor=line2{1}(1);
%extract refined extinction coefficients
for I=1:(nheader-1)/4
    line=textscan(header{(I)*4+1},'%f');
    exti(I,:)=line{1}(1);
end

for I=1:Natom
    %Read the first line of data block
    block1=textscan(fid,'%s %f %f %f%f%f%f',1); % Read data block
    name{I}=block1{1}{1};
    atype(I,:)=block1{2};
    occ(I,:)=block1{4};
    pos(I,:)=[block1{5} block1{6} block1{7}];
    thermaltype(I,:)=block1{3};
    
    switch thermaltype(I)
        case 1 %isotropic thermal displacement
            dat=textscan(fid,'%f%f%f%f%f%f %s',1 );
            thermalstr{I}='isotropic';
            B{I}=cell2mat(dat(1:6));
            flag{I}=dat(7);
        case 2  %harmonic thermal displacement
            dat=textscan(fid,'%f%f%f%f%f%f %s',1 );
            thermalstr{I}='harmonic';
            B{I}=cell2mat(dat(1:6));
            flag{I}=dat(7);
        case 3  %3 order anharmonic thermal displacement
            dat=textscan(fid,'%f%f%f%f%f%f %s \r\n %f%f%f%f%f%f %s \r\n %f%f%f%f %s',1);
            thermalstr{I}='3rd order anharmonic';
            B{I}=cell2mat(dat([1:6 8:13 15:18])) ;
            flag{I}=dat([7 14 19]);
        case 4  %4 order anharmonic thermal displacement
            dat=textscan(fid,'%f%f%f%f%f%f %s \r\n %f%f%f%f%f%f %s \r\n %f%f%f%f %s \r\n %f%f%f%f%f%f %s \r\n %f%f%f%f%f%f %s \r\n %f%f%f%f %s',1);
            thermalstr{I}='4th order anharmonic';
            B{I}=cell2mat(dat([1:6 8:13 15:18 20:25 27:32 34:37])) ;
            flag{I}=dat([7 14 19 26 33]);
    end
    
    block.name=name{I};
    block.atomtype=atype(I);
    block.position=pos(I,:);
    block.occupation=occ(I);
    block.ADPtype=thermalstr{I};
    block.ADP=B{I};
    block.refflag=flag{I};
    DATA{I}=block;
    
end

%repeat the above to read standard uncertainties

for k=1:nheader+1
    header2{k}=fgetl(fid);
end
line2=textscan(header2{3},'%f');
overall_scalefactorE=line2{1}(1);

%extract refined extinction coefficients
for I=1:(nheader-1)/4
    line=textscan(header2{(I)*4+2},'%f');
    extiE(I,:)=line{1}(1);
end


for I=1:Natom
    % %Read the first line of data block
    %   block1=textscan(fid,'%s %f %f %f%f%f%f',1); % Read data block
    %   name{I}=block1{1};
    %   atypeE(I,:)=block1{2};
    %   occE(I,:)=block1{4};
    %   positionE(I,:)=[block1{5} block1{6} block1{7}];
    %   thermaltypeE(I,:)=block1{3};
    %
    switch thermaltype(I)
        case 1 %isotropic thermal displacement
            dat=textscan(fid,'%s %f%f%f%f \r\n %f%f%f%f%f%f',1 );
            occE(I,:)=dat{2};
            posE(I,:)=cell2mat(dat(3:5));
            BE{I}=cell2mat(dat(6:end));
        case 2  %harmonic thermal displacement
            dat=textscan(fid,'%s %f%f%f%f \r\n %f%f%f%f%f%f',1 );
            occE(I,:)=dat{2};
            posE(I,:)=cell2mat(dat(3:5));
            BE{I}=cell2mat(dat(6:end));
            
        case 3  %3 order anharmonic thermal displacement
            dat=textscan(fid,'%s %f%f%f%f \r\n %f%f%f%f%f%f \r\n %f%f%f%f%f%f \r\n %f%f%f%f',1);
            thermalstr{I}='3rd order anharmonic';
            posE(I,:)=cell2mat(dat(3:5));
            occE(I,:)=dat{2};
            BE{I}=cell2mat(dat(6:end));
        case 4  %4 order anharmonic thermal displacement
            dat=textscan(fid,'%s %f%f%f%f \r\n %f%f%f%f%f%f \r\n %f%f%f%f%f%f \r\n %f%f%f%f \r\n %f%f%f%f%f%f \r\n %f%f%f%f%f%f \r\n %f%f%f%f',1);
            thermalstr{I}='4th order anharmonic';
            posE(I,:)=cell2mat(dat(3:5));
            occE(I,:)=dat{2};
            BE{I}=cell2mat(dat(6:end));
    end
    block.positionE=posE(I,:);
    block.occupationE=occE(I);
    block.ADPE=BE{I};
    DATA{I}=block;
    
end

header=[header header2];

fclose(fid);

output.name=name;
output.header=header;
output.position=pos;
output.error.position=posE;
output.adp=B;
output.error.adp=BE;
output.occupancy=occ;
output.error.occupancy=occE;
output.extinction=exti;
output.error.extinction=extiE;
output.scale=overall_scalefactor;
output.error.scale=overall_scalefactorE;





end

