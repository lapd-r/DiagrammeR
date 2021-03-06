% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_subgraph_ws.R
\name{create_subgraph_ws}
\alias{create_subgraph_ws}
\title{Create a subgraph based on a selection of nodes
or edges}
\usage{
create_subgraph_ws(graph)
}
\arguments{
\item{graph}{a graph object of class
\code{dgr_graph} that is created using
\code{create_graph}.}
}
\value{
a graph object of class \code{dgr_graph}.
}
\description{
Create a subgraph based on a
selection of nodes or edges extant in the graph
object.
}
\examples{
\dontrun{
# Create a simple graph
nodes <-
  create_nodes(
    nodes = c("a", "b", "c", "d",
              "e", "f", "g", "h"),
    value = c(3.5, 2.6, 9.4, 2.7,
              5.2, 2.1, 4.8, 8.5))

edges <-
  create_edges(
    from = c("a", "b", "c", "g", "e",
             "e", "h", "f", "a", "c"),
    to = c("d", "c", "a", "c", "h",
           "b", "d", "e", "f", "d"))

graph <-
  create_graph(nodes_df = nodes,
               edges_df = edges)

get_nodes(graph)
#> [1] "a" "b" "c" "d" "e" "f" "g" "h"

get_edges(graph, return_type = "vector")
#> [1] "a -> d" "b -> c" "c -> a" "g -> c" "e -> h"
#> [6] "e -> b" "h -> d" "f -> e" "a -> f" "c -> d"

# Create a selection of nodes
graph <-
  select_nodes(
    graph = graph,
    node_attr = "value",
    search = "> 3")

# Create a subgraph based on the selection
subgraph <-
  create_subgraph_ws(graph)

# Check the nodes available in the subgraph
get_nodes(subgraph)
#> [1] "a" "c" "e" "g" "h"

# Check the edges available in the subgraph
get_edges(subgraph, return_type = "vector")
#> [1] "c -> a" "g -> c" "e -> h"
}
}

