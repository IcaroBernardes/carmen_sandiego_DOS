library(ggplot2)
library(ggfx)
library(ggpath)

ggplot()+ggfx::with_outer_glow(
  geom_from_path(aes(x=0,y=0,path="www/detective_raw.png"),height=0.9),
  colour = "black", 
  sigma=0,
  expand=10)+
  coord_equal(ratio = 1.4)+theme_void()

ggsave("www/detective.png", dpi = 320, width = 125, height = 190, units = "px")

ggplot()+ggfx::with_outer_glow(
  geom_from_path(aes(x=0,y=0,path="www/speechbubble_raw.png"),width=0.9),
  colour = "black", 
  sigma=0,
  expand=8)+
  coord_equal(ratio = 0.33)+theme_void()

ggsave("www/speechbubble.png", dpi = 320, width = 585, height = 140, units = "px")
