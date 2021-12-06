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
          rename("country" = Country) %>%
          rename("deaths" = Volcano...Deaths) %>%
          rename("damage_millions_of_dollars" = Volcano...Damage..in.M..)