module top (
    input wire clk,
    input wire rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);
    wire rst1=rst_n;
    reg rst2;
    wire rst=rst1&&~rst2;
    always @(posedge clk) begin
        rst2<=rst_n;
    end
    assign debug_wb_have_inst=1;
    assign debug_wb_pc=pc;
    assign debug_wb_ena=RFWr;
    assign debug_wb_reg=inst[11:7];
    assign debug_wb_value=wD;
    //cpuclk
    wire clk_g;
    //PC
    wire [31:0] pc;
    //NPC
    wire [31:0] npc;
    wire [31:0] pc4;
    //IROM
    wire [31:0] inst;
    //SEXT
    wire [31:0] ext;
    //CTRL
    wire [2:0] NPCop;
    wire WEn;
    wire [3:0] ALUop;
    wire ASel;
    wire BSel;
    wire [2:0] EXTop;
    wire RFWr;
    wire [1:0] WDSel;
    //RF
    wire [31:0] rD1;
    wire [31:0] rD2;
    
    wire [31:0] wD;
    //ALU
    wire [31:0] C;

    wire [31:0] A;
    wire [31:0] B;
    wire branch;
    //DRAM
    wire [31:0] rd;

    wire [31:0] wdin;
    //MUX
    assign wD= (WDSel==0? C:(
        (WDSel==2'b01)? rd :(
            (WDSel==2'b10)? pc4 : ext
        )
    ));
    assign A=(ASel)? pc : rD1;
    assign B=(BSel)? ext : rD2;
    assign wdin=rD2;

    PC u_PC(
        .clk    (clk_g),
        // .clk    (clk),
        .rst    (rst),
        .npc    (npc),
        .pc     (pc)
    );

    cpuclk u_cpuclk(
        .clk_in1    (clk),
        .clk_out1   (clk_g),
        .locked ()
    );

    NPC u_NPC(
        .NPCop  (NPCop),
        .ra     (C),
        .imm    (ext),
        .pc     (pc),
        .npc    (npc),
        .pc4    (pc4)
    );

    SEXT u_SEXT(
        .EXTop  (EXTop),
        .din    (inst[31:7]),
        .ext    (ext)
    );

    prgrom u_prgrom(
        .a      (pc[15:2]),
        .spo    (inst)
    );
    // inst_mem imem(
    //     .a      (pc[15:2]),
    //     .spo    (inst)
    // );

    RF u_RF(
        .clk    (clk_g),
        // .clk    (clk),
        .rst    (rst),
        .RFWr   (RFWr),
        .rR1    (inst[19:15]),
        .rR2    (inst[24:20]),
        .wR     (inst[11:7]),
        .wD     (wD),
        .rD1    (rD1),
        .rD2    (rD2)
    );

    CTRL u_CTRL(
        .opcode     (inst[6:0]),
        .fun3       (inst[14:12]),
        .fun7       (inst[31:25]),
        .branch     (branch),
        .NPCop      (NPCop),
        .WEn        (WEn),
        .ALUop      (ALUop),
        .ASel       (ASel),
        .BSel       (BSel),
        .EXTop      (EXTop),
        .RFWr       (RFWr),
        .WDSel      (WDSel)
    );

    ALU u_ALU(
    .clk        (clk_g),
    // .clk    (clk),
    .ALUop      (ALUop),
    .A          (A),
    .B          (B),
    .branch     (branch),
    .C          (C)
    );

    dram u_dram(
        .clk    (clk_g),
        .we    (WEn),
        .a      (C[15:2]),
        .d      (wdin),
        .spo    (rd)
    );
    // data_mem dmem(
    //     .clk    (clk),
    //     .we    (WEn),
    //     .a      (C[15:2]),
    //     .d      (wdin),
    //     .spo    (rd)
    // );

endmodule