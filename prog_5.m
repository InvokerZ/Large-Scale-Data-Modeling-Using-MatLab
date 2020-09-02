clear
%load mdates
load china
load china_betas

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

j=0;
for i=86:385
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

j=0;
for i=98:numc
    j=j+1;
    z1=[china_rets(:,i) china_monthly_mv(:,i-1) china_betas(:,i-1) china_dwse(:,i-7) china_dweb(:,i-7)];
    in1=find(z1(:,1)>-1 & z1(:,2)>0 & z1(:,3)>-1 & z1(:,4)>0 & z1(:,5)~=-999);
    z2=z1(in1,:);
    num1=length(in1);
    z2(:,6)=z2(:,4)./z2(:,2);
    z2(:,7)=z2(:,5)./z2(:,4);
    
    [a1,a2,a3,a4]=linregAdjust(z2(:,1), [ones(num1,1) z2(:,3)]);
    reg1(j,1:3)=[a1' a4];
    [a1,a2,a3,a4]=linregAdjust(z2(:,1), [ones(num1,1) log(z2(:,2)) log(z2(:,6))]);
    reg2(j,1:4)=[a1' a4];
    [a1,a2,a3,a4]=linregAdjust(z2(:,1), [ones(num1,1) log(z2(:,6))]);
    reg3(j,1:3)=[a1' a4];
     [a1,a2,a3,a4]=linregAdjust(z2(:,1), [ones(num1,1) log(z2(:,2)) log(z2(:,6)) z2(:,3)]);
    reg4(j,1:5)=[a1' a4];
end
mean(reg1)
