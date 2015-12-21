module UP2_TOP
(
	MCLK,
	
	FLEX_DIGIT_1,
	FLEX_DIGIT_1_DP,
	FLEX_DIGIT_2,
	FLEX_DIGIT_2_DP,
	
	FLEX_MOUSE_CLK,
	FLEX_MOUSE_DATA,
	
	VGA_RED,
	VGA_BLUE,
	VGA_GREEN,
	VGA_HSYNC,
	VGA_VSYNC,
	
	LED,
	SW,
	BT,
	
	DISP1,
	DISP1_DP,
	DISP2,
	DISP2_DP,
	DISP3,
	DISP3_DP,
	DISP4,
	DISP4_DP,
	
	PS2_DATA,
	PS2_CLK,
	
	RS232_RX,
	RS232_TX,
	RS232_RTS,
	RS232_CTS,
	
	MATRIX_ROW,
	MATRIX_COL
);

/*
	==== interface description ====
*/

input MCLK;	//main clock input

output [6:0] FLEX_DIGIT_1;
output [6:0] FLEX_DIGIT_2;
output FLEX_DIGIT_1_DP;
output FLEX_DIGIT_2_DP;

output VGA_RED;
output VGA_GREEN;
output VGA_BLUE;
output VGA_HSYNC;
output VGA_VSYNC;

output [15:0] LED;
input [7:0] SW;
input [3:0] BT;

output [6:0] DISP1;
output DISP1_DP;
output [6:0] DISP2;
output DISP2_DP;
output [6:0] DISP3;
output DISP3_DP;
output [6:0] DISP4;
output DISP4_DP;

inout PS2_DATA;
inout PS2_CLK;
inout FLEX_MOUSE_DATA;
inout FLEX_MOUSE_CLK;

input RS232_RX;
output RS232_TX;
output RS232_RTS;
input RS232_CTS;

output [7:0] MATRIX_ROW;
output [15:0] MATRIX_COL;


/*
	==== functionality ====
*/

//let's save some energy
//assign FLEX_DIGIT_1 = 7'b1111111;
//assign FLEX_DIGIT_2 = 7'b1111111;
assign FLEX_DIGIT_1_DP = 1;
assign FLEX_DIGIT_2_DP = 1;
assign MATRIX_ROW = 8'hFF;
assign MATRIX_COL = 16'hFFFF;

wire plusBtn;
wire minusBtn;
wire modeBtn;
wire resetBtn;

wire [3:0] secUnits;
wire [3:0] secTens;
wire [3:0] minUnits;
wire [3:0] minTens;
wire [3:0] hUnits;
wire [3:0] hTens;

wire prescaledMCLK;


prescaler prescalerMod(
	.clkin(MCLK),
	.clkout(prescaledMCLK)
);

debouncer plusBtnDbncr(
	.clk(MCLK),
	.button(BT[2]),
	.bt_act(plusBtn)
);

debouncer minusBtnDbncr(
	.clk(MCLK),
	.button(BT[0]),
	.bt_act(minusBtn)
);

debouncer modeBtnDbncr(
	.clk(MCLK),
	.button(BT[3]),
	.bt_act(modeBtn)
);

debouncer resetBtnDbncr(
	.clk(MCLK),
	.button(BT[1]),
	.bt_act(resetBtn)
);

dek7seg secUnitsDisp(
	.data_in(secUnits),
	.disp(NEG_FLEX_DIGIT_2)
);
wire [7:0] NEG_FLEX_DIGIT_2;
assign FLEX_DIGIT_2 = ~NEG_FLEX_DIGIT_2;

dek7seg secTensDisp(
	.data_in(secTens),
	.disp(NEG_FLEX_DIGIT_1)
);
wire [7:0] NEG_FLEX_DIGIT_1;
assign FLEX_DIGIT_1 = ~NEG_FLEX_DIGIT_1;

dek7seg minsUnitsDisp(
	.data_in(minUnits),
	.disp(DISP4)
);

dek7seg minsTensDisp(
	.data_in(minTens),
	.disp(DISP3)
);

dek7seg hUnitsDisp(
	.data_in(hUnits),
	.disp(DISP2)
);

