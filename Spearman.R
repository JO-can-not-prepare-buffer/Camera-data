# 检验变量的多重共线性 #
# Spearman #

csvpath <- file.choose()
csvpath

df <- read.csv(csvpath, header = T, stringsAsFactors = FALSE)
df <- as.data.frame(df)

df1 <- df[,c(7,9,10,11,12,13,16,17,18,19,20,21,22,23,24,25,26)]
result1 <- cor(df1, method = "spearman")
write.csv(result1,"RAI/result1cor.csv")

library(Hmisc)
res <- rcorr(as.matrix(df1))

res$r #相关性系数
res$n #样本个数
res$P #p值

# 矩阵转为数据框，筛选相关系数绝对值大于0.5的变量
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

flattenCorrMatrix(res$r, res$P)

df2 <- flattenCorrMatrix(res$r, res$P)
abs(df2$cor) > 0.5
df3 <- df2[abs(df2$cor) > 0.5,]
df4 <- df2[abs(df2$cor) > 0.4,]
write.csv(df3,"RAI/cor_abs_0.5.csv")
write.csv(df3,"RAI/cor_abs_0.4.csv")


# 作图
library(corrplot)
corrplot(res$r,type="upper",tl.col ="black",tl.srt = 45)

# 或者热图
col<-colorRampPalette(c("blue","white","red"))(20)
heatmap(x=res$r,col=col,symm=T)
heatmap(x=res$r,col=col,symm=F)
