//+------------------------------------------------------------------+
//|                                                  bbTestStrat.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#define EXPERT_MAGIC 123456


input int bbPeriod = 20;
#include <PipValueHelper.mqh>
#include <OrderManager.mqh>
#include <TechnicalIndicatorsManager.mqh>
#include <Trade/Trade.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Alert("The EA just started"); 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
    Alert("The EA just closed"); 
    Alert(getEAPositionTicket(EXPERT_MAGIC));
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  CTrade trade; 
  
//---
    //--- bb calculation 
   
   double handlebb = iBands(NULL,PERIOD_CURRENT,bbPeriod,0,1,PRICE_CLOSE); 
   double _bb1Upper[];
   double _bb1Lower[];
   double _bb1Mid[];   
   ArraySetAsSeries(_bb1Upper, true); 
   ArraySetAsSeries(_bb1Lower, true); 
   ArraySetAsSeries(_bb1Mid, true); 
   if (CopyBuffer(handlebb,0,0,20,_bb1Mid) < 0){Print("CopyBuffer_bb1 error =",GetLastError());}
   if (CopyBuffer(handlebb,1,0,20,_bb1Upper) < 0){Print("CopyBuffer_bb1 error =",GetLastError());}
   if (CopyBuffer(handlebb,2,0,20,_bb1Lower) < 0){Print("CopyBuffer_bb1 error =",GetLastError());}
   double handlebb2 = iBands(NULL,PERIOD_CURRENT,bbPeriod,0,4,PRICE_CLOSE); 
   double _bb2Upper[];
   double _bb2Lower[];
   double _bb2Mid[]; 
   ArraySetAsSeries(_bb2Upper, true); 
   ArraySetAsSeries(_bb2Lower, true); 
   ArraySetAsSeries(_bb2Mid, true); 
   if (CopyBuffer(handlebb2,1,0,20,_bb2Upper) < 0){Print("CopyBuffer_bb1 error =",GetLastError());}
   if (CopyBuffer(handlebb2,2,0,20,_bb2Lower) < 0){Print("CopyBuffer_bb1 error =",GetLastError());}
   
   
//--- main logic 

   double askPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK); 
   double bidPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double signalPrice = 0.71; 
   int takeProfitInPips = 20; 
   int stopLossInPips = 10; 
   
   if (!isAlreadyInOrder(EXPERT_MAGIC)) {
      if (askPrice < _bb1Lower[0]) {
         // place buy order
            Print("Price is below signal price, entering buy position " + askPrice);
            double takeProfit = _bb1Mid[0]; 
            double stopLoss =  _bb2Lower[0] ;
            Print("TP = " + takeProfit);
            Print("SL = " + stopLoss);
            
            createOrder(true, stopLoss, takeProfit, EXPERT_MAGIC, optimalLotSize(0.02, askPrice, stopLoss));
      } else if (bidPrice > _bb1Upper[0]) {      
         //place sell order
            Print("Price is above signal price, entering sell position " + bidPrice);
            double takeProfit = _bb1Mid[0]; 
            double stopLoss = _bb2Upper[0];
            Print("TP = " + takeProfit);
            Print("SL = " + stopLoss);
            
            createOrder(false, stopLoss, takeProfit, EXPERT_MAGIC, optimalLotSize(0.02, bidPrice, stopLoss));         
      } 
   } else {
   ulong currentTicket = getEAPositionTicket(EXPERT_MAGIC);
      // update SL and TP           0 = buy / 1 = sell
      if(PositionSelectByTicket(getEAPositionTicket(EXPERT_MAGIC))) {
         int positionType = PositionGetInteger(POSITION_TYPE); 
         
         // if buy position
         if (positionType == 0) {
            
            double currentStop = NormalizeDouble(_bb2Lower[0], _Digits);
            double currentTP = NormalizeDouble(_bb1Mid[0], _Digits);
        
            
            if (PositionGetDouble(POSITION_TP) < currentTP) {
               trade.PositionModify(currentTicket, PositionGetDouble(POSITION_SL), currentTP);
               Print("take profit has been modified" + currentTP);
            } else {
               Print("take profit lower, no modification");
            }
            
         } 
         // if sell position
         else if (positionType == 1) {
            double currentTP = NormalizeDouble(_bb1Mid[0], _Digits);
            
            if (PositionGetDouble(POSITION_TP) > currentTP) {
               trade.PositionModify(currentTicket, PositionGetDouble(POSITION_SL), currentTP);
               Print("take profit has been modified" + currentTP);
            } else {
               Print("take profit upper, no modification");
            }
         }
      }
   }
   
  }
//+------------------------------------------------------------------+
