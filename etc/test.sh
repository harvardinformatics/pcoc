#! /bin/bash


set -e


mkdir -p test
cd test
ROOT_DIR=$PWD
TREES_DIR=$ROOT_DIR/../etc/data/tree_ensembl
OUTPUT_DIR=$ROOT_DIR/out_test/
mkdir -p  $OUTPUT_DIR


meth="--topo --pcoc --ident"
debug="--no_cleanup --debug"
debug=""
# test1: TOPO IDENT PCOC NO_NOISE
docker run --rm -i -v $ROOT_DIR:$ROOT_DIR -v $TREES_DIR:$TREES_DIR  carinerey/pcoc  bash -c "pcoc_sim.py -td $TREES_DIR -o $OUTPUT_DIR/test1 -n_sc 1 -nb_sampled_couple 1 -n_sites 100 -c 5 -c_max 7 -cpu 1  $meth $debug"

#test2: TOPO IDENT PCOC BL_NOISE
docker run --rm -i -v $ROOT_DIR:$ROOT_DIR -v $TREES_DIR:$TREES_DIR  carinerey/pcoc  bash -c "pcoc_sim.py -td $TREES_DIR -o $OUTPUT_DIR/test2 -n_sc 1 -nb_sampled_couple 1 -n_sites 100 -c 5 -c_max 7 -cpu 1 $meth $debug --bl_noise"

#test3: TOPO IDENT PCOC ALI_NOISE
docker run --rm -i -v $ROOT_DIR:$ROOT_DIR -v $TREES_DIR:$TREES_DIR  carinerey/pcoc  bash -c "pcoc_sim.py -td $TREES_DIR -o $OUTPUT_DIR/test3 -n_sc 1 -nb_sampled_couple 1 -n_sites 100 -c 5 -c_max 7 -cpu 1  $meth $debug --ali_noise"


echo TOPO IDENT PCOC NO_NOISE
cat $OUTPUT_DIR/test1/RUN*/Tree_1/BenchmarkResults.tsv | cut -f 8,4,5,14,16-19 | grep -e Threshold -e "0.9$" -e "NA$"

echo TOPO IDENT PCOC BL_NOISE
cat $OUTPUT_DIR/test2/RUN*/Tree_1/BenchmarkResults.tsv | cut -f 8,4,5,14,16-19 | grep -e Threshold -e "0.9$" -e "NA$"

echo TOPO IDENT PCOC ALI_NOISE
cat $OUTPUT_DIR/test3/RUN*/Tree_1/BenchmarkResults.tsv | cut -f 8,4,5,14,16-19 | grep -e Threshold -e "0.9$" -e "NA$"

