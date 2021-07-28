library(readxl)
library(dplyr)
library(caTools)
install.packages("writexl")
library("writexl")

reg <- read_excel("C:/Users/David Mora Salazar/Documents/ECONOMÍA UNIVERSIDAD DE COSTA RICA/Economía Financiera/Examen práctico/FINAL/final rendimientos ajustados.xlsx", sheet = "Rendimientos")


#Obtener rendimiento en exceso para las acciones
for(i in c(2:7)){
  reg[i] <- reg[i]-reg$rf
}
reg[2:7][is.na(reg[2:7])] <- 0
colnames(reg)[7] <- "CRSP"



#Regresiones: modelo de Sharpe
#Betas con el índice de mercado
#model <- lm(APD ~rmt, data = reg)
#summary(model)
mercado <- lapply(reg[,2:7], function(x) { 
  a <- lm(x ~ rmt, data=reg)
  coefficients(a)
})
#Betas con el índice de S&P500
mercadoCRSP <- lapply(reg[,2:7], function(x) { 
  a <- lm(x ~ CRSP, data=reg)
  coefficients(a)
})


betas_mercado <- data.frame(do.call(rbind, mercado))
betas_CRSP <- data.frame(do.call(rbind, mercadoCRSP))

#Estadisticos t: modelo de Sharpe
tEstadis <- lapply(reg[,2:7], function(x) { 
  b <- summary(lm(x ~ rmt, data=reg))
  b$coefficients[,"t value"]
})

tSharpe <- data.frame(do.call(rbind, tEstadis))

#PVALUE: modelo de Sharpe
PVALUE <- lapply(reg[,2:7], function(x) { 
  b <- summary(lm(x ~ rmt, data=reg))
  b$coefficients[,"Pr(>|t|)"]
})
PSharpe <- data.frame(do.call(rbind, PVALUE))

#Estadisticos t: modelo de Sharpe
tEstadis1 <- lapply(reg[,2:7], function(x) { 
  b <- summary(lm(x ~ CRSP, data=reg))
  b$coefficients[,"t value"]
})

tSharpe1 <- data.frame(do.call(rbind, tEstadis1))

#PVALUE: modelo de Sharpe
PVALUE1 <- lapply(reg[,2:7], function(x) { 
  b <- summary(lm(x ~ CRSP, data=reg))
  b$coefficients[,"Pr(>|t|)"]
})
PSharpe1 <- data.frame(do.call(rbind, PVALUE1))

#Unir dataframe 
betas_mercado <- betas_mercado %>% 
  rename(ZMercadoSharpe=rmt) 

betas_CRSP <- betas_CRSP %>% 
  rename(ZCRSPSharpe=CRSP) 

tSharpe <- tSharpe %>% 
  rename(tMercadoSharpe=rmt) 

PSharpe <- PSharpe %>% 
  rename(pMercadoSharpe=rmt) 

tSharpe1 <- tSharpe1 %>% 
  rename(tCRSPSharpe=CRSP) 

PSharpe1 <- PSharpe1 %>% 
  rename(pZCRSPSharpe=CRSP) 

BetasSharpe <- merge(betas_mercado, betas_CRSP, by=0, sort=FALSE)
EstimadoresSharpeMercado <- merge(tSharpe, PSharpe, by=0, sort=FALSE)
EstimadoresSharpeCRSP <- merge(tSharpe1, PSharpe1, by=0, sort=FALSE)
#Se descargan los datos a excel
write_xlsx(EstimadoresSharpeMercado,"C:/Users/David Mora Salazar/Documents/ECONOMÍA UNIVERSIDAD DE COSTA RICA/Economía Financiera/Examen práctico/EstimadoresSharpeMercado.xlsx")


#Regresiones: modelo de FFC

regress <- lapply(reg[,2:5], function(x) { 
  a <- lm(x ~ zm + zs + zv + zmom, data=reg)
  coefficients(a)
})

betasFFC <- data.frame(do.call(rbind, regress))

#Estadisticos t: modelo de Sharpe

tEstadis2 <- lapply(reg[,2:5], function(x) { 
  b <- summary(lm(x ~ zm + zs + zv + zmom, data=reg))
  b$coefficients[,"t value"]
})


tFFC <- data.frame(do.call(rbind, tEstadis2))

#Unir dataframe 

betasFFC <- betasFFC %>% 
  subset(select= -c(1))


tFFC <- tFFC %>% 
  rename(
         tm =zm,
         tSMB=zs,
         tHML=zv,
         tMOM=zmom
  ) %>% 
  subset(select= -c(1))

#PVALUE: 
PVALUEFFC <- lapply(reg[,2:5], function(x) { 
  b <- summary(lm(x ~ zm + zs + zv + zmom, data=reg))
  b$coefficients[,"Pr(>|t|)"]
})
PFFC <- data.frame(do.call(rbind, PVALUEFFC))

PFFC <- PFFC %>% 
FFCfinal <- merge(betasFFC, tFFC, by=0, sort=FALSE)

#Se vuelve a correr solo los significativos
CMCSA <- summary(lm(CMCSA ~ zm + zs+zmom, data=reg))
EMR<- summary(lm(EMR ~ zm+ zv + zs, data=reg))
RTN<- summary(lm(RTN ~ zm + zv + zmom, data=reg))
TEL<- summary(lm(TEL ~ zm + zv + zs, data=reg))

#Se vuelve a correr solo los significativos
CMCSA1 <- summary(lm(CMCSA ~ zm + zs, data=reg))
EMR1<- summary(lm(EMR ~ zm + zs, data=reg))
RTN1<- summary(lm(RTN ~ zm + zv + zmom, data=reg))
TEL1<- summary(lm(TEL ~ zm + zv , data=reg))

#Se descargan los datos a excel
write_xlsx(FFCfinal,"C:/Users/David Mora Salazar/Documents/ECONOMÍA UNIVERSIDAD DE COSTA RICA/Economía Financiera/Examen práctico/FINAL/FFCfinal.xlsx")
write_xlsx(PFFC,"C:/Users/David Mora Salazar/Documents/ECONOMÍA UNIVERSIDAD DE COSTA RICA/Economía Financiera/Examen práctico/PFFC.xlsx")





