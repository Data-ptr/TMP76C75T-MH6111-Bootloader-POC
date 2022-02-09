; MH6111/TMP76C75T Bootstrap from Serial test code (TASM)
; Jane Hacker
; 9th Feb 2022
;
; XTAL = 12MHz, E = 12MHz/6 = 2MHz
; Baud rate = 2Mhz/4096 = 488 Baud (Nice and slow)
; Baud rate = 2Mhz/128 = 15,625 Baud
; Baud rate = 2Mhz/16 = 125,000 Baud (Holy smokes!)
;
; Run in Mode 2, Multiplexed/RAM/No ROM, P20: L, P21: H, P22: L
;
                    .msfirst
;
;Internal registers
SCI_BAUD            .equ    $0010
SCI_SCR             .equ    $0011
rxbuff              .equ    $0012
txbuff              .equ    $0013
ram_ctrl            .equ    $0014
;
;RAM
RAM_BOT             .equ    $0040       ;The bottom of stored RAM
RAM_CODE            .equ    $0057       ;The bottom of reset RAM
STACK               .equ    $01BF       ;The top of RAM
;
;
;...The Void...
;
;ROM
start               .equ    $8000       ;start address of the external rom
                    .org    start
:
; Strings
HELLOSTR            .text   "\nJANE HACKER 2022 <3\n"
                    .byte   $00
READYSTR            .text   "READY"
                    .byte   $00
DONESTR             .text   "DONE"
                    .byte   $00
;
;Code
ENTRYPOINT          lds     #STACK        ;setup the stack pointer
;
                    ldaa    #$C0          ;to RAM enable
                    staa    ram_ctrl      ;enable RAM
;
                    ldaa    #$05          ;baud = E/16, async ;0x07 = baud = E/4096, async
                    staa    SCI_BAUD
                    ldaa    #$0A          ;set acc. A to TE (Transmit Enable) and RE (Recieve Enable) bit in SCI_SCR
                    staa    SCI_SCR       ;enable transmitter and reciever
;
                    clra                  ;Clear acc. A
;
COPYINIT            ldx     #RAM_CODE     ;Put start addr. of code in RAM into X
;
                    jsr     PREADY        ;Print "READY" to serial
;
COPY                jsr     RCHAR         ;Load acc. A with code
                    staa    $00,x         ;Store acc. A into RAM code
                    inx
                    staa    $00,x         ;Peek for end of instruction marker
                    cmpa    #$F0
                    bne     COPY
;
                    ldd     #$0000
                    ldx     #$0000
                    ldy     #$0000
;
                    jsr     RAM_CODE      ;Run the code copied into RAM
;
                    jsr     PDONE         ;Print "DONE" to the serial
;
INFLOOP             bra     INFLOOP
;Print a char out the serial port
PCHAR               psha                ;save A
PCHAR1              ldaa    SCI_SCR     ;get comms status ;clears the TDRE bit
                    anda    #$20        ;mask for tdre bit
                    beq     PCHAR1      ;wait till empty
                    pula                ;restore A
                    staa    txbuff      ;send it
                    rts
;
;Read a char from the serial port
RCHAR               ldaa    SCI_SCR     ;get comms status ;clears the RDRF bit?
                    anda    #$80        ;mask for rdrf bit
                    beq     RCHAR       ;wait till full
                    ldaa    rxbuff      ;read it
                    rts                 ;the byte is now in acc. A
;
;Print a string out the serial port; expect start address of string in reg. D
PSTR                pshx                ;Chuck ind. X onto the stack
                    xgdx                ;ind. X now has the string address
                    pshx
PSTRLOOP            ldaa    $00,x       ;Load acc. A with data at address in X
                    cmpa    #$00
                    beq     PSTRDONE    ;If acc. A is zero (our "null byte")
                    jsr     PCHAR       ;Print the char
                    inx                 ;Increment X to the next byte
                    bra     PSTRLOOP    ;loop
PSTRDONE            pulx                ;restore acc. D
                    xgdx
                    pulx                ;restore ind. X
                    rts                 ;return
;
;Print the string READY to serial
PREADY              ldd     #READYSTR   ;Point to start of "READY" string
                    jsr     PSTR        ;Print string routine
                    rts
;
;Print the string DONE to serial
PDONE               ldd     #DONESTR    ;Point to start of "READY" string
                    jsr     PSTR        ;Print string routine
                    rts
;
;Clear accumulators
CLRACC              clra
                    clrb
                    rts
;
;ISRs
sci_tr              bra     sci_tr
tof_tr              bra     tof_tr
ocf_tr              bra     ocf_tr
icf_tr              bra     icf_tr
irq_tr              bra     irq_tr
swi_tr              bra     swi_tr
nmi_tr              bra     nmi_tr
;
; Interrupt Vectors
                    .org     $fff0
;
                    .word    sci_tr
                    .word    tof_tr
                    .word    ocf_tr
                    .word    icf_tr
                    .word    irq_tr
                    .word    swi_tr
                    .word    nmi_tr
                    .word    ENTRYPOINT
                    .end
