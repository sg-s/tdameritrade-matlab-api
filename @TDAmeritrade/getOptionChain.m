% returns options chain for all symbols
% in self.tickers
% outputs are of type OptionContracts
% usage:
% 

function options = getOptionChain(self, args)


arguments
	self (1,1) TDAmeritrade
	args.Type string  {mustBeMember(args.Type,["Call","Put","All"])} = "All"
	args.Verbose (1,1) logical = true
end

options = OptionContracts;

thistime = datetime;

for i = 1:length(self.tickers)
	T = upper(self.tickers{i});


	if args.Verbose
		disp(strcat(string(T)," -- ",args.Type))
	end

	url = ('https://api.tdameritrade.com/v1/marketdata/chains?&symbol=TICKER&apikey=APIKey&contractType=OPTION_TYPE&toDate=ENDDATE&fromDate=STARTDATE');


	url = strrep(url,'ENDDATE',datestr(self.EndDate,29));
	url = strrep(url,'STARTDATE',datestr(self.StartDate,29));

	url = strrep(url,'APIKey',self.APIKey);
	url = strrep(url,'TICKER',T);
	url = strrep(url,'OPTION_TYPE',upper(args.Type));

	temp = webread(url);


	if strcmp(args.Type,"All") 
		TypeMaps = {'callExpDateMap','putExpDateMap'};
		Types = ["Call","Put"];
	elseif strcmp(args.Type,"Call") 
		TypeMaps = {'callExpDateMap'};
		Types = "Call";
	elseif strcmp(args.Type,"Put") 
		TypeMaps = {'putExpDateMap'};
		Types = "Put";
	end

	idx = temp.numberOfContracts + options.Size;

	for ti = 1:length(TypeMaps)
		TypeMap = TypeMaps{ti};
		Type = Types(ti);

		fn1 = fieldnames(temp.(TypeMap));
		for j = 1:length(fn1)
			fn2 = fieldnames(temp.(TypeMap).(fn1{j}));
			for k = 1:length(fn2)

				S = temp.(TypeMap).(fn1{j}).(fn2{k});
				S = S(1);

				S.underlyingPrice = temp.underlyingPrice;
				S.Type = Type;
				S.expirationDate = datetime(S.expirationDate*1e-3,'ConvertFrom','posixtime');

				S.symbol = self.tickers{i};
				S.time = thistime;

				options = options.insertAt(S,idx);
				idx = idx - 1;
			end
		end

	end


end