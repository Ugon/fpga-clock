module EventDispatcher(
	input modeBtn,
	input plusBtn,
	input minusBtn,
	input resetBtn,
	
	output reg resetSignal,
	
	output reg plusMinutesUnits,
	output reg minusMinutesUnits,
	
	output reg plusMinutesTesn,
	output reg minusMinutesTens,
	
	output reg plusHoursUnits,
	output reg minusHoursUnits,
	
	output reg plusHoursTens,
	output reg minusHoursTens,
	
	output reg stopSignal,
	
	output reg [2:0] st
);

reg [2:0] state;
//0 - clock
//1 - set h tens
//2 - set h units
//3 - set min tens
//4 - set min units

always@ (state)
	st <= state;

always@(state, resetBtn)
	if(resetBtn == 0)
		resetSignal <= 0;
	else if(state == 0)
		begin	
			resetSignal <= 1;

			plusMinutesUnits <= 1;
			minusMinutesUnits <= 1;

			plusMinutesTesn <= 1;
			minusMinutesTens <= 1;

			plusHoursUnits <= 1;
			minusHoursUnits <= 1;

			plusHoursTens <= 1;
			minusHoursTens <= 1;
			
			stopSignal <= 1;
		end
	else if(state == 1)
		begin
			resetSignal <= modeBtn;

			plusMinutesUnits <= 1;
			minusMinutesUnits <= 1;

			plusMinutesTesn <= 1;
			minusMinutesTens <= 1;

			plusHoursUnits <= 1;
			minusHoursUnits <= 1;

			plusHoursTens <= plusBtn;
			minusHoursTens <= minusBtn;
			
			stopSignal <= 0;
		end
	else if(state == 2)
		begin
			resetSignal <= 1;

			plusMinutesUnits <= 1;
			minusMinutesUnits <= 1;

			plusMinutesTesn <= 1;
			minusMinutesTens <= 1;

			plusHoursUnits <= plusBtn;
			minusHoursUnits <= minusBtn;

			plusHoursTens <= 1;
			minusHoursTens <= 1;
			
			stopSignal <= 0;
		end
	else if(state == 3)
		begin
			resetSignal <= 1;

			plusMinutesUnits <= 1;
			minusMinutesUnits <= 1;

			plusMinutesTesn <= plusBtn;
			minusMinutesTens <= minusBtn;

			plusHoursUnits <= 1;
			minusHoursUnits <= 1;

			plusHoursTens <= 1;
			minusHoursTens <= 1;
			
			stopSignal <= 0;
		end
	else if(state == 4)
		begin
			resetSignal <= 1;

			plusMinutesUnits <= plusBtn;
			minusMinutesUnits <= minusBtn;

			plusMinutesTesn <= 1;
			minusMinutesTens <= 1;

			plusHoursUnits <= 1;
			minusHoursUnits <= 1;

			plusHoursTens <= 1;
			minusHoursTens <= 1;
			
			stopSignal <= 0;
		end

always@(negedge modeBtn, negedge resetBtn)
	if(resetBtn == 0)
		state <= 0;
	else if (state == 0)
		state <= 1;
	else if (state == 1)
		state <= 2;
	else if (state == 2)
		state <= 3;
	else if (state == 3)
		state <= 4;
	else if (state == 4)
		state <= 0;
endmodule
