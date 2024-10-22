
; programming example

include 'win64a.inc'

format PE64 CONSOLE 5.0
entry start

;include 'include\\opengl.inc'

compare_strings:
    ;push rbp
    ;mov rbp, rsp
    ;sub rsp, 8*2

    ;invoke printf, "%s %s", [rbp+24], [rbp+16]

    ;mov rsi, [rbp+24]
    ;mov rdi, [rbp+32]
    cld               ; Clear direction flag

compare_loop:
    lodsb             ; Load byte from str1 into AL
    scasb             ; Compare byte in AL with byte at str2
    jne strings_not_equal ; If not equal, jump to the label
    test al, al       ; Check if end of string (null byte)
    jnz compare_loop  ; If not end, continue loop

strings_equal:
    mov rax, 1        ; Strings are equal

    ;mov rsp, rbp
    ;pop rbp
    ret

strings_not_equal:
    mov rax, 0        ; Strings are not equal

    ;mov rsp, rbp
    ;pop rbp
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