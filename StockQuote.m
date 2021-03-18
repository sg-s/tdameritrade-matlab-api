
% class that contains information for a stock
% quote

classdef StockQuote



properties (Access = private)

end % private props

properties
	AssetType char
	CUSIP char
	Symbol char
	Name char
	ClosePrice double
	LastPrice double
	DividendYield double 


end % props



methods 

	function self = StockQuote(data)

		if nargin == 0
			return
		end

		self.AssetType = data.assetType;
		self.CUSIP = (data.cusip);
		self.Symbol = data.symbol;
		self.Name = data.description;
		self.ClosePrice = data.closePrice;
		self.LastPrice = data.lastPrice;
		self.DividendYield = data.divYield;
	end % constructor


end % methods



methods (Static)

end % static methods






end % classdef

