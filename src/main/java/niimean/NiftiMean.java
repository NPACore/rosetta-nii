package niimean;
import java.io.File;
import java.io.IOException;

import com.ericbarnhill.niftijio.NiftiVolume;

/* slower? many dependencies */
//import loci.formats.ImageReader;
//import loci.formats.in.NiftiReader;
//import loci.formats.FormatException;

class NiftiMean {
   public static void main(String []args)
         throws  IOException  {

      var inputFile = "wf-mp2rage-7t_2017087.nii.gz";

      /* bioformats: formats-gpl, many dependencies */
      //var nii = new ImageReader();
      //nii.setId(inputFile);


      /* 1.2s if just reading */
      NiftiVolume volume = NiftiVolume.read(inputFile);
      int nx = volume.header.dim[1];
      int ny = volume.header.dim[2];
      int nz = volume.header.dim[3];
      int dim = volume.header.dim[4];

      /* .1s to mean */
      double sum = 0;
      for (int d = 0; d < dim; d++)
          for (int k = 0; k < nz; k++)
              for (int j = 0; j < ny; j++)
                  for (int i = 0; i < nx; i++)
                      sum += volume.data.get(i,j,k,d);
      double mean = sum / (dim*nz*ny*nx);

      // show something
      System.out.printf("%.4f\n", mean);

    }
}
