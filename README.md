# aacrPamphlet
October 2018 pamphlet on Bioconductor:Cancer

# Comments

- The rendered PDF with hyperlinks is ccl.pdf

- You can create it from ccl.Rmd under the following conditions
    - You have sufficient pandoc infrastructure to render tufte_handout Rmarkdown
    - You have sufficient Google BigQuery authentication in the rendering session to succeed with the
buildPancanSE example
        - this would imply that you have a valid project-id for BigQuery; we'll pretend it is "xyz-abc-def"
    - You load MultiAssayExperiment, BiocOncoTK, and then load("blcaMAE.rda")
    - You run the command experiments(blcaMAE)$meth@seed@seed@filepath@bqconn@billing = "xyz-abc-def" # USE YOUR CODE
    - You verify that assay(experiments(blcaMAE)$meth) retrieves some data from BigQuery
    - You save(blcaMAE, file="blcaMAE.rda)
