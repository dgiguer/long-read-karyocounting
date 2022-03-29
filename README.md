<p align="center"><img src="images/logo_transparent.png" alt="Karyocounter" width="80%"></p>

[![DOI](https://zenodo.org/badge/419751237.svg)](https://zenodo.org/badge/latestdoi/419751237)

Karyocounter is a Nextflow pipeline to determine the number of nuclear chromosomes in eukaryotic organisms using only nanopore reads. 

### How it works

1) Long reads are filtered to retain only telomere-containing reads above a certain read length. 

2) Reads are aligned in all-vs-all mode with minimap2 and filtered to retain only full length alignments. 

3) A network graph of the overlaps is generated where each represent cluster represents the end of a single chromosome. 

4) The number of chromosomes can then be counted and interpreted according to the biology of the organism (diploid, haploid, special cases, etc...). 

### Quick start 

1) Install [Nextflow](https://www.nextflow.io/) and ensure the following dependencies are available in your path: [seqtk](https://github.com/lh3/seqtk), [minimap2](https://github.com/lh3/minimap2), the R programming language with [iGraph](https://igraph.org/r/) installed.

2) Run the Nextflow pipeline. 

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

