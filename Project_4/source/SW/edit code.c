//RISCVInstrInfo.td
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  class ALU_imad<bits<5> rs3, bits<2> funct2,  bits<3> funct3, string opcodestr>
    : RVInstR4<funct2, funct3, OPC_OP, (outs GPR:$rd),
                (ins GPR: $rs1, GPR: $rs2, GPR: $rs3),
                opcodestr, "$rd, $rs1, $rs2, $rs3">;

}
def IMAD : ALU_imad<0b01100, 0b10, 0b000, "imad">,
           Sched<[WriteIALU, ReadIALU, ReadIALU, ReadIALU]>;


def : Pat<(add (mul GPR:$rs1, GPR:$rs2), GPR:$rs3),
          (IMAD $rs1, $rs2, $rs3)>;


//riscv-opc.h 
#define MATCH_IMAD 0x04000033  // opcode = 0x33, funct2 = 10, funct3 = 0b000
#define MASK_IMAD  0x600707f  // opcode + funct7 + funct3, 상위 2비트 포함


//riscv-dis.c
	case 'r':
		print (info->stream, "%s", riscv_gpr_names[EXTRACT_OPERAND (RS3, l)]);
		break;



//riscv-opc.c
{"imad",       0, INSN_CLASS_R, "d,s,t,r",     MATCH_IMAD, MASK_IMAD, match_opcode, 0}, //2020171049