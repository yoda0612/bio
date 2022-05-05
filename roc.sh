
# * There must be a version of Rscript available in the PATH.
# * The ggplot2 package must be installed in R

OUTPUT_PATH="/Users/ntu_jacoblab/result_vcf"
cd $OUTPUT_PATH

Template="/Users/ntu_jacoblab/result_vcf"

echo
echo "----------------------------------------------------------------------------------"
echo
echo "Making plots (this replaces plots in the doc folder of this checkout!)"

f1="SRR13076390.hg19"
f2="SRR13076390.hg19"

f3="SRR13076390.hg19.Sentieon.realigned"
f4="SRR13076390.hg19.Sentieon.realigned"



f5="SRR13076390.b37"
f6="SRR13076390.b37"



# WGS
# GRCh38_HG001_ILMN
Rscript ${Template}/rocplot_test.Rscript ${OUTPUT_PATH} ${f1}:${f2} ${f3}:${f4} ${f5}:${f6} -pr
