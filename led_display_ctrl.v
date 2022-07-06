module led_display_ctrl(
    input wire clkg,
	input [31:0] 	  result,

    output wire led0_en_o,
    output wire led1_en_o,
    output wire led2_en_o,
    output wire led3_en_o,
    output wire led4_en_o,
    output wire led5_en_o,
    output wire led6_en_o,
    output wire led7_en_o,
	output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp 
    );

	reg  [7:0] led_en;
	assign led0_en_o=led_en[0];
	assign led1_en_o=led_en[1];
	assign led2_en_o=led_en[2];
	assign led3_en_o=led_en[3];
	assign led4_en_o=led_en[4];
	assign led5_en_o=led_en[5];
	assign led6_en_o=led_en[6];
	assign led7_en_o=led_en[7];

//控制小数点，使小数点常暗
assign led_dp=1;

//把不同数字对应的不同数码管驱动信号，记录到number数组中去，便于控制显示内�?
reg [6:0] number [15:0];
always @(*) begin
    number[15]= 7'b0111000;
    number[14]= 7'b0110000;
    number[13]= 7'b1000010;
    number[12]= 7'b1110010;
    number[11]= 7'b1100000;
    number[10]= 7'b0001000;
    number[9]=  7'b0001100;
    number[8]=  7'b0000000;
    number[7]=  7'b0001111;
    number[6]=  7'b0100000;
    number[5]=  7'b0100100;
    number[4]=  7'b1001100;
    number[3]=  7'b0000110;
    number[2]=  7'b0010010;
    number[1]=  7'b1001111;
    number[0]=  7'b0000001;
end 


//将计算结果按位分解成8个数，每个数都是4位二进制—�?�即�?�?16进制，便于输出到8个数码管�?
reg [3:0] answer[7:0];
always @(posedge clkg) begin
    answer[0][3:0]=result[3:0];
    answer[1][3:0]=result[7:4];
    answer[2][3:0]=result[11:8];
    answer[3][3:0]=result[15:12];
    answer[4][3:0]=result[19:16];
    answer[5][3:0]=result[23:20];
    answer[6][3:0]=result[27:24];
    answer[7][3:0]=result[31:28];
end

//核心代码，将�?�?的数据输出到led数码�?
reg [6:0] led;
always @(posedge clkg) begin
    case (cnt)
        3'd0:led=number[answer[0]];
        3'd1:led=number[answer[1]];
        3'd2:led=number[answer[2]];
        3'd3:led=number[answer[3]];
        3'd4:led=number[answer[4]];
        3'd5:led=number[answer[5]];
        3'd6:led=number[answer[6]];
        3'd7:led=number[answer[7]];
        default: led=0;
    endcase


	led_ca=led[6];
	led_cb=led[5];
	led_cc=led[4];
	led_cd=led[3];
	led_ce=led[2];
	led_cf=led[1];
	led_cg=led[0];

    // else if (rst) begin
    //     led_ca=1;
	// 	led_cb=1;
	// 	led_cc=1;
	// 	led_cd=1;
	// 	led_ce=1;
	// 	led_cf=1;
	// 	led_cg=1;
    // end
    
end


//计数器，控制数码管显示位�?
reg [19:1] mytime;
reg [2:0] cnt;
always @(posedge clkg) begin
	mytime=mytime+1;
	if (mytime==20'd20001) begin
		mytime=0;
	end
end
always @(posedge clkg) begin
    if (mytime==0) begin
		cnt=cnt+1;
	end
    
end


//依照计数器，控制使能信号，按顺序依次控制8个数码管
always @(posedge clkg) begin
	if (cnt==4'd7) begin
		led_en=8'b01111111;
	end
	else if (cnt==4'd6) begin
		led_en=8'b10111111;
	end
	else if (cnt==4'd5) begin
		led_en=8'b11011111;
	end
	else if (cnt==4'd4) begin
		led_en=8'b11101111;
	end
	else if (cnt==4'd3) begin
		led_en=8'b11110111;
	end
	else if (cnt==4'd2) begin
		led_en=8'b11111011;
	end
	else if (cnt==4'd1) begin
		led_en=8'b11111101;
	end
	else if (cnt==4'd0) begin
		led_en=8'b11111110;
	end


end

endmodule
