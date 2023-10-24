package main

import (
	"fmt"
	util "voxcor/util"
)

func main() {
	//roi_file := flag.String("roi", "", "path to roi atlas/mask nifti image")
	//flag.Parse()
	//img := util.Read_nifti(*roi_file)
   img := util.Read_nifti("wf-mp2rage-7t_2017087.nii.gz")
	sum := 0.0
	for _, v := range img {
		sum += v
	}

	n := float64(len(img))
	fmt.Printf("mean: %.3f", sum/n)
}
