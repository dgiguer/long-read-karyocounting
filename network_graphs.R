#!/usr/bin/env Rscript 

####################

# Options

library(optparse)
library(igraph)

option_list <- list(
    make_option(c("-i","--overlaps"), type="character", default=NULL,
            help="filtered overlaps",
            dest="overlaps_filename"),
    make_option(c("-m","--minimum"), type="integer", default=10,
            help="minimum number of nodes to retain graph",
            dest="minimum_vertices"),
    make_option(c("-o","--output"), type="character", default="./",
            help="path output directory [default = ./]",
            dest="output_directory")
            )

parser <- OptionParser(usage = "%prog -i overlaps.paf -o ./ [options]",option_list=option_list)

####################

# Reading data

opt = parse_args(parser)

overlaps <- read.table(file = opt$overlaps_filename)
min_nodes <- opt$minimum_vertices
out_dir <- opt$output_directory

subset <- data.frame(from=overlaps$V1, to=overlaps$V6)

g <- graph_from_data_frame(subset)
clu <- components(g)

# filter graphs to remove noise
graphs <- decompose.graph(g, min.vertices=min_nodes)

number_of_graphs <- length(graphs)

# Get histogram 
hist_vec <- vector()

for (i in seq(length(groups(clu)))) {
    hist_vec[i] <- length(groups(clu)[[i]]) 
}

####################

# Plotting 

### Plot a histogram of reads per cluster and noise cutoff line

pdf(paste0(out_dir, "cluster-histogram.pdf"))

hist(hist_vec, breaks = 99, main = "", xlab = "Number of reads per cluster")
abline(v=min_nodes, lty = 2)

rect(xleft = -5 , ybottom = 0, xright = min_nodes, ytop = max(table(hist_vec)), col = rgb(1, 0, 0, 0.2), border = NA)
text(x = min_nodes/2, y = max(table(hist_vec)) / 1.5, label = "Noise")

rect(xleft = min_nodes , ybottom = 0, xright = max(hist_vec), ytop = max(table(hist_vec)), col = rgb(0, 1, 0, 0.2), border = NA)
text(x = max(hist_vec)/2, y = max(table(hist_vec)) / 1.5, label = "Chromosome clusters")

dev.off()

### Plot a graph of each individual cluster for closer inspection

pdf(paste0(out_dir, "all-clusters.pdf"), width = 20, height = number_of_graphs/1.5)

number_of_rows <- ceiling(number_of_graphs/6) 

par(mfrow=c(number_of_rows, 6))

for (i in seq(graphs)) {

    plot(graphs[[i]], vertex.label=NA, vertex.size=15, edge.arrow.size=0.1, vertex.color=rgb(0.2,0,1, 0.2), vertex.frame.color="NA", main=paste0("Graph ", i))

}

dev.off()
