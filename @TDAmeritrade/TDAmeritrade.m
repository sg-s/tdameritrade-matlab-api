% class to interface with the TD Ameritrade API


classdef TDAmeritrade < StockDataSource



properties (Access = private)
	API_key char
	AccountID char
	refresh_token char
end % private props

properties


end % props

methods 

	function self = TDAmeritrade()

		% read API key
		self.API_key = fileread(fullfile(fileparts(fileparts(which('TDAmeritrade'))),'private','tda.key'));

		% read AccountID
		self.AccountID = fileread(fullfile(fileparts(fileparts(which('TDAmeritrade'))),'private','accountid.key'));


		% read access token. this is the token that you have to go through hell to get using OAuth, and is not the same as the API key
		self.refresh_token = fileread(fullfile(fileparts(fileparts(which('TDAmeritrade'))),'private','refresh_token.key'));

	end % constructor



end % methods



methods (Static)

end % static methods






end % classdef

