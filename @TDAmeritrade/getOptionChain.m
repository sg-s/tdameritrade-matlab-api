
function options = getOptionChain(self, args)


arguments
	self (1,1) TDAmeritrade
	args.Type char  {mustBeMember(args.Type, {'Call','Put'})} =  'Call'
end

options = OptionContract.empty;

for i = 1:length(self.tickers)
	T = upper(self.tickers{i});


	url = ('https://api.tdameritrade.com/v1/marketdata/chains?&symbol=TICKER&apikey=APIKey&contractType=OPTION_TYPE');

	url = strrep(url,'APIKey',self.APIKey);
	url = strrep(url,'TICKER',T);
	url = strrep(url,'OPTION_TYPE',upper(args.Type));

	temp = webread(url);

	these_options = repmat(OptionContract,temp.numberOfContracts,1);

	idx = 1;

	if strcmp(args.Type,'Call')
		TypeMap = 'callExpDateMap';
	else
		TypeMap = 'putExpDateMap';
	end

	fn1 = fieldnames(temp.(TypeMap));
	for j = 1:length(fn1)
		fn2 = fieldnames(temp.(TypeMap).(fn1{j}));
		for k = 1:length(fn2)

			S = temp.(TypeMap).(fn1{j}).(fn2{k});
			S = S(1);

			these_options(idx) = OptionContract(S);
			these_options(idx).symbol = T;
			idx = idx + 1;
		end
	end

	options = [options; these_options];

end