
; programming example

include 'win64a.inc'

format PE64 CONSOLE 5.0
entry start

;include 'include\\opengl.inc'


compare_strings:
    cld
compare_loop:
    lodsb            
    scasb             
    jne strings_not_equal
    test al, al
    jnz compare_loop
strings_equal:
    mov rax, 1
    ret
strings_not_equal:
    mov rax, 0
    ret
macro CompareText strA, strB
    mov rsi, strA
    mov rdi, strB
    call compare_strings
end macro





section '.text' code readable executable

    start:
    sub	rsp,8		; Make stack dqword aligned

    ;mov rsi, string1
    ;mov rdi, string2
    ;call compare_strings
    CompareText string1, string2
    invoke printf, "%i OK", rax

    invoke	ExitProcess,0

section '.data' data readable writeable
    lf db 13,10,0

    string1 db 'Hello', 0
    string2 db 'Hello', 0


section '.idata' import data readable writeable
    include 'include\\idata.inc'