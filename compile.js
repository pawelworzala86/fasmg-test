const fs = require('fs')



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


    r(/console.log/gm,'printf')


    function getParams(text){
        return text.split('(')[1].split(')')[0].split(',').map(param=>{
            let prop = param.split(':')
            return {name:prop[0],type:prop[1]}
        })
    }

    r(/function([\s\S]+?)(?<num>\:[0-9]+)\{([\s\S]+?)(\k<num>)\}/gm,match=>{
        let head = match.split(/:[0-9]+\{/)[0]

        let index = match.split(':')
        index=index[index.length-1].replace(':','').replace('}','')

        let body = match.split(new RegExp(':'+index+'\\{'))[1].split(new RegExp(':'+index+'\\}'))[0]

        let params = getParams(head)
        let name = head.split('(')[0].replace('function','').trim()

        let count = 1
        let idx = 1
        if((params.length>0)&&params[0].name.length>0){
            console.log(params)
            for(const param of params){
                body = body.replace(new RegExp(param.name,'gm'),'[rbp+'+(idx*8+16)+']')
                idx--
                count++
            }
        }
        FUNCTIONS.push({
            name,
            params,
            body
        })
        
        return `${name}:
    push rbp
    mov rbp, rsp
    sub rsp, 8*${count}

    ${body}

    mov rsp, rbp
    pop rbp
ret`
    })

    FUNCTIONS.map(FUNC=>{
        r(new RegExp(FUNC.name+'\\([\\s\\S]+?\\)','gm'),match=>{
            console.log(match)
            let params = getParams(match)
            let head = ''
            for(const param of params){
                head += '\n   push '+param.name
            }
            return `${head}
    call ${FUNC.name}`
        })
    })

    r(/([a-zA-Z0-9\_]+)\(([\s\S]+?)\)/gm,'invoke $1, $2')

    


    return source
}



var fileName = process.argv[2]

let sourceOrg = fs.readFileSync('./source/'+fileName+'.ts').toString()

sourceOrg = Parse(sourceOrg)

let frame = fs.readFileSync('./frame/cmd.asm').toString()

frame = frame.replace(/{{SOURCE}}/gm, sourceOrg)

fs.writeFileSync('./cache/'+fileName+'.asm',frame)