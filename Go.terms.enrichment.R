source("https://bioconductor.org/biocLite.R")
biocLite("AnnotationDbi")
biocLite("GOstats")

library("GOstats")
universe <- read.table('data/universe.txt',header=T)
goframeData = data.frame(universe$go_id, universe$Evidence, universe$gene_id)
goFrame=GOFrame(goframeData,organism="C.mac")
goAllFrame=GOAllFrame(goFrame)
library("GSEABase")
gsc <- GeneSetCollection(goAllFrame, setType = GOCollection())
library("GOstats")
univ=unique(universe$gene_id)
univ=as.character(univ)

genes <- read.table('GO.SFP.txt',header=T)
gen=unique(genes$genes_id)
gen=as.character(gen)

sink("GO.SFP.GOtermsEnrichment.txt", append=FALSE, split=FALSE)

params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",geneSetCollection=gsc, geneIds = gen,universeGeneIds = univ,ontology = "MF",pvalueCutoff = 0.05,conditional = FALSE, testDirection = "over")
Over <- hyperGTest(params)
summary(Over)

params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",geneSetCollection=gsc, geneIds = gen,universeGeneIds = univ,ontology = "CC",pvalueCutoff = 0.05,conditional = FALSE, testDirection = "over")
Over <- hyperGTest(params)
summary(Over)

params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",geneSetCollection=gsc, geneIds = gen,universeGeneIds = univ,ontology = "BP",pvalueCutoff = 0.05,conditional = FALSE, testDirection = "over")
Over <- hyperGTest(params)
summary(Over)

sink()
