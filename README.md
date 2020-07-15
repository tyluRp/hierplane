
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hierplane

<!-- badges: start -->

[![R build
status](https://github.com/tyluRp/hierplane/workflows/R-CMD-check/badge.svg)](https://github.com/tyluRp/hierplane/actions)
[![Codecov test
coverage](https://codecov.io/gh/tyluRp/hierplane/branch/master/graph/badge.svg)](https://codecov.io/gh/tyluRp/hierplane?branch=master)
<!-- badges: end -->

:warning: Work in progress :warning:

The goal of `hierplane` is to visualize trees. This is an HTML widget
that uses source code from the [original javascript
library](https://github.com/allenai/hierplane). A handful of functions
are provided that allow R users to render hierplanes in shiny. See a
live demonstration
[here](https://tylerlittlefield.com/shiny/tyler/hierplane/).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tyluRp/hierplane")
```

## Example

Rendering a hierplane requires you to:

1.  Create a hierplane object with `hp_` functions
2.  Render the hierplane with `hierplane()`

A hierplane object can be created from different input data. At the time
of writing this, a `data.frame` or string:

``` r
library(hierplane)

# requires spacyr package
hp_spacyr("Sam likes boats")
#> <hierplane_tree object: from hp_spacyr>
```

With this, we can render a hierplane in shiny:

``` r
library(hierplane)
library(shiny)

ui <- fluidPage(
  hierplaneOutput("hplane")
)

server <- function(input, output, session) {
  output$hplane <- renderHierplane({
    x <- hp_spacyr("Sam likes boats")
    hierplane(x)
  })
}

shinyApp(ui, server)
```

<img src="man/figures/hierplane_spacyr.png" width="100%" />

While hierarchical data isn’t common in a `data.frame` centric language
like R, we are working on a way to parse a `data.frame` to hierplane
ready data. This works by using `hp_dataframe()`:

``` r
ui <- fluidPage(
  hierplaneOutput("hplane")
)

server <- function(input, output, session) {
  output$hplane <- renderHierplane({
    hierplane(hp_dataframe(starships, title = "Starships"))
  })
}

shinyApp(ui, server)
```

<img src="man/figures/hierplane_dataframe.png" width="100%" />

## Acknowledgements

  - [`allenai/hierplane`](https://github.com/allenai/hierplane): The
    original javascript library that this package uses
  - [`DeNeutoy/spacy-vis`](https://github.com/DeNeutoy/spacy-vis): Spacy
    models using hierplane
