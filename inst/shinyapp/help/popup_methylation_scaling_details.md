Probability scaling maps the underlying probability scores (usually integers from 0 to 255)
to the probability text that should be displayed inside each box. The two "standard" options
are either scaling to 0-1 probabilities or leaving as 0-255 integers.

Scaling is implemented as $\frac{p-min}{max}$, where $p$ is the underlying probability score and 
$min$ and $max$ are values specifying the probability range. 

 * To write probabilities as unmodified 0-255
integers, $\frac{p-0}{1}$ is used ($min = 0$ and $max = 1$). 

 * To write probabilities as standard 0-1 probabilities,
$\frac{p+0.5}{256}$ is used ($min = -0.5$ and $max = 256$). 
This is because each integer $p$ represents the probability space from
$\frac{p}{256}$ to $\frac{p+1}{256}$ 
(see [SAMtools tag specifications][link_samtools_tag_specs]),
so $\frac{p+0.5}{256}$ takes the centre of each integer's probability space.

If custom scaling is desired, $min$ and $max$ can be set to arbitrary numeric values,
though this is an advanced option that should be used carefully and with intention.
