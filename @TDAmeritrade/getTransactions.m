

function transactions = getTransactions(self)



% get a new access token

disp('Requesting access token using OAuth...')
curl_str = 'curl -X POST --header "Content-Type: application/x-www-form-urlencoded" -d "grant_type=refresh_token&refresh_token=$REFRESH_token&access_type=&code=&client_id=$API_KEY%40AMER.OAUTHAP" "https://api.tdameritrade.com/v1/oauth2/token"';

curl_str = strrep(curl_str, '$REFRESH_token',urlencode(self.refresh_token));
curl_str = strrep(curl_str, '$API_KEY',self.API_key);

[e,o] = system(curl_str);

if e ~= 0
	disp('Something went wrong with getting the access token. The error was:')
	disp(o)
	disp('Try getting a new refresh token')
	error('Cannot read access token')
end

response = jsondecode(o);


% use the new access token to get transactions 
disp('Requesting transactions using OAuth...')
curl_str = 'curl -X GET --header "Authorization: " --header "Authorization: Bearer $ACCESS_TOKEN" "https://api.tdameritrade.com/v1/accounts/$ACCOUNTID/transactions?type=TRADE"';



curl_str = strrep(curl_str,'$ACCOUNTID',self.AccountID);
curl_str = strrep(curl_str,'$ACCESS_TOKEN',(response.access_token));


[e,o] = system(curl_str);

tx_raw = jsondecode(o);
transactions = table(categorical(NaN),0,0,NaT('TimeZone','UTC'),0,0,'VariableNames',{'Symbol','Quantity','Price','Date','Amount','TransactionID'});
transactions = repmat(transactions,length(tx_raw),1);

for i = 1:length(tx_raw)
	this_tx = tx_raw{i};
	if ~strcmp(this_tx.type,'TRADE')
		continue
	end
	transactions.Symbol(i) = this_tx.transactionItem.instrument.symbol;

	transactions.Quantity(i) = this_tx.transactionItem.amount;
	transactions.Price(i) = this_tx.transactionItem.price;

	if strcmp(this_tx.transactionItem.instruction,'SELL')
		transactions.Quantity(i) = -transactions.Quantity(i);
	end

	transactions.Date(i) = datetime(this_tx.transactionDate,'InputFormat','uuuu-MM-dd''T''HH:mm:ssXXX','TimeZone','UTC');
	transactions.TransactionID(i) = str2double(this_tx.orderId);

end