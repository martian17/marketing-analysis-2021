let fs = require("fs");


let Record = function(str){
    let rows = str.split("\n").map(a=>a.split(/\s+/));
    let head = rows[0];
    let body = rows.slice(1);
    let side = [];
    for(let i = 0; i < body.length; i++){
        let row = body[i];
        body[i] = row.slice(1).map(a=>parseFloat(a));
        side.push(row[0]);
    }
    this.head = head;
    this.side = side;
    this.body = body;
    
    this.setSide = function(s){
        side = s;
    };
    
    let repeatChars = function(c,n){
        let str = "";
        for(let i = 0; i < n; i++){
            str += c;
        }
        return str;
    };
    
    let printWidth = function(str,n){
        str = str+"";
        let w = 0;
        let s = "";
        for(let i = 0; i < str.length; i++){
            let ww = 0;
            if(str[i].match(/[\u4e00-\u9fa5\uff00-\uffff\u3000-\u30ff\u4e00-\u9faf]/)){
                //full width
                ww += 1;
            }
            ww += 1;
            if(w+ww > n){
                break;
            }
            w += ww;
            s += str[i];
        }
        if(w === n){
            //return s;
        }else{
            for(w; w < n; w++){
                s += " ";
            }
            //return s;
        }
        process.stdout.write(s);
    };
    
    this.highlightPrint = function(n){//highlight top n
        let mask = [];
        for(let j = 0; j < body.length; j++){
            mask[j] = [];
        }
        for(let i = 0; i < head.length; i++){
            let rec = [];
            for(let j = 0; j < body.length; j++){
                mask[j][i] = 0;
                rec.push([body[j][i],j]);
            }
            rec.sort((a,b)=>Math.abs(b[0])-Math.abs(a[0]));
            for(let j = 0; j < n; j++){
                mask[rec[j][1]][i] = 1;
            }
        }
        //printing the header
        printWidth("",32);
        for(let i = 0; i < head.length; i++){
            printWidth(head[i],8);
        }
        process.stdout.write("\n");
        //printing the side as well as the body
        for(let i = 0; i < body.length; i++){
            if(i&1 === 1)process.stdout.write("\u001b[40m");
            printWidth(side[i],32);
            for(let j = 0; j < head.length; j++){
                if(mask[i][j] === 1)process.stdout.write("\u001b[33m");
                printWidth(body[i][j],8);
                if(mask[i][j] === 1)process.stdout.write("\u001b[0m");
                if(i&1 === 1)process.stdout.write("\u001b[40m");
            }
            if(i&1 === 1)process.stdout.write("\u001b[0m");
            process.stdout.write("\n");
        }
    };
};

let main = function(){
    let str = fs.readFileSync("/dev/stdin").toString();
    let record = new Record(str);
    record.setSide(`自宅からのアクセスの良さ
宿泊施設・駐車場からのアクセスの良さ。
値段の安さ・割引（SNS・観光アプリとの連携）の充実度・
営業時間（ナイターの有無など）/
食事施設の充実度。
レンタル品の充実度・
宿泊施設の充実度。
周辺施設（温泉・土産店など）の充実度。
周辺施設（コンビニ・ガソリンスタンド）の充実度
ツアーパックの充実度・
スキースクール・トレッキングガイドの充実度
スキー・スノーボード以外のアクティビティの充実度、
景観の美しさ’
天候・雪質”
自然との近さ
コース・登山道のバリエーション
安全性の高さ・
口コミの高さ・
知名度の高さ・
過去の利用経験
外国人の多さ
スタッフの年齢層`.split("\n"));
    record.highlightPrint(4);
};


main();