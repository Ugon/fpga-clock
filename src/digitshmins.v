module digitshmins(
	input reset,
	input clkin,
	input plus,
	input minus,
	input [3:0] hTens,
	output reg clkout,
	output reg [3:0] digit
);

parameter MIN_DIGIT = 0;
parameter MAX_DIGIT = 9;
parameter CONDITIONAL_MAX_DIGIT = 3;

reg[3:0] state;

wire innerclk = clkin & plus & minus;

always@(state)
	digit <= state;

always@(digit)
	if(hTens == 2)
		if(digit < (CONDITIONAL_MAX_DIGIT/2 + 1))
			clkout <= 0;
		else clkout <= 1;
	else
		if(digit < (MAX_DIGIT/2 + 1))
			clkout <= 0;
		else clkout <= 1;

always@(negedge reset, negedge innerclk)
	if(reset == 0)
		begin
			state <= 0;
		end
	else
		begin
			if(plus == 0 | clkin == 0)
				if(hTens == 2)
					if (state < CONDITIONAL_MAX_DIGIT)
						state <= digit + 1;
					else 
						state <= MIN_DIGIT;
				else
					if (state < MAX_DIGIT)
						state <= digit + 1;
					else 
						state <= MIN_DIGIT;
			else if(minus == 0)
				if(hTens == 2)
					if (state > MIN_DIGIT)
						state <= digit - 1;
					else 
						state <= MAX_DIGIT;
				else 
					if (state> MIN_DIGIT)
						state <= digit - 1;
					else 
						state <= CONDITIONAL_MAX_DIGIT;
		end

endmodule
