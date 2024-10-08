//+------------------------------------------------------------------+
//|                                                  MACD Sample.mq4  |
//|                   Copyright 2005-2014, MetaQuotes Software Corp.  |
//|                                              http://www.mql4.com  |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"

input double Lots          = 0.01;      // Tamaño del lote
input double TrailingStop  = 30;        // Valor del Trailing Stop
input double RiskRewardRatio = 2;      // Relación de Riesgo/Beneficio (por ejemplo, 1:2)
input double SL_Percentage = 1.0;      // Porcentaje de Stop Loss basado en el precio actual
input int    MagicNumber   = 12345;     // Número mágico único para identificar órdenes
input int    Sensitivity   = 1;        // Sensibilidad reducida para el TTM Scalper
input int    OrderInterval = 300;      // Intervalo mínimo entre órdenes (en segundos)

string Symbols[] = {"ETHUSD#", "BTCUSD#", "EURUSD#", "USDJPY#", "GBPUSD#", "EURJPY#", "AUDUSD#", "XAUUSD#"}; // Lista ampliada de símbolos a operar

double TTMScalperSignal;
int lastErrorCode;
datetime lastOrderTime;  // Guardar la hora de la última orden

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick(void)
{
   for (int i = 0; i < ArraySize(Symbols); i++) // Iterar sobre cada símbolo
   {
      string currentSymbol = Symbols[i];  // Obtener el símbolo actual
      double MacdCurrent, MacdPrevious;
      double SignalCurrent, SignalPrevious;
      double slPrice, tpPrice;
      int ticket;
      datetime currentTime = TimeCurrent();  // Obtener la hora actual

      //--- Comprobar que no han pasado menos de OrderInterval segundos desde la última orden
      if ((currentTime - lastOrderTime) < OrderInterval)
      {
         Print("Esperando para abrir una nueva orden en ", currentSymbol);
         continue;  // Saltar si no ha pasado suficiente tiempo
      }

      //--- Verificar si ya hay órdenes abiertas para este símbolo específico
      bool hasOpenOrders = false;
      for (int j = 0; j < OrdersTotal(); j++)
      {
         if (OrderSelect(j, SELECT_BY_POS) && OrderSymbol() == currentSymbol && OrderMagicNumber() == MagicNumber)
         {
            hasOpenOrders = true;  // Si hay una orden abierta para este símbolo, no abrir otra
            break;
         }
      }
      if (hasOpenOrders)
      {
         Print("Ya hay una orden abierta para ", currentSymbol);
         continue;  // Saltar si ya hay una orden abierta
      }

      //--- Obtener valores de MACD para el símbolo actual
      MacdCurrent = iMACD(currentSymbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
      MacdPrevious = iMACD(currentSymbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1);
      SignalCurrent = iMACD(currentSymbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, 0);
      SignalPrevious = iMACD(currentSymbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, 1);

      //--- Imprimir los valores del MACD para depuración
      Print(currentSymbol, " MACD Current: ", MacdCurrent, " Signal Current: ", SignalCurrent);

      //--- Obtener la señal del TTM Scalper usando iCustom
      TTMScalperSignal = iCustom(currentSymbol, 0, "TTM-scalper", Sensitivity, 0);

      //--- Imprimir el valor del TTM Scalper para depuración
      Print(currentSymbol, " TTM Scalper Signal: ", TTMScalperSignal);

      //--- Verificar el margen disponible
      double marginRequired = MarketInfo(currentSymbol, MODE_MARGINREQUIRED);
      double freeMargin = AccountFreeMarginCheck(currentSymbol, OP_BUY, Lots);
      Print(currentSymbol, " Free margin: ", freeMargin);
      
      if (freeMargin < marginRequired)
      {
         Print("Margen insuficiente para abrir una orden en ", currentSymbol);
         continue;  // Saltar si no hay suficiente margen
      }

      //--- Condición de compra: MACD cruzando por encima de la señal (con TTM Scalper)
      if (MacdCurrent > SignalCurrent && MacdPrevious <= SignalPrevious && TTMScalperSignal > 0)
      {
         Print("Señal de compra detectada con MACD y TTM Scalper en ", currentSymbol);
         slPrice = Ask - (Ask * SL_Percentage / 100);
         tpPrice = Ask + ((Ask - slPrice) * RiskRewardRatio);
         ticket = OrderSend(currentSymbol, OP_BUY, Lots, Ask, 3, slPrice, tpPrice, "Buy order", MagicNumber, 0, Blue);

         if (ticket > 0)  // Si la orden fue exitosa
         {
            lastOrderTime = TimeCurrent();  // Actualizar el tiempo de la última orden
         }
         else
         {
            lastErrorCode = GetLastError();
            Print("Error abriendo una orden de compra en ", currentSymbol, ": ", lastErrorCode);
         }
      }

      //--- Condición alternativa de compra: Solo con MACD
      if (MacdCurrent > SignalCurrent && MacdPrevious <= SignalPrevious) // Solo MACD
      {
         Print("Señal de compra detectada solo con MACD en ", currentSymbol);
         slPrice = Ask - (Ask * SL_Percentage / 100);
         tpPrice = Ask + ((Ask - slPrice) * RiskRewardRatio);
         ticket = OrderSend(currentSymbol, OP_BUY, Lots, Ask, 3, slPrice, tpPrice, "Buy order", MagicNumber, 0, Blue);

         if (ticket > 0)  // Si la orden fue exitosa
         {
            lastOrderTime = TimeCurrent();  // Actualizar el tiempo de la última orden
         }
         else
         {
            lastErrorCode = GetLastError();
            Print("Error abriendo una orden de compra solo con MACD en ", currentSymbol, ": ", lastErrorCode);
         }
      }

      //--- Condición de venta: MACD cruzando por debajo de la señal (opcional si deseas agregar ventas)
      if (MacdCurrent < SignalCurrent && MacdPrevious >= SignalPrevious && TTMScalperSignal < 0)
      {
         Print("Señal de venta detectada en ", currentSymbol);
         // Aquí puedes agregar la lógica de venta si lo necesitas
      }
   }
}


