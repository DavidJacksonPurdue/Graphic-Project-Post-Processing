#Graphic-Project-Post-Processing

Another GPU programming project, this one demonstrates various live post processing effects (rather than just gpu generated imagery). The default generated image is that of a spinning textured box, and the post processor performs various calculates to change the apperance of this gpu rendered object based on user input.

Pressing "t" will apply a sepia filter to the box

Pressing "d" will create a swirl effect in the middle of the screen

Pressing "m" will apply a horizontal motion blur that increases inverse proportionally in strength based on moving object's distance from the camera

Pressing "s" will apply a sketch filter to make the box appear as if it was hand drawn

Effects are intentionally non-stacking, so applying one effect will override another.
