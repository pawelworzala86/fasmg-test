class CLASS{
    propA:number = 12
    constructor(aaa:number){
        this.propA = 54
    }
}

function testProc(paramA:number,paramB:number):void{
    console.log("%i %i ", paramA, paramB)
}

function main():void{
    testProc(123,555)
}