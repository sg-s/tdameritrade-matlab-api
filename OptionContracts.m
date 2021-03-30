

% contains a store of option contacts 
classdef OptionContracts < Silo



properties (Access = private)

end % private props

properties

	Type (:,1) string = "Call"

	symbol (:,1) string = "" 

	strikePrice (:,1) double 

	bid (:,1) double
	ask (:,1) double
	highPrice (:,1) double
	lowPrice (:,1) double

    totalVolume (:,1) double 

    volatility (:,1) double 
	delta  (:,1) double
	gamma (:,1) double
	theta (:,1) double
	vega (:,1) double
	rho (:,1) double


	timeValue (:,1) double
	theoreticalOptionValue (:,1) double 
	theoreticalVolatility (:,1) double

	
	expirationDate (:,1) datetime 
	multiplier (:,1) double = 100

	percentChange (:,1) double 	
	inTheMoney (:,1) logical

	openInterest (:,1) double

	time (:,1) datetime = datetime

	underlyingPrice (:,1) double = NaN


end % props



methods 

	function self = OptionContracts()


	end % constructor



	function self = setTimeZone(self,TimeZone)
		for i = 1:length(self)
			self(i).expirationDate.TimeZone = TimeZone;
		end
	end

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

		figure('outerposition',[300 300 1200 901],'PaperUnits','points','PaperSize',[1200 901]); hold on

		ax(1) = subplot(2,1,1); hold on
		ylabel('Strike + Premium ($)')
		ax(2) = subplot(2,1,2); hold on
		ylabel('Total Volume')


		% get all expiration dates
		exp_dates = unique(vertcat(self.expirationDate));

		if length(exp_dates) < 8
			C = lines;
		else
			C = parula(length(exp_dates));
		end



		for i = 1:length(exp_dates)
			options = self.filter('expireOn',exp_dates(i));

			strike_prices = [options.strikePrice];
			predicted_price = [options.ask] + strike_prices;

			plot(ax(1),strike_prices,predicted_price,'Color',C(i,:));
			plot(ax(2),strike_prices,[options.totalVolume],'Color',C(i,:));
		end


		figlib.pretty()
	end



end % methods




end % classdef

