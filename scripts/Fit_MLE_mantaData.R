### Aim: 1 PSD per water type, with all data combined
### First extrapolate to largest sample size
### Second fit (bootstrap) power law distribution
### Thirs plot one graph per water type with xmin & slope, both with 2x SD

rm(list=ls())


library(dplyr)
library(poweRlaw)
library(ggplot2)
library(ggpubr)

distributions <- read.csv("C:/Users/kooi009/OneDrive - WageningenUR/University - PhD/Collaborations - ongoing/Coffin et al., RA California/cleanParticleData.csv")


sample_water <- distributions[which(distributions$Size_um <= 5000 &
                                      distributions$lower_size_limit_um >= 125 &
                                      distributions$Size_um >= 125 &
                                      distributions$MorphologicalCategory != "Fiber"),]



df <- sample_water

df.bs.all <- data.frame(gof = numeric(), xmin = numeric(), pars = numeric(),
                        ntail = numeric(),watertype = numeric())

df.plot.all <- data.frame(x = numeric(), y = numeric(), watertype = numeric())


## bootstrap the results
for(i in unique(df$matrix)){

  df.temp <- df[which(df$matrix==i),]
  ## make into continuous powerlaw object and estimate parameters
  df.pl <- conpl$new(na.omit(df.temp$Size_um)) 
  
  ## bootstrap fit
  bs <- bootstrap(df.pl, no_of_sims =100, threads = 2, xmax = 2E12)
  bs.res <- bs$bootstraps
  bs.res$watertype <- i
  
  ## save bootstrapped results in df 
  df.bs.all <- rbind(df.bs.all, bs.res)
  
  ## CDF results from the conpl object (makes a figure - could be turned off?)
  df.plot <- plot(df.pl)
  df.plot$watertype <- i
  
  df.plot.all<- rbind(df.plot.all, df.plot)
}


## functions to calculate mean, min and max slope
pwr <- function(x, alpha) (x/xmin.plot)^(-alpha+1)

## size range for which to generate pwr results
x <- seq(from = 125, to = 5000, by = 1)

### theme plot ####
p.theme <- theme( 
  axis.text = element_text(size = 10, colour = "black"),
  strip.text.x = element_text(size = 10, color =  "black"),
  strip.text.y = element_text(size = 10),
  axis.title = element_text(size = 10),
  panel.grid.major.x = element_blank(),
  panel.grid.major.y = element_line(size = .1, color = "grey75"),
  panel.grid.minor.y = element_line(size = .05, color = "grey85"),
  panel.grid.minor = element_blank(),
  strip.background = element_rect(fill = "white"),
  panel.border = element_rect(colour="black", size=1, fill = NA),
  panel.background = element_rect(fill = "white"),
  axis.ticks.length=unit(0.1,"cm"),
  axis.text.x  = element_text(angle = 0, hjust = 0.5),
  legend.position = "none",
  legend.box = "horizontal",
  legend.background = element_rect(fill = alpha("pink", alpha = 0)),
  legend.key = element_rect(fill = "white"),
  #legend.key.height = unit(0.5, "cm"),
  legend.key.width = unit(1.7, "cm"),
  legend.text = element_text(size = 10, colour = " black"),
  legend.title = element_blank()
)

## some empty dataframes to fill with the data that make it easier to plot

df.bs.plot <- data.frame(mean.xmin = numeric(),
                         sd.xmin = numeric(),
                         mean.alpha = numeric(),
                         sd.alpha = numeric(),
                         xmin.plot = numeric(),
                         watertype = numeric(),
                         n.obs = numeric()
)

df.pwr.plot <- data.frame(x = numeric(),
                          y = numeric(),
                          y.min = numeric(),
                          y.max = numeric(),
                          watertype = numeric())

df.pwr.plot.valid <- data.frame(x = numeric(),
                                y = numeric(),
                                y.min = numeric(),
                                y.max = numeric(),
                                watertype = numeric())


