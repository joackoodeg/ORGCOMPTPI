
module rv32i (
    input clk,
    input reset,
    output [31:0] pc,         
    output [31:0] aluResult,  
    output [31:0] writeData,  
    output memWrite,           
    
    output [31:0] reg_x5,
    output [31:0] reg_x6,
    output [31:0] reg_x7,
    output [31:0] reg_x8,
    output [31:0] reg_x9,
    output [31:0] reg_x18

);

    // Señales internas
    wire [31:0] instr;
    wire [31:0] readData;

    // ROM 
    rom instructionMemory (
        .reset(reset),
        .address(pc[6:2]),
        .data(instr)
    );

    // Data memory 
    DM dataMemory (
        .clk(clk),
        .addressDM(aluResult[6:2]),  // Usamos los bits [6:2] del resultado de la ALU como dirección
        .wd(writeData),
        .we(memWrite),
        .rd(readData)
    );

    // Datapath 
    dataPath dp (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .readData(readData),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite),

        .reg_x5(reg_x5),
        .reg_x6(reg_x6),
        .reg_x7(reg_x7),
        .reg_x8(reg_x8),
        .reg_x9(reg_x9),
        .reg_x18(reg_x18)    
    );


endmodule
