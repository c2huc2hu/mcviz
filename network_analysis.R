library(rPython)
library(igraph)

python_file <-file("fb.py", "r")
python.load(python_file)
post <-python.get("tree")

net_matrix <-comment_network(post)
net <-graph.edgelist(net_matrix)
net.sp <- shortest.paths(net)
net.hc <- hclust(dist(net.sp))

plot(net.hc, labels=FALSE)

net <-network_cluster(net, net.hc, 7)

plot(net, vertex.label=NA, vertex.size=3, edge.arrow.size=0.05)

