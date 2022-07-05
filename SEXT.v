module SEXT (
    input wire [31:7]din,
    input wire [2:0]EXTop,
    output reg [31:0]ext
);
    reg signed [31:0]imm;
    assign ext=imm;
    //change din to exact imm
    always @(*) begin
        case(EXTop)
            3'b000:begin
                imm={din[31:20],20'b0};
                imm=imm>>>5'd20;
            end
            3'b001:begin
                imm={din[31:25],din[11:7],20'b0};
                imm=imm>>>5'd20;
            end
            3'b010:begin
                imm={din[31],din[7],din[30:25],din[11:8],20'b0};
                imm=imm>>>5'd19;
            end
            3'b011:begin
                imm={din[31:12],12'b0};
            end
            3'b100:begin
                imm={din[31],din[19:12],din[20],din[30:21],12'b0};
                imm=imm>>>5'd11;
            end
        endcase
    end
endmodule