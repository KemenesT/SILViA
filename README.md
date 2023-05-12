
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SILViA

<!-- badges: start -->
<!-- badges: end -->

The goal of SILViA is to provide a method to identify outlying points
recorded by a CTD device along a depth profile, which are not congruent
with the range of measurements taken in the surrounding water column.
These are labeled as “incongruent” points. For this, the package
includes a function to import and format .vp2 files, as well as
functions to visualize depth profiles and the incongruent points they
contain.

## Installation

You can install the development version of SILViA from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("KemenesT/SILViA")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(SILViA)
## basic example code
```

You can also embed plots, for example:

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
