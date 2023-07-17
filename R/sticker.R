# comment here
pacman::p_load(
  hexSticker, magick, ggplot2, lattice
)
file_image <- "img/hexImage.svg"


p <- ggplot(aes(x = mpg, y = wt), data = mtcars) + geom_point()

stick_img <- sticker(
  subplot = p, 
  s_width = 1.2,
  s_x = 0.9,
  s_y = 1.1,
  package = "Basics", 
  p_color = "#152c52", 
  p_size = 20, 
  p_x = 1, 
  p_y = 0.5,
  h_size = 5, 
  h_fill = "white", 
  h_color = "#152c52", 
  url = "www.google.com", 
  u_color = "#152c52", 
  u_size = 1,
  spotlight = FALSE, 
  filename = file_image
)

image_read(file_image)


counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
bwplot <- bwplot(
  counts ~ outcome | treatment, xlab=NULL, ylab=NULL, cex=.5, scales=list(cex=.5), par.strip.text=list(cex=.5)
)
stick_img <- sticker(bwplot, package="BUAD 345", p_size=14, s_x=1.02, s_y=0.75, s_width=1.6, s_height=1.1,
        h_fill="#f9690e", h_color="#f39c12", filename="img/lattice.png")
stick_img
