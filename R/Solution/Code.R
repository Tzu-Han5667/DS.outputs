#Q1

protein <- read.csv('/Users/B/Desktop/textbook/2 Stat data/Coursework/protein.csv',header=TRUE)
head(protein)
attach(protein)

#(a)level
levels(Country)
#(a)summary
summary(protein[2:10])
max(RedMeat)
min(WhiteMeat)
median(Eggs)
quantile(Milk, 0.25)
quantile(Fish, 0.75)
mean(Cereals)
max(Starch)
min(Nuts)
median(Fr.Veg)

#(b)plot
par(mfrow=c(1,1))
boxplot(protein[2:10])

#(c)association
cor(protein[,10], y= protein[,2:9])

#(d)plot of association
par(mfrow=c(2,4))
for (i in 2:9){
  plot(Fr.Veg,protein[,i],xlab = 'Fr.Veg',ylab = names(protein)[i])
}

#(e)confidenence level
for (i in 2:dim(protein)[2]){
  print(paste("95% Confidence interval for", names(protein)[i]))
  print(t.test(protein[,i],conf.level = 0.95)$conf.int) 
}

#(f)t test
length(Country) #25<30, use t test
t.test(Starch, alternative="greater",mu = mean(Nuts), conf.level=0.95,var.equal=TRUE)

#Q2

DP <- read.csv('/Users/B/Desktop/textbook/2 Stat data/Coursework/DartPoints.csv', header = TRUE)
head(DP)
attach(DP)

#(a)scaling
DP_scale <- scale(DP[3:9])
head(DP_scale)

#(b)plot relationship between Length & each other variables
par(mfrow=c(2,3))
for (i in 4:9){
  plot(Length, DP_scale[,i-2],xlab = 'Length', ylab = names(DP)[i])
  abline(lm(DP_scale[,i-2]~Length))
}

plot(Length, DP[,2],xlab = 'Length', ylab = 'Name')
for (i in 10:15){
  plot(Length, DP[,i],xlab = 'Length', ylab = names(DP)[i])
}

#(c)
# Width=DP[4]
# Thickness=DP[5]
# Weight=DP[9]
#(c)variables have strong relationship with Length
asso_item <- c(4,5,9)
for (i in asso_item){
  cor1 <- cor(Length, DP_scale[,i-2],use = "complete.obs")
  print(paste("Correlation between Length &", names(DP)[i]))
  print(cor1)
}

#(d)frequency of distribution of Weight
weight_class<-rep(NA,dim(DP)[1])
weight_class[which(Weight<=quantile(Weight,0.25))]<-"0-25%"
weight_class[which(Weight>quantile(Weight,0.25) & Weight<=mean(Weight))]<-"25%-50%"
weight_class[which(Weight>mean(Weight) & Weight<=quantile(Weight,0.75))]<-"50%-75%"
weight_class[which(Weight>quantile(Weight,0.75))]<-"75%+"
weight_class<-factor(weight_class,levels=c("0-25%","25%-50%","50%-75%","75%+"))
blade_sh <-factor(Blade.Sh,levels=c("E","I","R","S"))

par(mfrow=c(2,2))

#for blade.Sh=E
table(blade_sh,weight_class)[1,]/length(which(blade_sh=='E'))
barplot(table(blade_sh,weight_class)[1,]/length(which(blade_sh=='E')),main="Blade shape = E",xlab = "Weight", ylab = "Relative Freq.")

#for blade.Sh=I
table(blade_sh,weight_class)[2,]/length(which(blade_sh=='I'))
barplot(table(blade_sh,weight_class)[2,]/length(which(blade_sh=='I')),main="Blade shape = I",xlab = "Weight", ylab = "Relative Freq.")

#for blade.Sh=R
table(blade_sh,weight_class)[3,]/length(which(blade_sh=='R'))
barplot(table(blade_sh,weight_class)[3,]/length(which(blade_sh=='R')),main="Blade shape = R",xlab = "Weight", ylab = "Relative Freq.")

#for blade.Sh=S
table(blade_sh,weight_class)[4,]/length(which(blade_sh=='S'))
barplot(table(blade_sh,weight_class)[4,]/length(which(blade_sh=='S')),main="Blade shape = S",xlab = "Weight", ylab = "Relative Freq.")

#(e)find multiple regression model
Name<- as.factor(Name)
Blade.Sh<- as.factor(Blade.Sh)
Base.Sh<-as.factor(Base.Sh)
Should.Sh<- as.factor(Should.Sh)
Should.Or<- as.factor(Should.Or)
Haft.Sh<-as.factor(Haft.Sh)
Haft.Or<-as.factor(Haft.Or)

