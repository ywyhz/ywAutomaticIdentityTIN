function [outIndex]=ywBeltOptimization(inIndex,x,y)
    [kb,err]=polyfit(x(inIndex),y(inIndex),1);
%     �������P:��x1��y1����ֱ�߷���L:A*x+B*y+C=0����P�㵽ֱ��L�ľ���matlab�������£�
%     abs(A*x1+B*y1+C)/sqrt(A^2+B^2)
%     ���е�absΪȡ����ֵ��sqrtΪ��ƽ��
    B=1;A=-kb(1);C=-kb(2);
    jl=abs(A*x(inIndex)+B*y(inIndex)+C)/sqrt(A^2+B^2);
    m=find(jl>err.normr);
    if(length(m)==0)
        outIndex=inIndex;
    else
        outIndex=inIndex(~m);
    end
end