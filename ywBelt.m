%     n=1000;
%     x=rand(1,n);
%     y=rand(1,n);
%     xy=[x;y];
%     save('xy.mat','xy'); 

    clear
    close all
    clc
    yw=0;
    load xy;
    xy=xy';
    xy=unique(xy,'rows','stable');
    xy=xy';
    x=xy(1,:);
    y=xy(2,:);
    %plot(x,y,'.b');hold on;
    figure('position',[100 100 480 400]);    scatter(x,y,'.k'),hold off;     xlabel('x');     ylabel('y'); box on; 
    xlim([0 1]);ylim([0 1]);
    set(gca,'xtick',[0:0.2:1]);    set(gca,'ytick',[0:0.2:1]);
    figure('position',[100 100 480 400]);     %scatter(x,y,'.k'),hold off; axis equal;    xlabel('x');     ylabel('y'); box on; hold on;
    dt=DelaunayTri(x',y');       %Éú³ÉÈý½ÇÍø
    triplot(dt,'color',[.6 .6 .6]);  hold on;                 %»æÍ¼
    scatter(x,y,'.k'),hold off;  xlabel('x');     ylabel('y');
    set(gca,'xtick',[0:0.2:1]);    set(gca,'ytick',[0:0.2:1]);
    triangles=dt.Triangulation;
    dis(1)=0; 
    maxDis=0.032;  %fig.3 (d)
    maxDis=0.028;  %fig.3 (c)
     maxDis=0.024;  %fig.3 (b)
     maxDis=0.020;  %fig.3 (a)
    figure('position',[100 100 420 400]);     scatter(x,y,'.k'),hold off; xlabel('x');     ylabel('y'); box on;
    hold on;
    relatedEQIndex1(1)=0;
    relatedEQIndex2(1)=0;
    relatedEQC=0;
    for(i=1:length(triangles))
        dis((i-1)*3+1)=sqrt((x(triangles(i,1))-x(triangles(i,2))).^2+(y(triangles(i,1))-y(triangles(i,2))).^2);
        if(dis((i-1)*3+1)<maxDis)
            plot([x(triangles(i,1)) x(triangles(i,2))],[y(triangles(i,1)) y(triangles(i,2))],'-b');
            relatedEQC=relatedEQC+1;
            relatedEQIndex1(relatedEQC)=triangles(i,1);
            relatedEQIndex2(relatedEQC)=triangles(i,2);
        end
        dis((i-1)*3+2)=sqrt((x(triangles(i,2))-x(triangles(i,3))).^2+(y(triangles(i,2))-y(triangles(i,3))).^2);
        if(dis((i-1)*3+2)<maxDis)
            plot([x(triangles(i,2)) x(triangles(i,3))],[y(triangles(i,2)) y(triangles(i,3))],'-b');
            relatedEQC=relatedEQC+1;
            relatedEQIndex1(relatedEQC)=triangles(i,2);
            relatedEQIndex2(relatedEQC)=triangles(i,3);
        end

        dis((i-1)*3+3)=sqrt((x(triangles(i,1))-x(triangles(i,3))).^2+(y(triangles(i,1))-y(triangles(i,3))).^2);
        if(dis((i-1)*3+3)<maxDis)
            plot([x(triangles(i,1)) x(triangles(i,3))],[y(triangles(i,1)) y(triangles(i,3))],'-b');
            relatedEQC=relatedEQC+1;
            relatedEQIndex1(relatedEQC)=triangles(i,1);
            relatedEQIndex2(relatedEQC)=triangles(i,3);
        end       
    end
    set(gca,'xtick',[0:0.2:1]);    set(gca,'ytick',[0:0.2:1]);
    xlim([0 1]);ylim([0 1]);
%     figure('position',[100 100 480 400]); 
%     scatter(x,y,'.k'),hold off;   xlabel('x');     ylabel('y'); box on;
    hold on;    
    for(k=1:length(x))
        clear global family;
        global family;
        family=k;
        ywFindRelationship(relatedEQIndex1,relatedEQIndex2,k);
        family=unique(family);
        if(length(family)>1)
            if(length(family)<6)
                continue;
            end
            [family]=ywBeltOptimization(family,x,y);
            bx=x(family);
            by=y(family);
            [rectx,recty,area,perimeter] = minboundrect(bx,by,'a');
            line(rectx,recty,'color','k');
            cx=mean(rectx(1:4));    cy=mean(recty(1:4));
            cr=sqrt((rectx(1)-cx)*(rectx(1)-cx)+(recty(1)-cy)*(recty(1)-cy));
            cr=cr*1.2;

            clear cpx;
            clear cpy;
            cpx=cx+cr;
            cpy=cy;
            for(jd=0:10:360)
                cpx=[cpx cx+cr*cos(jd/180*pi)];
                cpy=[cpy cy+cr*sin(jd/180*pi)];
            end

            chang=sqrt((rectx(1)-rectx(2))^2+(recty(1)-recty(2))^2);
            kuan=sqrt((rectx(2)-rectx(3))^2+(recty(2)-recty(3))^2);
            if(chang<kuan)
                tmp=kuan;
                kuan=chang;
                chang=tmp;
            end
            in=inpolygon(x,y,cpx,cpy);
            in(find(in==0))=[];
            if(chang/kuan>=5 & length(family)/length(in)>=0.75)
                line(rectx,recty,'color','r');
                yw=1;
            end
            %plot(cpx,cpy,':k');
        end
    end
        xlim([0 1]);ylim([0 1]);

   