
% class that contains information for a stock
% quote


classdef StockQuote < Constructable


properties
	assetType (1,1) string
	cusip (1,1) string
	symbol (1,1) string
	description (1,1) string
	closePrice (1,1) double
	lastPrice (1,1) double
	divYield (1,1) double 

end


methods
	function self = StockQuote(varargin)
		self = self@Constructable(varargin{:}); 
	end

end

end