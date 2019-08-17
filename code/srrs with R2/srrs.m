function [ newStateMatrix ] = srrs( decisionData, stateMatrix )

% set Level 1, Level 2 and Level 3
 l1=0.8707;
 l2=1.0227;
 l3=0.8061;

% get exchange number, stock code of the trading object
  exchange=decisionData.tickerMap{1,2};
  symbol=decisionData.tickerMap{1,3};

% get acount serial
  AccountSerialID=1;

% get 15 days data of daily high and daily low price of the trading object
  hip=decisionData.HIP_DAY01.data;
  lop=decisionData.LOP_DAY01.data;

% standardize the original hip and lop
  hip=(hip-mean(hip))/var(hip);
  lop=(lop-mean(lop))/var(lop);

% the statematrix is empty for the first day, so the innitial position 
% will be set to 0.
  if isempty(stateMatrix)                           
      stateMatrix.volume=0;
  end

% fit the model, get beta
  beta=polyfit(lop,hip,1);
  beta=beta(1);

% calculate R-SQUARE
  tss=0;
  ess=0;
  mhip=mean(hip);
  mlop=mean(lop);
  
  for j=1:n
    tss=(hip(j)-mhip)^2+tss;
    ess=(lop(j)-mlop)^2+ess;
  end
  
  r2=ess*beta^2/tss;

% open a position with 80% amount of the account balance when beta is 
% larger than l2 and R-SQUARE islarger than l3 
  if ((beta>l2)&&(r2>l3))
    vol=floor(AccountBalance(AccountSerialID)/hip(length(hip))*0.8);
    PlaceOrder (exchange, symbol,1,vol, 0, 1, AccountSerialID);
  end


% get positionid now, close all the position when beta is lower than l1
  positionid = SelectPsnBySymbol(symbol, exchange, AccountSerialID,1 );
  
  if (mdfbeta<l1)
    ClosePosition( positionid, stateMatrix.volume, 0);
  end


% record the position now and assign it to the new state matrix
  if positionid>0
    volume= PositionVolume( );
  else
    volume=0;
  end

  newStateMatrix.volume = volume;

end