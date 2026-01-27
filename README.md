# Hep_Ploidy_protocol

This is the ploidy identification workflow from the article "Stereo-cell Deciphers the Spatial and Functional Heterogeneity of Polyploid Hepatocytes". 
The method employs deep learning techniques: Cellpose & StarDist to accurately identify DAPI fluorescence-stained images and brightfield images, respectively. 
It acquires detailed information on the morphological characteristics and spatial localization of nuclei and cells, which serves as the core process for hepatocyte ploidy identification.
Leveraging Stereo-cell technology, this workflow significantly enhances both the quantity of hepatocytes for which ploidy information can be obtained and the number of genes detected in the new workflow.


<img width="1391" height="385" alt="new_fig1" src="https://github.com/user-attachments/assets/1715f8f5-ea70-429c-8b39-407827760ce4" />


<img width="1354" height="686" alt="workflow" src="https://github.com/user-attachments/assets/e351bd09-2214-4ee1-a93b-ca73370f0d5f" />


<img width="1345" height="485" alt="fig2" src="https://github.com/user-attachments/assets/b0d844a2-9db1-4def-8132-75c3d831693f" />



# Tutorial
#  Step1: Staining image registration and quantification 
```
Since the slide is not moved between DAPI and brightfield imaging using the microscope,
 the DAPI and brightfield microscopy images are already registered.。
Therefore, FIJI ImageJ (https://imagej.net/software/fiji/) is only required to register
the DAPI images with the UMI image.

1. Preprocessing in ImageJ:
Convert both DAPI and brightfield images from RGB to 8-bit in ImageJ to reduce memory consumption.
Adjust the image brightness to make the DAPI and UMI image basically consistent.

2. TrackEM2 Project Setup:
Create a TrackEM2 project in ImageJ, then import the folder containing brightfield image,
 DAPI image, and UMI image.
Switch the active image to the UMI image. Unlink the UMI image from other images to ensure
 that adjustments to the DAPI image do not affect the UMI image. Maintain the link between
 the DAPI and brightfield images.
Select the DAPI layer as the active layer. Configure the UMI image as the red channel
and DAPI as the green channel in the layer settings.

3. Registration and Validation:
  Register the DAPI image using the Transform tool, After registration,
validate the alignment by zooming into multiple fields of view to ensure
that the majority of the DAPI signal (green channel) overlaps with the UMI regions(red channel).

4. Export and save both the DAPI and brightfield images in TIFF format.
```
CAUTION!  Do not alter the UMI image at any stage of registration;only the DAPI image is subject to transformation.
This ensures that spatial gene expression data (UMI) remains unmodified, preserving the integrity of expression localization during alignment with nuclear features (DAPI)
#  Step2: GEM Generates UMI images

#  Step3: Cell and nuclear segmentation
Perform cell segmentation on the DAPI image (registered with the UMI image) and brightfield image. For the brightfield image, use Cellpose (https://github.com/MouseLand/cellpose) with the cyto3 model.For the DAPI image, use StarDist (https://github.com/stardist/stardist) with the 2D_versatile_fluo model to generate DAPI masks in StarDist_dapi.py.



