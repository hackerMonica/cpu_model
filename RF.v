module RF (
    input wire clk,
    input wire rst,
    input wire RFWr,
    input wire [31:0]rR1,
    input wire [31:0]rR2,
    input wire [31:0]wR,
    input wire [31:0]wD,
    output reg [31:0]rD1,
    output reg [31:0]rD2

);
    reg [31:0]x[31:0];
    always @(*) begin
        if (rR1==0) begin
            rD1=0;
        end else begin
            rD1=x[rR1];
        end
    end
    always @(*) begin
        if (rR2==0) begin
            rD2=0;
        end else begin
            rD2=x[rR2];
        end
    end

    always @(posedge clk) begin
        if (rst==1'b1) begin
            x[0]=0;
            x[1]=0;
            x[2]=0;
            x[3]=0;
            x[4]=0;
            x[5]=0;
            x[6]=0;
            x[7]=0;
            x[8]=0;
            x[9]=0;
            x[10]=0;
            x[11]=0;
            x[12]=0;
            x[13]=0;
            x[14]=0;
            x[15]=0;
            x[16]=0;
            x[17]=0;
            x[18]=0;
            x[19]=0;
            x[20]=0;
            x[21]=0;
            x[22]=0;
            x[23]=0;
            x[24]=0;
            x[25]=0;
            x[26]=0;
            x[27]=0;
            x[28]=0;
            x[29]=0;
            x[30]=0;
            x[31]=0;
        end
        else if (RFWr==1) begin
            x[wR]=wD;
        end
    end

endmodule