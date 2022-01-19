//+------------------------------------------------------------------+
//|                                    TechnicalIndicatorsManager.mqh |
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
void getBollingerBand (double& _bb1[], int bufferNumber, int bbPeriod, int deviation)
{
   double handlebb = iBands(NULL,PERIOD_CURRENT,bbPeriod,0,deviation,PRICE_CLOSE); 
      
   ArraySetAsSeries(_bb1, true); 
  
   if (CopyBuffer(handlebb,bufferNumber,0,20,_bb1) < 0){Print("CopyBuffer_bb1 error =",GetLastError());}
}

void getSmma (double& smma[], int maPeriod) 
{
   double handle = iMA(_Symbol, PERIOD_CURRENT, maPeriod, 0, MODE_SMMA, PRICE_CLOSE); 
   
      ArraySetAsSeries(smma, true); 
  
   if (CopyBuffer(handle,0,0,20,smma) < 0){Print("CopyBuffer_smma error =",GetLastError());}
}