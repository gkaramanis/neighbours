library(tidyverse)
library(geofacet)

countries <- read_csv("https://raw.githubusercontent.com/geodatasource/country-borders/master/GEODATASOURCE-COUNTRY-BORDERS.CSV")

wc_grid <- world_countries_grid1 %>% 
  separate(code_iso_3166_2, c("iso", "country_code"), sep = ":") %>% 
  select(name, country_code, col, row) 

countries_grid <- countries %>% 
  left_join(wc_grid) %>% 
  left_join(wc_grid, by = c("country_border_code" = "country_code"), suffix = c("_start", "_end")) %>% 
  filter(!is.na(col_start), !is.na(col_end))

ggplot(countries_grid, aes(x = col_start, y = row_start,
                           xend = col_end, yend = row_end)) +
  geom_segment() +
  geom_text(aes(label = country_code)) +
  scale_y_reverse() +
  coord_fixed() +
  theme_void()
