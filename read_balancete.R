library(vroom)
library(tidyverse)

options(encoding = "latin1")
options(max.print=999999)
fwf_sample <- readr_example("fwf-sample.txt")
writeLines(read_lines("BALAN.txt"))

# You can specify column positions in several ways:
# 1. Guess based on position of empty columns
read_fwf(fwf_sample, fwf_empty(fwf_sample, col_names = c("first", "last", "state", "ssn")))
# 2. A vector of field widths
read_fwf(fwf_sample, fwf_widths(c(20, 10, 12), c("name", "state", "ssn")))
# 3. Paired vectors of start and end positions
read_fwf(fwf_sample, fwf_positions(c(1, 30), c(20, 42), c("name", "ssn")))
# 4. Named arguments with start and end positions
read_fwf(fwf_sample, fwf_cols(name = c(1, 20), ssn = c(30, 42)))
# 5. Named arguments with column widths
read_fwf(fwf_sample, fwf_cols(name = 20, state = 10, ssn = 12))




tt <- (readLines("BALAN.txt" ,encoding = "UFT-8"))

tt <- str_replace_all(tt,"\"","'")

tt21 <- tail(tt,-21)

tt21 <- head(tt21, -1)


 (writeLines(tt21))



sink(file = "texto.txt")
(tt21)
sink(file = NULL)

aaa <- as.data.frame(tt21)
balancete_siafi <- as.data.frame(  read.fortran("texto.txt",c("A8","A15","A40","A21","A1")))

write.csv2(balancete_siafi,"balancete.cvs")

balancete <- read_delim("balancete.cvs", 
                        delim = ";", escape_double = FALSE, locale = locale(decimal_mark = ",", 
                                                                            grouping_mark = ".", encoding = "latin1"), 
                        trim_ws = TRUE)
