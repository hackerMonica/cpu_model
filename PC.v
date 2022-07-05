module PC (
    input wire clk,
    input wire rst,
    input wire [31:0]npc,
    output wire [31:0]pc
);
    reg [31:0] pcReg=0;
    assign pc=pcReg;
    always @(posedge clk) begin
        if (rst) begin
            pcReg=0;
        end else begin
            pcReg=npc;
        end
        
    end
endmodule