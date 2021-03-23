function data = getPriceHistory(self)

self.EndDate =  dateshift(self.EndDate,'start','day');

for i = 1:length(self.tickers)
	T = self.tickers{i};


	T = strrep(T,'_','.');
	TT = T;
	
	if strcmp(T,'GSPC')
		% for whatever reason, GSPC is called $SPX.X on TD ameritrade
		TT = '$SPX.X';
	end

	curl_str = ['https://api.tdameritrade.com/v1/marketdata/TICKER/pricehistory?frequencyType=$FT&endDate=END_DATE&startDate=START_DATE&apikey='];

	curl_str = strrep(curl_str,'TICKER',TT);
	curl_str = strrep(curl_str,'$FT',self.frequencyType);

	curl_str = strrep(curl_str,'END_DATE',mat2str(posixtime(self.EndDate)*1000));
	curl_str = strrep(curl_str,'START_DATE',mat2str(posixtime(self.StartDate)*1000));
	curl_str = [curl_str self.APIKey];

	if strcmp(self.frequencyType,'daily')
		curl_str = [curl_str '&periodType=year'];
	end

	try
		temp = webread(curl_str);
	catch
		% this is so that we don't accidentally leak the API key into the MATLAB display
		error('Error reading data. ')
	end

	if temp.empty 
		continue
	end
	
	data(i).Time = datetime(vertcat(temp.candles.datetime)/1e3,'ConvertFrom','posixtime','TimeZone','America/New_York');
	data(i).Ticker = T;
	data(i).Close = vertcat(temp.candles.close);
	data(i).Open = vertcat(temp.candles.open);
	data(i).High = vertcat(temp.candles.high);
	data(i).Low = vertcat(temp.candles.low);
	data(i).Volume = vertcat(temp.candles.volume);

end


