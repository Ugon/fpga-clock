module Digits0to2(
	input clkin,
	input resetSignal,
	input plus,
	input minus,
	input stopSignal,
	input MCLK,
	
	output reg clkout,
	output reg [3:0] digit
);

parameter MIN_DIGIT = 0;
parameter MAX_DIGIT = 2;

reg prevPlus;
reg prevMinus;
reg prevClk;

reg midPlus;
reg midMinus;
reg midClk;

always@(digit)
	if(digit <= (MAX_DIGIT/2))
		clkout <= 0;
	else clkout <= 1;
	
always@(negedge MCLK)
	begin
		prevPlus <= plus;
		prevMinus <= minus;
		prevClk <= clkin;
	end
	
always@(negedge resetSignal, negedge MCLK)
	if(resetSignal == 0)
		begin
			digit <= 0;
		end
	else
		begin
			if(clkin == 0 & prevClk == 1 & stopSignal == 1)
				if (digit < MAX_DIGIT)
					digit <= digit + 1;
				else 
					digit <= MIN_DIGIT;
			if((plus == 0 & prevPlus == 1))
				if (digit < MAX_DIGIT)
					digit <= digit + 1;
				else 
					digit <= MIN_DIGIT;
			if(minus == 0 & prevMinus == 1)
				if (digit> MIN_DIGIT)
					digit <= digit - 1;
				else 
					digit <= MAX_DIGIT;
		end
		
endmodule
