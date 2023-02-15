configfile: "config.yaml"

rule all:
    input:
        "result/counts/counts.txt",
        "result/report/report.pdf"

def get_input_sra(wildcards):
    return config["samples"][wildcards.rep]

rule extract:
    input:
        get_input_sra
    output:
        "result/raw/fq/{rep}_1.fastq",
        "result/raw/fq/{rep}_2.fastq"
    shell:
        "fasterq-dump {input} -3 -e 12 -O result/raw/fq/"

rule pigz:
    input:
        "result/raw/fq/{rep}_1.fastq",
        "result/raw/fq/{rep}_2.fastq"
    output:
        "result/raw/fq/{rep}_1.fastq.gz",
        "result/raw/fq/{rep}_2.fastq.gz"
    shell:
        "pigz {input} -p 12"

rule cutadapt:
    input:
        "result/raw/fq/{rep}_1.fastq.gz",
        "result/raw/fq/{rep}_2.fastq.gz"
    output:
        "result/clean/fq/{rep}_1_val_1.fq.gz",
        "result/clean/fq/{rep}_2_val_2.fq.gz"
    shell:
        "trim_galore {input}  -o result/clean/fq/ \
        -j 4 -q 25 --phred33 --length 35 --stringency 3 --paired --gzip"

rule qc:
    input:
        "result/clean/fq/{rep}_1_val_1.fq.gz",
        "result/clean/fq/{rep}_2_val_2.fq.gz"
    output:
        "result/clean/qc/{rep}_1_val_1_fastqc.html",
        "result/clean/qc/{rep}_2_val_2_fastqc.html"
    shell:
        "fastqc {input} -t 12 -o result/clean/qc/"

rule align:
    input:
        "result/clean/fq/{rep}_1_val_1.fq.gz",
        "result/clean/fq/{rep}_2_val_2.fq.gz"
    output:
        temp("result/align/sam/{rep}.sam")
    params:
        genome=config["genome"]
    threads:12
    log:
        "logs/hisat2/{rep}.log"
    shell:
        "hisat2 -x {params.genome} -S  {output} \
        -1 {input[0]}  -2 {input[1]} \
        -t -p {threads}"

rule sorted_bam:
    input:
        "result/align/sam/{rep}.sam"
    output:
        protected("result/align/bam/{rep}_sorted.bam")
    shell:
        "samtools sort {input} -o {output} \
        -@ 12"

rule count:
    input:
        bam=expand("result/align/bam/{rep}_sorted.bam", rep=config["samples"]),
    output:
        "result/counts/counts.txt"
    params:
        gtf=config["gtf"]
    shell:
        "featureCounts {input.bam}  -a {params.gtf} \
        -o result/counts/counts.txt \
        -T 12  -p"

rule Rmarkdown_report:
    output:
      "result/report/report.pdf"
    shell:
        """
        Rscript -e "rmarkdown::render('RNASeq-downstream-visualization.Rmd')"
        """
       
       