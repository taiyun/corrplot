M = cor(mtcars)
ord = corrMatOrder(M, order = 'AOE')
M2 = M[ord, ord]


corrplot.mixed(M2)
corrplot.mixed(M2, lower = 'ellipse', upper = 'circle')
corrplot.mixed(M2, lower = 'square', upper = 'circle')
corrplot.mixed(M2, lower = 'shade', upper = 'circle')
corrplot.mixed(M2, tl.pos = 'lt')
corrplot.mixed(M2, tl.pos = 'lt', diag = 'u')
corrplot.mixed(M2, tl.pos = 'lt', diag = 'l')
corrplot.mixed(M2, tl.pos = 'n')
