# VariationalFrameworkInpainting
Implementation of a variational framework for non-local inpainting in Matlab, based on the paper from Vadim Fedorov, Gabriele Facciolo, Pablo Arias.

This MATLAB implementation of the variational framework for non-local inpainting is made in the context of the final project of the "Traitement d'Images Avancé" (Advance Image Processing) class for Master 2 students, at the University of Bordeaux. It is written by Yiye Jiang, Anais Gastineau and Candice Bentéjac.

## To-do list
- [x] Consider all types of images (grayscale and color images)
- [x] Write the patch error function `E` for the patch non-local Poisson
- [x] Implement the entire patch match algorithm to compute the nearest-neighbor fields
- [x] Parallelize the patch match algorithm
- [x] Minimize the energies
    - [x] Correspondance update step
    - [x] Image update step
- [x] Implement the confidence masks
- [ ] Write the report (easy peasy :grin:) -- https://www.overleaf.com/12314065qkxqstqrchft
- [ ]

## To do (if enough time left)
- [ ] Write the patch error function `E` for the patch non-local means
- [x] Write the patch error function `E` for the patch non-local medians
- [ ] Add the new patch error functions to the patch match algorithm and make them a parameter
- [x] Add the possibility for the user to choose which patch error function to use
- [ ] Decouple the image and correspondence update steps
- [x] Implement the multiscale scheme
    - [x] Construction of a masked Gaussian pyramid
    - [x] Joint image and NNF upscaling
- [x] Add the ability for the user to select the mask by themselves (brush system on the input image)
