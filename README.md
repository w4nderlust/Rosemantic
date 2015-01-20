# Rosemantic
Processing script for generating vector images that represent a flattening of the vectorial sum on an n-dimensional semantic space.

I coded this script in order to generate the cover for my PhD thesis, inspired by "Fragments of a Hologram Rose" by William Gibson.

## How it works

![Interface](http://i.imgur.com/Y2wOz39.png)

The script generates a vector (random vector 1) inside the minimum and maximum ray. Then generates another vector (random vector 2) with an angle between minimum and maximum angle from the first one and with a length between minimum and maximum ray.

Then it sums up the two vectors and draws two triangles connecting the origin, the two random vectors and the sum vector. The colors of the two triangles are randomized in the HSB space and it's possible to set the ranges of variability of all three values for both triangles.

This generative process is repeated a number of times.

The final shapes can be exported in PDF or SVG in bulk, also cycling the hue margins through the hue wheel.

![Scheme](http://i.imgur.com/Ds0BUgV.png)


## Examples
Here are some example shapes generated with the example parameters available.

![Roses](http://i.imgur.com/b2RZ3HD.png)

## Notes

The blending modes do not work when exporting in PDF (due to limitations of the renderer) and SVG (due to limitations of the actual SVG format, i don't like filters).

## License
The script in released under MIT license
