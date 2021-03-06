#' Get neighboring nodes based on node attribute
#' similarity
#' @description With a graph a single node serving as
#' the starting point, get those nodes in a potential
#' neighborhood of nodes (adjacent to the starting
#' node) that have a common or similar (within
#' threshold values) node attribute to the starting
#' node.
#' @param graph a graph object of class
#' \code{dgr_graph} that is created using
#' \code{create_graph}.
#' @param node a single-length vector containing a
#' node ID value.
#' @param node_attr the name of the node attribute
#' to use to compare with adjacent nodes.
#' @param tol_abs if the values contained in the node
#' attribute \code{node_attr} are numeric, one can
#' optionally supply a numeric vector of length 2 that
#' provides a lower and upper numeric bound as criteria
#' for neighboring node similarity to the starting
#' node.
#' @param tol_pct if the values contained in the node
#' attribute \code{node_attr} are numeric, one can
#' optionally supply a numeric vector of length 2 that
#' specifies lower and upper bounds as negative and
#' positive percentage changes to the value of the
#' starting node. These bounds serve as criteria for
#' neighboring node similarity to the starting node.
#' @return a vector of node ID values.
#' @examples
#' \dontrun{
#' library(magrittr)
#'
#' # Create a graph with a tree structure that's
#' # 3 levels deep (begins with node `1`, branching
#' # by 2 nodes at each level)
#' #
#' # The resulting graph contains 15 nodes, numbered
#' # `1` through `15`; one main branch has all its 7
#' # nodes colored `red`, the other main branch has
#' # 3 of its 7 nodes colored `blue`
#' #
#' # A schematic of the graph:
#' #
#' #   red->[7 red nodes]
#' #    /
#' # [1]
#' #    \
#' #  blue->[3 blue nodes, 4 black nodes]
#' #
#' graph <-
#'   create_graph() %>%
#'   add_node("A") %>%
#'   select_nodes %>%
#'   add_n_nodes_from_selection(2, "B") %>%
#'   clear_selection %>%
#'   select_nodes("type", "B") %>%
#'   add_n_nodes_from_selection(2, "C") %>%
#'   clear_selection %>%
#'   select_nodes("type", "C") %>%
#'   add_n_nodes_from_selection(2, "D") %>%
#'   clear_selection %>%
#'   select_nodes_by_id(
#'     c(2, 4, 5, 8, 9, 10, 11)) %>%
#'   set_node_attr_ws(
#'     node_attr = 'color',
#'     value = 'red') %>%
#'   clear_selection %>%
#'   select_nodes_by_id(
#'     c(3, 6, 7)) %>%
#'   set_node_attr_ws(
#'     node_attr = 'color',
#'     value = 'blue') %>%
#'   select_edges(from = 1, to = 2) %>%
#'   set_edge_attr_ws(
#'     edge_attr = 'color',
#'     value = 'red') %>%
#'   clear_selection %>%
#'   select_edges(from = 1, to = 3) %>%
#'   set_edge_attr_ws(
#'     edge_attr = 'color',
#'     value = 'blue') %>%
#'   clear_selection
#'
#' # Get all nodes with the node attribute
#' # `color = red`; Begin at node `1` and traverse
#' # along the red edge to the first `red` node, then,
#' # find the larger neighborhood of red nodes (the
#' # collection of nodes comprises the entire set of 7
#' # red nodes that have adjacency to each other)
#' graph %>%
#'   select_nodes_by_id(1) %>%
#'   trav_out_edge('color', 'red') %>%
#'   trav_in_node %>%
#'   get_similar_nbrs(
#'     node = get_selection(.)[[1]],
#'     node_attr = 'color')
#' #> [1] "4"  "5"  "8"  "9"  "10" "11"
#'
#' # Get all nodes with the attribute `color = blue`;
#' # Begin at node `1` and traverse along the blue edge
#' # to the first `blue` node, then, find the larger
#' # neighborhood of blue nodes (it comprises the
#' # entire set of 3 blue nodes that have adjacency
#' # to each other)
#' graph %>%
#'   select_nodes_by_id(1) %>%
#'   trav_out_edge('color', 'blue') %>%
#'   trav_in_node %>%
#'   get_similar_nbrs(
#'     node = get_selection(.)[[1]],
#'     node_attr = 'color')
#' #> [1] "6" "7"
#'
#' # Getting similar neighbors can also be done through
#' # numerical comparisons; start with creating a
#' # random, directed graph with 18 nodes and 22 edges
#' random_graph <-
#'   create_random_graph(
#'     n = 18,
#'     m = 22,
#'     directed = TRUE,
#'     fully_connected = TRUE,
#'     set_seed = 20) %>%
#'   set_global_graph_attr(
#'     'graph', 'layout', 'sfdp') %>%
#'   set_global_graph_attr(
#'     'graph', 'overlap', 'false')
#'
#' # This graph cannot be shown in this help page
#' # but you may be interested in displaying it with
#' # `render_graph()`
#' random_graph %>% render_graph
#'
#' # The `create_random_graph()` function randomly
#' # assigns numerical values to all nodes (as the
#' # `value` attribute) from 0 to 10 and to 1 decimal
#' # place. By starting with node (`8`), we can test
#' # whether any nodes adjacent and beyond are
#' # numerically equivalent in `value`
#' random_graph %>%
#'   get_similar_nbrs(
#'     node = 8,
#'     node_attr = 'value')
#' #> [1] NA
#'
#' # There are no nodes neighboring `8` that have a
#' # `value` node attribute equal to `1.0` as node does
#' #
#' # We can, however, set a tolerance for ascribing
#' # similarly by using either the `tol_abs` or
#' # `tol_pct` arguments (the first applies absolute
#' # lower and upper bounds from the value in the
#' # starting node and the latter uses a percentage
#' # difference to do the same); try setting `tol_abs`
#' # with a fairly large range to determine if several
#' # nodes can be selected
#' random_graph %>%
#'   get_similar_nbrs(
#'     node = 8,
#'     node_attr = 'value',
#'     tol_abs = c(3, 3))
#' #> [1] "3"  "9"  "10" "13" "17" "18"
#'
#' # That resulted in a fairly large set of 7
#' # neigboring nodes; For sake of example, setting the
#' # range to be very large will effectively return all
#' # nodes in the graph except for the starting node
#' random_graph %>%
#'   get_similar_nbrs(
#'     node = 8,
#'     node_attr = 'value',
#'     tol_abs = c(10, 10)) %>%
#'     length
#' #> [1] 17
#' }
#' @export get_similar_nbrs

