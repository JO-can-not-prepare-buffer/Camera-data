# glm for RAI#
# 广义线性回归分析 #

csvpath <- file.choose()
csvpath

df <- read.csv(csvpath, header = T, stringsAsFactors = FALSE)
df <- as.data.frame(df)
head(df)

# all season #----
glmG0 <- glm(cmcRAI ~ grassC+H_hided+
               humanRAI+livestockRAI+catRAI+foxRAI+
               Dis_house+Dis_road+Dis_shelter+Dis_county,
             family = gaussian,
             data = df)
summary(glmG0)
glmG01 <- step(glmG0)
summary(glmG01)

plot(glmG01, which = 1)
plot(glmG01, which = 2)
plot(glmG01, which = 3)
plot(glmG01, which = 4)

df2 <- df[-c(197, 205, 206),]

glm02 <- glm(cmcRAI ~ grassC+H_hided+
                 humanRAI+livestockRAI+catRAI+foxRAI+
                 Dis_house+Dis_road+Dis_shelter+Dis_county,
               family = gaussian,
               data = df2)
summary(glm02)
glm03 <- step(glm02)
summary(glm03)
a
