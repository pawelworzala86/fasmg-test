
; programming example

include 'win64a.inc'

format PE64 CONSOLE 5.0
entry start

;include 'include\opengl.inc'


section '.text' code readable executable

testProc:
    push rbp
    mov rbp, rsp
    sub rsp, 8*2

    
    invoke printf, "%i ", [rbp+24]


    mov rsp, rbp
    pop rbp
ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    
       push 123
   push 555

    call testProc


    mov rsp, rbp
    pop rbp
ret

start:
    sub	rsp,8		; Make stack dqword aligned

    call main

    ;invoke printf, "OK"

    invoke	ExitProcess,0


section '.data' data readable writeable
    lf db 13,10,0


section '.idata' import data readable writeable
    include 'include\idata.inc'