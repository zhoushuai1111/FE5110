function [ newStateMatrix ] = srrs( decisionData, stateMatrix )

% set Level 1 and Level 2
 l1=0.8707;
 l2=1.0227;

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

% calculate volume DIF and DEA with function MACD
  CQ=decisionData.CQ_DAY01.data;
  n=length(CQ);
  [dif, dea]= MACD(CQ, 12, 26, 9 );

% the statematrix is empty for the first day, so the innitial position 
% will be set to 0.
  if isempty(stateMatrix)                           
      stateMatrix.volume=0;
  end

% fit the model and get beta
 beta=polyfit(lop,hip,1);
 beta=beta(1);

% open a position with 80% amount of the account balance when beta is 
% larger than l2 and the slope of DIF is larger than the slope of DEA
  if (beta>l2)&&((dif(n-1)-dif(n-5))>(dea(n-1)-dea(n-5)))
    vol=floor(AccountBalance(AccountSerialID)/hip(length(hip))*0.8);
    PlaceOrder (exchange, symbol,1,vol, 0, 1, AccountSerialID);
  end

% get positionid now, close all the position when beta is lower than l1
  positionid = SelectPsnBySymbol(symbol, exchange, AccountSerialID,1 );
  
  if (beta<l1)
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