dek7seg hTensDisp(
	.data_in(hTens),
	.disp(DISP1)
);

wire resetSignal;
	
wire plusMinutesUnits;
wire minusMinutesUnits;

wire plusMinutesTesn;
wire minusMinutesTens;

wire plusHoursUnits;
wire minusHoursUnits;

wire plusHoursTens;
wire minusHoursTens;

wire stopSignal;

wire [2:0] EventDispatcherState;

EventDispatcher EventDispatcherMod(
	.modeBtn(modeBtn),
	.plusBtn(plusBtn),
	.minusBtn(minusBtn),
	.resetBtn(resetBtn),
	
	.resetSignal(resetSignal),

	.plusMinutesUnits(plusMinutesUnits),
	.minusMinutesUnits(minusMinutesUnits),

	.plusMinutesTesn(plusMinutesTens),
	.minusMinutesTens(minusMinutesTens),
	
	.plusHoursUnits(plusHoursUnits),
	.minusHoursUnits(minusHoursUnits),
	
	.plusHoursTens(plusHoursTens),
	.minusHoursTens(minusHoursTens),
	
	.stopSignal(stopSignal),
	
	.st(EventDispatcherState)
);

Digits0to9 SecUnitsMod(
	.clkin(prescaledMCLK),
	.resetSignal(resetSignal),
	.plus(1),
	.minus(1),
	.stopSignal(stopSignal),
	.MCLK(MCLK),
	
	.clkout(CLKFromSecUnits),
	.digit(secUnits),
);

wire CLKFromSecUnits;

Digits0to5 SecTensMod(
	.clkin(CLKFromSecUnits),
	.resetSignal(resetSignal),
	.plus(1),
	.minus(1),
	.stopSignal(stopSignal),
	.MCLK(MCLK),
	
	.clkout(CLKFromSecTens),
	.digit(secTens),
);

wire CLKFromSecTens;

////////////////
Digits0to9 MinUnitsMod(
	.clkin(CLKFromSecTens),
	.resetSignal(resetSignal),
	.plus(plusMinutesUnits),
	.minus(minusMinutesUnits),
	.stopSignal(stopSignal),
	.MCLK(MCLK),
	
	.clkout(CLKFromMinUnits),
	.digit(minUnits),
);

wire CLKFromMinUnits;

Digits0to5 MinTensMod(
	.clkin(CLKFromMinUnits),
	.resetSignal(resetSignal),
	.plus(plusMinutesTens),
	.minus(minusMinutesTens),
	.stopSignal(stopSignal),
	.MCLK(MCLK),
	
	.clkout(CLKFromMinTens),
	.digit(minTens),
);

wire CLKFromMinTens;

DigitsForHoutUnits DigitsForHoutUnitsMod(
	.clkin(CLKFromMinTens),
	.resetSignal(resetSignal),
	.plus(plusHoursUnits),
	.minus(minusHoursUnits),
	.stopSignal(stopSignal),
	.hTens(hTens),
	.MCLK(MCLK),
	
	.clkout(CLKFromHoursUnits),
	.digit(hUnits),
);

wire CLKFromHoursUnits;

Digits0to9 HoursTensMod(
	.clkin(CLKFromHoursUnits),
	.resetSignal(resetSignal),
	.plus(plusHoursTens),
	.minus(minusHoursTens),
	.stopSignal(stopSignal),
	.MCLK(MCLK),
	
	.digit(hTens),
);



assign LED[15] = stopSignal;
assign LED[14] = resetSignal;
assign LED[13] = CLKFromSecUnits;
assign LED[12] = prescaledMCLK;

assign LED[11] = plusMinutesUnits;
assign LED[10] = minusMinutesUnits;
assign LED[9] = plusMinutesTens;
assign LED[8] = minusMinutesTens;

assign LED[7] = plusHoursUnits;
assign LED[6] = minusHoursUnits;
assign LED[5] = plusHoursTens;
assign LED[4] = minusHoursTens;

assign LED[3] = 0;
assign {LED[2], LED[1], LED[0]} = EventDispatcherState;


endmodule



