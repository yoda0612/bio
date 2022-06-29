apt install build-essential
apt-get install libboost-all-dev
apt install libgtest-dev
./dragen-os --build-hash-table true --ht-reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta  --output-directory /volume/cyvolume/dragmap_index



./dragen-os -r /volume/cyvolume/dragmap_index \
 -1 /volume/cyvolume/somaticseq/fastq/SRR13076390_1.fastq \
 -2 /volume/cyvolume/somaticseq/fastq/SRR13076390_2.fastq \
 >  /volume/cyvolume/SRR13076390.dragmap.sam
