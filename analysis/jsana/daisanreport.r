# ----------------------------------------------------------------------------------
#    statAna 2018s 3rd week #5#6
#                                                    by T. Kuwahara,  Keio Univ.
# ----------------------------------------------------------------------------------
# 作業ディレクトリの設定（自分の環境にあわせて修正して下さい）
# setwd("~/Documents/Lecture")

# 青木先生（群馬大）による関数の読み込み（自分の環境にあわせて修正して下さい）
# source("all.R", encoding="EUC-JP")

       # インターネットが利用可能ならば、こうすればいつでも最新版
       # source("http://aoki2.si.gunma-u.ac.jp/R/src/all.R", encoding="euc-jp")
       
# 本講座用関数の読み込み（ディレクトリパスは、自分の環境にあわせて修正して下さい）
source("kujmra14_Rlib.R",encoding="EUC-JP")

# ----------------------------------------------------------------------------------


# 企業イメージデータの読み込み
ci <- read.csv(file="ci88n.csv", header=T, nrows=-1)
cif <- ci[,c(2:22)]; colnames(cif)
cif <- ci[,-1]; colnames(cif)

ci <- read.csv(file="ci88n.csv", header=T, nrows=-1, row.name=1)

# 因子数の決定
ans <- pca(ci)
plot(cex=4, ans$eval, type="b", xlab="主成分", ylab="分散", main="スクリープロット")


因子分析　　factors=4 とか　factors=6とかも試してみてください
result <- pfa(ci, method=c("Varimax"), factors=5)

# 相関係数
round(result$correlation.matrix,3)
# 全部
print.default(result)
# 共通性
result$communality

# 因子負荷量（回転前）
print(result, before=TRUE)

# 因子負荷量（回転後）
print(result)



# 因子得点
round(result$scores,3)

