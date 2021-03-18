% class to interface with the TD Ameritrade API


classdef TDAmeritrade < StockDataSource



properties (Access = private)
	APIKey char
	AccountID char
	RefreshToken char
end % private props

properties


end % props

methods 

	function self = TDAmeritrade()

		% read API key
		try
			cloc = fullfile(userpath,'tdameritrade','APIKey.key');
			self.APIKey = fileread(cloc);
		catch
			warning('Could not read API key. TDAmeritrade will not work. Set the API_key property before using.')
		end

		% read AccountID
		try
			cloc = fullfile(userpath,'tdameritrade','AccountID.key');
			self.AccountID = fileread(cloc);
		catch
		end


		% read access token. this is the token that you have to go through hell to get using OAuth, and is not the same as the API key
		try
			cloc = fullfile(userpath,'tdameritrade','RefreshToken.key');
			self.RefreshToken = fileread(cloc);
		catch
		end

	end % constructor


	function self = set(self, thing, secret)

		arguments
			self (1,1) TDAmeritrade
			thing char {mustBeMember(thing, {'APIKey','AccountID','RefreshToken'})}
			secret char
		end

		self.(thing) = secret;

		% write to disk
		cloc = fullfile(userpath,'tdameritrade',[thing '.key']);
		filelib.write(cloc,{secret});

	end


end % methods



methods (Static)

end % static methods






end % classdef

