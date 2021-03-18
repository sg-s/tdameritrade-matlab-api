
classdef (Abstract) StockDataSource < Unhashable



properties (Access = private)

end % private props

properties

	tickers cell = {'AAPL', 'TDOC'}

	StartDate (1,1) datetime = datetime('03-Jan-1995')
	EndDate (1,1) datetime = datetime


	frequencyType (1,1) duration = days(1)

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

