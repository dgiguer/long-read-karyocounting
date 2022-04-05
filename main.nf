#!/usr/bin/env nextflow

params.reads = "$baseDir/data/wontwork.fastq.gz"
params.out = "$baseDir/overlaps.paf"
params.dir = "$baseDir/lrk_output/"
params.minimumReadLength = 5000
params.threads = 4
params.queryCoverage = '0.95'
params.telomere = "AACCCT"


process telomereComplement {

    output:
    tuple env(telo_1), env(telo_2) into telomeres_ch

    shell:
    '''
    telo_1="$(echo !{params.telomere})"
    telo_2="$(echo !{params.telomere} | tr ACGTacgt TGCAtgca | rev)"
    '''

}

process processReads {

    input:
    path 'input.fastq.gz' from params.reads 
    tuple env(telo_1), env(telo_2) from telomeres_ch

    output:
    file 'filtered_reads' into reads_ch
 
    shell:
    '''
    seqtk seq -L !{params.minimumReadLength} input.fastq.gz | grep -A 2 -B 1 -E "${telo_1}${telo_1}${telo_1}|${telo_2}${telo_2}${telo_2}" - | grep -v -- '^--\$' > filtered_reads
    '''

}

process makeOverlaps {

    publishDir 'lrk_output', mode: 'copy'

    input:
    path 'filtered_reads' from reads_ch

    output:
    file 'overlaps.paf' into overlaps_ch

    """
    minimap2 -x ava-ont -t $params.threads filtered_reads filtered_reads | awk '( (\$4 - \$3) / \$2 ) >= $params.queryCoverage {print \$0}' - > overlaps.paf
    """
}

process makeGraphs {

    publishDir 'lrk_output', mode: 'copy'

    input:
    path 'overlaps.paf' from overlaps_ch

    output:
    file '*.pdf' into graphs_ch

    """
    Rscript $baseDir/network_graphs.R -i overlaps.paf
    """
}

overlaps_ch
    .collectFile(name: params.out)
    .view {file -> "Output saved as:\n${file.name}" }
    .subscribe {println it}

graphs_ch
    .view {file -> "Output saved as:\n${file.name}" }