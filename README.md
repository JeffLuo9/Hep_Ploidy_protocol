# Hep_Ploidy_protocol

This is the ploidy identification workflow from the article "Stereo-cell Deciphers the Spatial and Functional Heterogeneity of Polyploid Hepatocytes". 
The method employs deep learning techniques: Cellpose & StarDist to accurately identify DAPI fluorescence-stained images and brightfield images, respectively. 
It acquires detailed information on the morphological characteristics and spatial localization of nuclei and cells, which serves as the core process for hepatocyte ploidy identification.
Leveraging Stereo-cell technology, this workflow significantly enhances both the quantity of hepatocytes for which ploidy information can be obtained and the number of genes detected in the new workflow.


<img width="1391" height="385" alt="new_fig1" src="https://github.com/user-attachments/assets/1715f8f5-ea70-429c-8b39-407827760ce4" />


<img width="1194" height="616" alt="fig2_cut" src="https://github.com/user-attachments/assets/03830306-d12c-42c0-bf25-c213b490c998" />



<img width="1345" height="485" alt="fig2" src="https://github.com/user-attachments/assets/b0d844a2-9db1-4def-8132-75c3d831693f" />



# Tutorial
The example data is accessible at this location: "Hep_Ploidy_protocol/Tutorial/Demon_data.rar"
#  Step1: GEM Generates UMI images
To map the fluorescence staining signals captured by microscopy to the actual gene expression profiles, we first generate spatial expression heatmaps for the genes of interest, followed by registering the DAPI and bright-field images to the spatial pattern defined by these UMI image.
```bash
python ../01.GEM Generate UMI image/gem2mask.py -f nCount -g ../Y00723M1_con.gem.gz  -b 1 -n 0 10 -C variable x y value exon -o Y00723M1_con_umi
```

#  Step2: Staining image registration and quantification 
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

#  Step3: Cell and nuclear segmentation
Perform nuclear segmentation on the DAPI image (registered with the UMI image) and cell segmenttation on brightfield image. For the brightfield image, use Cellpose (https://github.com/MouseLand/cellpose) with the cyto3 model.    For the DAPI image, use StarDist (https://github.com/stardist/stardist) with the 2D_versatile_fluo model to generate DAPI masks in StarDist_dapi.py.
```bash
#Nuclear segmentation on Demon DAPI image
python ../02.Cell Segmentation/StarDist_small.py -i ../DAPI_image.tif -o ../dapi_mask.label.csv
#The example data is small, so a different StarDist function was used;for details, please refer to the official StarDist tutorial.

#Nuclear segmentation on normal DAPI images
python ../02.Cell Segmentation/StarDist_dapi.py -i ../DAPI_image.tif -o ../dapi_mask.label.csv
```
For cell segmentation using Cellpose, we highly recommend its graphical user interface (GUI). For the code-based workflow, please refer to Cellpose's official documentation (https://cellpose.readthedocs.io/en/latest/). Therefore, we only demonstrate the detailed steps of the GUI here.

<img width="338" height="285" alt="cellpose_done" src="https://github.com/user-attachments/assets/d1874063-1bea-4dae-a084-23867e2d82c3" />

1. load bright image
<img width="365" height="240" alt="cellpose_11" src="https://github.com/user-attachments/assets/57ba3ab8-1b18-4899-b28a-52ae7ea14cfa" />

2. cell segmentation
<img width="290" height="191" alt="cellpose_s2" src="https://github.com/user-attachments/assets/0450f2f1-f566-4171-b327-d044319cdcec" />

3. save result image
<img width="375" height="235" alt="cellpose_s3" src="https://github.com/user-attachments/assets/6c7615bd-97b1-4b55-873b-2326d95d22f2" />

After completing cell segmentation, we first segment the GEM-format file based on the result files generated by Cellpose.
The Cellpose output files in *.png format must be converted to TIFF format prior to segmentation.
```bash
python ../02.Cell Segmentation/gem_cut.py -g ../Y00723M1.gem.gz -m ../cellpose_mask.tif  -b 1 -o Y00723M1_cell
```

# Step4: Hepatocytes polyploidy identification

In Python, we integrate the cell segmentation results from Cellpose and nuclear segmentation results from StarDist to quantify the number and area of nuclei within cells.

```python
import sys
sys.path.append("../03.Hepatocyte Ploidy Identification/cell_nuclear_stats.py")
from cell_nuclear_stats import calculate_cell_nuclear_stats
    bright_path = "../cellpose_masks.tif"  # Cellpose Cell Segmentation Result Images
    dapi_path = "../dapi_mask.label.csv"   # StarDist Nuclear Segmentation Result File
    dapi_raw_path = "../DAPI_image.tif"    # Registered Original DAPI Image

    output_file = "../results/" 
    sample_name = "Y00723M1" 

    dapi_stats, cell_nuclear_stats = calculate_cell_nuclear_stats(
        bright_path=bright_path,
        dapi_path=dapi_path,
        dapi_raw_path=dapi_raw_path,
        output_file=output_file,
        sample_name=sample_name,
        cover_thre=cover_thre
    )
```
After running calculate_cell_nuclear_stats, a file with the suffix "dtb.csv" will be generated. This file records the features of each nucleus row by row. Next, it is necessary to identify which nuclei are diploid and which are tetraploid.
The classification between single-nucleus diploid and single-nucleus tetraploid uses k-means. In essence, k-means will converge on several groups of points with the largest differences, which is similar to the sudden increase in nuclear area from diploid to tetraploid due to chromosome replication.For multiple distinct samples, we recommend merging all the dtb.csv files first, then performing k-means clustering on the combined dataset in a unified manner.
Generate single-cell analysis files using the newly generated segmented GEM file (implemented here with R-based Seurat(V4.2.0)).
```r
library(data.table)
library(Seurat)
source("../03.Hepatocyte Ploidy Identification/R_function.r")
df_gem<-fread("../Y00723M1_cell_cut.gem.gz")
rna_m1<-gem2rds(df_gem)  #Use this function to perform the format conversion from GEM to Seurat object.

#Add ploidy information to the Seurat object to initiate the analysis.
df_m1_ploidy<-read.csv("../Y00723M1_dtb.csv")
k_m1<-kmeans(df_m1_ploidy$area,centers = 3)
head(k_m1)  #Examine the clustering results based on nuclear area, where we define Cluster 3 as the group with largest mean nuclear areas,Clustre 1 as smallest nuclear areas.
df_m1_ploidy$k_cluster<-k_m1$cluster
cut_num1<-max(df_mi_ploidy$area[df_m1_ploidy$k_cluster == 1]) #Determine the segmentation threshold
cut_num2<-min(df_mi_ploidy$area[df_m1_ploidy$k_cluster == 3])
df_m1_meta<-addPloidy(df_m1_ploidy,cut_num1,cut_num2)
rna_m1<-AddMetaData(rna_m1,df_m1_meta)

saveRDS(rna_m1,"../Y00723M1_seurat.rds")
```








