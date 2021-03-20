

function transactions = getTransactions(self)



% get a new access token
response = self.requestAccessToken();


% use the new access token to get transactions 
disp('Requesting transactions using OAuth...')
curl_str = 'curl -X GET --header "Authorization: " --header "Authorization: Bearer $ACCESS_TOKEN" "https://api.tdameritrade.com/v1/accounts/$ACCOUNTID/transactions?type=TRADE"';



curl_str = strrep(curl_str,'$ACCOUNTID',strip(self.AccountID));
curl_str = strrep(curl_str,'$ACCESS_TOKEN',strip(response.access_token));

[e,o] = system(curl_str);

assert(e==0,'curl failed. Cannot get transactions')

tx_raw = jsondecode(o);
transactions = table(categorical(NaN),0,0,NaT('TimeZone','UTC'),0,0,'VariableNames',{'Symbol','Quantity','Price','Date','Amount','TransactionID'});
transactions = repmat(transactions,length(tx_raw),1);

for i = 1:length(tx_raw)
	this_tx = tx_raw(i);
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