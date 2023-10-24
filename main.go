package main

import (
	"fmt"
   "os"
   "log"
	//https://gobyexample.com/command-line-flags
	"flag"
	"github.com/okieraised/gonii"
	"gonum.org/v1/gonum/stat" //Correlation
)

type CorPair struct {
	x []float64
	y []float64
}

func debug(v ...any) {
   if _, ok := os.LookupEnv("DEBUG"); ok {
      log.Println(v...)
   }
}

func read_nifti(input string) []float64 {

	debug("reading ", input)
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

func main() {
	roi_file := flag.String("roi", "", "path to roi atlas/mask nifti image")
	x_file := flag.String("x", "", "path to first input image")
	y_file := flag.String("y", "", "path to second input image")
	flag.Parse()

	img := read_nifti(*roi_file)
	img_x := read_nifti(*x_file)
	img_y := read_nifti(*y_file)

	debug("parsing rois")
	roi_idx := make(map[float64]*CorPair)
	for i, v := range img {
		if v == 0 {
			continue
		}
		x_val := img_x[i]
		y_val := img_y[i]
		if val, okay := roi_idx[v]; okay {
			val.x = append(val.x, x_val)
			val.y = append(val.y, y_val)
		} else {
			roi_idx[v] = &CorPair{[]float64{x_val}, []float64{y_val}}
		}
	}

	debug("generating per roi stats")
	fmt.Printf("roi\tnvox\tmean_x\tmean_y\tr\n")
	for k, v := range roi_idx {
		mean_x := stat.Mean(v.x, nil)
		mean_y := stat.Mean(v.y, nil)
		r := stat.Correlation(v.x, v.y, nil)
		fmt.Printf("%.0f\t%d\t%.2f\t%.2f\t%.2f\n", k, len(v.x), mean_x, mean_y, r)
	}
}
