library(vroom)
library(tidyverse)
library(janitor)

options(encoding = "latin1")
options(max.print=999999)




balan_siafi <- (readLines("BALAN.txt" ,encoding = "UFT-8"))

balan_siafi <- str_replace_all(balan_siafi,"\"","'")

balancete_clean <- tail(balan_siafi,-21)

balancete_clean <- head(balancete_clean, -1)


writeLines(balancete_clean, "balancete_clean.txt")    

balancete <- as.data.frame(  read.fortran("balancete_clean.txt",c("A15","A40","A21","A1")))
write_csv2(balancete,"balancete.csv")



names(balancete) <- c("conta_id_siafi","conta_siafi","saldo_siafi","tipo_saldo")

balancete <- balancete %>% mutate(saldo_siafi = parse_number(saldo_siafi, locale = locale(decimal_mark = ",", grouping_mark = ".")))

balancete <- balancete %>% mutate(conta_id = ( str_replace_all(balancete$conta_id_siafi, "[^[:alnum:]]", "")))

balancete$conta_id <- type.convert(balancete$conta_id)

datatable(balancete) %>% formatCurrency(
  
  "saldo_siafi",
  currency = "R$ ",
  interval = 3,
  mark = ".",
  digits = 2,
  dec.mark = getOption("OutDec"),
  before = TRUE,
  zero.print = NULL,
  rows = NULL
)

