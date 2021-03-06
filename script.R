library(tidyverse)
library(ggthemes)
library(devtools)
library(readxl)
library(readr)
library(janitor)
library(viridis)
library(lubridate)

download.file(url = "https://registrar.fas.harvard.edu/files/fas-registrar/files/class_enrollment_summary_by_term_3.22.19.xlsx", destfile = "spring_19.xlsx")
download.file(url = "https://registrar.fas.harvard.edu/files/fas-registrar/files/class_enrollment_summary_by_term_03.06.18.xlsx", destfile = "spring_18.xlsx")



spring_19 = clean_names(read_xlsx("spring_19.xlsx", skip=3))
spring_18 = clean_names(read_xlsx("spring_18.xlsx", skip=3))


file.remove(c("spring_19.xlsx","spring_18.xlsx"))



course_change <- course_data %>% 
  filter(!is.na(course_department)) %>% 
  group_by(course_department, year) %>% 
  summarize(total_enrollment = sum(total)) %>% 
  mutate(enroll_change = total_enrollment - lag(total_enrollment, default=total_enrollment[1])) %>% 
  mutate(percent_change = enroll_change/lag(total_enrollment, default = total_enrollment[1])) 


course_change_2019 <- course_change %>% 
  filter(year ==  2019) %>% 
  filter(!course_department %in% c("General Education","Faculty of Arts & Sciences", "No Department", "Special Concentrations")) %>% 
  ungroup(course_department,year) %>% 
  group_by(year) %>% 
  top_n(10, wt=abs(enroll_change)) %>% 
  arrange(enroll_change) %>% 
  mutate(course_department = fct_rev(factor(course_department, levels = course_department[order(percent_change)])))
  

ggplot(course_change_2019, aes(x = percent_change, y = course_department, size = abs(enroll_change), color=percent_change>0)) +
  geom_point(alpha=.7)  + 
  
  scale_x_continuous(limit=c(-.6, 2), breaks = c(-.5, 0, .5, 1, 1.5, 2),
                     labels = c("-0.5%","0%", "0.5%", "1%", "1.5%","2%")) +
   
  scale_size_area(breaks=c(200,300,400),
                  labels = expression("200 students", "300 students", "400 students")) +
  scale_color_manual(values =c( "red", "green"), labels=c("Negative", "Positive")) +
  labs(title = "Largest Changes in Enrollment by Harvard Department ",
       subtitle = "Courses: Spring 2018 - Spring 2019",
       y = "Department",
       x = "Percent Change",
       caption = "Source: Harvard Registrar Enrollment Data") +
  
  guides(color = guide_legend(title="Direction of Change")) +
  
  guides(size = guide_legend(title="Change in Students")) +
  
  theme(legend.position = "right") +
  
  theme_fivethirtyeight()






