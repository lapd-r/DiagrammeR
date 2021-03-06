% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_n_nodes_from_selection.R
\name{add_n_nodes_from_selection}
\alias{add_n_nodes_from_selection}
\title{Add a multiple of new nodes with edges from one or
more selected nodes}
\usage{
add_n_nodes_from_selection(graph, n, set_node_type = NULL,
  set_edge_rel = NULL)
}
\arguments{
\item{graph}{a graph object of class
\code{dgr_graph} that is created using
\code{create_graph}.}

\item{n}{the number of new nodes to attach as
successor nodes to the nodes in the selection.}

\item{set_node_type}{an optional string to apply a
\code{type} attribute to all newly created nodes.}

\item{set_edge_rel}{an optional string to apply a
\code{rel} attribute to all newly created edges.}
}
\value{
a graph object of class \code{dgr_graph}.
}
\description{
Add n new nodes to one or more nodes
available in a graph object of class
\code{dgr_graph}, with edges moving from the nodes
in the selection toward the newly created nodes.
Optionally, set node \code{type} and edge \code{rel}
values for the new nodes and edges.
}
\examples{
\dontrun{
library(magrittr)

# Create an empty graph, add a node to it, select
# that node, and 5 more nodes to the graph with
# edges from the original node to all of the new
# nodes
graph <-
  create_graph() \%>\%
  add_n_nodes(1) \%>\%
  select_last_node \%>\%
  add_n_nodes_from_selection(5)

# Get the graph's nodes
graph \%>\% get_nodes
#> [1] "1" "2" "3" "4" "5" "6"

# Get the graph's edges
graph \%>\% get_edges(return_type = "vector")
#> "1 -> 2" "1 -> 3" "1 -> 4" "1 -> 5" "1 -> 6"
}
}

