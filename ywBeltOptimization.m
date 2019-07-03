function [outIndex]=ywBeltOptimization(inIndex,x,y)
    [kb,err]=polyfit(x(inIndex),y(inIndex),1);
%     设点坐标P:（x1，y1），直线方程L:A*x+B*y+C=0，则P点到直线L的距离matlab程序如下：
%     abs(A*x1+B*y1+C)/sqrt(A^2+B^2)
%     其中的abs为取绝对值，sqrt为开平方
    B=1;A=-kb(1);C=-kb(2);
    jl=abs(A*x(inIndex)+B*y(inIndex)+C)/sqrt(A^2+B^2);
    m=find(jl>err.normr);
    if(length(m)==0)
        outIndex=inIndex;
    else
        outIndex=inIndex(~m);
    end
end