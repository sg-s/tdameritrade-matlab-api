# TDAmeritrade

(Will be) fully featured TD Ameritrade API for MATLAB. 


## Installation

Download this repo and a dependency, and add them to your MATLAB path:


```bash
git clone https://github.com/sg-s/srinivas.gs_mtools/
git clone https://github.com/sg-s/tdameritrade-matlab-api/
```



## Features

### Get historical data for any symbol 

```matlab
T = TDAmeritrade;
data = T.getPriceHistory;
```

`data` is a structure array containing time series of 

- Open
- Close
- High
- Low
- Volume 

Currently, only daily information is available, but future work will support all available frequencies. 

### Get delayed quotes 

```matlab
q = T.getQuote;
```

returns a [StockQuote]() array. The stock quote for `AAPL` can look like:


```
  StockQuote with properties:

        AssetType: 'EQUITY'
            CUSIP: '037833100'
           Symbol: 'AAPL'
             Name: 'Apple Inc. - Common Stock'
       ClosePrice: 124.7600
        LastPrice: 122.1900
    DividendYield: 0.6600
```

### Get fundamental information about instrument 

```
f = T.getFundamental;
```

returns a structure array with various fundamental information (e.g., `quickRatio`, `marketCap`, etc.)

### Get transactions from account 

### Get positions 

## Configuration

You will need a TD Ameritrade trading account **and** a developer account to use this. 

## License  

GPL v3. 