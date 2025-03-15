#include <stdio.h>
#include <stdint.h>

#define BITS_OPENCODE   7
#define BITS_RD         5
#define BITS_FUNCT3     3
#define BITS_RS1        5
#define BITS_RS2        5
#define BITS_FUNCT7     7

#define INS_FMT_TYPE_R  0
#define INS_FMT_TYPE_I  1
#define INS_FMT_TYPE_S  2
#define INS_FMT_TYPE_B  3
#define INS_FMT_TYPE_U  4
#define INS_FMT_TYPE_J  5


#define SLICE_LEN(msb, lsb) ((msb) - (lsb) + 1)

struct Instruction {

    char *mnemonic;

    int8_t fmt;

    uint32_t opcode;
    uint32_t funct3;
    uint32_t funct7;
    uint32_t rd;
    uint32_t rs1;
    uint32_t rs2;
    uint32_t imm;

};



uint32_t mask(uint32_t m_bits) {
    uint32_t mask = 0;
    for (uint32_t i = 0; i < m_bits; i++) {
        mask |= (1 << i);
    }

    return mask;
}

uint32_t slice(
    uint32_t val,
    uint32_t msb,
    uint32_t lsb
) {
    val >>= lsb;
    val &= mask(msb - lsb + 1);

    return val;
}

uint32_t mask_and_lhs(
    uint32_t val,
    uint32_t m_bits,
    uint32_t sht_bits
) {
    if (m_bits == 0) {
        return 0;
    }
    
    val &= mask(m_bits);
    val <<= sht_bits;

    return val;
}

uint32_t encode_r_type(
    uint32_t opcode,
    uint32_t rd,
    uint32_t funct3,
    uint32_t rs1,
    uint32_t rs2,
    uint32_t funct7
) {
    uint32_t ins = 0;

    ins |= mask_and_lhs(opcode, BITS_OPENCODE, 0);
    ins |= mask_and_lhs(rd, BITS_RD, 7);
    ins |= mask_and_lhs(funct3, BITS_FUNCT3, 12);
    ins |= mask_and_lhs(rs1, BITS_RS1, 15);
    ins |= mask_and_lhs(rs2, BITS_RS2, 20);
    ins |= mask_and_lhs(funct7, BITS_FUNCT7, 25);

    return ins;
}

uint32_t encode_i_type(
    uint32_t opcode,
    uint32_t rd,
    uint32_t funct3,
    uint32_t rs1,
    uint32_t imm
) {
    uint32_t ins = 0;

    ins |= mask_and_lhs(opcode, BITS_OPENCODE, 0);
    ins |= mask_and_lhs(rd, BITS_RD, 7);
    ins |= mask_and_lhs(funct3, BITS_FUNCT3, 12);
    ins |= mask_and_lhs(rs1, BITS_RS1, 15);
    ins |= mask_and_lhs(imm, 12, 20);

    return ins;
}

uint32_t encode_s_type(
    uint32_t opcode,
    uint32_t funct3,
    uint32_t rs1,
    uint32_t rs2,
    uint32_t imm
) {
    uint32_t ins = 0;

    ins |= mask_and_lhs(opcode, BITS_OPENCODE, 0);
    ins |= mask_and_lhs(funct3, BITS_FUNCT3, 12);
    ins |= mask_and_lhs(rs1, BITS_RS1, 15);
    ins |= mask_and_lhs(rs2, BITS_RS2, 20);

    ins |= mask_and_lhs(
        slice(imm, 4, 0),
        SLICE_LEN(4, 0),
        7
    );

    ins |= mask_and_lhs(
        slice(imm, 11, 5),
        SLICE_LEN(11, 5),
        25
    );

    return ins;
}

uint32_t encode_b_type(
    uint32_t opcode,
    uint32_t funct3,
    uint32_t rs1,
    uint32_t rs2,
    uint32_t imm
) {
    uint32_t ins = 0;
    
    ins |= mask_and_lhs(opcode, BITS_OPENCODE, 0);
    ins |= mask_and_lhs(funct3, BITS_FUNCT3, 12);
    ins |= mask_and_lhs(rs1, BITS_RS1, 15);
    ins |= mask_and_lhs(rs2, BITS_RS2, 20);

    imm <<= 1;
    ins |= mask_and_lhs(
        slice(imm, 11, 11),
        SLICE_LEN(11, 11),
        7
    );
    ins |= mask_and_lhs(
        slice(imm, 4, 1),
        SLICE_LEN(4, 1),
        8
    );
    ins |= mask_and_lhs(
        slice(imm, 10, 5),
        SLICE_LEN(10, 5),
        25
    );
    ins |= mask_and_lhs(
        slice(imm, 12, 12),
        SLICE_LEN(12, 12),
        31
    );

    return ins;
}

uint32_t encode_u_type(
    uint32_t opcode,
    uint32_t rd,
    uint32_t imm
) {
    uint32_t ins = 0;

    ins |= mask_and_lhs(opcode, BITS_OPENCODE, 0);
    ins |= mask_and_lhs(rd, BITS_RD, 7);

    ins |= mask_and_lhs(
        slice(imm, 19, 0),
        SLICE_LEN(19, 0),
        12
    );

    return ins;
}

uint32_t encode_j_type(
    uint32_t opcode,
    uint32_t rd,
    uint32_t imm
) {
    uint32_t ins = 0;

    ins |= mask_and_lhs(opcode, BITS_OPENCODE, 0);
    ins |= mask_and_lhs(rd, BITS_RD, 7);

    imm <<= 1;
    ins |= mask_and_lhs(
        slice(imm, 19, 12),
        SLICE_LEN(19, 12),
        12
    );
    ins |= mask_and_lhs(
        slice(imm, 11, 11),
        SLICE_LEN(11, 11),
        20
    );
    ins |= mask_and_lhs(
        slice(imm, 10, 1),
        SLICE_LEN(10, 1),
        21
    );
    ins |= mask_and_lhs(
        slice(imm, 20, 20),
        SLICE_LEN(20, 20),
        31
    );
    
    return ins;
}

int main(int argc, char *argv[]) {

    uint32_t ins = encode_j_type(
        0b1101111,
        0b00001,
        0b10101010101010101010
    );

    printf("ins = %x\n", ins);

    return 0;
}
