docker run -v /Users/ntu_jacoblab/somaticseq:/Users/ntu_jacoblab/somaticseq --rm lethalfang/somaticseq:3.7.1 makeSomaticScripts.py single --bam /Users/ntu_jacoblab/somaticseq/SRR13076390.realigned.bam --genome-reference /Users/ntu_jacoblab/somaticseq/human_g1k_v37_decoy.fasta --output-directory /Users/ntu_jacoblab/somaticseq/output --dbsnp-vcf /Users/ntu_jacoblab/somaticseq/dbsnp_138.b37.vcf --threads 1 --run-mutect2 --run-vardict --run-lofreq --run-scalpel --run-strelka2 --run-somaticseq --run-workflow




docker run  -v /Users/ntu_jacoblab/somaticseq:/1499a6233f5848b49865dd855640efd3 -v /Users/ntu_jacoblab/somaticseq:/18ab51877b1849a4ae8f968fb73ea819 -v /Users/ntu_jacoblab/somaticseq:/9976ea21ca7d4d35b14f52bfbe1ec976 -v /Users/ntu_jacoblab/somaticseq/output:/f2cc8b0ce1e04ab898e90576d41958c7 -v /Users/ntu_jacoblab/somaticseq:/4b394bc33fb7452798070e46632a7d98 -u $UID --rm  lethalfang/somaticseq:3.7.1 \
/opt/somaticseq/somaticseq/run_somaticseq.py \
--output-directory /9976ea21ca7d4d35b14f52bfbe1ec976/output/SomaticSeq \
--genome-reference /18ab51877b1849a4ae8f968fb73ea819/human_g1k_v37_decoy.fasta \
--inclusion-region /f2cc8b0ce1e04ab898e90576d41958c7/genome.bed \
--dbsnp-vcf /4b394bc33fb7452798070e46632a7d98/dbsnp_138.b37.vcf \
--algorithm xgboost \
single \
--bam-file  /1499a6233f5848b49865dd855640efd3/SRR13076390.realigned.bam \
--mutect2-vcf /9976ea21ca7d4d35b14f52bfbe1ec976/output/SRR13076390.Mutect2.vcf \
--arbitrary-snvs /9976ea21ca7d4d35b14f52bfbe1ec976/output/SRR13076390.b37.TNscope.selected.snv.vcf \
--arbitrary-indels /9976ea21ca7d4d35b14f52bfbe1ec976/output/SRR13076390.b37.TNscope.selected.indel.vcf


/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools view Consensus.sSNV.vcf -Oz -o Consensus.sSNV.vcf.gz
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools index Consensus.sSNV.vcf.gz

/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools view Consensus.sINDEL.vcf -Oz -o Consensus.sINDEL.vcf.gz
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools index Consensus.sINDEL.vcf.gz

/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools view SSeq.Classified.sSNV.vcf -Oz -o SSeq.Classified.sSNV.vcf.gz
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools index SSeq.Classified.sSNV.vcf.gz

/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools view SSeq.Classified.sINDEL.vcf -Oz -o SSeq.Classified.sINDEL.vcf.gz
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools index SSeq.Classified.sINDEL.vcf.gz

#合併
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools  merge --force-samples Consensus.sSNV.vcf.gz Consensus.sINDEL.vcf.gz > megred.vcf
java  -Xmx40g -jar /opt/ohpc/Taiwania3/pkg/biology/Picard/picard_v2.26.0/picard.jar MergeVcfs I=Consensus.sSNV.vcf.gz I=Consensus.sINDEL.vcf.gz O=merged2.vcf

#I did not explicitly incorporate TNscope into the single mode. But in the latest version, there is a way to use the result of any additional caller, i.e., --arbitrary-snvs and --arbitrary-indels.
#First, you'll need to separate the snvs and indels by doing
splitVcf.py -infile TNscope.vcf.gz -snv tnscope_snvs.vcf -indel tnscope_indels.vcf.


docker run -v /home/ubuntu/somaticseq:/home/ubuntu/somaticseq \
  --rm lethalfang/somaticseq:3.7.1 makeSomaticScripts.py \
  single  \
  --bam /home/ubuntu/somaticseq/SRR13076390.realigned.bam \
  --genome-reference /home/ubuntu/somaticseq/human_g1k_v37_decoy.fasta \
  --output-directory /home/ubuntu/somaticseq/output \
  --dbsnp-vcf /home/ubuntu/somaticseq/dbsnp_138.b37.vcf \
  --threads 1 --run-mutect2 --run-vardict --run-lofreq --run-scalpel --run-strelka2 --run-somaticseq --run-workflow


###Mutect2_1
  java -Xmx80G -jar /gatk/gatk.jar Mutect2 \
  --reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --intervals /volume/cyvolume/somaticseq/CTR_hg19.b37.bed \
  --input /volume/cyvolume/somaticseq/SRR13076391.realigned.bam \
  --tumor-sample "SRR13076391" \
  --native-pair-hmm-threads 20 \
  --output /volume/cyvolume/somaticseq/output/SRR13076391.unfiltered.MuTect2.vcf


  java -Xmx80G -jar /gatk/gatk.jar FilterMutectCalls \
  --variant /volume/cyvolume/somaticseq/output/SRR13076391.unfiltered.MuTect2.vcf \
  --reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --output /volume/cyvolume/somaticseq/output/SRR13076391.MuTect2.vcf



