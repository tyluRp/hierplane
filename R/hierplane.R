#' Render a hierplane
#'
#' Hierplanes visualize hierarchical data, specifically tailored towards
#' rendering dependency parses. The user only needs to provide a string of text.
#' Hierplane will call on `spacyr::spacy_parse()` to generate a dataframe and
#' parse the correct tree structure that the JavaScript library expects.
#'
#' @param .data A dataframe containing hierarchical features.
#' @param settings A hierplane settings object.
#' @param title The tite of the hierplane.
#' @param theme Either light or dark
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param elementId Explicitly provide an element ID to the widget rather than
#' an automatically generated one. This is optional.
#'
#' @import htmlwidgets
#' @source https://github.com/allenai/hierplane
#'
#' @export
hierplane <- function(.data, settings, title = "Hierplane", theme = "light", width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x <- list(
    tree = build_tree(.data, title, settings),
    theme = theme
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'hierplane',
    x,
    width = width,
    height = height,
    package = 'hierplane',
    elementId = elementId
  )
}


#' Shiny bindings for hierplane
#'
#' Output and render functions for using hierplane within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a hierplane
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name hierplane-shiny
#'
#' @export
hierplaneOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'hierplane', width, height, package = 'hierplane')
}

#' @rdname hierplane-shiny
#' @export
renderHierplane <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, hierplaneOutput, env, quoted = TRUE)
}