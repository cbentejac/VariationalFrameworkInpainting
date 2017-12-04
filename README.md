# VariationalFrameworkInpainting
Implementation of a variational framework for non-local inpainting in Matlab, based on the paper from Vadim Fedorov, Gabriele Facciolo, Pablo Arias.

This MATLAB implementation of the variational framework for non-local inpainting is made in the context of the final project of the "Traitement d'Images Avancé" (Advance Image Processing) class for Master 2 students, at the University of Bordeaux. It is written by Yiye Jiang, Anais Gastineau and Candice Bentéjac.

## To-do list
- [x] Consider all types of images (grayscale and color images)
- [x] Write the patch error function `E` for the patch non-local Poisson
- [x] Implement the entire patch match algorithm to compute the nearest-neighbor fields
- [ ] Parallelize the patch match algorithm
- [ ] Minimize the energies
    - [ ] Correspondance update step
    - [ ] Image update step
- [ ] Implement the confidence masks
- [ ] Write the report (easy peasy :grin:)


## To do (if enough time left)
- [ ] Write the patch error function `E` for the patch non-local means
- [ ] Write the patch error function `E` for the patch non-local medians
- [ ] Add the new patch error functions to the patch match algorithm and make them a parameter
- [ ] Add the possibility for the user to choose which patch error function to use
- [ ] Decouple the image and correspondence update steps
- [ ] Implement the multiscale scheme
    - [ ] Construction of a masked Gaussian pyramid
    - [ ] Joint image and NNF upscaling
- [ ] Add the ability for the user to select the mask by themselves (brush system on the input image)
