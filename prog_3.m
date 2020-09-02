clear
%load mdates
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
for i=74:385
   j=j+1;
    z1=[china_rets(:,i) china_monthly_mv(:,i-1)];
    in1=find(z1(:,1)>-1 & z1(:,2)>0);
    z2=z1(in1,:);
    ewret(j,1)=mean(z2(:,1));
    vwret(j,1)=z2(:,1)'*z2(:,2)/sum(z2(:,2));
end

momentum=-999*ones(numr,numc);
for i=74:numc
    z1=china_rets(:,i-11:i-1);
    
    for j=1:numr
        x1=z1(j,:);
        in1=find(x1>-1);
        if(length(in1)==11)
            momentum(j,i)=prod(x1+1)-1;
        end
    end
end

k1=2;
j=0;
for i=86:numc
    j=j+1;
    z1=[china_rets(:,i) china_monthly_mv(:,i-1) momentum(:,i-1)];
    in1=find(z1(:,1)>-1 & z1(:,2)>0 & z1(:,3)>-1);
    z2=z1(in1,:);
    
    %medcap=median(z2(:,3));
    %in1=find(z2(:,3)<=medcap);
    %in2=find(z2(:,3)>medcap);
    %z2=z2(in2,:);
    
    p1=prctile(z2(:,k1), [20 40 60 80]);
    in1=find(z2(:,k1)<=p1(1));
    in2=find(z2(:,k1)>p1(1) & z2(:,k1)<p1(2));
    in3=find(z2(:,k1)>p1(2) & z2(:,k1)<p1(3));
    in4=find(z2(:,k1)>p1(3) & z2(:,k1)<p1(4));
    in5=find(z2(:,k1)>p1(4));
   
    er(j,1)=mean(z2(in1,1));
    er(j,2)=mean(z2(in2,1));
    er(j,3)=mean(z2(in3,1));
    er(j,4)=mean(z2(in4,1));
    er(j,5)=mean(z2(in5,1));
    
    vr(j,1)=z2(in1,1)'*z2(in1,2)/sum(z2(:,2));
    vr(j,2)=z2(in2,1)'*z2(in2,2)/sum(z2(:,2));
    vr(j,3)=z2(in3,1)'*z2(in3,2)/sum(z2(:,2));
    vr(j,4)=z2(in4,1)'*z2(in4,2)/sum(z2(:,2));
    vr(j,5)=z2(in5,1)'*z2(in5,2)/sum(z2(:,2));               
end

nanmean(er)*100
nanmean(vr)*100
dif1=er(:,5)-er(:,1);
dif2=vr(:,5)-vr(:,1);
[100*mean(dif1) 100*mean(dif2)]

[b1,b2,b3,b4,b5]=regress(dif1, [ones(300,1) ewret(13:end,1)]);
[b1,b2,b3,b4,b5]=regress(dif2, [ones(300,1) vwret(13:end,1)]);

