####################################
####Generating a simple dataset#####
####################################
rm(list=ls())
library(data.table)
library(splines)
library(FSA)
library(zoo)
library(boot)
library(plyr)
# Generate Data -  binary outcome Y, binary treatment indicator A
set.seed(1234) 
# number of subjects
N <- 1000
# number of time points
Ndat <-5
# parameters
# alpha0=0.5;alpha1=0.5;
# beta0=0;   beta1=-2;
# theta0=-7; theta1=0; theta2=0; theta3=0

alpha0=0.5;alpha1=0.5;
beta0=0;   beta1=-2;
theta0=-2; theta1=-2;theta2=-0.8;theta3=0

test2014<-data.frame()
for(s in 1:N){
  for (j in 1:Ndat){
    if(j == 1){
      L<-Y<-A<-t0<-NULL
      t0[j]<-j-1
      #Baseline covariate, does not vary within each subject, e.g. gender
      #Baseline L0, binary with equal chance
      L[j] <- rbinom(1, 1, 0.5)
      #Baseline exposure level, binary
      A[j] <- rbinom(1, 1, plogis(alpha0+alpha1*L[j]))
      Y[j] <- rbinom(1, 1, plogis(theta0+theta1*L[j]+theta2*A[j]))
    }
    else if(j >= 2){
      t0[j]<-j-1
      L[j]<- rbinom(1, 1, plogis(beta0+beta1*A[j-1]))
      A[j]<- rbinom(1, 1, plogis(alpha0+alpha1*L[j]))
      Y[j]<- rbinom(1, 1, plogis(theta0+theta1*L[j]+theta2*A[j]+theta3*A[j-1]))
    }
    {if (Y[j]==1){break}}
  } #end of j loop
  test2014 <- rbind(test2014,cbind(id=s,t0,L,A,Y))
}
test1<-data.table(test2014)
test1[,lag.A:= shift(A,1,0,type='lag'),by=id]

#Write the fake dataset into csv file
#write.table(test1, file="Path/test1.csv",sep=",")



