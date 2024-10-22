const fs = require('fs')

var fileName = process.argv[2]

let sourceOrg = fs.readFileSync('./source/'+fileName+'.js').toString()

function Blocks(source){
    let newSource = ''
    var tab = 1
    for(let index=0;index<source.length;index++){
        if(source[index]=='{'){
            newSource += ':'+tab
            tab++
        }
        if(source[index]=='}'){
            newSource += ':'+(tab-1)
            tab--
        }
        newSource += source[index]
    }
    return newSource
}



const FUNCTIONS = []

function Parse(source){
    function r(regexp,callback){
        source = source.replace(regexp,callback)
    }

    source = Blocks(source)



    r(/function(.*)(?<num>\:[0-9]+)\{([\s\S]+?)(\k<num>)\}/gm,match=>{
        //console.log(match)
        let head = match.split(/:[0-9]+\{/)[0]
        //console.log(head)
        let index = match.split(':')[1].split('{')[0]
        let body = match.split(new RegExp(':'+index+'\\{'))[1].split(new RegExp(':'+index+'\\}'))[0]
        //console.log(body)
        let params = head.split('(')[1].split(')')[0].split(',')
        let name = head.split('(')[0].replace('function','').trim()
        //console.log(params)
        //console.log(name)
        let count = params.length
        let idx = 1
        if((params.length>0)&&params[0].length>0){
            console.log(params)
            for(const param of params){
                body = body.replace(new RegExp(param,'gm'),'[rbp+'+(idx*8+16)+']')
            }
        }
        FUNCTIONS.push({
            name,
            params,
            body
        })
        if((params.length>0)&&params[0].length>0){
        return `${name}:
    push rbp
    mov rbp, rsp
    sub rsp, 8*${count}

    ${body}

    mov rsp, rbp
    pop rbp
ret`}else{
    return `${name}:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    ${body}

    mov rsp, rbp
    pop rbp
ret`
}
    })

    FUNCTIONS.map(FUNC=>{
        r(new RegExp(FUNC.name+'\\([\\s\\S]+?\\)','gm'),match=>{
            console.log(match)
            let params = match.split('(')[1].split(')')[0].split(',')
            let head = ''
            for(const param of params){
                head += '   push '+param+'\n'
            }
            return `${head}
    call ${FUNC.name}`
        })
    })

    r(/([a-zA-Z0-9\_]+)\(([\s\S]+?)\)/gm,'invoke $1, $2')


    return source
}

sourceOrg = Parse(sourceOrg)

fs.writeFileSync('./cache/'+fileName+'.asm',`
; programming example

include 'win64a.inc'

format PE64 CONSOLE 5.0
entry start

;include 'include\\opengl.inc'


section '.text' code readable executable

${sourceOrg}

start:
    sub	rsp,8		; Make stack dqword aligned

    call main

    ;invoke printf, "OK"

    invoke	ExitProcess,0


section '.data' data readable writeable
    lf db 13,10,0


section '.idata' import data readable writeable
    include 'include\\idata.inc'`)