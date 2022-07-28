module load compiler/gcc/10.2.0
/opt/ohpc/Taiwania3/pkg/biology/BEDTOOLS/BEDTOOLS_v2.29.1/bin/bedtools


#strelka
SampleName="SRR13076390"
workdir=/staging/biology/yoda670612/plan
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
realigned_bam=$workdir/SRR13076390.bowtie2.realigned.bam
runDir=$workdir/strelka/bowtie2
/opt/ohpc/Taiwania3/pkg/biology/STRELKA/STRELKA_v2.9.10/bin/configureStrelkaSomaticWorkflow.py \
--tumorBam=$realigned_bam \
--referenceFasta=$fasta \
--callMemMb=40960 \
--runDir=$runDir


SampleName="SRR13076390"
workdir=/staging/biology/yoda670612/plan
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
realigned_bam=$workdir/SRR13076390.hisat2.realigned.bam
runDir=$workdir/strelka/hisat2
/opt/ohpc/Taiwania3/pkg/biology/STRELKA/STRELKA_v2.9.10/bin/configureStrelkaGermlineWorkflow.py \
--bam=$realigned_bam \
--exome \
--referenceFasta=$fasta \
--runDir=$runDir




#alias

SampleName="Merged"
workdir=/volume/cyvolume
fasta=/volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta
realigned_bam=$workdir/${SampleName}.realigned.bam
runDir=$workdir/strelka
/opt/strelka/bin/configureStrelkaSomaticWorkflow.py \
--tumorBam=$realigned_bam \
--referenceFasta=$fasta \
--runDir=$runDir

SampleName="Merged"
workdir=/volume/cyvolume
fasta=/volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta
realigned_bam=$workdir/${SampleName}.realigned.bam
runDir=$workdir/strelka
/opt/strelka/bin/configureStrelkaGermlineWorkflow.py \
--bam=$realigned_bam \
--callMemMb=40960 \
--referenceFasta=$fasta \
--callRegions=/volume/cyvolume/somaticseq/output/genome.bed.gz \
--runDir=$runDir



#懶惰用
job_name="hi2_index"
p=ngs192G
c=56
mem=184G
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
bowtie2_build=/opt/ohpc/Taiwania3/pkg/biology/BOWTIE/bowtie2_v2.4.2/bowtie2-build
bw2_index=/staging/biology/yoda670612/bw2_hg19_index/bw2_hg19
hisat2_build=/work/yoda670612/hisat2-2.1.0/hisat2-build
hisat2_index=/staging/biology/yoda670612/hisat2_hg19_index/hisat2_hg19

sbatch -A MST109178 -J $job_name  -p $p -c $c --mem=$mem -o %j.out -e %j.log \
--mail-user=cycheng1978@g.ntu.edu.tw --mail-type=FAIL,END \
--wrap="$hisat2_build $fasta $hisat2_index"

job_name="bw2_index"
sbatch -A MST109178 -J $job_name  -p $p -c $c --mem=$mem -o %j.out -e %j.log \
--mail-user=cycheng1978@g.ntu.edu.tw --mail-type=FAIL,END \
--wrap="$bowtie2_build $fasta $bw2_index"
