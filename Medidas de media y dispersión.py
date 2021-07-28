# -*- coding: utf-8 -*-
"""
Created on Tue Jul 27 13:35:58 2021

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
from datetime import datetime
data = pd.read_excel (r"C:\Users\David Mora Salazar\Documents\ECONOMÍA UNIVERSIDAD DE COSTA RICA\Economía Financiera\Examen práctico\FINAL\Rendimientos.xlsx")
#Medidas de dispersión y varianza
def sr_ic(x):
    return (x.quantile(.75) - x.quantile(.25))/2
def semivar(x):
    N = x.size
    mu = x.mean()
# estimated variance but just over values below the mean
    sv = (1.0/(N - 1.0))*np.sum((x[x < mu] - mu)**2)
    return sv
def range_(x):
    return x.max() - x.min()
def range_student(x):
    return (x.max() - x.min())/x.std()
def Sharpe(x):
    return (x.mean()-data["rf"].mean())/x.std()
def statistics(df):
    return df.agg(['count', 'mean', 'median', 'var', 'std', range_,range_student, sr_ic,semivar, 'mad', Sharpe]).T
statistics_df = statistics(data)
statistics_df=pd.DataFrame(statistics_df)
statistics_df.to_excel("mediaydispersión.xlsx")