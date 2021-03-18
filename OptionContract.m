
classdef OptionContract



properties (Access = private)

end % private props

properties

	Type char  {mustBeMember(Type, {'Call','Put'})} = 'Call'

	symbol char 

	strikePrice (1,1) double 

	bid (1,1) double
	ask (1,1) double
	highPrice (1,1) double
	lowPrice (1,1) double

    totalVolume (1,1) double 

    volatility (1,1) double 
	delta  (1,1) double
	gamma (1,1) double
	theta (1,1) double
	vega (1,1) double
	rho (1,1) double


	timeValue (1,1) double
	theoreticalOptionValue (1,1) double 
	theoreticalVolatility (1,1) double

	
	expirationDate (1,1) datetime 
	multiplier (1,1) double = 100

	percentChange (1,1) double 	
	inTheMoney (1,1) logical

	openInterest (1,1) double


end % props



methods 

	function self = OptionContract(data)

		if nargin == 0
			return
		end

		assert(isstruct(data),'Expected data to be a struct')
		assert(isscalar(data),'Expected data to be scalar')

		fn = fieldnames(data);

		fn = intersect(fn,properties(self));
		for i = 1:length(fn)
			if strcmp(fn{i},'expirationDate')
				self.expirationDate = datetime(data.expirationDate*1e-3,'ConvertFrom','posixtime');

			else
				try
					self.(fn{i}) = data.(fn{i});
				catch
					self.(fn{i}) = str2double(data.(fn{i}));
				end
			end
		end


	end % constructor


	function options = filter(self,args)

		arguments
			self (:,1) OptionContract
			args.symbol char = self(1).symbol;
			args.expireAfter (1,1) datetime = min([self.expirationDate])
			args.expireBefore (1,1) datetime = max([self.expirationDate])
			args.expireOn (1,1) datetime = NaT
		end

		options = self;

		this = strcmp({options.symbol},args.symbol) & [options.expirationDate] >= args.expireAfter & [options.expirationDate] <= args.expireBefore;

		if ~isnat(args.expireOn)
			this = this & [options.expirationDate] == args.expireOn;
		end

		options = options(this);


	end


	function plotStrikeDistribution(self)

		figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on

		ax(1) = subplot(2,1,1); hold on
		ax(2) = subplot(2,1,2); hold on



		% get all expiration dates
		exp_dates = unique(vertcat(self.expirationDate));
		C = parula(length(exp_dates));

		for i = 1:length(exp_dates)
			options = self.filter('expireOn',exp_dates(i));

			strike_prices = [options.strikePrice];
			predicted_price = [options.bid] + strike_prices;

			plot(ax(1),strike_prices,predicted_price,'Color',C(i,:));
			plot(ax(2),strike_prices,[options.openInterest],'Color',C(i,:));
		end



	end


	function N = daysToExpiration(self)
		keyboard
	end


end % methods



methods (Static)

end % static methods






end % classdef

