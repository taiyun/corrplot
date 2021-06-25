data(mtcars)
M = cor(mtcars)

r = rbind(c('gear', 'wt', 'qsec', 'carb'),
        c('wt', 'gear', 'carb', 'qsec'))
corrplot(M, order = 'AOE') -> p
corrRect(p, namesMat = r)

# same as using pipe operator `|>`
if(getRversion() >= '4.1.0') {
  corrplot(M, order = 'AOE') |> corrRect(namesMat = r)
}


r = c('gear', 'carb', 'qsec', 'wt')
corrplot(M, order = 'AOE', type='lower') -> p
corrRect(p, namesMat = r)

# same as using pipe operator `|>`
if(getRversion() >= '4.1.0') {
  corrplot(M, order = 'AOE', type='lower') |>
    corrRect(namesMat = r)
}


corrplot(M, order = 'hclust', type = 'upper') -> p
corrRect(p, index = c(1, 6, 11))

# same as using pipe operator
if(getRversion() >= '4.1.0') {
  corrplot(M, order = 'AOE', type='lower') |>
    corrRect(index = c(1, 6, 11))
}


corrplot(M, order = 'hclust') -> p
corrRect(p, name = c('carb', 'qsec', 'gear'))

# same as using pipe operator
if(getRversion() >= '4.1.0') {
  corrplot(M, order = 'hclust') |>
    corrRect(name = c('carb', 'qsec', 'gear'))
}




(order.hc = corrMatOrder(M, order = 'hclust'))
(order.hc2 = corrMatOrder(M, order = 'hclust', hclust.method = 'ward.D'))
M.hc  = M[order.hc, order.hc]
M.hc2 = M[order.hc2, order.hc2]

par(ask = TRUE)

# same as: corrplot(M, order = 'hclust', addrect = 2)
corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 2)

# same as: corrplot(M, order = 'hclust', addrect = 3)
corrplot(M.hc)
corrRect.hclust(corr = M.hc, k = 3)

# same as: corrplot(M, order = 'hclust', hclust.method = 'ward.D', addrect = 2)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 2, method = 'ward.D')

# same as: corrplot(M, order = 'hclust', hclust.method = 'ward.D', addrect = 3)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 3, method = 'ward.D')

# same as: corrplot(M, order = 'hclust', hclust.method = 'ward.D', addrect = 4)
corrplot(M.hc2)
corrRect.hclust(M.hc2, k = 4, method = 'ward.D')
