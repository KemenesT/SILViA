
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

## Usage

A fairly common task when dealing with strings is the need to split a
single string into many parts. This is what `base::strplit()` and
`stringr::str_split()` do.

``` r
(x <- "alfa,bravo,charlie,delta")
#> [1] "alfa,bravo,charlie,delta"
strsplit(x, split = ",")
#> [[1]]
#> [1] "alfa"    "bravo"   "charlie" "delta"
stringr::str_split(x, pattern = ",")
#> [[1]]
#> [1] "alfa"    "bravo"   "charlie" "delta"
```

Notice how the return value is a **list** of length one, where the first
element holds the character vector of parts. Often the shape of this
output is inconvenient, i.e. we want the un-listed version.

That’s exactly what `regexcite::str_split_one()` does.

You can also embed plots, for example:

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
