## Changes since last release
Two small bug fixes as well as adding native routine registration to address 
NOTE on current CRAN build.

## Test environments
* local OS X install, R 3.4.0
* ubuntu 12.04 (on travis-ci), R 3.3.3
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

Winbuilder gave 1 note.

https://win-builder.r-project.org/eekKaCQ4aCk9/00check.log

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Gregory Jefferis <jefferis@gmail.com>'

Possibly mis-spelled words in DESCRIPTION:
  Arya (9:30)
  dataset (8:72)

The first is a surname. The second appears to be an acceptable spelling
according to the Oxford English Dictionary.

## Reverse dependencies

I have run R CMD check on the 22 reverse dependencies. There were no errors.
There were some warnings and notes but these appear unrelated to changes in RANN.
