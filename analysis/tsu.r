# Marketing Strategy   2020-つりだし
#                     by  T. Kuwahara,  Keio University at SFC
#                                kuwahara@sfc.keio.ac.jp

setwd("/home/yutaro/prog/class/marketing2021/analysis")
source("http://aoki2.si.gunma-u.ac.jp/R/src/all.R", encoding="euc-jp")
library(openxlsx)         # install.packages("openxlsx", dependencies=T) 
library(psych)            # install.packages("psych")


# teamD
ifile="tsu.xlsx"
ofile="tsuoutput.csv"


# ゲレンデアンケート結果の読み込み
lsce <- read.xlsx( ifile, sheet=1, colNames=TRUE, rowNames=TRUE)
colnames(lsce)
head(lsce)

# 因子分析用データ作成
lscef <- lsce
head(lscef)

# determine # of factors
   # Principal Component Analysis（pca: all.Rが必要）
      ans <- pca(lscef)
      print(ans)

   # 関数screeplotが使えないので、plotを使う
      plot(ans$eval, type="b", xlab="PCS", ylab="Variance", main="Scree Plot")


# 因子分析 psych::fa
# fa()による、主因子法 →　バリマックス回転
fa.pavm <- fa(lscef, fm="pa", nfactors=4, rotate="varimax")
print(fa.pavm, digits=3)


# 因子得点
fs <- factor.scores(lscef, fa.pavm, Phi = NULL, method = c("Thurstone"),rho=NULL,impute="none")

fs$scores



# グループ別因子得点の集計
# by(lscef$FAC.1, lsce3$sex, mean, na.rm=T)
# by(lsce3[,c(37:41)], lsce3$sex, colMeans, na.rm=T)
# by(lsce3[,c(37:41)], lsce3$job, colMeans, na.rm=T)



# --  クラスタリング -----------
# --- 非階層的方法（k-means）
set.seed(989898); (cl <- kmeans(fs$scores,7))
set.seed(989898); (cl <- kmeans(fs$scores,6))
set.seed(989898); (cl <- kmeans(fs$scores,5))
#set.seed(989898); (cl <- kmeans(fs$scores,4))
#set.seed(989898); (cl <- kmeans(fs$scores,3))
#set.seed(989898); (cl <- kmeans(fs$scores,2))


# --- 因子得点の前処理
lsce1 <- cbind(as.numeric(rownames(fs$scores)), fs$scores)
colnames(lsce1)[1] <- "cid"

# --- クラスタ番号の前処理
lsce2 <- cbind(as.numeric(rownames(as.matrix(cl$cluster))), as.matrix(cl$cluster))
colnames(lsce2) <- c("cid", "cluster")

# --- 因子得点とクラスタ番号のマージ
lsce3 <- merge(lsce1, lsce2, by.x="cid", by.y="cid", all=T)

# --- 元のデータから必要な変数の切り出し
# lsce0 <- lsce
# lsce0 <- cbind(as.numeric(rownames(lsce0)), lsce0)
# colnames(lsce0)[1] <- "cid"

# lsce4 <- merge(lsce0, lsce3, by.x="cid", by.y="cid", all=T)
# colnames(lsce4)
# nrow(lsce4)

# lsce3
write.csv(lsce3, file=ofile)


# クロス集計（クラスター別）
##tbl <- xtabs(~cluster+sex, data=lsce4)
##tbl
##cross(45, 28,lsce4, row=T,latex=T, test=c("chisq"))
##tbl


##tbl <- xtabs(~cluster+sex, data=lsce5)
##tbl
##cross(45, 28,lsce5, row=T,latex=T, test=c("chisq"))
##tbl


