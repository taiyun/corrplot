data(mtcars)
M <- cor(mtcars)


f=corrplot(M, order = "AOE")
r=rbind(c('gear', 'wt', 'qsec', 'carb'),
        c('wt', 'gear', 'carb', 'qsec'))
corrRect(namesMat=r, corrRes=f)


f=corrplot(M, method = "circle", order = "AOE", type='lower')
r=c('gear', 'carb', 'qsec', 'wt')
corrRect(namesMat=r, corrRes=f)


corrplot(M, method = "circle", order = "hclust")
corrRect(clus=c(5,6))

corrplot(M, method = "circle", order = "hclust")
corrRect(clus=c(5,3,3))

(order.hc <- corrMatOrder(M, order = "hclust"))
(order.hc2 <- corrMatOrder(M, order = "hclust", hclust.method = "ward.D"))
M.hc  <- M[order.hc, order.hc]
M.hc2 <- M[order.hc2, order.hc2]

par(ask = TRUE)

# same as: corrplot(M, order = "hclust", addrect = 2)
corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 2)

# same as: corrplot(M, order = "hclust", addrect = 3)
corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 3)

# same as: corrplot(M, order = "hclust", hclust.method = "ward.D", addrect = 2)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 2, method = "ward.D")

# same as: corrplot(M, order = "hclust", hclust.method = "ward.D", addrect = 3)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 3, method = "ward.D")

# same as: corrplot(M, order = "hclust", hclust.method = "ward.D", addrect = 4)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 4, method = "ward.D")
