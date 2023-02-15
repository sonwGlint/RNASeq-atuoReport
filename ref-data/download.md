常用参考基因组的index可直接在hisat2的官网的download目录下找到，直接下载。

UCSC mm10 Indx的下载以及解压如下：

```shell
wget https://genome-idx.s3.amazonaws.com/hisat/mm10_genome.tar.gz
tar -zxvf *tar.gz 
rm *tar.gz
```

UCSC mm10参考基因组注释可以在https://hgdownload.soe.ucsc.edu/下载。

```shell
wget https://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/genes/mm10.refGene.gtf.gz
```

最后整个参考数据文件目录如下：

```shell
(base) @sonwGlint ➜ /workspaces/CodeSpace/snake-test/ref-data (main ✗) $ tree
.
├── download.md
├── mm10
│   ├── genome.1.ht2
│   ├── genome.2.ht2
│   ├── genome.3.ht2
│   ├── genome.4.ht2
│   ├── genome.5.ht2
│   ├── genome.6.ht2
│   ├── genome.7.ht2
│   ├── genome.8.ht2
│   └── make_mm10.sh
└── mm10.refGene.gtf.gz
```