Name.D<-as.double(Name=="Darl")
Name.E<-as.double(Name=="Ensor")
Name.P<-as.double(Name=="Pedernales")
Name.T<-as.double(Name=="Travis")
Name.W<-as.double(Name=="Wells")
Blade.Sh.E<-as.double(Blade.Sh=="E")
Blade.Sh.I<-as.double(Blade.Sh=="I")
Blade.Sh.R<-as.double(Blade.Sh=="R")
Blade.Sh.S<-as.double(Blade.Sh=="S")
Base.Sh.E<-as.double(Base.Sh=="E")
Base.Sh.I<-as.double(Base.Sh=="I")
Base.Sh.R<-as.double(Base.Sh=="R")
Base.Sh.S<-as.double(Base.Sh=="S")
Should.Sh.E<-as.double(Should.Sh=="E")
Should.Sh.I<-as.double(Should.Sh=="I")
Should.Sh.S<-as.double(Should.Sh=="S")
Should.Sh.X<-as.double(Should.Sh=="X")
Should.Or.B<-as.double(Should.Or=="B")
Should.Or.H<-as.double(Should.Or=="H")
Should.Or.T<-as.double(Should.Or=="T")
Should.Or.X<-as.double(Should.Or=="X")
Haft.Sh.A<-as.double(Haft.Sh=="A")
Haft.Sh.E<-as.double(Haft.Sh=="E")
Haft.Sh.I<-as.double(Haft.Sh=="I")
Haft.Sh.R<-as.double(Haft.Sh=="R")
Haft.Sh.S<-as.double(Haft.Sh=="S")
Haft.Or.C<-as.double(Haft.Or=="C")
Haft.Or.E<-as.double(Haft.Or=="E")
Haft.Or.P<-as.double(Haft.Or=="P")
Haft.Or.T<-as.double(Haft.Or=="T")
Haft.Or.V<-as.double(Haft.Or=="V")

lm0<-lm(Weight~Name+Length+Width+Thickness+B.Width+J.Width+H.Length+Blade.Sh+Base.Sh+Should.Sh+Should.Or+Haft.Sh+Haft.Or)
summary(lm0)

lm1<-lm(Weight~Length+Width+Name*Blade.Sh,data=DP)
summary(lm1)

lm2<-lm(Weight~Length+Width+Name*Base.Sh,data=DP)
summary(lm2)

lm3<-lm(Weight~Length+Width+Name*Should.Sh,data = DP)
summary(lm3)

lm4<-lm(Weight~Length+Width+Name*Should.Or,data=DP) 
summary(lm4)
model4<-lm(Weight~Length+Width+Name.T) 
summary(model4) 
###Name.T

lm5<-lm(Weight~Length+Width+Name*Haft.Sh,data=DP)
summary(lm5) 
#repeat

lm6<-lm(Weight~Length+Width+Name*Haft.Or,data=DP)
summary(lm6)
model6<-lm(Weight~Length+Width+Name.W*Haft.Or.P)
summary(model6) 
model6<-lm(Weight~Length+Width+Name.W:Haft.Or.P+Haft.Or.P) 
summary(model6)
### Name.W:Haft.Or.P+Haft.Or.P

lm7<-lm(Weight~Length+Width+Blade.Sh*Base.Sh,data=DP)
summary(lm7)

lm8<-lm(Weight~Length+Width+Blade.Sh*Should.Sh,data=DP)
summary(lm8)
model8<-lm(Weight~Length+Width+Blade.Sh.R*Should.Sh.I)
summary(model8) 
model8<-lm(Weight~Length+Width+Should.Sh.I+Blade.Sh.R:Should.Sh.I)
summary(model8) 
### Should.Sh.I+Blade.Sh.R:Should.Sh.I

lm9<-lm(Weight~Length+Width+Blade.Sh*Should.Or,data=DP) 
summary(lm9)
model9<-lm(Weight~Length+Width+Blade.Sh.S*Should.Or.H)
summary(model9) 
model9<-lm(Weight~Length+Width+Should.Or.H) 
summary(model9) 
###Should.Or.H

lm10<-lm(Weight~Length+Width+Blade.Sh*Haft.Sh,data=DP)
summary(lm10)
model10<-lm(Weight~Length+Width+Haft.Sh.R+Blade.Sh.R*Haft.Sh.E) 
summary(model10)
model10<-lm(Weight~Length+Width+Haft.Sh.R+Blade.Sh.R:Haft.Sh.E)
summary(model10)
###Haft.Sh.R+Blade.Sh.R:Haft.Sh.E

