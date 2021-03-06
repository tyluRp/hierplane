requireNamespaceQuietStop <- function(package) {
  if (!requireNamespace(package, quietly = TRUE))
    stop(paste('package',package,'is required to use this function'), call. = FALSE)
}

tree <- function(title, root, children, settings, styles) {

  if (settings$type %in% "spacyr") {
    spans <- list(pull_word_span(title, root$dat[[settings$child_id]]))
  } else {
    spans <- list(list(start = 0, end = nchar(title)))
  }

  tree <- list(
    text = title,
    root = list(
      nodeType = root$dat[[settings$node_type]],
      word = root$dat[[settings$child]],
      attributes = pull_attr(root$dat, settings$attributes),
      spans = spans)
  )

  if (!is.null(children)) {
    tree$root$children <- children
  }

  if (!is.null(styles$node_type_to_style)) {
    tree$nodeTypeToStyle <- styles$node_type_to_style
  }


  if (!is.null(styles$link_to_positions)) {
    tree$linkToPosition <- styles$link_to_positions
  }

  if (!is.null(styles$link_name_to_label)) {
    tree$linkNameToLabel <- styles$link_name_to_label
  }

  tree

}

parse_root <- function(x, settings) {
  list(
    id = x[x[[settings$link]] %in% settings$root_tag, ][[settings$child_id]],
    dat = x[x[[settings$link]] %in% settings$root_tag, ]
  )
}

parse_children <- function(x, title, root_id, settings) {
  x <- x[!x[[settings$parent_id]] == x[[settings$child_id]], ]
  x$sort_order <- ifelse(x[[settings$parent_id]] %in% root_id, 0, 1)
  x <- x[with(x, order(x$sort_order, x[[settings$child_id]])), ]
  x[c(
    settings$parent_id,
    settings$child_id,
    settings$child,
    settings$link,
    settings$node_type,
    settings$attributes,
    "sort_order"
  )]
}


transform_logical <- function(x) {
  for (bool_col in which(sapply(x, is.logical))) {
    bool_name <- names(x)[bool_col]
    x[[bool_col]] <- ifelse(
      test = x[[bool_col]],
      yes = gsub(".*_", "", bool_name),
      no = ""
    )
  }
  x
}



pull_attr <- function(x, attributes) {
  x <- as.vector(unlist(sapply(attributes, function(i) x[[i]])))
  as.list(x[nchar(x) > 0 & !is.na(x)])
}

