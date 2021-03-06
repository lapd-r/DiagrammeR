% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cache_edge_attr_ws.R
\name{cache_edge_attr_ws}
\alias{cache_edge_attr_ws}
\title{Cache edge attributes (based on a selection of
edges) in the graph}
\usage{
cache_edge_attr_ws(graph, edge_attr, mode = NULL)
}
\arguments{
\item{graph}{a graph object of class
\code{dgr_graph} that is created using
\code{create_graph}.}

\item{edge_attr}{the edge attribute from which to
obtain values.}

\item{mode}{a option to recast the returned vector
of edge attribute value as \code{numeric} or
\code{character}.}
}
\value{
a graph object of class \code{dgr_graph}.
}
\description{
From a graph object of class
\code{dgr_graph}, get edge attribute properties for
edges available in a selection and cache those
values in the graph for later retrieval using
\code{get_cache}.
}

