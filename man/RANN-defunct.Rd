\name{RANN-defunct}
\alias{RANN-defunct}
\alias{nn}
\title{Defunct functions in RANN package}
\usage{
  nn(...)
}
\arguments{
  \item{...}{Ignored}
}
\description{
  Defunct functions in RANN package
}
\details{
  C code underlying nn() contained memory leaks.
  \code{\link{nn2}} is a more flexible and efficient
  alternative.
}

