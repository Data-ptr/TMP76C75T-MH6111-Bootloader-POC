; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
;Current theory 0x42 is 1-byte something acc. A
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
                    ldaa    #$01         ;marker
                    jsr     PCHAR
                    ;
INST_TEST           clra
                    ldab    #$04
TEST_LOOP           .byte   $41          ;If is it 4 byte, B = 4
                    decb                 ;If is it 3 byte, B = 3
                    decb                 ;If is it 2 byte, B = 2
                    decb                 ;If is it 1 byte, B = 1
                    tba
                    jsr     PCHAR
                    ;
                    ldaa    #$01         ;marker
                    jsr     PCHAR
                    ;
                    rts
                    .end
