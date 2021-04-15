

% get quote for one or more symbols 
function quotes = getQuote(self)

% break this up into 100-ticker sized chunks
n_batches = ceil(length(self.tickers)/100);
batch_idx = randi(n_batches,length(self.tickers),1);


% GSPC is called $SPX.X in TDAmeritrade
tickers = self.tickers;
tickers(tickers == "GSPC") = "$SPX.X";

quotes = repmat(StockQuote,length(tickers),1);

for bi = 1:n_batches

	these_tickers = tickers(batch_idx==bi);
	these_tickers = strrep(these_tickers,'_','.');
	these_tickers = strrep(these_tickers,'.','%2E');

	% add a comma between each ticker
	these_tickers = strcat(these_tickers,'%2C');
	these_tickers = strcat(these_tickers{:});
	these_tickers = these_tickers(1:end-3);


	curl_str = 'https://api.tdameritrade.com/v1/marketdata/quotes?&symbol=TICKER&apikey=';
	curl_str = strrep(curl_str,'TICKER',these_tickers);
	curl_str = [curl_str self.APIKey];


	try
		temp = webread(curl_str);
	catch
		error('Could not connect to server. FATAL')
	end

	for i = 1:length(tickers)
		if batch_idx(i) ~= bi
			continue
		end

		T = tickers(i);
		T = strrep(T,'.','_');

		if strcmp(tickers(i),'$SPX.X')
			T = 'x_SPX_X';
		end

		try
			quotes(i) = StockQuote(temp.(T));
			quotes(i).Symbol = tickers(i);
		catch
		end
	end
end



