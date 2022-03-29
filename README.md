# Long read karyocounting

### Introduction

[![DOI](https://zenodo.org/badge/419751237.svg)](https://zenodo.org/badge/latestdoi/419751237)

Long read karyocounting is a bioinformatic pipeline provided in Nextflow that determines the number of chromosomes in eukaryotic organisms using only long reads. 

Dependencies need to be available in your path: [seqtk](https://github.com/lh3/seqtk), [minimap2](https://github.com/lh3/minimap2), [iGraph](https://igraph.org/r/) within a currently installed R environment.

### Pipeline summary

1) Long reads are filtered to retain only telomere-containing reads above a certain read length. 

2) Reads are aligned in all-vs-all mode with minimap2 and filtered to retain only full length alignments. 

3) Network graphs are generated where each represent sub-graph represents a single chromosomes. 

4) The number of chromosomes are enumerated and interpreted according to the biology of the organism sequenced (diploid, haploid, special cases, etc...)

### Instructions 

1) Install [Nextflow](https://www.nextflow.io/) and ensure all dependencies are available in your path. 

2) Download the pipeline and test it on a minimal data set. 

3) Run your own analysis on your own dataset. 

Vanilla: 

```
nextflow run dgiguer/long-read-karyocounting --reads /path/to/reads  
```

After a :coffee: :
```
nextflow run dgiguer/long-read-karyocounting  --reads /path/to/reads --threads 12 --minimumReadLength 50000 --queryCoverage 
```

### What this pipeline can and can't do

This pipeline can:
    - enable you to determine the number of nuclear linear chromosomes in a eukaryotic organism. 
    - automatically generate network graphs

This pipeline can not (currently):
    - determine the ploidy of your organism
    - automatically report the number of chromosomes. This depends on the expected ploidy. We have also found some organisms expected to be diploid contain one chromosome without haplotypes distinguishable by sequence identity.

