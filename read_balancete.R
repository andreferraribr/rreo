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

balancete <- balancete %>% mutate(valor = parse_number(V3, locale = locale(decimal_mark = ",", grouping_mark = ".")))

datatable(balancete) %>% formatCurrency(
  
  "valor",
  currency = "R$ ",
  interval = 3,
  mark = ".",
  digits = 2,
  dec.mark = getOption("OutDec"),
  before = TRUE,
  zero.print = NULL,
  rows = NULL
)

tabela_reais = function (df,coluna = NULL) {
  datatable((df)%>%
              # "row" para o total aparecer na linha, ou seja, totalizar os valores de uma coluna
              adorn_totals("row") ,
            filter = 'top', 
            rownames = FALSE,
            extensions = 'Buttons',
            options = list( 
              # order = list (df[(length(df))], 'desc'),
              dom = "Blfrtip",
              buttons = 
                list("copy", list(
                  extend = "collection",
                  buttons = c("csv", "excel", "pdf"),
                  text = "Download" ) ),
              lengthMenu = list( c(-1, 5, 10,20),
                                 c( "tudo",5, 10, 20)),
              pageLength = -1 )
  )%>%
    formatRound(
      # formatar apenas as colunas numericas.
      # sapply para identificar as colunas numericas e combinar com o parametro COLUNA
      # ((ncol(df %>% select_if(is.character))+1):(ncol(df )+1)),
      # http://datamining.togaware.com/survivor/Remove_Non_Numeric.html
      (c(colnames(df[,sapply(df, is.numeric)]), coluna)),
      digits = 2,
      interval = 3,
      mark = ".",
      dec.mark = ","
    ) 
}



# library(readr)
# balancete_2 <- read_delim("balancete.csv", delim = ";", 
#                   escape_double = FALSE, locale = locale(decimal_mark = ",", 
#                                                          grouping_mark = "."), trim_ws = TRUE)


# sink(file = "texto.txt")
# (tt21)
# sink(file = NULL)
# 
# aaa <- as.data.frame(tt21)
# balancete_siafi <- as.data.frame(  read.fortran("texto.txt",c("A8","A15","A40","A21","A1")))
# 
# balancete_siafi <- as.data.frame(  read.fortran("texto.txt",c("A8","A15","A40","A21","A1")))
# 
# write.csv2(balancete_siafi,"balancete.cvs")
# 
# balancete <- read_delim("balancete.cvs", 
#                         delim = ";", escape_double = FALSE, locale = locale(decimal_mark = ",", 
#                                                                             grouping_mark = ".", encoding = "latin1"), 
#                         trim_ws = TRUE)
# 
# balancete <- read_delim("balancete_clean.txt", 
#                         delim = ";", escape_double = FALSE, locale = locale(decimal_mark = ",", 
#                                                                             grouping_mark = ".", encoding = "latin1"), 
#                         trim_ws = TRUE)
# 
# 
# library(dplyr)
# library(tidyr)
# 
# gg <- tt21 %>%
#   data.frame(tt21 = .) %>%
#   extract(tt21, c("x","y","z","w"), "^(\\a{15})(\\a{34})(\\a{21})(\\a{1})", remove = FALSE)
# 
# 
# 
