; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
;Current theory 0x13 is 3-bytes STR offset,X,immediate (indexed by X)
;
                    .msfirst
;
;RAM
RAM_BBU_BOT         .equ    $0040       ;The bottom of "Battery Backup" RAM
RAM_BBU_TOP         .equ    $0056       ;The top of "Battery Backup" RAM
RAM_VIO_BOT         .equ    $0057       ;The bottom of "violate" RAM
RAM_VIO_TOP         .equ    $01BF       ;The top of "violate" RAM
;

;
;Subroutines in ROM
PCHAR               .equ    $8054
RCHAR               .equ    $805F
PSTR                .equ    $8068
CLRACC              .equ    $8089
;
START               .equ    RAM_VIO_BOT
;
                    .org    START
                    ldx     #RAM_BBU_BOT
CLR_RAM             staa    $00,x
                    inx
                    cpx     #RAM_BBU_TOP
                    bls     CLR_RAM
                    ldaa    #$01         ;marker
                    jsr     PCHAR
INST_TEST           ldd     #$0000
                    ldy     #$0000       ;Using Y as a loop counter
                    ldx     #RAM_BBU_BOT
CLR_N_TEST          iny
                    .byte   $13, $00, $55
                    tpa
                    jsr     PCHAR
                    inx
                    ;inx
                    cmpy    #$0016       ;Finish after three loops
                    bcs     CLR_N_TEST
                    ldaa    #$01         ;marker
                    jsr     PCHAR
                    ldx     #RAM_BBU_BOT
DUMP_MEM            ldaa    $00,x
                    jsr     PCHAR
                    inx
                    cpx     #RAM_BBU_TOP
                    bls     DUMP_MEM
                    rts
                    .end
