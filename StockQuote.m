
% class that contains information for a stock
% quote


classdef StockQuote < Constructable


properties
	assetType char
	cusip char
	symbol char
	description char
	closePrice double
	lastPrice double
	divYield double 

end


methods
	function self = StockQuote(varargin)
		self = self@Constructable(varargin{:}); 
	end

end

end