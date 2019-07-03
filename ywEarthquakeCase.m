
    clear
    close all
    clc
    yw=0;
    
    eqtFN='2005江西九江（大陆）.eqt';
    [eqTime,eqLongi,eqLati,eqMag,eqDepth]=ywReadEQT(eqtFN);
    x=eqLongi;  y=eqLati;
    x=x';   y=y';
    xy=[x;y];
       
    xy=xy';
    xy=unique(xy,'rows','stable');
    xy=xy';
    x=xy(1,:);
    y=xy(2,:);

    %plot(x,y,'.b');hold on;
    figure('position',[100 100 480 400]);    scatter(x,y,'.k'),hold off;     xlabel('x');     ylabel('y'); box on; 
    %xlim([0 1]);ylim([0 1]);
    set(gca,'xtick',[0:0.2:1]);    set(gca,'ytick',[0:0.2:1]);
    figure('position',[100 100 480 400]);     %scatter(x,y,'.k'),hold off; axis equal;    xlabel('x');     ylabel('y'); box on; hold on;
    dt=delaunayTriangulation(x',y');       %生成三角网
    triplot(dt,'color',[.6 .6 .6]);  hold on;                 %绘图
    scatter(x,y,'.k'),hold off;  xlabel('x');     ylabel('y');
    set(gca,'xtick',[0:0.2:1]);    set(gca,'ytick',[0:0.2:1]);
    triangles=dt.ConnectivityList;
    dis(1)=0; 
    maxDis=0.032;  %fig.3 (d)
    maxDis=0.028;  %fig.3 (c)
     maxDis=0.024;  %fig.3 (b)
     maxDis=0.020;  %fig.3 (a)
     maxDis=2;
    figure('position',[100 100 420 400]);     scatter(x,y,'ok'),hold off; xlabel('x');     ylabel('y'); box on;
    hold on;
    relatedEQIndex1(1)=0;
    relatedEQIndex2(1)=0;
    relatedEQC=0;
    fp = fopen('ywRelationEarthquake.txt','wt');
    fpAllTIN = fopen('ywAllTIN.txt','wt');
    for(i=1:length(triangles))
        dis((i-1)*3+1)=sqrt((x(triangles(i,1))-x(triangles(i,2))).^2+(y(triangles(i,1))-y(triangles(i,2))).^2);
        if(dis((i-1)*3+1)<=maxDis)
            plot([x(triangles(i,1)) x(triangles(i,2))],[y(triangles(i,1)) y(triangles(i,2))],'-b');
            relatedEQC=relatedEQC+1;
            relatedEQIndex1(relatedEQC)=triangles(i,1);
            relatedEQIndex2(relatedEQC)=triangles(i,2);
            fprintf(fp, '%d %d\r\n', [x(triangles(i,1)) y(triangles(i,1))]);
            fprintf(fp, '%d %d\r\n', [x(triangles(i,2)) y(triangles(i,2))]);
            fprintf(fp, '%s\r\n', '>>');
        end
        fprintf(fpAllTIN, '%d %d\r\n', [x(triangles(i,1)) y(triangles(i,1))]);
        fprintf(fpAllTIN, '%d %d\r\n', [x(triangles(i,2)) y(triangles(i,2))]);
        fprintf(fpAllTIN, '%s\r\n', '>>');

        dis((i-1)*3+2)=sqrt((x(triangles(i,2))-x(triangles(i,3))).^2+(y(triangles(i,2))-y(triangles(i,3))).^2);
        if(dis((i-1)*3+2)<=maxDis)
            plot([x(triangles(i,2)) x(triangles(i,3))],[y(triangles(i,2)) y(triangles(i,3))],'-b');
            relatedEQC=relatedEQC+1;
            relatedEQIndex1(relatedEQC)=triangles(i,2);
            relatedEQIndex2(relatedEQC)=triangles(i,3);
            fprintf(fp, '%d %d\r\n', [x(triangles(i,2)) y(triangles(i,2))]);
            fprintf(fp, '%d %d\r\n', [x(triangles(i,3)) y(triangles(i,3))]);
            fprintf(fp, '%s\r\n', '>>');
        end
        fprintf(fpAllTIN, '%d %d\r\n', [x(triangles(i,2)) y(triangles(i,2))]);
        fprintf(fpAllTIN, '%d %d\r\n', [x(triangles(i,3)) y(triangles(i,3))]);
        fprintf(fpAllTIN, '%s\r\n', '>>');
        dis((i-1)*3+3)=sqrt((x(triangles(i,1))-x(triangles(i,3))).^2+(y(triangles(i,1))-y(triangles(i,3))).^2);
        if(dis((i-1)*3+3)<=maxDis)
            plot([x(triangles(i,1)) x(triangles(i,3))],[y(triangles(i,1)) y(triangles(i,3))],'-b');
            relatedEQC=relatedEQC+1;
            relatedEQIndex1(relatedEQC)=triangles(i,1);
            relatedEQIndex2(relatedEQC)=triangles(i,3);
            fprintf(fp, '%d %d\r\n', [x(triangles(i,1)) y(triangles(i,1))]);
            fprintf(fp, '%d %d\r\n', [x(triangles(i,3)) y(triangles(i,3))]);
            fprintf(fp, '%s\r\n', '>>');
        end   
        fprintf(fpAllTIN, '%d %d\r\n', [x(triangles(i,1)) y(triangles(i,1))]);
        fprintf(fpAllTIN, '%d %d\r\n', [x(triangles(i,3)) y(triangles(i,3))]);
        fprintf(fpAllTIN, '%s\r\n', '>>');    
    end
    fclose(fp);
    fclose(fpAllTIN);

    set(gca,'xtick',[0:0.2:1]);    set(gca,'ytick',[0:0.2:1]);
  %  xlim([0 1]);ylim([0 1]);
%     figure('position',[100 100 480 400]); 
%     scatter(x,y,'.k'),hold off;   xlabel('x');     ylabel('y'); box on;
    hold on;  
    fpSuspected  = fopen('ywSuspected.txt','wt');
    fpSeimicBand = fopen('ywSeimicBand.txt','wt');

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
            for(iii=1:5)
                fprintf(fpSuspected, '%d %d\r\n', [rectx(iii) recty(iii)]);
            end
            fprintf(fp, '%s\r\n', '>>');

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
                for(iii=1:5)
                    fprintf(fpSeimicBand, '%d %d\r\n', [rectx(iii) recty(iii)]);
                end
                fprintf(fpSeimicBand, '%s\r\n', '>>');
                yw=1;
            end
            %plot(cpx,cpy,':k');
        end
    end
    fclose(fpSuspected);
    fclose(fpSeimicBand);
   %     xlim([0 1]);ylim([0 1]);