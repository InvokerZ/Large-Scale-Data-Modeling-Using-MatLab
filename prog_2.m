clear
load china
t1=isnan(china_monthly_ri);
china_monthly_ri(t1)=-999;
t1=isnan(china_monthly_mv);
china_monthly_mv(t1)=-999;

[numr,numc]=size(china_monthly_ri);
china_rets=-999*ones(numr,numc);

j=0;
for i=74:numc
    j=j+1;
    z1=[china_monthly_ri(:,i) china_monthly_ri(:,i-1)];
    in1=find(z1(:,1)>-1 & z1(:,2)>-1);
    z2=z1(in1,:);
    china_rets(in1,i)=z2(:,1)./z2(:,2)-1;
    nfirms(j,1)=length(in1);
end

j=0;
for i=74:numc
    j=j+1;
    z1=china_rets(:,i);
    in1=find(z1>-1);
    st_deviation(j,1)=std(z1(in1,1));
end
plot(st_deviation)

j=0;
for i=86:numc
    j=j+1;
    z1=[china_rets(:,i-1) china_rets(:,i) china_monthly_mv(:,i-1)];
    in1=find(z1(:,1)>-1 & z1(:,2)>-1 & z1(:,3)>0);
    z2=z1(in1,:);
    
   % medcap=median(z2(:,3));
 %   in1=find(z2(:,3)<=medcap);
 %   in2=find(z2(:,3)>medcap);
  %  z2=z2(in2,:);
    
    
    p1=prctile(z2(:,1), [20 40 60 80]);
    in1=find(z2(:,1)<=p1(1));
    in2=find(z2(:,1)>p1(1) & z2(:,1)<p1(2));
    in3=find(z2(:,1)>p1(2) & z2(:,1)<p1(3));
    in4=find(z2(:,1)>p1(3) & z2(:,1)<p1(4));
    in5=find(z2(:,1)>p1(4));
   
    er(j,1)=mean(z2(in1,2));
    er(j,2)=mean(z2(in2,2));
    er(j,3)=mean(z2(in3,2));
    er(j,4)=mean(z2(in4,2));
    er(j,5)=mean(z2(in5,2));
    
    vr(j,1)=z2(in1,2)'*z2(in1,3)/sum(z2(:,3));
    vr(j,2)=z2(in2,2)'*z2(in2,3)/sum(z2(:,3));
    vr(j,3)=z2(in3,2)'*z2(in3,3)/sum(z2(:,3));
    vr(j,4)=z2(in4,2)'*z2(in4,3)/sum(z2(:,3));
    vr(j,5)=z2(in5,2)'*z2(in5,3)/sum(z2(:,3));
                
end

nanmean(er)*100
nanmean(vr)*100
dif1=er(:,5)-er(:,1);
dif2=vr(:,5)-vr(:,1);
[100*mean(dif1) 100*mean(dif2)]
    
 
    