##lofreq
  lofreq call \
  --call-indels \
  -l /volume/cyvolume/somaticseq/output/genome.bed \
  -f /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  -o /volume/cyvolume/somaticseq/output/SRR13076391.LoFreq.vcf \
  -d /volume/cyvolume/somaticseq/dbsnp_138.b37.vcf.gz \
  /volume/cyvolume/somaticseq/SRR13076391.realigned.bam


  #scalpel  fail
  /opt/scalpel/scalpel-discovery --single \
  --ref /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --bed /volume/cyvolume/somaticseq/output/genome.bed \
  --bam /volume/cyvolume/somaticseq/SRR13076390.realigned.bam \
  --window 600 \
  --dir /volume/cyvolume/somaticseq/output/scalpel && \
  /opt/scalpel/scalpel-export --single \
  --db /volume/cyvolume/somaticseq/output/scalpel/variants.db.dir \
  --ref /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --bed /volume/cyvolume/somaticseq/genome.bed \
   \
  > /volume/cyvolume/somaticseq/output/scalpel/scalpel.vcf


  #varDict

  /opt/somaticseq/somaticseq/utilities/split_mergedBed.py \
  -infile /volume/cyvolume/somaticseq/output/genome.bed -outfile /volume/cyvolume/somaticseq/output/split_regions.bed

  /opt/VarDict-1.7.0/bin/VarDict \
  -G /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  -f 0.05 -h \
  -b '/volume/cyvolume/somaticseq/SRR13076391.realigned.bam' \
  -Q 1 -c 1 -S 2 -E 3 -g 4 /volume/cyvolume/somaticseq/output/split_regions.bed \
  > /volume/cyvolume/somaticseq/output/SRR13076391.vardict.var

  cat /volume/cyvolume/somaticseq/output/SRR13076391.vardict.var | awk 'NR!=1' | /opt/VarDict/teststrandbias.R | /opt/VarDict/var2vcf_valid.pl -N 'TUMOR' -f 0.05 > /volume/cyvolume/somaticseq/output/vardict/SRR13076391.VarDict.vcf

## output
  /opt/somaticseq/somaticseq/run_somaticseq.py \
  --output-directory /volume/cyvolume/somaticseq/output/SomaticSeq \
  --genome-reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --inclusion-region /volume/cyvolume/somaticseq/CTR_hg19.b37.bed \
  --dbsnp-vcf /volume/cyvolume/somaticseq/dbsnp_138.b37.vcf \
  --classifier-snv /volume/cyvolume/somaticseq/output/SomaticSeq/Ensemble.sSNV.tsv.xgb.v3.7.1.classifier \
  --classifier-indel /volume/cyvolume/somaticseq/output/SomaticSeq/Ensemble.sINDEL.tsv.xgb.v3.7.1.classifier \
  --algorithm xgboost \
  single \
  --bam-file  /volume/cyvolume/somaticseq/SRR13076390.realigned.bam \
  --mutect2-vcf /volume/cyvolume/somaticseq/output/MuTect2.vcf \
  --vardict-vcf /volume/cyvolume/somaticseq/output/VarDict.vcf \
  --strelka-vcf /volume/cyvolume/somaticseq/output/Strelka/results/variants/variants.vcf.gz \
  --arbitrary-snvs /volume/cyvolume/somaticseq/output/tnscope_snvs.vcf /volume/cyvolume/somaticseq/output/dragen_snvs.vcf \
  --arbitrary-indels /volume/cyvolume/somaticseq/output/tnscope_indels.vcf /volume/cyvolume/somaticseq/output/dragen_indels.vcf \
  --lofreq-vcf /volume/cyvolume/somaticseq/output/LoFreq.vcf

# train
/opt/somaticseq/somaticseq/run_somaticseq.py \
--output-directory /volume/cyvolume/somaticseq/output/SomaticSeq \
--genome-reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
--inclusion-region /volume/cyvolume/somaticseq/CTR_hg19.b37.bed \
--dbsnp-vcf /volume/cyvolume/somaticseq/dbsnp_138.b37.vcf \
--algorithm xgboost \
--somaticseq-train \
--truth-snv /volume/cyvolume/somaticseq/KP_snvs.vcf \
--truth-indel /volume/cyvolume/somaticseq/KP_indels.vcf \
--threads 3 \
single \
--bam-file  /volume/cyvolume/somaticseq/SRR13076390.realigned.bam \
--mutect2-vcf /volume/cyvolume/somaticseq/output/MuTect2.vcf \
--vardict-vcf /volume/cyvolume/somaticseq/output/VarDict.vcf \
--strelka-vcf /volume/cyvolume/somaticseq/output/Strelka/results/variants/variants.vcf.gz \
--arbitrary-snvs /volume/cyvolume/somaticseq/output/tnscope_snvs.vcf /volume/cyvolume/somaticseq/output/dragen_snvs.vcf \
--arbitrary-indels /volume/cyvolume/somaticseq/output/tnscope_indels.vcf /volume/cyvolume/somaticseq/output/dragen_indels.vcf \
--lofreq-vcf /volume/cyvolume/somaticseq/output/LoFreq.vcf

## strelka
  cat /volume/cyvolume/somaticseq/output/genome.bed | bgzip > /volume/cyvolume/somaticseq/output/genome.bed.gz
  tabix -f /volume/cyvolume/somaticseq/output/genome.bed.gz

  /opt/strelka/bin/configureStrelkaGermlineWorkflow.py \
  --bam=/volume/cyvolume/somaticseq/SRR13076391.realigned.bam \
  --referenceFasta=/volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --callMemMb=4096 \
  --callRegions=/volume/cyvolume/somaticseq/output/genome.bed.gz \
  --runDir=/volume/cyvolume/somaticseq/output/Strelka1
