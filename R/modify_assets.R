library(ggplot2)
library(ggfx)
library(ggpath)
library(purrr)
library(glue)
library(stringr)
library(magick)

############################## Detective #######################################
ggplot()+ggfx::with_outer_glow(
  geom_from_path(aes(x=0,y=0,path="www/detective_raw.png"),height=0.9),
  colour = "black", 
  sigma=0,
  expand=10)+
  coord_equal(ratio = 1.4)+theme_void()
ggsave("www/detective.png", dpi = 320, width = 125, height = 190, units = "px")

################################# Locations ####################################
wrapped_loc <- function(image) {
  p = ggplot()+ggfx::with_outer_glow(
    geom_from_path(aes(x=0,y=0,path=glue::glue("www/raws/{image}")),width=0.9),
    colour = "black", 
    sigma=0,
    expand=10)+
    coord_equal(ratio = 205/325)+theme_void()
  image_name = stringr::str_remove(image, "_raw")
  ggsave(filename = glue::glue("www/wrapped/{image_name}"), plot = p, dpi = 320, width = 325, height = 205, units = "px")
}
img <- list.files("www/raws") %>% stringr::str_subset("_person", negate = TRUE)
purrr::walk(img, wrapped_loc)

wrapped_per <- function(image) {
  p = ggplot()+ggfx::with_outer_glow(
    geom_from_path(aes(x=0,y=0,path=glue::glue("www/raws/{image}")),height=0.9),
    colour = "black", 
    sigma=0,
    expand=10)+
    coord_equal(ratio = 185/130)+theme_void()
  image_name = stringr::str_remove(image, "_raw")
  ggsave(filename = glue::glue("www/wrapped/{image_name}"), plot = p, dpi = 320, width = 130, height = 185, units = "px")
}
img <- list.files("www/raws") %>% stringr::str_subset("_person")
purrr::walk(img, wrapped_per)

############################# Profiles #########################################
img <- list.files("www/profiles") %>% stringr::str_subset("_final", negate = TRUE)
bg <- c("black","black","#6172f3",
        "#107110","#828282","#6172f3",
        "#414141","#828282","#6172f3",
        "#414141")
out <- c("#DB0D0D","#DB0D0D","#DBBF5A",
         "#DB0D0D","#51DB78","#DBBF5A",
         "#7A85F5","#51DB78","#DBBF5A",
         "#7A85F5")

outliner <- function(image, bg, out) {
  image = stringr::str_remove(image, ".png")
  img_trans = magick::image_read(glue::glue("www/profiles/{image}.png")) %>% 
    image_fill(color = "transparent",refcolor = bg, fuzz = 10)
  
  img_trans %>% 
    image_modulate(brightness = 0) %>% 
    image_fill(color = "gray50", refcolor = "black", fuzz = 100) %>% 
    image_write(path = glue::glue("www/outlines/{image}_raw.png"))
  img_trans %>% 
    image_write(path = glue::glue("www/profiles/{image}_raw.png"))
  
  p = ggplot()+ggfx::with_outer_glow(
    geom_from_path(aes(x=0,y=0,path=glue::glue("www/profiles/{image}_raw.png")),height=0.8),
    colour = "black", 
    sigma=0,
    expand=10)+
    coord_equal(ratio = 242/201)+theme_void()
  ggsave(filename = glue::glue("www/profiles/{image}_wrap.png"), plot = p,
         dpi = 320, width = 201, height = 242, units = "px")
  
  p = ggplot()+ggfx::with_outer_glow(
    geom_from_path(aes(x=0,y=0,path=glue::glue("www/outlines/{image}_raw.png")),height=0.8),
    colour = "black", 
    sigma=0,
    expand=10)+
    coord_equal(ratio = 242/201)+theme_void()
  ggsave(filename = glue::glue("www/outlines/{image}_wrap.png"), plot = p,
         dpi = 320, width = 201, height = 242, units = "px")
  
  magick::image_read(glue::glue("www/profiles/{image}_wrap.png")) %>% 
    image_background(color = "#EDE3D9") %>% 
    image_write(path = glue::glue("www/profiles/{image}_final.png"))
  
  magick::image_read(glue::glue("www/outlines/{image}_wrap.png")) %>% 
    image_background(color = "#EDE3D9") %>% 
    image_write(path = glue::glue("www/outlines/{image}_final.png"))
}
purrr::pwalk(list(img,bg,out), outliner)

files = list.files("www/profiles") %>% stringr::str_subset("(_raw)|(_wrap)")
glue::glue("www/profiles/{files}") %>%  file.remove()
files = list.files("www/outlines") %>% stringr::str_subset("(_raw)|(_wrap)")
glue::glue("www/outlines/{files}") %>%  file.remove()
