species=quercus_suber
display_name="Quercus suber"
#prod_name=vigna_unguiculata_gca004118075v1
annotation_url=https://www.ncbi.nlm.nih.gov/assembly/GCA_002906115.4
annotation_provider=Genosuber
version=2022-04-Genosuber
date=2022-04

#Rename DB
#rename_db pl1-w gnaamati_quercus_suber_core_107 quercus_suber_core_54_107_1

##Deletion
echo delete from meta where meta_key=\"genebuild.id\"\; 
echo delete from meta where meta_key=\"species.stable_id_prefix\"\;
echo delete from meta where meta_key=\"species.strain_group\"\;
echo

##Updates
echo update meta set meta_value=\"$display_name\" \
where meta_key=\"species.display_name\"\;

echo update meta set meta_value=\"$date\" \
where meta_key=\"genebuild.initial_release_date\"\;

echo update meta set meta_value=\"$date\" \
where meta_key=\"genebuild.last_geneset_update\"\;

echo "After running GFF Loader:"
echo update meta set meta_value=\"$annotation_url\" \
where meta_key=\"annotation.provider_url\"\;

echo update meta set meta_value=\"external_annotation_import\" \
where meta_key=\"genebuild.method\"\;

echo

##Insertions
echo insert into meta \(meta_key, meta_value\) \
values \(\"annotation.provider_name\",\"$annotation_provider\"\)\; 

echo insert into meta \(meta_key, meta_value\) \
values \(\"genebuild.version\",\"$version\"\)\; 

