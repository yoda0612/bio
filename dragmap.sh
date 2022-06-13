apt install build-essential
apt-get install libboost-all-dev
apt install libgtest-dev
./dragen-os --build-hash-table true --ht-reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta  --output-directory /volume/cyvolume/dragmap_index
