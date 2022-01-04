##Note:: If we use merge need to update for EMS and Inter-homoeologous

dbcmd=mysql-ens-plants-prod-1-ensrw

#database=solanum_lycopersicum_variation_24_77_240
database=triticum_turgidum_variation_45_98_1
database=triticum_aestivum_variation_52_105_4

file=combined_maps.promoters.1513.No_RH.vcf
file=watkins-filtered-cleaned.vcf
file=1kEC_genotype01222019.fixed.vcf


source=EMS-induced-mutation
source=Cornell
population=Cornell 


##Don't forget the merging or non merging!
echo \
perl -I \
    $ENSEMBL_ROOT_DIR/ensembl-variation/scripts/import \
    $ENSEMBL_ROOT_DIR/ensembl-variation/scripts/import/import_vcf.pl \
    --input_file $file \
    --species ${database%_variation_*} \
    --source $source \
    --population $population \
    --tmpdir /tmp \
    $($dbcmd --details script) \
    --no_merge \
    --test 10 \
    | sed -e 's/\s\+/\n/g' | awk 'NR%2{printf "%s\t",$0;next;}1'

    #--no_merge_source 'EMS-induced mutation'
    #--no_merge \


    #--no_merge_source 'EMS-induced mutation' \
    #--no_merge_source 'Inter-homoeologous' \

    ##--no_merge \

    #--skip_tables allele,population_genotype,compressed_genotype_var \
    ##--sample_prefix "gbs_" \

    #'allele'                          => 1,
    #'population_genotype'             => 1,
    #'compressed_genotype_var'         => 1,


    #--mart_genotypes \

##    --no_merge \
#    --fork 12
#    --test 100 \

