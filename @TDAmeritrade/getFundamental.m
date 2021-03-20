% get fundamental info
function fdata = getFundamental(self, o)

arguments
	self (1,1) TDAmeritrade
	o.ProgressBar matlab.ui.dialog.ProgressDialog
	o.UseCache (1,1) logical = true
end

cloc = fullfile(userpath,'tdameritrade','fundamental_data');
filelib.mkdir(cloc)



for i = length(self.tickers):-1:1
	T = self.tickers{i};


	% progress
	if nargin > 1 && isa(o.ProgressBar,'matlab.ui.dialog.ProgressDialog')
		o.ProgressBar.Value = (length(self.tickers) - i)/length(self.tickers);
		o.ProgressBar.Message = ['Downloading fundamental data: ' T];
	else
		disp(T)
	end

	% first check the cache
	if o.UseCache
		try
			load(fullfile(cloc,[T '.mat']),'FunData')
			fdata(i) = FunData;
			continue
		catch
		end
	end

	

	curl_str = 'https://api.tdameritrade.com/v1/instruments?&symbol=TICKER&projection=fundamental&apikey=';

	curl_str = strrep(curl_str,'TICKER',T);
	curl_str = [curl_str self.APIKey];
	data = webread(curl_str);

	try
		data = data.(T);
	catch
		continue
	end

	fdata(i) = data.fundamental;

	% check that EPS is not zero
	if fdata(i).epsTTM == 0
		% fuck you TD ameritrade, fall back to Yahoo!
		disp('0 EPS reported, attempting to cross-check with Yahoo!')
		try
			YF = YahooFinance;
			YF.tickers = {fdata(i).symbol};
			fdata(i).epsTTM = YF.getEPS;
		catch
		end

	end

	% cache
	FunData = fdata(i);
	save(fullfile(cloc,[self.tickers{i} '.mat']),'FunData')

end

% make sure fdata isn't empty
for i = 1:length(fdata)
	if isempty(fdata(i).epsTTM)
		fdata(i).symbol = self.tickers{i};
		fdata(i).epsTTM = NaN;
	end
end

