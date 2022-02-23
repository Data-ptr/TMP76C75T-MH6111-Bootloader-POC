; Jane Hacker 20 Feb 2022
; Trys to get the length of instructions
;
                    .msfirst
;
;Internal registers
;
;RAM
RAM_BBU_BOT         .equ    $0040           ;The bottom of "Battery Backup" RAM
RAM_BBU_TOP         .equ    $0056           ;The top of "Battery Backup" RAM
RAM_VIO_BOT         .equ    $0057           ;The bottom of "violate" RAM
RAM_VIO_TOP         .equ    $01BF           ;The top of "violate" RAM
RAM_CODE_START      .equ    RAM_VIO_BOT
;
;User RAM
IL1                 .equ    $0044           ;_I_nstruction _L_ength votes
IL2                 .equ    $0045
IL3                 .equ    $0046
IL4                 .equ    $0047
MAX_VOTE            .equ    $0048           ;$0048:$0049
MAX_INT             .equ    $004A
;
;Subroutines in ROM
PCHAR               .equ    $8021
RCHAR               .equ    $802C
PSTR                .equ    $8035
CLRACC              .equ    $8056
MEMCPY              .equ    $8059
                    ;
                    .org    RAM_CODE_START
                    ;
                    jmp     ENTRYPOINT
                    ;
;Clear RAM area
CLRRAM              ldaa    #$00
                    ldx     #IL1
CRLOOP              staa    $00,x
                    inx
                    cpx     #MAX_INT + 1
                    bcs     CRLOOP
                    ;
                    rts
                    ;
; Expects byte count to be in acc. A
STRVOTE             tab                     ;put A in B (effectively D)
                    ldaa    #$00
                    nop
                    addd    #IL1            ;D is now the addr of the byte count
                    xgdx                    ;now X points to byte count
                    inc     $00,x
                    ;
                    rts
                    ;
FINDWINNER          ldx     #IL1            ;starting address
                    stx     MAX_VOTE        ;set as highest count
                    ldab    #$00
                    ;
FW_LOOP             inx                     ;is #IL2 on first loop
                    incb
                    ldy     MAX_VOTE        ;is #IL1 on first loop
                    ldaa    $00,y           ;acc. A has the count at MAX_VOTE, Y++
                    cmpa    $00,x           ;cmp MAX_VOTE to IL(x)
                    bcc     FW_CONT         ;if MAX_VOTE wins, continue
                    stx     MAX_VOTE        ;we have a new MAX_VOTE
                    stab    MAX_INT
FW_CONT             cpx     #IL4
                    bcc     FW_LOOP
                    ;
                    ldaa   MAX_INT
                    ;
                    rts
                    ;
ENTRYPOINT          ldaa    #$13
                    jsr     PCHAR           ;puts the instruction byte on serial
                    ;
                    jsr     CLRRAM          ;clear the ram we are using
;
;===================
; Expects A=instr
;===================
;
CNTBYTES            staa    $A2          ;copy in test instruction
                    staa    $AA
                    staa    $B4
                    staa    $C0
                    ;
                    ldaa    #$04            ;Use A as a counter
INSTR1              .byte   $00             ;Instruction byte
                    deca
                    deca
                    deca
                    jsr     STRVOTE
                    ldab    #$04            ;Use B as a counter
INSTR2              .byte   $00             ;Instruction byte
                    decb
                    decb
                    decb
                    tba
                    jsr     STRVOTE
                    ldx     #$0004          ;Use X as a counter
INSTR3              .byte   $00             ;Instruction byte
                    dex
                    dex
                    dex
                    xgdx
                    tba
                    jsr     STRVOTE
                    ldy     #$0004          ;Use Y as a counter
INSTR4              .byte   $00             ;Instruction byte
                    dey
                    dey
                    dey
                    xgdy
                    tba
                    jsr     STRVOTE
                    ;
                    ;
                    jsr     FINDWINNER
                    ;
                    jsr     PCHAR
                    rts
                    ;
                    .end
