
var nclu = 4;


var main = function(){
    var str = fs.readFileSync("/dev/stdin").toString();
    var recods = str.split("\n").slice(1).map((a)=>{
        return a.split(/\s+/).slice(2);
    });
    
}