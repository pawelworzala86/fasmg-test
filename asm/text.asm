
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


copy_string:
    ;mov rsi, src      ; adres źródłowego ciągu
    ;mov rdi, dest     ; adres docelowego ciągu
    cld               ; Clear direction flag
copy_loop:
    lodsb             ; Załaduj bajt z src do AL
    stosb             ; Zapisz bajt z AL do dest
    test al, al       ; Sprawdź, czy to koniec ciągu
    jnz copy_loop     ; Jeśli nie, kontynuuj pętlę
ret
macro CopyText src, dest
    mov rsi, src
    mov rdi, dest
    call copy_string
end macro



string_length:
    ;mov rsi, str      ; adres ciągu
    xor rcx, rcx      ; wyzeruj licznik

length_loop:
    lodsb             ; załaduj bajt z ciągu do AL
    test al, al       ; sprawdź, czy to koniec ciągu
    je done           ; jeśli tak, przejdź do końca
    inc rcx           ; zwiększ licznik
    jmp length_loop   ; kontynuuj pętlę

done:
    mov rax, rcx      ; wynik w RAX
ret
macro TextLength src
    mov rsi, src
    call string_length
end macro





section '.text' code readable executable

    start:
    sub	rsp,8		; Make stack dqword aligned

    ;mov rsi, string1
    ;mov rdi, string2
    ;call compare_strings
    CompareText string1, string2
    invoke printf, "%i", rax

    CopyText sourceString, destString
    invoke printf, "%s", destString

    TextLength string1
    invoke printf, "%i", rax

    invoke	ExitProcess,0

section '.data' data readable writeable
    lf db 13,10,0

    string1 db 'Hello', 0
    string2 db 'Hello', 0

    sourceString db 'Hello, World!', 0
    destString db 20 dup(0)


section '.idata' import data readable writeable
    include 'include\\idata.inc'