for(i in unique(df.bs.all$watertype)){
  
  ## call upon results from previous for-loop (or imported after saving)
  df.plot <- df.plot.all[which(df.plot.all$watertype == i),]
  bs.res <- df.bs.all[which(df.bs.all$watertype == i), ]
  
  ## xmin value for which the fitted function is valid (the intercept - so you can plot)
  ## first find the probability that maches with where the mean xmin intersects with the data
  ## next calculate the xmin that would fit with this probability (where would it equal 1) 
  P.xmin <- df.plot[which.min(abs(mean(bs.res$xmin)-df.plot$x)),]$y
  xmin.plot = mean(bs.res$xmin)/(P.xmin^(1/(-mean(bs.res$pars) + 1)))
  
  bs.temp <- cbind(mean(bs.res$xmin), sd(bs.res$xmin), 
                   mean(bs.res$pars), sd(bs.res$pars),
                   xmin.plot, i, nrow(df.plot))
  
  colnames(bs.temp) <- c("mean.xmin", "sd.xmin", "mean.alpha", "sd.alpha", "xmin.plot", "watertype", "n.obs")
  df.bs.plot <- rbind(df.bs.plot, bs.temp)
  
  ## dataframe with values based on fitted mean bs results
  df.pwr <- data.frame(x = x, y = pwr(x, mean(bs.res$pars)))
  df.pwr$y.min <- pwr(x, mean(bs.res$pars) - 2*sd(bs.res$pars))
  df.pwr$y.max <- pwr(x, mean(bs.res$pars) + 2*sd(bs.res$pars))
  df.pwr$watertype <- i
  
  ## two dataframes, one only until xmin, the other all the way to 10 um
  df.pwr.valid <- df.pwr[which(df.pwr$x > mean(bs.res$xmin)),]
  
  df.pwr.plot <- rbind(df.pwr.plot, df.pwr)
  df.pwr.plot.valid <- rbind(df.pwr.plot.valid, df.pwr.valid)
}

#lapply(df.bs.plot, class)

# ## given this + facet_wrap, we should be able to make it one figure. 
df.bs.plot[c("mean.xmin", "sd.xmin", "mean.alpha", "sd.alpha", "xmin.plot")] <- sapply(df.bs.plot[c("mean.xmin", "sd.xmin", "mean.alpha", "sd.alpha", "xmin.plot")], as.character)
df.bs.plot[c("mean.xmin", "sd.xmin", "mean.alpha", "sd.alpha", "xmin.plot")] <- sapply(df.bs.plot[c("mean.xmin", "sd.xmin", "mean.alpha", "sd.alpha", "xmin.plot")], as.numeric)


df.bs.plot$xmin.lim <- df.bs.plot$mean.xmin - 2*df.bs.plot$sd.xmin
df.bs.plot[!(df.bs.plot$xmin.lim > 1), "xmin.lim"] <- 1

## Plot the results
p <- ggplot(df.plot.all, aes(x = x, y = y))  + geom_point(alpha = 0.5) 
p <- p + facet_wrap(~watertype, ncol = 2)

## add xmin range (rectangle) and mean (segment)
p <- p + geom_rect(data = df.bs.plot, aes(x = NULL, y = NULL, xmin = xmin.lim, #mean.xmin - 2*sd.xmin,
                                          xmax = mean.xmin + 2*sd.xmin,
                                          ymin = 0, ymax = 1), alpha = 0.3, fill = "cadetblue4")

p <- p + geom_segment(data = df.bs.plot, aes(x = mean.xmin, xend = mean.xmin, 
                                             y = 0, yend = 1), color = "cadetblue4", lwd = 1) 

## add dotted slope that goes beyond xmin
p <- p + geom_line(data = df.pwr.plot, aes(x = x, y = y), lwd = 1, color = "chocolate1", linetype = "dotted")

## add line + 2*SD that stops at xmin
p <- p + geom_line(data = df.pwr.plot.valid, aes(x = x, y = y), lwd = 1, color = "chocolate3")
p <- p + geom_ribbon(data = df.pwr.plot.valid, aes(ymin = y.min, ymax = y.max), fill = "chocolate3", alpha = 0.3)

p <- p + p.theme + xlab("Length (\U003BCm)") + ylab ("P(X >= x)") 

p <- p + scale_y_log10() + scale_x_log10(breaks = c(125, 333, 1000, 3330, 5000))

p <- p + coord_cartesian(ylim = c(1e-3,1), xlim = c(125, 5000)) ## cut section

p




