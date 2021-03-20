

function positions = getPositions(self)


response = self.requestAccessToken();


% use the new access token to get transactions 
disp('Requesting position info using OAuth...')
curl_str = 'curl -X GET --header "Authorization: " --header "Authorization: Bearer $ACCESS_TOKEN" "https://api.tdameritrade.com/v1/accounts/$ACCOUNTID?fields=positions"';



curl_str = strrep(curl_str,'$ACCOUNTID',strip(self.AccountID));
curl_str = strrep(curl_str,'$ACCESS_TOKEN',strip(response.access_token));

[e,o] = system(curl_str);

assert(e==0,'curl failed. Cannot get positions')

pos_raw = jsondecode(o);
pos_raw = pos_raw.securitiesAccount.positions;

positions = table(categorical(NaN),0,0,0,'VariableNames',{'Symbol','Quantity','Price','MarketValue'});
positions = repmat(positions,length(pos_raw),1);

for i = 1:length(pos_raw)
	this_pos = pos_raw(i);

	positions.Symbol(i) = this_pos.instrument.symbol;

	positions.Quantity(i) = this_pos.longQuantity;
	positions.Price(i) = this_pos.averagePrice;

	positions.MarketValue(i) = this_pos.marketValue;




end