p = read.csv("Population.csv")
p = p[!p$STATE == 0,]
p = p[,-(1:3)]
Year = as.numeric(c(rep("2011", 52),rep("2012", 52), rep("2013", 52), rep("2014", 52), rep("2015", 52), rep("2016", 52)))
state = as.factor(rep(p$STATE, 6))
state = factor(state)
stname = rep(p$NAME, 6)
population = as.numeric(c(p$POPESTIMATE2011, p$POPESTIMATE2012, p$POPESTIMATE2013, p$POPESTIMATE2014, p$POPESTIMATE2015, p$POPESTIMATE2016))
Rbirth = as.numeric(c(p$RBIRTH2011, p$RBIRTH2012, p$RBIRTH2013, p$RBIRTH2014, p$RBIRTH2015, p$RBIRTH2016))
Rdeath = as.numeric(c(p$RDEATH2011, p$RDEATH2012, p$RDEATH2013, p$RDEATH2014, p$RDEATH2015, p$RDEATH2016))
pop = data.frame(state, stname, Year, population, Rbirth, Rdeath)
