clear
%load mdates
load china


t1=isnan(china_monthly_ri);
china_monthly_ri(t1)=-999;
t1=isnan(china_monthly_mv);
china_monthly_mv(t1)=-999;
t1=isnan(china_dwse);
china_dwse(t1)=-999;
t1=isnan(china_dwfc);
china_dwfc(t1)=-999;
t1=isnan(china_dweb);
china_dweb(t1)=-999;

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

for i=2:385
 
    z1=[china_rets(:,i) china_monthly_mv(:,i-1)];
    in1=find(z1(:,1)>-1 & z1(:,2)>0);
    z2=z1(in1,:);
    ewret(i,1)=mean(z2(:,1));
    vwret(i,1)=z2(:,1)'*z2(:,2)/sum(z2(:,2));
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

china_betas=-999*ones(numr,numc);

for i=85:numc
   
    z1=china_rets(:,i-35:i);
    mkt=vwret(i-35:i,1);
    for j=1:numr
        in1=find(z1(j,:)>-1);
        if(length(in1)>=24)
            [a1,a2,a3,a4]=linregAdjust(z1(j,in1)',[ones(length(in1),1) mkt(in1)]);
            china_betas(j,i)=a1(2,1);
        end
    end
end

save china_betas china_betas

