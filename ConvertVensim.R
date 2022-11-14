##### Meta #####

# Author: Andreas Hoehn
# Version: 1.0
# Date:  2022-11-14
# About: Transferring Vensim Models into deSolve-ready R Code

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [1] (install) load libraries ###
# install.packages(readsdr)
# install.packages(deSolve)
# install.packages(ggplot2)
library(readsdr)
library(deSolve)
library(ggplot2)

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [2] develop model in vensim ###
# preparatory step: develop a model in vensim OR use existing model
# convert the vensim SD model (".mdl") within vensim top bar -> model into a ".xmil"
# in this example, we work with a simple Customer model in Line with Duggan 2016

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [3] source the Customers.xmile model and convert it via readsdr::read_xmile ###
# ensure a correct file path, not tested for network drives 
filepath <- "C:/___Andreas_local/WORK/TRAINING/SD/VensimTest/Customers.xmile"
mdl      <- readsdr::read_xmile(filepath) 

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [4] explore what has been loaded and extract objects for feeding into deSolve 
summary(mdl)
str(mdl)
description        <- mdl$description
deSolve_components <- mdl$deSolve_components
graph_dfs          <- mdl$graph_dfs

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [5] feed all relevant information into deSolve ###
model_result <- data.frame(deSolve::ode(
  y = deSolve_components$stocks,                    # stock 
  times = seq(deSolve_components$sim_params$start,  # time frame - start
  deSolve_components$sim_params$stop,               # time frame - end
  by = deSolve_components$sim_params$dt),           # time frame - step   
  func = deSolve_components$func,                   # model functions
  parms = deSolve_components$consts,                # parameter "constants"
  method = "euler"))                                # method for solving

str(model_result)

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

### [6] plot results 
ggplot()+
  geom_line(data=model_result, aes(time,Losses),colour="red")+
  geom_line(data=model_result, aes(time,Recruits),colour="blue")+
  geom_line(data=model_result, aes(time,Customers),colour="black")+
  ylab("Losses (red), Recruits (blue), Stock (black)")+
  xlab("Year")+ 
  theme_bw()

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
