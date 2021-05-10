data(mtcars)
M <- cor(mtcars)
corrplot(M, method = "circle", order = "FPC")
corrRect(c(5,6))

(order.hc <- corrMatOrder(M, order = "hclust"))
(order.hc2 <- corrMatOrder(M, order = "hclust", hclust.method = "ward.D2"))
M.hc  <- M[order.hc, order.hc]
M.hc2 <- M[order.hc2, order.hc2]

par(ask = TRUE)

# same as: corrplot(M, order = "hclust", addrect = 2)
corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 2)

# same as: corrplot(M, order = "hclust", addrect = 3)
corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 3)

# same as: corrplot(M, order = "hclust", hclust.method = "ward.D2", addrect = 2)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 2, method = "ward.D2")

# same as: corrplot(M, order = "hclust", hclust.method = "ward.D2", addrect = 3)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 3, method = "ward.D2")

# same as: corrplot(M, order = "hclust", hclust.method = "ward.D2", addrect = 4)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 4, method = "ward.D2")
