import excel "C:\Users\Admin\Desktop\kltn - Copy.xlsx", sheet("Sheet2") firstrow
encode( Chỉtiêu), gen(id)
xtset id Năm
drop if Chỉtiêu == "AGM" | Chỉtiêu == "HNG" | Chỉtiêu == "MSH" | Chỉtiêu == "GMC" | Chỉtiêu == "SMB" | Chỉtiêu == "HAG" | Chỉtiêu == "BAF" 
//| Chỉtiêu == "CMX"
summarize ROA ROE LnSIZE LnAGE LEV AST CR GDP I CPI E 
pwcorr ROA ROE LnSIZE LnAGE LEV AST CR GDP I CPI E,star(0.1)

reg ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E
eststo ols1
vif
reg ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E
eststo ols2
vif

xtreg ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, fe 
eststo fe1
xtreg ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, re 
eststo re1
xttest0
hausman fe1 re1

xtreg ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, fe 
eststo fe2
xtreg ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, re 
eststo re2
xttest0
hausman fe2 re2

// xtgls ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, panels(heter) corr(psar1) igls
// eststo fgls1
// xtgls ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, panels(heter) corr(psar1) igls
// eststo fgls2

reg ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, vce(cluster id)
eststo ols1_rob
reg ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, vce(cluster id)
eststo ols2_rob
xtreg ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, fe vce(cluster id)
eststo fe1_rob
xtreg ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, re vce(cluster id)
eststo re1_rob
xtreg ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, fe vce(cluster id)
eststo fe2_rob
xtreg ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, re vce(cluster id)
eststo re2_rob

xtabond2 ROA l.ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L2.ROA l1.LnSIZE LEV CR l1.AST GDP I CPI E, lag(2 3)) iv(LnAGE) twostep

xtabond2 ROA l.ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L2.ROA l.LnSIZE LEV CR AST GDP I CPI E, lag(2 3)) iv(LnAGE) twostep
eststo gmm1
xtabond2 ROE l.ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L2.ROE l1.LnSIZE LEV CR l1.AST GDP I CPI E, lag(2 4)) iv(LnAGE) twostep
eststo gmm2

xtabond2 ROE l.ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L2.ROE l2.LnSIZE l1.LEV CR l.AST GDP I CPI E, lag(2 3)) iv(LnAGE) twostep
eststo gmm2

xtabond2 ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L.L1ROA l.LnSIZE LEV CR l1.AST, lag(2 3)) iv(LnAGE GDP I CPI E) twostep
eststo gmm1
xtabond2 ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L.L1ROE l.LnSIZE l3.LEV l.CR GDP, lag(1 1)) iv(LnAGE CPI I E) twostep
eststo gmm2
xtabond2 ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L.L1ROE l2.LnSIZE l2.LEV CR AST GDP, lag(1 2)) iv(LnAGE) twostep
esttab gmm1 gmm2, r2 ar2 b(%12.4f) se(%12.4f) scalar(p ar2 p_ar2 p_hansen hansen F) star(* 0.10 ** 0.05 *** 0.01) nogaps brackets

xtabond2 ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L.L1ROE l.LnSIZE l3.LEV l.CR GDP, lag(1 1)) iv(LnAGE CPI I E) twostep
// xtabond2 ROA L1ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L1.L1ROA l.LnSIZE LEV CR AST GDP I CPI E, lag(2 3)) iv(LnAGE) twostep
// eststo gmm1
// xtabond2 ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L1.L1ROE l2.LnSIZE LEV CR l.AST GDP I CPI E, lag(2 4)) iv(LnAGE) twostep
// eststo gmm2

xtabond2 ROE L1ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, gmm(L1.L1ROE l.LnSIZE LEV CR l.AST GDP I CPI E, lag(2 3)) iv(LnAGE) twostep
eststo gmm2

esttab ols1_rob fe1_rob re1_rob gmm1, r2 ar2 b(%12.4f) se(%12.4f) scalar(p F) star(* 0.10 ** 0.05 *** 0.01) nogaps brackets
esttab ols2_rob fe2_rob re2_rob gmm2, r2 ar2 b(%12.4f) se(%12.4f) scalar(p F) star(* 0.10 ** 0.05 *** 0.01) nogaps brackets


esttab ols1 re1 fe1 fgls1, r2 ar2 b(%12.4f) se(%12.4f) scalar(p F) star(* 0.10 ** 0.05 *** 0.01) nogaps brackets
esttab ols2 re2 fe2 fgls2, r2 ar2 b(%12.4f) se(%12.4f) scalar(p F) star(* 0.10 ** 0.05 *** 0.01) nogaps bracket

reg ROA L.ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, vce(cluster id)
eststo ols1_rob

reg ROE L.ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, vce(cluster id)
eststo ols2_rob

xtreg ROA L.ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, fe vce(cluster id)
eststo fe1_rob

xtreg ROA L.ROA LnSIZE LnAGE LEV AST CR GDP I CPI E, re vce(cluster id)
eststo re1_rob

xtreg ROE L.ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, fe vce(cluster id)
eststo fe2_rob

xtreg ROE L.ROE LnSIZE LnAGE LEV AST CR GDP I CPI E, re vce(cluster id)
eststo re2_rob
