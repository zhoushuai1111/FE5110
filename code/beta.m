
%function for calculating beta and its statistical characteristics

function [mea, med,sd,ske,kur,l1,l2] = beta(data,qt1,qt2)

%set window length=15   
  n=15;

%find the size of the object data
  siz=size(data);

%calculate beta each day
  for i=(siz-n):-1:1
	  hip=data(i:i+n,2);
	  lop=data(i:i+n,3);
	  hip=(hip-mean(hip))/var(hip);
	  lop=(lop-mean(lop))/var(lop);
  	c=polyfit(hip,lop,1);
	  ratio(i)=c(1);
  end

%plot the histogram of beta
  histfit(ratio);

%calculate the statistical characteristics of ratio
  mea=mean(ratio);
  med=median(ratio);
  sd=std(ratio);
  ske=skewness(ratio);
  kur=kurtosis(ratio);
  l1=quantile(ratio,qt1)-ske*0.1;
  l2=quantile(ratio,qt2)-ske*0.1;
  
end