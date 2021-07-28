# -*- coding: utf-8 -*-
"""
Created on Thu Jul 22 10:08:35 2021

@author: David Mora Salazar
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import yfinance as yf
import pandas_datareader as pdr
from arch.unitroot import VarianceRatio
from statsmodels.formula.api import ols
from statsmodels.iolib.summary2 import summary_col
from scipy.stats import f
from statsmodels.graphics.regressionplots import abline_plot
plt.style.use('seaborn')

empresas = ["RTX"]

tickers = ' '.join(empresas)

precios = yf.download(tickers,threads= False, start = "2001-05-01", end = "2021-06-01",
interval = "1mo").dropna(how = 'all')['Adj Close'].iloc[:-1]
precios.index = pd.to_datetime(precios.index, format='%m.%d.%Y %H:%M:%S')

precioscierre = yf.download(tickers,threads= False, start = "2011-9-01", end = "2020-11-01",
interval = "1mo").dropna(how = 'all')['Close'].iloc[:-1]
precioscierre.index = pd.to_datetime(precioscierre.index, format='%m.%d.%Y %H:%M:%S')

shares = []
for str in empresas:
    stock = yf.Ticker(str)
    shares.append(stock.info.get('sharesOutstanding'))
shares=pd.DataFrame(shares)
shares.columns=["Acciones"] 
shares["Empresas"] = empresas
shares_sorted=shares.sort_values('Empresas')
shares_sorted.reset_index(drop=True, inplace=True)
capitalización = []
empresas = pd.DataFrame(empresas)
empresas_sorted = empresas.sort_values(0)
empresas_sorted.reset_index(drop=True, inplace=True)

crsp = pdr.famafrench.FamaFrenchReader('F-F_Research_Data_Factors', start = "2001-05", end = "2021-06", freq = 'M').read()[0]/100
crsp = crsp.merge(pdr.famafrench.FamaFrenchReader('F-F_Momentum_Factor', start = '2001-05', end = '2021-06', freq = 'M').read()[0]/100,
left_index = True, right_index = True)
crsp.index = crsp.index.to_timestamp()


precios.to_excel("preciosfinal1.xlsx")  

shares.to_excel("sharesfinal1.xlsx")

crsp.to_excel("crspfinal.xlsx")

precioscierre.to_excel("precioscierre.xlsx")
