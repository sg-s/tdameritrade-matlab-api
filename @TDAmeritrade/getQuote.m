

% get quote for one or more symbols 
function data = getQuote(self)

% break this up into 100-ticker sized chunks
n_batches = ceil(length(self.tickers)/100);
batch_idx = randi(n_batches,length(self.tickers),1);

% make sure GSPC isn't here
batch_idx(strcmp(self.tickers,'GSPC')) = -1;

for bi = 1:n_batches

	ticker_string = '';
	for i = 1:length(self.tickers)-1
		if batch_idx(i) ~= bi
			continue
		end
		T = self.tickers{i};
		TT = strrep(T,'_','.');
		TT = strrep(TT,'.','%2E');
		ticker_string = [ticker_string, TT ,'%2C'];
	end

	T = self.tickers{end};
	TT = strrep(T,'.','%2E');
	ticker_string = [ticker_string, TT ];

	curl_str = 'https://api.tdameritrade.com/v1/marketdata/quotes?&symbol=TICKER&apikey=';
	curl_str = strrep(curl_str,'TICKER',ticker_string);
	curl_str = [curl_str self.APIKey];

	try
		temp = webread(curl_str);
	catch
		error('Could not connect to server. FATAL')
	end
	for i = 1:length(self.tickers)
		if batch_idx(i) ~= bi
			continue
		end

		T = self.tickers{i};
		T = strrep(T,'.','_');

		try
			data(i) = StockQuote(temp.(T));
			data(i).Symbol = strrep(data(i).Symbol,'.','_');
		catch
		end
	end
end

% special case to handle GSPC
% fall back to Yahoo! Finance
if min(batch_idx) == -1
	i = find(batch_idx == -1);
	data(i) = StockQuote;
	newdata = getMarketDataViaYahoo('^GSPC', datetime(datevec(today-1)), datetime(datevec(today)), '1d');
	if ~isempty(newdata)
		data(i).Symbol = 'GSPC';
		data(i).Name = 'S&P 500 Index';
		data(i).ClosePrice = newdata.Close(end);
		data(i).AssetType = 'Index';
		data(i).DividendYield = NaN;
	end
	


end



