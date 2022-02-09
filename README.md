# TMP76C75T/MH6111 Bootloader POC
 TMP76C75T/MH6111 Bootloader proof of concept

## Things needed
1. 7675 SBC board
2. Arduino (MEGA/2560 in examples)
3. EPROM emulator/EPROM with binary on it
4. Computer

## Assemble
### OSX
```
$OrgAsm -b -t6111 -xf bootstrap-from-serial-test-6111.asm
```

## Burn
###MiniPro
```
$minipro -p "SMJ27C256@DIP28" -w bootstrap-from-serial-test-6111.asm.obj
```

## Hook-up
### MEGA/2560
* Connect RX/TX on 7675 SBC board to pins D11/D10 respectively
* Connect Arduino to computer

* Monitor Serial on computer

## Resets
* Reset Arduino wait for "ReAdY!" over serial
* Reset 7675 SBC

* Watch things unfold!
