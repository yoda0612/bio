module load compiler/gcc/10.2.0
/opt/ohpc/Taiwania3/pkg/biology/BEDTOOLS/BEDTOOLS_v2.29.1/bin/bedtools


#strelka
SampleName="Merged"
workdir=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/seq2
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
realigned_bam=$workdir/${SampleName}.realigned.bam
runDir=$workdir/strelka
/opt/ohpc/Taiwania3/pkg/biology/STRELKA/STRELKA_v2.9.10/bin/configureStrelkaGermlineWorkflow.py \
--tumorBam=$realigned_bam \
--referenceFasta=$fasta \
--callMemMb=4096 \
--runDir=$runDir


SampleName="Merged"
workdir=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/seq2
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
realigned_bam=$workdir/${SampleName}.realigned.bam
runDir=$workdir/strelka
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
--callMemMb=4096 \
--referenceFasta=$fasta \
--callRegions=/volume/cyvolume/somaticseq/output/genome.bed.gz \
--runDir=$runDir



#懶惰用
job_name="mfas1"
p=ngs192G
c=56
mem=184G
sbatch -A MST109178 -J $job_name  -p $p -c $c --mem=$mem -o %j.out -e %j.log \
--mail-user=cycheng1978@g.ntu.edu.tw --mail-type=FAIL,END \
--wrap="gzip Merged1.fastq"
