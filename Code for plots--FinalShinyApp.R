library(fpp3)
library(fabletools)

#Mean/Naive/Seasonal/Drift Models

myausproduction <- aus_production %>%
  filter_index("1992 Q1" ~ "2006 Q4")

mean_model <- myausproduction %>%
  model(Mean = MEAN(Beer))
Mean1 <- mean_model %>% forecast(h = 14)

naive_model <- myausproduction %>%
  model(Naive = NAIVE(Beer))
Naive1 <- naive_model %>% forecast(h = 14)

seasonalnaive_model <- myausproduction %>%
  model(SeasonalNaive = SNAIVE((Beer~lag("year"))))
Seasonal1 <- seasonalnaive_model %>% forecast(h = 14)

drift1_model <- myausproduction %>%
  model(drift1_model = RW((Beer~drift())))
Drift1 <- drift1_model %>% forecast(h = 14)

Mean <- Mean1 %>% autoplot(myausproduction)+
  labs(title = "Mean Model")
Naive <- Naive1 %>% autoplot(myausproduction)+
  labs(title = "Naive Model")
Seasonal <- Seasonal1 %>% autoplot(myausproduction)+
  labs(title = "Seasonal Naive Model")
Drift <- Drift1 %>% autoplot(myausproduction)+
  labs(title = "Drift Model")

#ExponentialSmoothing Model

myausarrivals <- aus_arrivals %>%
  filter(Origin == "Japan")
myausarrivals %>%
  autoplot(Arrivals) +
  labs(y = "Arrivals", title = "Australian Arrivals")


fit <- myausarrivals %>%
  model(ETS(Arrivals ~ error("A") + trend("N") + season("N")))
fc <- fit %>%
  forecast(h = 5)
ExpSmoothing <- fc %>%
  autoplot(myausarrivals) +
  geom_line(aes(y = .fitted), col="#FF8200",
            data = augment(fit)) +
  labs(y="Arrivals", title="Exponential Smoothing: Arrivals") +
  guides(color = "none") 
ExpSmoothing


#Holts/Winters Model

fit2 <- myausarrivals %>%
  model(
    AAN = ETS(Arrivals ~ error("A") + trend("N") + season("N"))
  )
fc2 <- fit2 %>% forecast(h = 10)


#SAVE OUR WORK!
save(myausproduction,myausarrivals,Mean,
     Naive,Seasonal,Drift,ExpSmoothing,file="Pwells-BAS475_Final.RData")




selectizeInput(InputId="ModelChoice",
               label="Select Your Model",
               choices = c("Mean","Naive","Seasonal","Drift"),
               selected= "Mean",
               inline = TRUE
)



##top of the shiny app
load("PWells-BAS475-FinalEnvironment.RData")
