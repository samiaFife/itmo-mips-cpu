`include "util.v"
// `include "d_flop.v"
// `include "memory.v"
// `include "register_file.v"
//`include "calculator.v"

module mips_cpu(clk, pc, pc_new, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
                register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2);
  // сигнал синхронизации
  input clk;
  // текущее значение регистра PC
  inout [31:0] pc;
  // новое значение регистра PC (адрес следующей команды)
  output [31:0] pc_new;
  // we для памяти данных
  output data_memory_we;
  // адреса памяти и данные для записи памяти данных
  output [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
  // данные, полученные в результате чтения из памяти
  inout [31:0] instruction_memory_rd, data_memory_rd;
  // we3 для регистрового файла
  output register_we3;
  // номера регистров
  output [4:0] register_a1, register_a2, register_a3;
  // данные для записи в регистровый файл
  output [31:0] register_wd3;
  // данные, полученные в результате чтения из регистрового файла
  inout [31:0] register_rd1, register_rd2;

  wire [31:0] instr;
  assign instruction_memory_a=pc;
  //instruction_memory instr_mem(instruction_memory_a, instruction_memory_rd);
  assign instr=instruction_memory_rd;

  wire [15:0] imm;
  wire [25:0] jim;
  wire [31:0] signimm;
  assign imm=instr[15:0];
  assign jim=instr[25:0];
  sign_extend sextend(imm, signimm);

  wire [5:0] funct, opcode;
  assign funct = instr[5:0];
  assign opcode = instr[31:26];
  wire memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, jumpr;
  wire [2:0] alucontrol; 

  control_unit c_unit(opcode, funct, memtoreg, memwrite, branch, alusrc, regdst, regwrite, alucontrol, jump,jumpr);
  
  assign data_memory_we = memwrite;
  assign register_we3 = regwrite;
  
  assign register_a1 = instr[25:21];
  assign register_a2 = instr[20:16];
  
  wire [31:0] srca, srcb;
  assign srca=register_rd1;
  mux2_32 mx2_32(register_rd2, signimm, alusrc, srcb);
  
  wire [31:0] aluresult;
  wire z0;
  alu a_l_u(srca, srcb, alucontrol, z0, aluresult);
  wire isb;
  isbne ibne(opcode,isb);
  wire nan;
  xor_gate nang1(isb,z0,nan);
  assign zero=nan;
  
  assign data_memory_wd = register_rd2;
  //mux2_5 mux_2_5_2(aluresult,jim,)
  assign data_memory_a = aluresult;
  //data_memory data_mem(aluresult, memwrite, clk, data_memory_rd);

  wire [31:0] pcplus4;
  adder add(pc,{29'b0,3'b100},pcplus4);

  wire [31:0] actionresult,jumpresult;
  mux2_32 mx2_32_2(aluresult, data_memory_rd, memtoreg, actionresult);
  mux2_32 mx2_32_5(actionresult, pcplus4,jump,register_wd3);

  wire [4:0] a3_1, a3_2;
  assign a3_1=instr[20:16];
  assign a3_2=instr[15:11];
  wire [4:0] writereg, ra;
  assign ra=5'b11111;
  mux2_5 mx_2_5(a3_1,a3_2,regdst,writereg);
  mux2_5 mx_2_5_1(writereg,ra,jump,register_a3);

  wire [31:0] shl;
  shl_2 sdvig(signimm, shl);

  wire [31:0] pcbranch;
  adder add2(shl,pcplus4,pcbranch);

  wire pcsrc;
  and_gate a1(branch,zero,pcsrc);
  wire [31:0] pc_new_0;
  mux2_32 mx2_32_3(pcplus4,pcbranch,pcsrc,pc_new_0);
  mux2_32 mx2_32_4(pc_new_0,{4'b0000,jim,2'b00},jump,jumpresult);
  mux2_32 mx2_32_6(jumpresult,register_rd1,jumpr,pc_new);

  //d_flop pc_reg(pc_new, clk, pc);
endmodule

module control_unit(opcode, funct, memtoreg, memwrite, branch, alusrc, regdst, regwrite, alucontrol, jump,jumpr);
  input [5:0] opcode;
  input [5:0] funct;
  output memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump,jumpr;
  output [2:0] alucontrol;
  wire [1:0] aluop;
  reg rw, rd, asrc, br, memw, memtr, j,jr;
  reg [1:0] aop = 0;
  reg [2:0] actrl;
  always @(opcode or funct)
  begin
    case(opcode)
    6'b000000: //R
    begin
      if(funct==6'b001000) begin
        rw=1'b0;
        //rd=1'bX;
        asrc=1'b0;
        br=1'b1;
        memw=1'b0;
        //memtr=1'bX;
        aop=2'b01;
        j=1'b1;  
        jr=1'b1;
      end
      else begin
        rw=1'b1;
        rd=1'b1;
        asrc=1'b0;
        br=1'b0;
        memw=1'b0;
        memtr=1'b0;
        aop=2'b10;
        j=1'b0;
        jr=1'b0;
      end
    end
    6'b100011: //lw
    begin
      rw=1'b1;
      rd=1'b0;
      asrc=1'b1;
      br=1'b0;
      memw=1'b0;
      memtr=1'b1;
      aop=2'b00;
      j=1'b0;
      jr=1'b0;
    end
    6'b101011: //sw
    begin
      rw=1'b0;
      //rd=1'bX;
      asrc=1'b1;
      br=1'b0;
      memw=1'b1;
      //memtr=1'bX;
      aop=2'b00;
      j=1'b0;
      jr=1'b0;
    end
    6'b000100: //beq
    begin
      rw=1'b0;
      //rd=1'bX;
      asrc=1'b0;
      br=1'b1;
      memw=1'b0;
      //memtr<=1'bX;
      aop=2'b01;
      j=1'b0;
      jr=1'b0;
    end
    6'b001000: //addi
    begin
      rw=1'b1; //надо ли записать значение в a3
      rd=1'b0; //в какой a3 писать
      asrc=1'b1; //подставлять в алу константу или регистр
      br=1'b0; //штука для следующей инструкции
      memw=1'b0; //надо ли записать в память
      memtr=1'b0; //надо записать в регистр из памяти или из алу
      aop=2'b00; //для алу декодера
      j=1'b0;
      jr=1'b0;
    end
    6'b001100: //andi 
    begin
      rw=1'b1;
      rd=1'b0;
      asrc=1'b1;
      br=1'b0;
      memw=1'b0;
      memtr=1'b0;
      aop=2'b10;
      j=1'b0;
      jr=1'b0;
    end
    6'b000101: //bne
    begin
      rw=1'b0;
      //rd=1'bX;
      asrc=1'b0;
      br=1'b1;
      memw=1'b0;
      //memtr=1'bX;
      aop=2'b01;
      j=1'b0;
      jr=1'b0;
    end
    6'b000010: //j
    begin
      rw=1'b0;
      //rd=1'bX;
      asrc=1'b0;
      br=1'b1;
      memw=1'b0;
      //memtr=1'bX;
      aop=2'b01;
      j=1'b1;
      jr=1'b0;
    end
    6'b000011: //jal
    begin
      rw=1'b1;
      rd=1'b0;
      asrc=1'b0;
      br=1'b1;
      memw=1'b0;
      memtr=1'b0;
      aop=2'b01;
      j=1'b1;
      jr=1'b0;
    end
    endcase
    case (aluop) 
           2'b00 : actrl = 3'b010;
           2'b01 : actrl = 3'b110;
           2'b10 : begin
               case (funct)
                    6'b100000 : actrl = 3'b010;
                    6'b100010 : actrl = 3'b110;
                    6'b100100 : actrl = 3'b000;
                    6'b100101 : actrl = 3'b001;
                    6'b111001 : actrl = 3'b000;
                    6'b101010 : actrl = 3'b111;
               endcase
           end
  endcase
  end
  assign regwrite = rw;
  assign regdst = rd;
  assign memtoreg = memtr;
  assign memwrite = memw;
  assign alusrc = asrc;
  assign branch = br;
  assign aluop = aop;
  assign jump=j;
  assign jumpr=jr;
  assign alucontrol = actrl;
endmodule