%¶ÁµØÕðÄ¿Â¼

function [eqTime,eqLongi,eqLati,eqMag,eqDepth]=ywReadEQT(eqtFN)
    eqtStr=textread(eqtFN, '%s', 'delimiter', '\n', 'whitespace','');
    eqtStr1=char(eqtStr);
    year=eqtStr1(:,2:5);
    month=eqtStr1(:,6:7);
    day=eqtStr1(:,8:9);
    hour=eqtStr1(:,10:11);
    minute=eqtStr1(:,12:13);
    second=eqtStr1(:,14:15);    
    lati=eqtStr1(:,17:21);    
    longi=eqtStr1(:,23:28);    
    mag=eqtStr1(:,29:31);
    
    depth=eqtStr1(:,34:35);
    
    eqTime=datenum(str2num(year),str2num(month),str2num(day),str2num(hour),str2num(minute),str2num(second));
    eqLongi=str2num(longi);
    eqLati=str2num(lati);
    eqMag=str2num(mag);
    eqDepth=str2num(depth);
    
end