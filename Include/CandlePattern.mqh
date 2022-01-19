//+------------------------------------------------------------------+
//|                                                CandlePattern.mqh |
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
bool isBullishEngulfing() 
{
   // high : low : close : open 
   double high[], low[], close[], open[]; 
   getXCandleData(3, high, low, open, close); 

   // bougie 2 close < bougie 2 open. 
   bool isRed = close[2] < open[2];
   
   // bougie 1 open <= bougie 2 close. 
   bool isReversal = open[1] <= close[2]; 
   
   // bougie 1 close > de high de la bougie 2. 
   bool isEnglobing = close[1] > high[2];
   
   return isRed && isReversal && isEnglobing; 
}

bool isBearishEngulfing()
{
   double high[], low[], close[], open[]; 
   getXCandleData(3, high, low, open, close); 
   
   // bougie 2 close > bougie 2 open.
   bool isGreen = close[2] > open[2]; 
   
   // bougie 1 open >= bougie 2 close. 
   bool isReversal = open[1] >= close[2];  
   
   // bougie 1 close < bougie 2 low. 
   bool isEnglobing = close[1] < low[2];
   
   return isGreen && isReversal && isEnglobing;
}

void getXCandleData(int numbOfCandles, double& high[], double& low[], double& open[], double& close[])
{
   ArraySetAsSeries(high, true); 
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(open, true);
   
   CopyHigh(_Symbol, PERIOD_CURRENT, 0, 3, high); 
   CopyLow(_Symbol, PERIOD_CURRENT, 0, 3, low); 
   CopyClose(_Symbol, PERIOD_CURRENT, 0, 3, close);
   CopyOpen(_Symbol,PERIOD_CURRENT, 0, 3, open); 
}

void showSignalCandle()
{
   MqlRates PriceInformation[]; 
   int randomNumber = IntegerToString(MathRand());  
   
   ArraySetAsSeries(PriceInformation, true); 
   int Data = CopyRates(_Symbol,PERIOD_CURRENT,0,Bars(_Symbol,PERIOD_CURRENT),PriceInformation); 
   
   ObjectCreate(
      _Symbol,
      randomNumber,
      OBJ_RECTANGLE, 
      0, 
      PriceInformation[1].time, 
      PriceInformation[1].high, 
      PriceInformation[0].time, 
      PriceInformation[1].low
   );
   
   ObjectSetInteger(0, randomNumber, OBJPROP_FILL, clrGreen);     
}