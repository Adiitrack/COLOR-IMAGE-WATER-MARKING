b=imread('lena_colour.bmp');
k=1;
for i=256:-1:1
    for j=1:256
        a(k)=b(i,j,1);
        a(k+1)=b(i,j,2);
        a(k+3)=b(i,j,3);
        k=k+3;
    end
end
fid=fopen('lena_colour.hex','wt');
fprintf(fid,'%x\n',a);
disp('text file write done');disp(' ');
fclose(fid);