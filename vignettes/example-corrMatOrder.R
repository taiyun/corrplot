M <- cor(mtcars)

(order.AOE <- corrMatOrder(M, order = "AOE"))
(order.FPC <- corrMatOrder(M, order = "FPC"))
(order.hc <- corrMatOrder(M, order = "hclust"))
(order.hc2 <- corrMatOrder(M, order = "hclust", hclust.method = "ward"))

M.AOE <- M[order.AOE,order.AOE]
M.FPC <- M[order.FPC,order.FPC]
M.hc  <- M[order.hc, order.hc]
M.hc2 <- M[order.hc2,order.hc2]



par(ask = TRUE)
corrplot(M)
corrplot(M.AOE)
corrplot(M.FPC)
corrplot(M.hc)

corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 2)

corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 3)

corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 2, method = "ward")
