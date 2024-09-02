# JVM
## Libraries
 * https://github.com/cabeen/niftijio/blob/master/src/main/java/com/ericbarnhill/niftijio/Example.java
 * [bioformats](https://www.openmicroscopy.org/bio-formats/) is a java library providing [`NiftiReader`](https://bio-formats.readthedocs.io/en/v7.3.1/metadata/NiftiReader.html). Example usage in https://github.com/ome/bio-formats-examples . NB: pulls in lots of dependencies

## Java

slow (no SIMD) attempt on [`src/main/java/niimean/NiftiMean.java`](src/main/java/niimean/NiftiMean.java)

See [Makefile](Makefile)

```sh
gradle bulid
java -jar build/libs/rosetta-nii.jar
bats t/test_niimean.bats -f java
```

## Clojure
## Scala
