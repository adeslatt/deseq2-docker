Build a Container for the deseq2-docker

Steps to build this docker container.

Set up GitHub Actions
To build your image from the command line:

Can do this on Google shell - docker is installed and available
```
docker build -t deseq2 .
```

To test this tool from the command line

Set up an environment variable capturing your current command line:

```
PWD=$(pwd)
```

Then mount and use your current directory and call the tool now encapsulated within the environment. The input to DESeq2 is one single matrix.

```
docker run -it -v $PWD:$PWD -w $PWD gmsd Rscript combine-matrices.R
```
