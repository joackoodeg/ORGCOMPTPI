
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
        .clk(clk),
        .address(reset ? 5'b0 : pc[6:2]),
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


/*
module rv32i (
    input clk,
    input reset,
    input [31:0] instr,       // Instrucción desde la memoria de instrucciones
    input [31:0] readData,    // Datos leídos desde la memoria de datos
    output [31:0] pc,         // Contador de programa
    output [31:0] aluResult,  // Resultado de la ALU
    output [31:0] writeData,  // Datos a escribir en la memoria de datos
    output memWrite           // Señal de escritura de memoria
);

    // Señales internas
    wire [31:0] immExt;
    wire [31:0] srcA, srcB, writeDataReg;
    wire [2:0] aluControl;
    wire [1:0] immSrc;
    wire aluSrc, regWrite, pcSrc, branch, resSrc;

    // Instancia del dataPath
    dataPath dp (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .readData(readData),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite)
    );

    // Instancia de la Unidad de Control
    UC controlUnit (
        .op(instr[6:0]),
        .func3(instr[14:12]),
        .func7(instr[30]),
        .zero(aluResult == 0),
        .pcSrc(pcSrc),
        .branch(branch),
        .resSrc(resSrc),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .aluControl(aluControl),
        .immSrc(immSrc)
    );

endmodule
*/