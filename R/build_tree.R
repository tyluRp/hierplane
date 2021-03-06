build_tree <- function(x, title, settings, styles) {

  check_style(x, settings, styles, "node_type_to_style", "node_type")
  check_style(x, settings, styles, "link_to_positions", "link")
  check_style(x, settings, styles, "link_name_to_label", "link")

  root <- parse_root(x, settings)
  children <- build_nodes(parse_children(x, title, root$id, settings),
                          root = root$id,
                          title = title,
                          settings = settings)$children

  jsonlite::toJSON(
    x = tree(title, root, children, settings, styles),
    pretty = FALSE,
    auto_unbox = TRUE
  )
}

build_nodes <- function(x, root, title, settings) {

  if (nrow(x) == 0 | is.null(x)) return(NULL)

  if (is.factor(root))
    root <- as.character(root)

  r <- list()

  cur_tib <- x[x[[settings$child_id]] == root, ]

  r$nodeType <- unique(cur_tib[[settings$node_type]])
  r$word <- unique(cur_tib[[settings$child]])
  r$attributes <- unique(pull_attr(cur_tib, settings$attributes))
  r$link <- unique(cur_tib[[settings$link]])

  if (settings$type %in% "spacyr" & !is.null(r$word) & length(r$word) > 0) {
    r$spans <- list(pull_word_span(title, cur_tib[[settings$child_id]]))
  }

  children <- x[x[[settings$parent_id]] == root, ][[settings$child_id]]

  if (is.factor(children))
    children <- as.character(children)

  if (length(children) > 0) {
    r$children <- lapply(children,
                         build_nodes,
                         x = x,
                         title = title,
                         settings = settings
    )
  }

  r
}


