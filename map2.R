####### packages ---------------------------
# install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", "ggspatial" , "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata"))
#         install.packages("rgeos")
#         install.packages("ggmap")

library("ggplot2")
# theme_set(theme_bw())
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")


# Maps information---------
asia <-
  ne_countries(
    scale = "medium",
    type = "countries",
    continent = "asia" ,
    returnclass = "sf"
  )
world <-
  ne_countries(scale = "medium",
               type = "countries" ,
               returnclass = "sf")

spdf_asia <- ne_countries(continent = 'asia')


# Counries point--------------
asia_points <- st_centroid(asia)
asia_points <-
  cbind(asia, st_coordinates(st_centroid(asia$geometry)))
world_points <- st_centroid(world)
world_points <-
  cbind(world, st_coordinates(st_centroid(world$geometry)))

#  plot 1 -------
world[world$name == "Iran", ]
world$Iran = 0
world$Iran[world$name == "Iran"] = 1


(
  m = ggplot(data = world, aes(fill = as.factor(Iran))) +
    geom_sf(aes(alpha = as.factor(Iran)), color = "white") + guides(fill = FALSE) +
    guides(alpha = FALSE) +
    scale_fill_manual(values = c("#669999", "red")) + theme_bw() +
    scale_alpha_manual(values = c(0.5, 1)) +
    theme(
      panel.background = element_blank(),
      panel.grid = element_blank()  ,
      panel.border = element_blank()
    )
)
ggsave("m.jpg",
       m,
       width = 10,
       height = 10,
       dpi = 600)




#  plot 2 (Asia) --------
library(ggspatial)
ggplot(data = asia) +
  geom_sf() +
  scale_fill_gradient(low = "light gray", high = "dark red") +
  theme_classic() +
  
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(
    location = "bl",
    which_north = "true",
    pad_x = unit(0.75, "in"),
    pad_y = unit(0.5, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  geom_text(
    data = asia_points,
    aes(x = X, y = Y, label = name),
    color = "black",
    fontface = "bold",
    check_overlap = FALSE
  ) +
  theme(
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  ) +
  theme(
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )
