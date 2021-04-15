
classdef (Abstract) StockDataSource < Unhashable



properties (Access = private)

end % private props

properties

	tickers (:,1) string =  ["AAPL"; "TDOC"]
	StartDate (1,1) datetime = datetime('03-Jan-1995')
	EndDate (1,1) datetime = datetime

end % props



methods 

	function self = StockDataSource()

	end % constructor


	function data = getPriceHistory(self)

	end


end % methods



methods (Static)

end % static methods






end % classdef

