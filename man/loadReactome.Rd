% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loadReactome.R
\name{loadReactome}
\alias{loadReactome}
\title{this function should only ever be used to reload/maintain Reactome caches
all the files are as downloaded from the Reactome/Ensembl website but gzipped
FIXME: add loading of interaction maps for all of the supported organisms.}
\usage{
loadReactome(TxDbLitePath = "~/Dropbox/TxDbLite")
}
\arguments{
\item{TxDbLitePath}{where the TxDbLite source build root can be found}
}
\value{
invisibly, a list of the cache and pathway name listings.
}
\description{
this function should only ever be used to reload/maintain Reactome caches
all the files are as downloaded from the Reactome/Ensembl website but gzipped
FIXME: add loading of interaction maps for all of the supported organisms.
}

