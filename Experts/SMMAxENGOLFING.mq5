//+------------------------------------------------------------------+
//|                                               SMMAxENGOLFING.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <TechnicalIndicatorsManager.mqh>
#include <CandlePattern.mqh>

input int smma_signal_period = 21;
input int smma_mid_period = 50;
input int smma_long_period = 200;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- getting 3 smma

   double smma1[]; 
   double smma2[]; 
   double smma3[]; 
   getSmma(smma1, smma_signal_period); 
   getSmma(smma2, smma_mid_period); 
   getSmma(smma3, smma_long_period); 
   
//---

//--- checking if engulfing 
   
   if (isBullishEngulfing()) {
     showSignalCandle();
   }
   
   if (isBearishEngulfing()) {
      showSignalCandle();
   }

  }
//+------------------------------------------------------------------+
