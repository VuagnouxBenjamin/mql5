//+------------------------------------------------------------------+
//|                                                   pip_values.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

double getPipValue() 
{
   return _Digits >= 4 ? 0.0001 : 0.01;
}

double calculateTakeProfit(bool isBuyOrder, double currentMarketPrice, int takeProfitInPips) {
   switch (isBuyOrder)
   {
      case true: 
         return currentMarketPrice + takeProfitInPips * getPipValue(); 
         break; 
      case false: 
         return currentMarketPrice - takeProfitInPips * getPipValue(); 
         break;
      default: 
         Alert("Could not determine if buy or sell order in cqlculqteTakeProfit()");
         return 0; 
         break;      
   }
}

double calculateStopLoss(bool isBuyOrder, double currentMarketPrice, int stopLossInPips) {
   switch (isBuyOrder)
   {
      case true: 
         return currentMarketPrice - stopLossInPips * getPipValue(); 
         break; 
      case false: 
         return currentMarketPrice + stopLossInPips * getPipValue(); 
         break;
      default: 
         Alert("Could not determine if buy or sell order in cqlculqteTakeProfit()");
         return 0; 
         break;      
   }
}

double optimalLotSize(double maxLossPercentage, int maxLossInPips)
{ 
   // Total money in the account. 
   double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   
   // what type of lot is the account using. 
   double accountMinLotSize = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double accountContractSize = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_CONTRACT_SIZE);
  
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   if (_Digits <= 3) tickValue = tickValue / 100; 
  
   double maxLossEuro = accountEquity * maxLossPercentage;
   double maxLossInCurrentCurrency = maxLossEuro / tickValue; 
   Print(NormalizeDouble((maxLossInCurrentCurrency / (maxLossInPips * getPipValue()) / accountContractSize), 2));
   
   return NormalizeDouble((maxLossInCurrentCurrency / (maxLossInPips * getPipValue()) / accountContractSize), 2);
}

double optimalLotSize(double maxLossPercentage, double entryPrice, double stopLossPrice)
{
   int maxLossInPips = MathAbs(entryPrice - stopLossPrice) / getPipValue(); 
   
   Print("maxLossInPips "+ maxLossInPips);
   Print("Optimal lot size: "+ optimalLotSize(maxLossPercentage, maxLossInPips));

   return optimalLotSize(maxLossPercentage, maxLossInPips);      
}
