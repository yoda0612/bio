

# Update with the location of the Sentieon software package and license file
export SENTIEON_LICENSE=140.110.16.119:8990
release_dir="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-201808"
nt=40 #number of threads to use in computation


$release_dir/bin/sentieon driver -r /staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta -t $nt -i /staging/biology/yoda670612/0_1.marked.addmarked.bam -q /staging/biology/yoda670612/0_1.recal_data.table --algo TNscope 0_1.vcf
