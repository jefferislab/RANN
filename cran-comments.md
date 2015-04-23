- New submission, originally submitted as RANN1
- Difference to existing package RANN: Metric used for computing distances.
  RANN uses L2, RANN.L1 uses L1.  The underlying ANN library requires changing of
  preprocessor defines to change the metric; using two similar R packages
  seems to be the simplest solution to provide ANN implementations with
  different metrics for the R community.
- Checked against R 3.2.0 on Ubuntu, R-devel (r68237) on Debian
  and R-devel (r68221) on win-builder
