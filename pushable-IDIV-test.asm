; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
;0001/0002 = 0x00, r=0x01, CC=0xD0
;0002/0001 = 0x00, r=0x02, CC=0xD0
;0001/0000 = 0x00, r=0x01, CC=0xD0
;0000/0001 = 0x00, r=0x00, CC=0xD4
;0001/FFFF = 0x00, r=0x01, CC=0xD0
;FFFF/0001 = 0xFF, r=0xFF, CC=0xD0
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
                    jmp     IDOVTEST
PDIV_RESULT         jsr     PCHAR         ;acc. A has remainder
                    tba                   ;acc. B has result
                    jsr     PCHAR
                    rts
                    ;
IDOVTEST            ldd     #$0002
                    std     RAM_BBU_BOT
                    ldd     #$0001
                    idiv    #RAM_BBU_BOT  ;1/2 = 0x00, r=0x01, CC=0xD0
                    jsr     PDIV_RESULT
                    ldd     #$0001
                    idiv    #RAM_BBU_BOT
                    tpa                   ;dump condition codes to acc. A
                    jsr     PCHAR
                    ;
                    ;0x01()
                    ;0x00( )
                    ;0xd0(⸮)
                    ;
                    ldd     #$0001
                    std     RAM_BBU_BOT
                    ldd     #$0002
                    idiv    #RAM_BBU_BOT  ;2/1 = 0x00, r=0x02, CC=0xD0
                    jsr     PDIV_RESULT
                    ldd     #$0002
                    idiv    #RAM_BBU_BOT
                    tpa                   ;dump condition codes to acc. A
                    jsr     PCHAR
                    ;
                    ;0x02()
                    ;0x00( )
                    ;0xd0(⸮)
                    ;
                    ldd     #$0000
                    std     RAM_BBU_BOT
                    ldd     #$0001
                    idiv    #RAM_BBU_BOT  ;1/0 = 0x00, r=0x01, CC=0xD0
                    jsr     PDIV_RESULT
                    ldd     #$0001
                    idiv    #RAM_BBU_BOT
                    tpa                   ;dump condition codes to acc. A
                    jsr     PCHAR
                    ;
                    ;0x01()
                    ;0x00( )
                    ;0xd0(⸮)
                    ;
                    ldd     #$0001
                    std     RAM_BBU_BOT
                    ldd     #$0000
                    idiv    #RAM_BBU_BOT  ;0/1 = 0x00, r=0x00, CC=0xD4
                    jsr     PDIV_RESULT
                    ldd     #$0000
                    idiv    #RAM_BBU_BOT
                    tpa                   ;dump condition codes to acc. A
                    jsr     PCHAR
                    ;
                    ;0x00( )
                    ;0x00( )
                    ;0xd4(⸮)
                    ;
                    ldd     #$FFFF
                    std     RAM_BBU_BOT
                    ldd     #$0001
                    idiv    #RAM_BBU_BOT  ;1/FF = 0x00, r=0x01, CC=0xD0
                    jsr     PDIV_RESULT
                    ldd     #$0001
                    idiv    #RAM_BBU_BOT
                    tpa                   ;dump condition codes to acc. A
                    jsr     PCHAR
                    ;
                    ;0x01()
                    ;0x00( )
                    ;0xd0(⸮)
                    ;
                    ldd     #$0001
                    std     RAM_BBU_BOT
                    ldd     #$FFFF
                    idiv    #RAM_BBU_BOT  ;FF/1 = 0xFF, r=0xFF, CC=0xD0
                    jsr     PDIV_RESULT
                    ldd     #$00FF
                    idiv    #RAM_BBU_BOT
                    tpa                   ;dump condition codes to acc. A
                    jsr     PCHAR
                    ;
                    ;0xff(⸮)
                    ;0xff(⸮)
                    ;0xd0(⸮)
                    ;
                    rts
                    .end
