
library(BiocOncoTK)

# set up gene x tumor table

infilGenes = c(`PD-L1`="CD274", 
  `PD-L2`="PDCD1LG2", CD8A="CD8A")
tumcodes = c("COAD", "STAD", "UCEC")
combs = expand.grid(tumcode=tumcodes, 
  ali=names(infilGenes),
    stringsAsFactors=FALSE)
combs$sym = infilGenes[combs$ali]

# establish BigQueryConnection

bq = pancan_BQ() #billing=[project id])

# build a data.frame for ggplot, using
# bindMSI to add microsatellite instability 
# scores  and replaceRownames to convert 
# ENTREZ ids (used
# natively in ISB BigQuery 
# pancan-atlas) to HGNC symbols

exprByMSI = function(bq, tumcode, genesym, 
    alias) {
  if (missing(alias)) alias=genesym
  ex = bindMSI(buildPancanSE(bq, tumcode, 
    assay="RNASeqv2"))
  ex = replaceRownames(ex)
  data.frame(
   patient_barcode=colnames(ex),
   acronym=tumcode,
   symbol = genesym,
   alias = alias,
   log2ex=log2(
     as.numeric(
      SummarizedExperiment::assay(
       ex[genesym,]))+1),
   msicode = ifelse(ex$msiTest >= 4, 
      ">=4", "<4"))
 }

# apply exprByMSI to each tumor

updateL = lapply(1:nrow(combs), function(x) 
   exprByMSI(bq, combs$tumcode[x], 
     combs$sym[x], combs$ali[x]))
updated = do.call(rbind, updateL)

# visualize

library(ggplot2)
ggplot(updated,
    aes(msicode, log2ex)) + geom_boxplot() +
    facet_grid(acronym~alias) +
    ylab("log2(normalized expr. + 1)") +
    xlab("microsatellite instability score")
