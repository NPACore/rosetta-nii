package util
import (
   "os"
   "log"
	//https://gobyexample.com/command-line-flags
	"github.com/okieraised/gonii"
)


func Debug(v ...any) {
   if _, ok := os.LookupEnv("DEBUG"); ok {
      log.Println(v...)
   }
}

func Read_nifti(input string) []float64 {

	Debug("reading ", input)
	full_img, err := gonii.NewNiiReader(gonii.WithReadImageFile(input), gonii.WithReadRetainHeader(true))
	if err != nil {
		panic(err)
	}
	err = full_img.Parse()
	if err != nil {
		panic(err)
	}

	return full_img.GetNiiData().GetVoxels().GetDataset()
}
