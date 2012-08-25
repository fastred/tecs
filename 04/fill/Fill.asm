// This file is part of the materials accompanying the book 
// "The Elements of Computing Systems" by Nisan and Schocken, 
// MIT Press. Book site: www.idc.ac.il/tecs
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, 
// the screen should be cleared.

    // number of screen blocks
    @8192
    D=A
    @count
    M=D

(LOOP_INF)
    @i
    M=0
(LOOP_FILL)
    @i
    D=M
    @count
    D=D-M
    @LOOP_INF
    D;JGE
// READ KEYBOARD
    @KBD
    D=M
    @FILL_WHITE
    D;JEQ
// FILL BLACK
    @i
    D=M
    @SCREEN
    A=A+D
    M=-1
    @FILL_END
    0;JMP
(FILL_WHITE)
    @i
    D=M
    @SCREEN
    A=A+D
    M=0
(FILL_END)
    @i
    M=M+1
    @LOOP_FILL
    0;JMP

