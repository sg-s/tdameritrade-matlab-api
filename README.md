# Unofficial TDAmeritrade MATLAB API

(Will be) fully featured TD Ameritrade API for MATLAB. 





## Features

### Get historical data for any symbol 

```matlab
T = TDAmeritrade;
T.tickers={'AAPL','INTC','TSLA'};
data = T.getPriceHistory;
```

`data` is a structure array containing time series of 

- Open
- Close
- High
- Low
- Volume 

Currently, only daily information is available, but future work will support all available frequencies. 

You can plot this using:

```
plot(data(1).Time,data(1).Close)
```

and you should get something like this:

![](https://user-images.githubusercontent.com/6005346/111885025-a9677d00-899b-11eb-9300-211822763cfc.png)

### Get delayed quotes 

```matlab
q = T.getQuote;
```

returns a [StockQuote](https://github.com/sg-s/tdameritrade-matlab-api/blob/main/StockQuote.m) array. The stock quote for `AAPL` can look like:


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

This information is cached on disk, so subsequent calls will load from the cache and will not ping TDA's servers. If you want to force a fetch from the server, use:

```
f = T.getFundamental('UseCache',false);
```

### Get option chain

```
o = T.getOptionChain('Type','Call');
```

returns the full option chain for the symbols requested. Results are returned as an array of [OptionContract](https://github.com/sg-s/tdameritrade-matlab-api/blob/main/OptionContract.m). 

### Get transactions from account 


```
transactions = T.getTransactions;
```

Using OAuth2, get a list of transactions from a specified account. You need to tell it what account to read from (see below). 

`transactions` is a table that could look like this:

```

        Symbol         Quantity    Price             Date           
    _______________    ________    ______    ____________________   

    MOON                 -500         127    19-Mar-2021 13:18:12   
    FTFT                  -60      18.151    19-Mar-2021 14:38:06   
    TSLA                  -14       15.17    11-Mar-2021 14:15:19   
    GME                    14          18    11-Mar-2021 15:10:11   
    NVDA                   5          125    03-Mar-2021 14:19:00   
    GME                   -1        122.6    02-Mar-2021 14:21:40   
    GME                   700      123.14    22-Feb-2021 14:44:30   
    GME                  -700         125    22-Feb-2021 14:31:28   

```


### Get positions for account

```
positions = T.getPositions();
```

returns a table with positions. 

## Installation

Download this repo and a dependency, and add them to your MATLAB path:


```bash
git clone https://github.com/sg-s/srinivas.gs_mtools/
git clone https://github.com/sg-s/tdameritrade-matlab-api/
```


## Configuration

You will need a TD Ameritrade trading account **and** a developer account to use this. 

There are two levels of using this API, based on whether you want basic, delayed information (for which you can make unauthenticated requests), or realtime/private information (such as accessing your transactions). 

TD Ameritrade has smartly made it easy to get basic information, and made it hard (but secure) to access more sensitive information. 


### Basic configuration 

1. Go to [https://developer.tdameritrade.com/](https://developer.tdameritrade.com/)
2. Register for a new account
3. Create a new app, register it, and copy the "customer key"
4. This is your API key. Set it using:

```
T = TDAmeritrade;
T.set('APIKey','YOURAPIKEY');
```


### Advanced configuration

You only need to do this if you want to do things like:

1. read out account information
2. get realtime data
3. place trades, etc. 

You will have to go through the process of getting access tokens via OAuth (beyond the scope of this document). Once you have it,

```matlab

% set the refresh token 
% This API will use the refresh token to get 
% a new access token and will use that
T.set('RefreshToken','YOUR_REFRESH_TOKEN');


% also tell it what account you want to read from
T.set('AccountID','YOUR_ACCOUNT_ID');
```

## Limitations and known bugs

1. EPS incorrectly returned as 0 for companies that lose money (this is a bug in TDAmeritrade's reporting, so cannot be fixed)
2. Authenticated requests using OAuth use the system `curl`, rather than builtin MATLAB tools. If you don't have `curl` installed on your computer, this won't work. 


## Features not yet implemented

1. Realtime quotes (using authenticated requests)
2. ~~Variable resolution historical data~~
3. Get account balances & orders
4. Place orders
5. Cancel orders
6. Get new refresh token using access token
7. Instrument Search using keywords and regex
8. Get mover information
8. Watchlist operations


## License  

GPL v3. 