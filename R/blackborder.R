library(ggplot2)
library(ggfx)
library(ggpath)
library(purrr)
library(glue)
library(stringr)

ggplot()+ggfx::with_outer_glow(
  geom_from_path(aes(x=0,y=0,path="www/detective_raw.png"),height=0.9),
  colour = "black", 
  sigma=0,
  expand=10)+
  coord_equal(ratio = 1.4)+theme_void()
ggsave("www/detective.png", dpi = 320, width = 125, height = 190, units = "px")


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
