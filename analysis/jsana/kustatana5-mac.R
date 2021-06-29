# ----------------------------------------------------------------------------------
#    statAna 5th wek #9#10  Analysis of Covariance Structures
#                                                    by T. Kuwahara,  Keio Univ.
# ----------------------------------------------------------------------------------
# 作業ディレクトリの設定（自分の環境にあわせて修正して下さい）
# setwd("~/Documents/Lecture")

# 青木先生（群馬大）による関数の読み込み（自分の環境にあわせて修正して下さい）
# source("all.R", encoding="EUC-JP")
source("http://aoki2.si.gunma-u.ac.jp/R/src/all.R", encoding="euc-jp")
       
# 本講座用関数の読み込み（ディレクトリパスは、自分の環境にあわせて修正して下さい）
# source("./kujmra14_Rlib.R",encoding="EUC-JP")

# ----------------------------------------------------------------------------------

# ----------------------------------------------- 共分散構造分析
# ライブラリの読み込み
library(lavaan)      # install.packages("lavaan")
library(semPlot)     # install.packages("semPlot")

# 刹那因子だけ
# データ準備：ライフスタイル・データの読み込み
lsce <- read.table("http://web.sfc.keio.ac.jp/~kuwahara/courses/statAna/data_lsce2.csv", header=T, sep=",", nrows=-1)
anco0 <- lsce[,c(56:80)]
anco <- anco0[,c(2,4,5,6,8,10,11,14,16:21,25)]
anco <- na.omit(anco)
colnames(anco); nrow(anco)


# 刹那因子（構成概念、潜在因子）モデルの作成
setsuna <- anco[,c(1,13,14)]	# 必要な変数の取り出し 
setsuna <- na.omit(setsuna)		# 欠測値をもつ個体の排除
nrow(setsuna)					# N（データ数）
cor.setsuna <- cor(setsuna)		# 相関行列の算出、共分散なら  cov(setsuna)
round( cor.setsuna, 3 )


# モデル表現
modelS.刹那 <- ' 刹那f1 =~ nq4s2 + nq4s20 + nq4s21 '

# 共分散構造分析の実行
fitS.刹那 <- sem( model=modelS.刹那, data=setsuna, estimator="ML")

# 結果の表示
summary( object = fitS.刹那  )

# 非標準化推定値
parameterEstimates( object = fitS.刹那, ci = TRUE )
# 標準化推定値
standardizedSolution( object = fitS.刹那 )

# パス図の出力 (1)
semPaths( object = fitS.刹那
　　　　　, whatLabels="stand"      # パスのラベル："name" / "est" / "stand" / "eq" / "no"
　　　　　, style="lisrel"          # 図の形式："ram" / "mx" / "OpenMx" / "lisrel"
          , layout="tree"           # 図のスタイル："tree" / "tree2" / "circle" / "circle2" / "spring"
          , rotation=2              # パス図の回転：1 / 2 / 3 / 4 
          , sizeMan=12, sizeMan2=7  # 観測変数の四角形の幅と高さ
          , sizeLat=13, sizeLat2=8  # 潜在変数の丸の幅と高さ
          , nCharNodes=0            # ノードのラベル字数（指定文字数まで省略する。0は省略しない）
          , nCharEdges=3            # パスのラベル字数（指定文字数まで省略する。0は省略しない）
          , edge.label.cex=1.2      # パスの文字の大きさ
          , nodeLabels=c( "nq4s2", "nq2s20", "nq4s21", "刹那" )
          )


# パス図の出力 (2)
semPaths( object = fitS.刹那
　　　　　　, whatLabels="stand"      # パスのラベル："name" / "est" / "stand" / "eq" / "no"
          , nCharNodes=0            # ノードのラベル字数（指定文字数まで省略する。0は省略しない）
          )


# 構成概念（因子）得点の算出
factor.score.S.刹那 <- predict( object = fitS.刹那 )
factor.score.S.刹那



# -----------------------------　共分散構造解析による確証的因子分析

# モデル表現
modelH.因子仮説 <-  ' 刹那 =~ nq4s2 + nq4s20 + nq4s21
                               堅実 =~ nq4s4 + nq4s5 + nq4s19
                               顕示 =~ nq4s16 + nq4s17 + nq4s18
                              孤立 =~ nq4s6 + nq4s8 + nq4s25
                              規範 =~ nq4s10 + nq4s11 + nq4s14
                 刹那 ~~ 孤立
                 堅実 ~~ 孤立
                 顕示 ~~ 規範'

# 共分散構造分析の実行
fitH.因子仮説 <- sem( model=modelH.因子仮説, data=anco, estimator="ML")

# 結果の表示
summary( object = fitH.因子仮説 )

# 標準化推定値
standardizedSolution( object = fitH.因子仮説 )

# パス図の出力 (1)
semPaths( object = fitH.因子仮説
　　　　　　, whatLabels="stand"      # パスのラベル："name" / "est" / "stand" / "eq" / "no"
　　　　　　, style="lisrel"          # 図の形式："ram" / "mx" / "OpenMx" / "lisrel"
          , layout="tree"           # 図のスタイル："tree" / "tree2" / "circle" / "circle2" / "spring"
          , rotation=1              # パス図の回転：1 / 2 / 3 / 4 
          , sizeMan=5, sizeMan2=2  # 観測変数の四角形の幅と高さ
          , sizeLat= 4, sizeLat2=3  # 潜在変数の丸の幅と高さ
          , nCharNodes=0            # ノードのラベル字数（指定文字数まで省略する。0は省略しない）
          , nCharEdges=3            # パスのラベル字数（指定文字数まで省略する。0は省略しない）
          , edge.label.cex=0.5      # パスの文字の大きさ
          )
          
# パス図の出力 (2)
semPaths( object = fitH.因子仮説
　　　　　　, whatLabels="stand"      # パスのラベル："name" / "est" / "stand" / "eq" / "no"
　　　　　　, style="lisrel"          # 図の形式："ram" / "mx" / "OpenMx" / "lisrel"
          , layout="spring"         # 図のスタイル："tree" / "tree2" / "circle" / "circle2" / "spring"
          , rotation=1              # パス図の回転：1 / 2 / 3 / 4 
          , sizeMan=5, sizeMan2=2  # 観測変数の四角形の幅と高さ
          , sizeLat= 4, sizeLat2=3  # 潜在変数の丸の幅と高さ
          , nCharNodes=0            # ノードのラベル字数（指定文字数まで省略する。0は省略しない）
          , nCharEdges=3            # パスのラベル字数（指定文字数まで省略する。0は省略しない）
          , edge.label.cex=0.5      # パスの文字の大きさ
          )



# モデルの評価：適合度指標の表示
summary( object = fitH.因子仮説, fit.measure = TRUE  )

# 因子（構成概念）スコア
scores.因子仮説 <- predict( fitH.因子仮説 )
scores.因子仮説
cor(scores.因子仮説)
round( cor(scores.因子仮説), 3)



# 探索的因子分析（社交因子モデル）vs. 確証的因子分析（共分散構造分析）
# まずは、fa()による、最尤法 →　プロマックス回転
fa.mlpm <- fa(anco, fm="ml", nfactors=5, rotate="promax")

# 因子得点の比較
round( cor(scores.因子仮説, fa.mlpm$scores), 3 )

