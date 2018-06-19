plot2x2png = function(bedata, Var)
{
  if(!assert(bedata)) {
    cat("\n Subject count should be balanced!\n");
    return(NULL);
  }
  
  Si11 = bedata[bedata$GRP=="RT" & bedata$PRD==1, "SUBJ"]
  Si21 = bedata[bedata$GRP=="RT" & bedata$PRD==2, "SUBJ"]
  Si12 = bedata[bedata$GRP=="TR" & bedata$PRD==1, "SUBJ"]
  Si22 = bedata[bedata$GRP=="TR" & bedata$PRD==2, "SUBJ"]
  
  Yi11 = bedata[bedata$GRP=="RT" & bedata$PRD==1, Var]
  Yi21 = bedata[bedata$GRP=="RT" & bedata$PRD==2, Var]
  Yi12 = bedata[bedata$GRP=="TR" & bedata$PRD==1, Var]
  Yi22 = bedata[bedata$GRP=="TR" & bedata$PRD==2, Var]
  
  n1 = length(Yi11)
  n2 = length(Yi12)
  
  Y.11 = mean(Yi11)
  Y.21 = mean(Yi21)
  Y.12 = mean(Yi12)
  Y.22 = mean(Yi22)
  
  sY.11 = sd(Yi11)
  sY.21 = sd(Yi21)
  sY.12 = sd(Yi12)
  sY.22 = sd(Yi22)
  
  y.max = max(Y.11 + sY.11, Y.21 + sY.21, Y.12 + sY.12, Y.22 + sY.22, max(bedata[,Var])) * 1.2
  png(sprintf('%s-equivalence.png', Var), width = 960, height = 960)
  par(oma=c(1,1,3,1), mfrow=c(2,2))
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Period",  ylab=Var, main="(a) Individual Plot for Period")
  axis(2)
  axis(1, at=c(1,2))
  drawind(Yi11, Yi21, Yi12, Yi22, Si11, Si12)
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Treatment",  ylab=Var, main="(b) Individual Plot for Treatment")
  axis(2)
  axis(1, at=c(1,2), labels=c("Test", "Reference"))
  drawind(Yi21, Yi11, Yi12, Yi22, Si11, Si12)
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Period",  ylab=Var, main="(c) Mean and SD by Period")
  axis(2)
  axis(1, at=c(1,2))
  drawmeansd(Y.11, sY.11, Y.12, sY.12, Y.21, sY.21, Y.22, sY.22, y.max)
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Treatment",  ylab=Var, main="(d) Mean and SD by Treatment")
  axis(2)
  axis(1, at=c(1,2), labels=c("Test", "Reference"))
  drawmeansd(Y.21, sY.21, Y.12, sY.12, Y.11, sY.11, Y.22, sY.22, y.max)
  
  mtext(outer=T, side=3, paste("Equivalence Plot for", Var), cex=1.5)
  dev.off()
  
  png(sprintf('%s-box.png', Var), width = 960, height = 960)
  par(oma=c(1,1,3,1), mfrow=c(2,2))
  
  boxplot(Yi11, Yi21, Yi12, Yi22, names=c("PRD=1", "PRD=2", "PRD=1", "PRD=2"), cex.axis=0.85, main="(a) By Sequence and Period", sub="SEQ=RT           SEQ=TR")
  boxplot(c(Yi11, Yi21), c(Yi12, Yi22), names=c("Sequence=RT", "Sequence=TR"), main="(b) By Sequence")
  boxplot(c(Yi11, Yi12), c(Yi21, Yi22), names=c("Period=1", "Period=2"), main="(c) By Period")
  boxplot(c(Yi12, Yi21), c(Yi11, Yi22), names=c("Treatment=T", "Treatment=R"), main="(d) By Treatment")
  mtext(outer=T, side=3, paste("Box Plots for", Var), cex=1.5)
  dev.off()
}