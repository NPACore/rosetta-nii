import nifti from 'npm:nifti-reader-js'
// https://github.com/rii-mango/NIFTI-Reader-JS/blob/master/tests/canvas.html
var data = await Deno.readFile("/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz");
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
