# -*- coding: utf-8 -*-
"""
Created on Mon Jul 26 21:31:49 2021

@author: David Mora Salazar
"""
import pandas as pd
from arch.unitroot import VarianceRatio
data = pd.read_excel (r'C:\Users\David Mora Salazar\Documents\ECONOMÍA UNIVERSIDAD DE COSTA RICA\Economía Financiera\Examen práctico\FINAL\VR Test SPX.xlsx')
indice=data['SPX']
vr = VarianceRatio(indice.dropna(), 12, trend='n')
print(vr.summary().as_text())