lm11<-lm(Weight~Length+Width+Blade.Sh*Haft.Or,data=DP) 
summary(lm11) 
model11<-lm(Weight~Length+Width+Blade.Sh.R*Haft.Or.P)
summary(model11)
###Blade.Sh.R*Haft.Or.P

lm12<-lm(Weight~Length+Width+Base.Sh*Should.Sh,data=DP)
summary(lm12)

lm13<-lm(Weight~Length+Width+Base.Sh*Should.Or,data=DP) 
summary(lm13)

lm14<-lm(Weight~Length+Width+Base.Sh*Haft.Sh,data=DP)
summary(lm14)
model14<-lm(Weight~Length+Width+Haft.Sh.R,data=DP)
summary(model14)
### Haft.Sh.R

lm15<-lm(Weight~Length+Width+Base.Sh*Haft.Or,data=DP)
summary(lm15)
model15<-lm(Weight~Length+Width+Haft.Or.T*Base.Sh.I+Base.Sh.S*Haft.Or.T,data=DP)
summary(model15) 
model15<-lm(Weight~Length+Width+Haft.Or.T+Haft.Or.T:Base.Sh.I+Haft.Or.T:Base.Sh.S,data=DP)
summary(model15) 
### Haft.Or.T+Haft.Or.T:Base.Sh.I+Haft.Or.T:Base.Sh.S

lm16<-lm(Weight~Length+Width+Should.Sh*Should.Or,data=DP) 
summary(lm16)

lm17<-lm(Weight~Length+Width+Should.Sh*Haft.Sh,data=DP)
summary(lm17)

lm18<-lm(Weight~Length+Width+Should.Sh*Haft.Or,data=DP)
summary(lm18)
model18<-lm(Weight~Length+Width+Should.Sh.I*Haft.Or.V)
summary(model18)
model18<-lm(Weight~Length+Width+Should.Sh.I:Haft.Or.V)
summary(model18)

lm19<-lm(Weight~Length+Width+Should.Or*Haft.Sh,data=DP) 
summary(lm19) 
model19<-lm(Weight~Length+Width+Haft.Sh.R,data=DP)
summary(model19)
### repeat

lm20<-lm(Weight~Length+Width+Should.Or*Haft.Or,data=DP) 
summary(lm20)
model20<-lm(Weight~Length+Width+Should.Or.H*Haft.Or.P,data=DP)
summary(model20) 
model20<-lm(Weight~Length+Width+Should.Or.H+Should.Or.H:Haft.Or.P,data=DP) 
summary(model20)
### Should.Or.H+Should.Or.H:Haft.Or.P

lm21<-lm(Weight~Length+Width+Haft.Sh*Haft.Or,data=DP)
summary(lm21)

#build final model
model.1<-lm(Weight~Length+Width
            +Name.T+Should.Sh.I+Should.Or.H+Haft.Sh.R+Haft.Or.P+Haft.Or.T
            +Name.W:Haft.Or.P+Blade.Sh.R:Should.Sh.I+Blade.Sh.R:Haft.Sh.E+Should.Or.H:Haft.Or.P+Haft.Or.T:Base.Sh.I+Haft.Or.T:Base.Sh.S
            +Blade.Sh.R*Haft.Or.P)
summary(model.1)

model.2<-lm(Weight~Length+Width
            +Name.T+Should.Or.H+Haft.Or.T
            +Name.W:Haft.Or.P+Should.Or.H:Haft.Or.P+Haft.Or.T:Base.Sh.I+Haft.Or.T:Base.Sh.S)
summary(model.2)

model.3<-lm(Weight~Length+Width
            +Name.T+Should.Or.H+Haft.Or.T
            +Should.Or.H:Haft.Or.P+Haft.Or.T:Base.Sh.I+Haft.Or.T:Base.Sh.S)
summary(model.3)$coefficients

#(f)
par(mfrow=c(1,1))
plot(model.3)

#(g)
#Weight=  -8.8684728 + 0.1694280*Length + 0.3740638*Width + 1.1195626*Name.T - 2.6501723*Should.Or.H + 5.2381919*Haft.Or.T + 3.8259520 * Should.Or.H:Haft.Or.P-5.8306698*Haft.Or.T:Base.Sh.I-5.3581054*Haft.Or.T:Base.Sh.S)
#(h) predict weight within 0.95 confidence interval
newdata<-data.frame(Length=70,Width=60,Name.T=1,Should.Or.H=0,Haft.Or.T=0,Haft.Or.P=1,Haft.Or.T=0,Base.Sh.I=0,Base.Sh.S=0)
predict(model.3,newdata,df=80,interval = "confidence",level=0.95)


