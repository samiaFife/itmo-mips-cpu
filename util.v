// модуль, который реализует расширенение
// 16-битной знаковой константы до 32-битной
module sign_extend(in, out);
  input [15:0] in;
  output [31:0] out;

  assign out = {{16{in[15]}}, in};
endmodule

module sign_extend_26(in, out);
  input [25:0] in;
  output [31:0] out;

  assign out = {{6{in[25]}},in};
endmodule

// модуль, который реализует побитовый сдвиг числа
// влево на 2 бита
module shl_2(in, out);
  input [31:0] in;
  output [31:0] out;

  assign out = {in[29:0], 2'b00};
endmodule

// 32 битный сумматор
module adder(a, b, out);
  input [31:0] a, b;
  output [31:0] out;

  assign out = a + b;
endmodule

// 32-битный мультиплексор
module mux2_32(d0, d1, a, out);
  input [31:0] d0, d1;
  input a;
  output [31:0] out;
  assign out = a ? d1 : d0;
endmodule

// 5 - битный мультиплексор
module mux2_5(d0, d1, a, out);
  input [4:0] d0, d1;
  input a;
  output [4:0] out;
  assign out = a ? d1 : d0;
endmodule


module xnor_gate(x,y,c);
  input wire x,y;
  output wire c;
  wire nx,ny,a1,a2;
  not_gate ng1(x,nx);
  not_gate ng2(y,ny);
  and_gate ag1(x,y,a1);
  and_gate ag2(nx,ny,a2);
  or_gate og1(a1,a2,c);
endmodule


module xor_gate(a,b,c);
input a,b;
output c;
nand_gate nag1(a,b,nab);
or_gate og1(a,b,oab);
and_gate ag1(nab,oab,c);
endmodule

module isbne(opcode, ans);
  input [5:0] opcode;
  output ans;
  reg a;
  always @(opcode) begin
    a=0;
    case(opcode)
    6'b000101:
    begin
      a=1;
    end
    endcase
  end
  assign ans=a;
endmodule

module alu(a,b,op,zero,res);
  input [31:0] a,b;
  input [2:0] op;
  output zero;
  output [31:0] res;

  reg [31:0] r;
  reg z, less;
  wire sl;

  slt_gate slt(a,b,sl);

  always @(a or b or op)
  begin
    #1;
    less=sl;
    case(op)
      3'b010: r=a+b;
      3'b110: r=a-b;
      3'b000: r=a&b;
      3'b001: r=a|b;
      3'b111: begin
        r={31'b0000000000000000000000000000000,less};  
      end
    endcase
    if(r==0)
    begin
      z=1;
    end
    else
    begin
      z=0;
    end
    //$display("res is %b, zero is %d",r,z);
  end

  assign res=r;
  assign zero=z;
endmodule

module slt_gate(a,b,ans);
  input [31:0] a,b;
  output ans;
  
  wire [31:0] invb, nb;
  wire s1,c1,s2,c2,s3,c3,s4,c4,x1,x2,x3;
  wire s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,
  s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,s31,s32;
  wire c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,
  c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32;
  invert inv(b,invb);
  full_adder_1_bit fa1(a[0],invb[0],1'b1,s1,c1);
  full_adder_1_bit fa2(a[1],invb[1],c1,s2,c2);
  full_adder_1_bit fa3(a[2],invb[2],c2,s3,c3);
  full_adder_1_bit fa4(a[3],invb[3],c3,s4,c4);
  full_adder_1_bit fa5(a[4],invb[4],c4,s5,c5);
  full_adder_1_bit fa6(a[5],invb[5],c5,s6,c6);
  full_adder_1_bit fa7(a[6],invb[6],c6,s7,c7);
  full_adder_1_bit fa8(a[7],invb[7],c7,s8,c8);
  full_adder_1_bit fa9(a[8],invb[8],c8,s9,c9);
  full_adder_1_bit fa10(a[9],invb[9],c9,s10,c10);
  full_adder_1_bit fa11(a[10],invb[10],c10,s11,c11);
  full_adder_1_bit fa12(a[11],invb[11],c11,s12,c12);
  full_adder_1_bit fa13(a[12],invb[12],c12,s13,c13);
  full_adder_1_bit fa14(a[13],invb[13],c13,s14,c14);
  full_adder_1_bit fa15(a[14],invb[14],c14,s15,c15);
  full_adder_1_bit fa16(a[15],invb[15],c15,s16,c16);
  full_adder_1_bit fa17(a[16],invb[16],c16,s17,c17);
  full_adder_1_bit fa18(a[17],invb[17],c17,s18,c18);
  full_adder_1_bit fa19(a[18],invb[18],c18,s19,c19);
  full_adder_1_bit fa20(a[19],invb[19],c19,s20,c20);
  full_adder_1_bit fa21(a[20],invb[20],c20,s21,c21);
  full_adder_1_bit fa22(a[21],invb[21],c21,s22,c22);
  full_adder_1_bit fa23(a[22],invb[22],c22,s23,c23);
  full_adder_1_bit fa24(a[23],invb[23],c23,s24,c24);
  full_adder_1_bit fa25(a[24],invb[24],c24,s25,c25);
  full_adder_1_bit fa26(a[25],invb[25],c25,s26,c26);
  full_adder_1_bit fa27(a[26],invb[26],c26,s27,c27);
  full_adder_1_bit fa28(a[27],invb[27],c27,s28,c28);
  full_adder_1_bit fa29(a[28],invb[28],c28,s29,c29);
  full_adder_1_bit fa30(a[29],invb[29],c29,s30,c30);
  full_adder_1_bit fa31(a[30],invb[30],c30,s31,c31);
  full_adder_1_bit fa32(a[31],invb[31],c31,s32,c32);
  
  xor_gate xg1(a[31],b[31],x1);
  xor_gate xg2(c32,x1,x2);
  not_gate ng(x2,ans);

endmodule

module invert(a,na);
  input [31:0] a;
  output [31:0] na;
  reg [31:0] nan;
  reg i;
  not_gate ng1(a[0],na[0]);
  not_gate ng2(a[1],na[1]);
  not_gate ng3(a[2],na[2]);
  not_gate ng4(a[3],na[3]);
  not_gate ng5(a[4],na[4]);
  not_gate ng6(a[5],na[5]);
  not_gate ng7(a[6],na[6]);
  not_gate ng8(a[7],na[7]);
  not_gate ng9(a[8],na[8]);
  not_gate ng10(a[9],na[9]);
  not_gate ng11(a[10],na[10]);
  not_gate ng12(a[11],na[11]);
  not_gate ng13(a[12],na[12]);
  not_gate ng14(a[13],na[13]);
  not_gate ng15(a[14],na[14]);
  not_gate ng16(a[15],na[15]);
  not_gate ng17(a[16],na[16]);
  not_gate ng18(a[17],na[17]);
  not_gate ng19(a[18],na[18]);
  not_gate ng20(a[19],na[19]);
  not_gate ng21(a[20],na[20]);
  not_gate ng22(a[21],na[21]);
  not_gate ng23(a[22],na[22]);
  not_gate ng24(a[23],na[23]);
  not_gate ng25(a[24],na[24]);
  not_gate ng26(a[25],na[25]);
  not_gate ng27(a[26],na[26]);
  not_gate ng28(a[27],na[27]);
  not_gate ng29(a[28],na[28]);
  not_gate ng30(a[29],na[29]);
  not_gate ng31(a[30],na[30]);
  not_gate ng32(a[31],na[31]);
endmodule

module full_adder_1_bit(a,b,cin,sum,cout);
  input a,b,cin;
  output sum,cout;

  wire xn1,a1,a2,a3,o1;
  xnor_gate xng1(a,b,xn1);
  xnor_gate xng2(xn1,cin,sum);
  and_gate ag1(a,b,a1);
  and_gate ag2(a,cin,a2);
  and_gate ag3(cin,b,a3);
  or_gate og1(a1,a2,o1);
  or_gate og2(o1,a3,cout);
endmodule

module and_gate(x,y,c);
  input wire x,y;
  output wire c;
  wire w;
  nand_gate nag1(x,y,w);
  not_gate ng1(w,c);
endmodule

module not_gate(x,y);
  input wire x;
  output wire y;
  supply0 gnd;
  supply1 vdd;
  nmos nm(y,gnd,x);
  pmos pm(y,vdd,x);
endmodule

module nand_gate(x,y,c);
  input wire x, y;
  output wire c;
  supply0 gnd;
  supply1 pwr;
  wire n1;
  pmos pm1(c,pwr,x);
  pmos pm2(c,pwr,y);
  nmos nm1(n1,gnd,x);
  nmos nm2(c,n1,y);
endmodule


module or_gate(x,y,c);
  input wire x,y;
  output wire c;
  wire w;
  nor_gate nog1(x,y,w);
  not_gate ng1(w,c);
endmodule

module nor_gate(x,y,c);
  input wire x, y;
  output wire c;
  supply0 gnd;
  supply1 pwr;
  wire p1;
  pmos pm1(p1,pwr,x);
  pmos pm2(c,p1,y);
  nmos nm1(c,gnd,x);
  nmos nm2(c,gnd,y);
endmodule
