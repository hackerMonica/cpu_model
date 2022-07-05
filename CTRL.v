module CTRL (
    input wire [6:0] opcode,
    input wire [14:12] fun3,
    input wire [31:25] fun7,
    input wire branch,
    output reg [2:0] NPCop,
    output reg WEn,
    output reg [3:0] ALUop,
    output reg ASel,
    output reg BSel,
    output reg [2:0] EXTop,
    output reg RFWr,
    output reg [1:0] WDSel
);
    
    //control ALUop
    always @(*) begin
        case (opcode)
            7'b0110011,7'b0010011: begin
                case (fun3)
                    3'b000:begin
                        case (opcode)
                            7'b0110011:begin
                                case (fun7)
                                    7'b0000000: ALUop=0;
                                    7'b0100000: ALUop=4'b0001;
                                endcase
                            end
                            7'b0010011:begin
                                ALUop=0;
                            end
                        endcase
                        
                    end
                    3'b111: ALUop=4'b0010;
                    3'b110: ALUop=4'b0011;
                    3'b100: ALUop=4'b0100;
                    3'b001: ALUop=4'b0101;
                    3'b101:begin
                        case (fun7)
                            7'b0000000: ALUop=4'b0110;
                            7'b0100000: ALUop=4'b0111;
                        endcase
                    end
                    3'b010: ALUop=4'b1000;
                    3'b011: ALUop=4'b1001;
                endcase
            end
            7'b1100011: begin
                case (fun3)
                    3'b000: ALUop=4'b1010;
                    3'b001: ALUop=4'b1011;
                    3'b100: ALUop=4'b1100;
                    3'b110: ALUop=4'b1101;
                    3'b101: ALUop=4'b1110;
                    3'b111: ALUop=4'b1111;
                endcase
            end
            default: ALUop=0;
        endcase
    end
    
    //control NPCop
    always @(*) begin
        NPCop[0]=branch;
        case (opcode)
            7'b1100011: NPCop[2:1]=2'b11;
            7'b1101111: NPCop[2:1]=2'b01;
            7'b1100111: NPCop[2:1]=2'b10;
            default: NPCop[2:1]=0;
        endcase
    end

    //control WEn
    always @(*) begin
        case (opcode)
            7'b0100011: WEn=1;
            default: WEn=0;
        endcase
    end

    //control RFWr
    always @(*) begin
        case (opcode)
            7'b0100011,7'b1100011: RFWr=0;
            default: RFWr=1;
        endcase
    end

    //control ASel and BSel
    always @(*) begin
        case (opcode)
            7'b0010111: ASel=1;
            default: ASel=0; 
        endcase
        case (opcode)
            7'b0110011,7'b1100011: BSel=0;
            default: BSel=1;
        endcase
    end
    
    //control WDSel
    always @(*) begin
        case (opcode)
            7'b0000011: WDSel=2'b01;
            7'b1100111: WDSel=2'b10;
            7'b1101111: WDSel=2'b10;
            7'b0110111: WDSel=2'b11;
            default: WDSel=0;
        endcase
    end

    //control EXTop
    always @(*) begin
        case (opcode)
            7'b0100011: EXTop=3'b001;
            7'b1100011: EXTop=3'b010;
            7'b0110111,7'b0010111: EXTop=3'b011;
            7'b1101111: EXTop=3'b100;
            default: EXTop=0;
        endcase
    end
endmodule