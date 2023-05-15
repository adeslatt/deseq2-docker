library(DESeq2)
library(tidyverse)
library(magrittr) 

#take input from combined matrix
matrix <- commandArgs(trailingOnly=TRUE)
data <- read.csv(matrix, sep="\t")
de_input <- as.matrix(data[,-1])
row.names(de_input) <- data$gene_id

meta_df <- data.frame( Sample = names(data[-1])) %>% 
  mutate(
    Type = gsub("-.*","", Sample) %>% gsub("[.].*","", .)
  )

#object construction
dds <- DESeqDataSetFromMatrix(round(de_input),
                              meta_df,
                              design = ~Type)

#standard DESeq analysis
dds <- DESeq(dds)

#varianceStabilizingTransformation returns a DESeqTransform if a DESeqDataSet was provided, 
#or returns a a matrix if a count matrix was provided
vsd <- varianceStabilizingTransformation(dds)

library(genefilter)

#returns a matrix
wpn_vsd <- getVarianceStabilizedData(dds)

#variance estimates for each row
rv_wpn <- rowVars(wpn_vsd)
summary(rv_wpn)

q75_wpn <- quantile( rowVars(wpn_vsd), .75)  # <= original
q95_wpn <- quantile( rowVars(wpn_vsd), .95)  # <= changed to 95 quantile to reduce dataset

expr_normalized <- wpn_vsd[ rv_wpn > q95_wpn, ]

write.csv(expr_normalized, "DESeq.csv")
