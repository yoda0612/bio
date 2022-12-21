網址：
https://github.com/Illumina/DRAGMAP

建構步驟：
apt update &&
apt -y install build-essential &&
apt-get -y install libboost-all-dev &&
apt -y install libgtest-dev &&
apt -y install git &&
cd /root &&
git clone https://github.com/Illumina/DRAGMAP.git &&
cd DRAGMAP &&
make


建立index：
./dragen-os --build-hash-table true --ht-reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta  --output-directory /volume/cyvolume/dragmap_index



進行alignment
fastq1=/volume/cyvolume/seq2/SRR1307639_1.fastq.gz
fastq2=/volume/cyvolume/seq2/SRR1307639_2.fastq.gz
sam=/volume/cyvolume/seq2/SRR1307639.dragmap.hg19.sam
/root/DRAGMAP/build/release/dragen-os -r /volume/cyvolume/dragmap_index_hg19 \
 -1 $fastq1 \
 -2 $fastq2 \
 >  $sam

scp PanelA_LAB3*.dragmap.sam yoda670612@t3-c4.nchc.org.tw://staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/
