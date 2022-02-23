; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
;Current theory 0x42 is 1-byte something acc. A?
;
; Serial Results:
; 0xD4 1101 0100
; 0xD2 1101 0010
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
                    ;
CLR_RAM             ldx     #RAM_BBU_BOT
                    ldaa    #$00
CLR_RAM_LOOP        staa    $00,x
                    inx
                    cpx     #RAM_BBU_TOP
                    bls     CLR_RAM_LOOP
                    ;
                    ldaa    #$01         ;marker
                    jsr     PCHAR
                    ;
INST_TEST           ldaa    #$40
                    .byte   $42
                    ;
                    ldaa    #$01         ;marker
                    jsr     PCHAR
                    ;
DUMP_MEM            ldx     #RAM_BBU_BOT
DUMP_MEM_LOOP       ldaa    $00,x
                    jsr     PCHAR
                    inx
                    cpx     #RAM_BBU_TOP
                    bls     DUMP_MEM_LOOP
                    ;
                    rts
                    .end
