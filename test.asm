
; programming example

include 'win64a.inc'

format PE64 CONSOLE 5.0
entry start

;include 'include\\opengl.inc'

testProc:
    push rbp
    mov rbp, rsp
    sub rsp, 8*2

    mov rax, [rbp+24]
    invoke printf, "%i ", rax

    mov rsp, rbp
    pop rbp
ret

section '.text' code readable executable

    start:
    sub	rsp,8		; Make stack dqword aligned

    push [dataA]
    push 666
    call testProc

    push 111
    push 666
    call testProc

    invoke printf, "OK"

    invoke	ExitProcess,0

section '.data' data readable writeable
    lf db 13,10,0

    dataA dq 123


section '.idata' import data readable writeable
    include 'include\\idata.inc'