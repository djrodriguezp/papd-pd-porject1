library(dplyr)

dataset<-read.csv("dataset/volcanic_eruption_database.csv") %>%
          select(Year,
                 Flag.Tsunami,
                 Flag.Earthquake,
                 Volcano.Name,
                 Country,
                 Location,
                 Longitude,
                 Latitude,
                 Elevation,
                 Volcano.Type,
                 Status,
                 Volcanic.Explosivity.Index,
                 Volcano...Deaths,
                 Volcano...Damage..in.M..,
                 ) %>%
          rename("year" = Year) %>%
          rename("volcano_name" = Volcano.Name) %>%
          rename("flag_tsunami" = Flag.Tsunami) %>%
          rename("flag_earthquake" = Flag.Earthquake) %>%
          rename("location" = Location) %>%
          rename("longitude" = Longitude) %>%
          rename("latitude" = Latitude) %>%
          rename("elevation" = Elevation) %>%
          rename("volcano_type" = Volcano.Type) %>%
          rename("country" = Country) %>%
          rename("status" = Status) %>%
          rename("deaths" = Volcano...Deaths) %>%
          rename("explosivity_index" = Volcanic.Explosivity.Index) %>%
          rename("damage_millions_of_dollars" = Volcano...Damage..in.M..)

colors_list <- c("skyblue","orange","magenta","blue","red","gray", "brown")