Methylation probabilities can be "clamped" to alter the range of probabilities
across which the colour gradient is distributed. By default, the colour gradient
spans the entire range from 0 to 255 (~0% to ~100%), with blue at 0, red at 255,
and all intermediate values interpolated.

However, the endpoints of the colour gradient can be set to midway through the
probability space. For example, a low clamp value of 100 means all probability
values $\le$ 100 are identically coloured the low colour (blue by default),
and colours are interpolated starting from 100 rather than starting from 0.

Any values between 0 and 255 can be set as meaningful clamping values for 
BAM/SAM modification probabilities. This includes non-integer values e.g.
$0.3 \times 255 = 76.5$ to clamp the lower end of the scale at 30% probability.

Any changes to clamping are instantly reflected in the scalebar (provided all probabilities
are on the standard SAM/BAM 0-255 scale) so it is always clear exactly what each colour means.
