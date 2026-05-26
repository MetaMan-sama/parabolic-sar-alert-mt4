# Parabolic SAR Alert — MQL4 Script

A MetaTrader 4 script that monitors the **Parabolic Stop and Reverse (SAR)** indicator via `iSAR()` each cycle, compares the current close against the current SAR value to determine price position, tracks that position against a persistent `WasAbove` boolean state variable, and fires directional reversal alerts when price transitions from below the SAR to above it (bullish reversal) or from above to below it (bearish reversal) — implementing strict first-cross detection to eliminate repeated alerts during sustained SAR-aligned trends.

---

## Overview

The Parabolic SAR, developed by J. Welles Wilder Jr. and introduced in his 1978 book *New Concepts in Technical Trading Systems*, is a trend-following indicator that places a trailing stop-and-reverse point on the chart which accelerates in the direction of the trend using an Acceleration Factor. When price is above the SAR, the SAR trails below price — signalling an uptrend and acting as a rising stop. When price crosses below the SAR, the indicator "reverses" — flipping to trail above price and signalling the beginning of a downtrend. These flip events are among the clearest momentum-shift signals in technical analysis: a SAR reversal confirms that the trend's momentum has crossed a statistically defined threshold relative to its recent acceleration, making it a reliable trigger for both exits and entries in trend-following systems. This script monitors SAR flip events in real time and fires alerts the moment a reversal is confirmed — distinguishing between bullish flips (price crosses above SAR) and bearish flips (price crosses below SAR) via the `WasAbove` state variable.

> **Note on file naming:** This file is distributed as `Moving_Average_Crossover_Script_001.mq4` but implements a Parabolic SAR alert. The README documents the actual implemented logic.

---

## Features

- **`iSAR()` native computation** — `currentSAR = iSAR(TradeSymbol, Timeframe, Step, Maximum, 1)` fetches the confirmed SAR value at bar 1 (previous confirmed bar) to avoid repainting on the forming bar
- **Strict flip detection** — `WasAbove && currentClose < currentSAR` → **Bearish Reversal** (price crossed below SAR); `!WasAbove && currentClose > currentSAR` → **Bullish Reversal** (price crossed above SAR) — both require prior-state disagreement with current state
- **`WasAbove` boolean state persistence** — global bool updated to `isAbove = currentClose > currentSAR` at cycle end, maintaining the prior-bar SAR position for next-cycle flip comparison
- **Alert message includes SAR value** — `AlertSAR()` formats with `"SAR Value: %.5f"` for immediate level reference
- **Configurable `Step` and `Maximum`** — `Step` (default `0.02`) sets the initial Acceleration Factor and its per-period increment; `Maximum` (default `0.2`) caps the Acceleration Factor; both match Wilder's original specification
- **Three notification channels:** sound alert, email, and mobile push
- **Lightweight loop** — polls once per minute (`Sleep(60000)`)
- All SAR flip events logged to the MT4 **Experts** tab with SAR value and timeframe

---

## How It Works

1. Every minute, `iSAR(..., Step, Maximum, 1)` fetches the confirmed prior-bar SAR value; `iClose(..., 0)` fetches current close
2. `isAbove = currentClose > currentSAR` computed
3. Flip conditions evaluated using `WasAbove`:
   - `WasAbove && !isAbove` → **Bearish Reversal Detected** — price crossed below SAR
   - `!WasAbove && isAbove` → **Bullish Reversal Detected** — price crossed above SAR
4. `WasAbove = isAbove` updated at cycle end

---

## Input Parameters

| Parameter      | Type            | Default     | Description                                             |
|----------------|-----------------|-------------|---------------------------------------------------------|
| `TradeSymbol`  | string          | `EURUSD`    | Symbol for analysis                                     |
| `Timeframe`    | ENUM_TIMEFRAMES | `PERIOD_H1` | Timeframe for analysis                                  |
| `Step`         | double          | `0.02`      | SAR Acceleration Factor step (Wilder default: `0.02`)   |
| `Maximum`      | double          | `0.2`       | SAR Acceleration Factor maximum cap (Wilder default: `0.2`) |
| `EnableAlerts` | bool            | `true`      | Fire an on-screen/sound alert                           |
| `EnableEmail`  | bool            | `false`     | Send an email notification                              |
| `EnablePush`   | bool            | `false`     | Send a mobile push notification                         |

---

## Alert Message Format

```
Bullish Reversal detected on EURUSD (Timeframe: PERIOD_H1)
SAR Value: 1.08145
```

---

## Installation

1. Copy `Moving_Average_Crossover_Script_001.mq4` to `MQL4/Scripts/`
2. Compile in MetaEditor (F7)
3. Drag onto any chart from Navigator → Scripts
4. Configure inputs and click **OK**

---

## Requirements

- MetaTrader 4 (`#property strict` compatible build)
- MQL4 compiler (MetaEditor)

---

## License

MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