get_similar_nbrs <- function(graph,
                             node,
                             node_attr,
                             tol_abs = NULL,
                             tol_pct = NULL) {

  # Get value to match on
  match <-
    get_node_df(graph)[
      which(get_node_df(graph)[, 1] ==
              node),
      which(colnames(get_node_df(graph)) ==
              node_attr)]

  # Create an empty list object
  nodes <- list()

  # Extract all `node_attr` values to test for their
  # type
  attr_values <-
    get_node_df(graph)[
      , which(colnames(get_node_df(graph)) ==
                node_attr)]

  # Determine whether `node_attr` values are numeric
  node_attr_numeric <-
    ifelse(
      suppressWarnings(
        any(is.na(as.numeric(attr_values)))),
      FALSE, TRUE)

  if (node_attr_numeric == FALSE) {

    # Get the set of all nodes in graph that
    # satisfy one or more conditions
    graph_nodes_with_attr <-
      graph$nodes_df[
        which(
          graph$nodes_df[, which(
            colnames(graph$nodes_df) ==
              node_attr)] %in% match), 1]
  }

  if (node_attr_numeric == TRUE) {

    match <- as.numeric(match)

    if (!is.null(tol_abs)) {
      match_range <-
        c(match - tol_abs[1], match + tol_abs[2])
    }

    if (!is.null(tol_pct)) {
      match_range <-
        c(match - match * tol_pct[1]/100,
          match + match * tol_pct[2]/100)
    }

    if (is.null(tol_abs) & is.null(tol_pct)) {
      match_range <- c(match, match)
    }

    # Get the set of all nodes in graph that
    # satisfy one or more conditions
    graph_nodes_with_attr <-
      graph$nodes_df[
        intersect(
          which(
            as.numeric(graph$nodes_df[, which(
              colnames(graph$nodes_df) ==
                node_attr)]) >= match_range[1]),
          which(
            as.numeric(graph$nodes_df[, which(
              colnames(graph$nodes_df) ==
                node_attr)]) <= match_range[2])), 1]
  }

  # place starting node in the neighbourhood vector
  neighborhood <- node

  # Initialize `i`
  i <- 1

  repeat {

    # From the starting node get all adjacent nodes
    # that are not in the `neighborhood` vector
    neighborhood <-
      unique(
        c(neighborhood,
          intersect(
            unique(c(
              get_edges(
                graph,
                return_type = "df")[
                  which(get_edges(
                    graph,
                    return_type = "df")[, 1] %in%
                      neighborhood), 2],
              get_edges(
                graph,
                return_type = "df")[
                  which(get_edges(
                    graph,
                    return_type = "df")[, 2] %in%
                      neighborhood), 1])),
            graph_nodes_with_attr)))

    # Place revised neighborhood nodes in `nodes` list
    nodes[[i]] <- neighborhood

    # Break if current iteration yields no change in
    # the `nodes` list
    if (i > 1){
      if (identical(nodes[[i]], nodes[[i - 1]])) break
    }

    i <- i + 1
  }

  # Get the final set of nodes that satisfy similarity
  # and adjacency conditions
  matching_nodes <-
    setdiff(nodes[length(nodes)][[1]], node)

  # If there are no matching nodes, assign NA to
  # `matching_nodes`
  if (length(matching_nodes) == 0) {
    matching_nodes <- NA
  }

  # If `matching_nodes` has node ID values, determine
  # if the node ID values are numeric and, if so, apply
  # a numeric sort
  if (all(!is.na(matching_nodes))) {

    # Determine whether the node ID values are entirely
    # numeric
    node_id_numeric <-
      ifelse(
        suppressWarnings(
          any(is.na(as.numeric(matching_nodes)))),
        FALSE, TRUE)

    # If the node ID values are numeric, then apply a
    # numeric sort and reclass as a `character` type
    if (node_id_numeric) {
      matching_nodes <-
        as.character(sort(as.numeric(matching_nodes)))
    }
  }

  return(matching_nodes)
}
