//+------------------------------------------------------------------+
//|                      ParabolicSARAlert.mq4                       |
//| Alerts when price crosses above/below Parabolic SAR dots         |
//+------------------------------------------------------------------+
#property strict

// Input parameters
input string TradeSymbol = "EURUSD";        // Symbol for analysis
input ENUM_TIMEFRAMES Timeframe = PERIOD_H1; // Timeframe for analysis
input double Step = 0.02;                   // Step for Parabolic SAR
input double Maximum = 0.2;                 // Maximum for Parabolic SAR
input bool EnableAlerts = true;             // Enable sound alerts
input bool EnableEmail = false;             // Enable email notifications
input bool EnablePush = false;              // Enable push notifications

// Global variables to track the previous SAR state
double PrevSAR = 0.0;
bool WasAbove = false;

//+------------------------------------------------------------------+
//| Main function                                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("Parabolic SAR Alert Script Started.");

   while (!IsStopped()) {
      // Get the current Parabolic SAR value
      double currentSAR = iSAR(TradeSymbol, Timeframe, Step, Maximum, 1);

      // Get the current and previous close prices
      double currentClose = iClose(TradeSymbol, Timeframe, 0);
      double prevClose = iClose(TradeSymbol, Timeframe, 1);

      // Determine if the price has crossed the SAR
      bool isAbove = currentClose > currentSAR;

      if (WasAbove && currentClose < currentSAR) {
         // Price crosses below SAR (potential bearish trend)
         AlertSAR("Bearish Reversal", currentSAR, TradeSymbol, Timeframe);
      } else if (!WasAbove && currentClose > currentSAR) {
         // Price crosses above SAR (potential bullish trend)
         AlertSAR("Bullish Reversal", currentSAR, TradeSymbol, Timeframe);
      }

      // Update the state for the next iteration
      WasAbove = isAbove;
      PrevSAR = currentSAR;

      Sleep(60000); // Wait 1 minute before checking again
   }
}

//+------------------------------------------------------------------+
//| Send alert notifications                                         |
//+------------------------------------------------------------------+
void AlertSAR(string trendType, double sarValue, string symbol, ENUM_TIMEFRAMES timeframe)
{
   string message = StringFormat(
      "%s detected on %s (Timeframe: %s)\nSAR Value: %.5f",
      trendType, symbol, EnumToString(timeframe), sarValue
   );

   if (EnableAlerts) Alert(message);
   if (EnableEmail) SendMail("Parabolic SAR Alert", message);
   if (EnablePush) SendNotification(message);

   Print(message);
}
