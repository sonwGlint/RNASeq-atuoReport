#  download sra file to ./raw/sra/ from NCBI
echo  "begin downloading sra file......"
cat idname | while read id
do 
  prefetch $id 

  mv $id/*.sra*  ./
  rm -r $id/

  echo -e "$id downloaded sucessfully!"
done 
echo "All sra file downloaded!"  

