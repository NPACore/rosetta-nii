#!/usr/bin/env -S deno run --allow-read
import nifti from 'npm:nifti-reader-js'
// https://github.com/rii-mango/NIFTI-Reader-JS/blob/master/tests/canvas.html
var data = await Deno.readFile("wf-mp2rage-7t_2017087.nii.gz");
var data = new Uint8Array(data).buffer;
var niftiHeader=null;
var niftiImage = null;

if (nifti.isCompressed(data)) {
   data = nifti.decompress(data);
}

if (! nifti.isNIFTI(data)) {
  deno.exit()
}
niftiHeader = nifti.readHeader(data);
//console.log(niftiHeader.datatypeCode)
niftiImage = nifti.readImage(niftiHeader, data);
var typedData = new Float32Array(niftiImage);
var sum=0
for(const e of typedData){ sum += e; }
console.log(sum/typedData.length)
