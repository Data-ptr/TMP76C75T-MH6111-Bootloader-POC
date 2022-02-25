; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
                    .msfirst
;
;Data Registers
SCI_BAUD            .equ    $0010
;
;RAM
RAM_BBU_BOT         .equ    $0040       ;The bottom of "Battery Backup" RAM
RAM_VIO_BOT         .equ    $0057       ;The bottom of "violate" RAM
RAM_VIO_TOP         .equ    $01BF       ;The top of "violate" RAM
;
;Subroutines in ROM
PCHAR               .equ    $8021
RCHAR               .equ    $802C
PSTR                .equ    $8035
PDONE               .equ    $804F
CLRACC              .equ    $8056
;
;Internal ROM
INT_ROM             .equ    $D000
;
START               .equ    RAM_VIO_BOT
;
                    .org    START
                    ldaa    #$05
                    staa    SCI_BAUD
DUMP                ldx     #INT_ROM   ;X = start of internal rom
DUMP1               ldaa    0,x        ;get byte
                    jsr     PCHAR
                    inx
                    cpx     #$0000     ;Dumps 0xFFFF, then wraps, detect that
                    bne     DUMP1
                    jsr     PDONE
INFLOOP             bra     INFLOOP
                    rts
                    .end
