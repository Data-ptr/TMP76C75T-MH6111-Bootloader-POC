; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
                    .msfirst
;
;RAM
RAM_BBU_BOT         .equ    $0040       ;The bottom of "Battery Backup" RAM
RAM_VIO_BOT         .equ    $0057       ;The bottom of "violate" RAM
RAM_VIO_TOP         .equ    $01BF       ;The top of "violate" RAM
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
FDIVTEST            ldd     #$0001
                    fdiv    #$02       ;1/2
                    jsr     PCHAR      ;acc. A has remainder
                    tba                ;acc. B has result
                    jsr     PCHAR
                    tpa                ;dump condition codes to acc. A
                    jsr     PCHAR
                    .end
