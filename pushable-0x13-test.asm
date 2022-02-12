; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
;Current theory 0x13 is 3-bytes ???? offset,B (indexed by B)
;
;0x01
;0xf8 - 1111 1000 ;HIN set ZVC clr ;#$FE
;0xf1 - 1111 0001 ;HIC set NZV clr ;#$50
;0xf9 - 1111 1001 ;HINC set ZV clr ;#$00
;0x01
;
;
;CC   = 0b??HINZVC
;CPD  = 0b----CCCC -=unchangedC= changed
;C=1 if the absolute value of the contents of memory is larger than the absolute value of the accumulator; cleared otherwise.
;V=1 if a twos complement overflow resulted from the operation;
;Z=1 if result all zero
;N=1 if MSB of result set
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
INIT                ldaa    #$01         ;marker
                    jsr     PCHAR
INST_TEST           ldd     #$FE50       ;set two bytes of RAM
                    std     RAM_BBU_BOT  ;Store
                    ldd     #$0000
                    ldy     #$0000       ;Using Y as a loop counter
                    ldx     #RAM_BBU_BOT
CLR_N_TEST          iny
                    .byte   $13, $00, $40
                    tpa
                    jsr     PCHAR
                    inx
                    inx
                    cmpy    #$0005       ;Finish after three loops
                    bcs     CLR_N_TEST
                    ldaa    #$01         ;marker
                    jsr     PCHAR
                    rts
                    .end
