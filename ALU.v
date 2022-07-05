module ALU (
    input wire clk,
    input wire [3:0]ALUop,
    input wire [31:0]A,
    input wire [31:0]B,
    output reg branch,
    output reg [31:0]C
);
    reg signed  [31:0] sA;
    reg         [31:0] usA;
    reg signed  [31:0] sB;
    reg         [31:0] usB;
    reg         [32:0] temp;
    reg         [33:0] temp2;
    always @(*) begin
        sA=A;
        usA=A;
        sB=B;
        usB=B;
    end

    always @(*) begin
        case (ALUop)
            4'b0000:begin
                C=sA+sB;
            end
            4'b0001:begin
                C=sA+(~sB+1'b1);
            end
            4'b0010:begin
                C=sA&sB;
            end
            4'b0011:begin
                C=sA|sB;
            end
            4'b0100:begin
                C=sA^sB;
            end
            4'b0101:begin
                C=sA<<sB[4:0];
            end
            4'b0110:begin
                C=sA>>sB[4:0];
            end
            4'b0111:begin
                C=sA>>>sB[4:0];
            end
            4'b1000,4'b1001,4'b1010,4'b1011,4'b1100,4'b1101,4'b1110,4'b1111:begin
                case (ALUop[2:0])
                    3'b000:begin
                        temp=sA-sB;
                        case (temp[32])
                            0: C=0;
                            1: C=1;
                            default: C=0;
                        endcase
                    end 
                    3'b001:begin
                        temp2=usA-usB;
                        case (temp2[33])
                            0: C=0;
                            1: C=1;
                            default: C=0;
                        endcase
                    end 
                    3'b010:begin
                        if (A[31]==B[31]&&A[30]==B[30]&&
                            A[29]==B[29]&&A[28]==B[28]&&
                            A[27]==B[27]&&A[26]==B[26]&&
                            A[25]==B[25]&&A[24]==B[24]&&
                            A[23]==B[23]&&A[22]==B[22]&&
                            A[21]==B[21]&&A[20]==B[20]&&
                            A[19]==B[19]&&A[18]==B[18]&&
                            A[17]==B[17]&&A[16]==B[16]&&
                            A[15]==B[15]&&A[14]==B[14]&&
                            A[13]==B[13]&&A[12]==B[12]&&
                            A[11]==B[11]&&A[10]==B[10]&&
                            A[9]==B[9]&&A[8]==B[8]&&
                            A[7]==B[7]&&A[6]==B[6]&&
                            A[5]==B[5]&&A[4]==B[4]&&
                            A[3]==B[3]&&A[2]==B[2]&&
                            A[1]==B[1]&&A[0]==B[0]) begin
                            
                            branch=1;
                        end else begin
                            branch=0;
                        end
                    end 
                    3'b011:begin
                        if (A[31]==B[31]&&A[30]==B[30]&&
                            A[29]==B[29]&&A[28]==B[28]&&
                            A[27]==B[27]&&A[26]==B[26]&&
                            A[25]==B[25]&&A[24]==B[24]&&
                            A[23]==B[23]&&A[22]==B[22]&&
                            A[21]==B[21]&&A[20]==B[20]&&
                            A[19]==B[19]&&A[18]==B[18]&&
                            A[17]==B[17]&&A[16]==B[16]&&
                            A[15]==B[15]&&A[14]==B[14]&&
                            A[13]==B[13]&&A[12]==B[12]&&
                            A[11]==B[11]&&A[10]==B[10]&&
                            A[9]==B[9]&&A[8]==B[8]&&
                            A[7]==B[7]&&A[6]==B[6]&&
                            A[5]==B[5]&&A[4]==B[4]&&
                            A[3]==B[3]&&A[2]==B[2]&&
                            A[1]==B[1]&&A[0]==B[0]) begin
                            
                            branch=0;
                        end else begin
                            branch=1;
                        end
                    end 
                    3'b100:begin
                        temp=sA-sB;
                        case (temp[32])
                            0: branch=0;
                            1: branch=1;
                            default: branch=0;
                        endcase
                    end 
                    3'b101:begin
                        temp2=usA-usB;
                        case (temp2[33])
                            0: branch=0;
                            1: branch=1;
                            default: branch=0;
                        endcase
                    end 
                    3'b110:begin
                        temp=sA-sB;
                        case (temp[32])
                            0: branch=1;
                            1: branch=0;
                            default: branch=0;
                        endcase
                    end 
                    3'b111:begin
                        temp2=usA-usB;
                        case (temp2[33])
                            0: branch=1;
                            1: branch=0;
                            default: branch=0;
                        endcase
                    end 
                    default: begin
                        C=0;
                        branch=0;
                    end
                endcase
            end
            default: begin
                C=0;
                branch=0;
            end
        endcase
    end    
endmodule