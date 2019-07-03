clear
clc
close all

totalCount=0;

n=80;
drawX(1)=0;
drawTC(1)=0;
drawYC(1)=0;
c=0;
for(n=83:10:10000)
    for(m=3:n)
        totalCount=totalCount+nchoosek(n,m);
    end
    totalCount
    computerVelocity=20e16;
    secondCount=totalCount/computerVelocity;
    yearCount=secondCount/31536000
    c=c+1;
    drawX(c)=n;
    drawTC(c)=totalCount;
    drawYC(c)=yearCount;
end
figure;subplot(211);
semilogy(drawX,drawTC,'-o');
subplot(212);
semilogy(drawX,drawYC,'-o');
[kb,err]=polyfit(drawX,log10(drawTC),1)

