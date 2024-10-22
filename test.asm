
; programming example

include 'win64a.inc'

format PE64 CONSOLE 5.0
entry start

;include 'include\\opengl.inc'

section '.text' code readable executable

    start:
    sub	rsp,8		; Make stack dqword aligned

    invoke printf, "OK"

    invoke	ExitProcess,0

section '.data' data readable writeable
    lf db 13,10,0


section '.idata' import data readable writeable
    include 'include\\idata.inc'