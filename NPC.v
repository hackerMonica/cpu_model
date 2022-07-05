module NPC (
    input wire [31:0]pc,
    input wire [31:0]imm,
    input wire [31:0]ra,
    input wire [2:0]NPCop,
    output reg [31:0]pc4,
    output reg [31:0]npc
);
    always @(*) begin
        pc4=pc+4;
        case(NPCop[2:1])
            2'b00:  npc=pc+4;
            2'b01:  npc=imm+pc;
            2'b10:  npc=ra;
            2'b11:begin
                case(NPCop[0])
                    1'b0:   npc=pc+4;
                    1'b1:   npc=pc+imm;
                endcase
            end
        endcase
    end
endmodule