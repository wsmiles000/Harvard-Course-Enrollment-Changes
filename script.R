library(tidyverse)
library(gt)
library(devtools)
library(readxl)
library(readr)
library(janitor)
library(viridis)
library(lubridate)

download.file(url = "https://registrar.fas.harvard.edu/files/fas-registrar/files/class_enrollment_summary_by_term_3.22.19.xlsx", destfile = "spring_19.xlsx")
download.file(url = "https://registrar.fas.harvard.edu/files/fas-registrar/files/class_enrollment_summary_by_term_03.06.18.xlsx", destfile = "spring_18.xlsx")
download.file(url = "http://registrar.fas.harvard.edu/files/fas-registrar/files/class_enrollment_summary_by_term_2017_03_07_final_0.xlsx", destfile = "spring_17.xlsx")
download.file(url = "http://registrar.fas.harvard.edu/files/fas-registrar/files/course_enrollment_statistics_0.xlsx", destfile = "spring_16.xlsx")


spring_19 = clean_names(read_xlsx("spring_19.xlsx", skip=3))
spring_18 = clean_names(read_xlsx("spring_18.xlsx", skip=3))
spring_17 = clean_names(read_xlsx("spring_17.xlsx", skip=3))
spring_16 = clean_names(read_xlsx("spring_16.xlsx"))

spring_16 <- spring_16 %>%
  rename(course_title=course, course_department = department, total=total_enrollment, u_grad=hcol, grad=gsas, non_degree = nondgr, x_reg=xreg) %>%
  select(-class_nbr)



file.remove(c("spring_19.xlsx","spring_18.xlsx","spring_17.xlsx","spring_16.xlsx"))







