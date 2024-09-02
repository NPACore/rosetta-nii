package niimean;
import java.io.File;
import java.io.IOException;

//import com.github.cabeen.niftijio.NiftiVolume;
import com.ericbarnhill.niftijio.NiftiVolume;

//import loci.formats.ImageReader;
//import loci.formats.in.NiftiReader;
//import loci.formats.FormatException;

class NiftiMean {
   public static void main(String []args)
         throws  IOException  {

      var inputFile = "wf-mp2rage-7t_2017087.nii.gz";

      //File inputFile = new File("wf-mp2rage-7t_2017087.nii.gz");
      //var nii = new NiftiReader();
      //nii.initFile(inputFile); // protected

      /* import fails when running */
      //var nii = new ImageReader();
      //nii.setId(inputFile);
 
      NiftiVolume volume = NiftiVolume.read(inputFile);
      System.out.println("Finished reading file.");

    }
}
