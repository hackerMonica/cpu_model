module IObus (
    input wire rst,
    input wire clk,
    input wire we,
    input wire [15:2] adr,
    input wire wdata,

    input wire [31:0] switch,

    output reg [31:0] spo,

    output reg [31:0] led,
    output reg [31:0] ledNumber
);
    reg [31:0] memOutput;
    reg [15:0] adr_ext={adr,00};

    //read
    always @(*) begin
        case (adr_ext)
            16'hf000: spo=ledNumber; 
            16'hf060: spo=led;
            16'hf070: spo=switch;
            16'hf010,16'hf078: spo=0;
            default:  spo=memOutput;
        endcase
    end

    //write
    always @(posedge clk) begin
        if (rst) begin
            ledNumber=0;
            led=0;
            switch=0;
            memOutput=0;
            spo=0;
        end else if (we) begin
            case (adr_ext)
                16'hf000: begin
                    WEn=0;
                    ledNumber=wdata;
                end 
                16'hf060: begin
                    WEn=0;
                    led=wdata;
                end
                16'hf010,16'hf078,16'hf070: WEn=0;
                default: begin
                    WEn=1;
                end
            endcase
        end else begin
            WEn=0;
        end
    end

    reg WEn;    //control dram writing
    data_mem dmem(
        // .clk    (clk_g),
        .clk    (clk),
        .we    (WEn),
        .a      (adr),
        .d      (wdata),
        .spo    (memOutput)
    );
    
endmodule