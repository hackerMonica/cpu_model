module IObus (
    input wire rst,
    input wire clk,
    input wire we,
    input wire [15:2] adr,
    input wire [31:0] wdata,

    input wire [23:0] switch,

    output reg [31:0] spo,

    output reg [23:0] led,
    output reg [31:0] digit
);
    wire [31:0] memOutput;
    reg [15:0] adr_ext;

    always @(*) begin
        adr_ext[15:2]=adr;
        adr_ext[1:0]=0;
        
    end

    //read
    always @(*) begin
        case (adr_ext)
            16'hf000: spo=digit; 
            16'hf060: spo=led;
            16'hf070: spo=switch;
            16'hf010,16'hf078: spo=0;
            default:  spo=memOutput;
        endcase
    end

    //write
    always @(posedge clk) begin
        if (rst) begin
            digit=0;
            led=0;
        end else if (we) begin
            case (adr_ext)
                16'hf000: begin
                    digit=wdata;
                end 
                16'hf060: begin
                    led=wdata;
                end
            endcase
        end
    end

    //control WEn
    always @(*) begin
        if (we) begin
            case (adr_ext)
                16'hf000: begin
                    WEn=0;
                end 
                16'hf060: begin
                    WEn=0;
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

    wire [31:0] waddr_tmp = adr - 16'h4000;
    reg WEn;    //control dram writing
    dram u_dram(
        .clk    (clk),
        .we    (WEn),
        .a      (waddr_tmp[15:2]),
        .d      (wdata),
        .spo    (memOutput)
    );
    
endmodule