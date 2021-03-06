//+------------------------------------------------------------------+
//|                                                 handle_order.mqh |
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
void createOrder(bool isBuyOrder, double stopLossPrice, double takeProfitPrice, int magicNumber, double volume = 0.01)
{
     if (!isTradeAllowed()) return;

     ENUM_ORDER_TYPE orderTypeENUm = isBuyOrder ? ORDER_TYPE_BUY : ORDER_TYPE_SELL; 
       
      MqlTradeRequest request={};
      MqlTradeResult  result={};
         //--- parameters of request
      request.action       = TRADE_ACTION_DEAL;                     // type of trade operation
      request.symbol       = Symbol();                              // symbol
      request.volume       = volume;                                   // volume of 0.1 lot
      request.type         = orderTypeENUm;                        // order type
      request.price        = SymbolInfoDouble(Symbol(),SYMBOL_ASK); // price for opening
      request.sl           = stopLossPrice;
      request.tp           = takeProfitPrice;
      request.deviation    = 5;                                     // allowed deviation from the price
      request.magic        = magicNumber;                          // MagicNumber of the order
      
      //--- send the request
      if(!OrderSend(request,result))
         PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
         
      //--- information about the operation
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
}

bool isTradeAllowed() {
   if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
      Alert("Auto Trading is disallowed. Please allow it in your terminal"); 
      return false;
   } else if(!MQLInfoInteger(MQL_TRADE_ALLOWED)) {
       Alert(" Le trading automatisé est interdit dans les paramètres du programme pour ",__FILE__);
       return false;
   }
   
   return true; 
}

bool isAlreadyInOrder(int magicNumber = NULL) {
  int totalOrdersCurrentlyOpen = PositionsTotal(); 
  
  if (magicNumber == NULL) 
  {
   return false; 
  } 
  else 
  {
      for (int i = 0; i < totalOrdersCurrentlyOpen; i++) 
     {
         ulong ticket=PositionGetTicket(i); 
         if(PositionSelectByTicket(ticket)) 
         {
             if (PositionGetInteger(POSITION_MAGIC) == magicNumber) 
             {
                  return true;           
             }         
         }
     }
  }
  
  
  return false; 
}

ulong getEAPositionTicket(int magicNumber) {
   if (isAlreadyInOrder(magicNumber)) {
   
      int totalOrdersCurrentlyOpen = PositionsTotal(); 

      for (int i = 0; i < totalOrdersCurrentlyOpen; i++) 
        {
            ulong ticket=PositionGetTicket(i); 
            if(PositionSelectByTicket(ticket)) 
            {
                if (PositionGetInteger(POSITION_MAGIC) == magicNumber) 
                {
                     return ticket;           
                }         
            }
        }
   }
   
   return 0; 
}