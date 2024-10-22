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
    sub rsp, 8*1

    
    invoke testProc, 123,555


    mov rsp, rbp
    pop rbp
ret