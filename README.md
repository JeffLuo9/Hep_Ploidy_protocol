# Hep_Ploidy_protocol

This is the ploidy identification workflow from the article "Stereo-cell Deciphers the Spatial and Functional Heterogeneity of Polyploid Hepatocytes". 
The method employs deep learning techniques: Cellpose & StarDist to accurately identify DAPI fluorescence-stained images and brightfield images, respectively. 
It acquires detailed information on the morphological characteristics and spatial localization of nuclei and cells, which serves as the core process for hepatocyte ploidy identification.
Leveraging Stereo-cell technology, this workflow significantly enhances both the quantity of hepatocytes for which ploidy information can be obtained and the number of genes detected in the new workflow.

<img width="1315" height="220" alt="ploidy_workflow" src="https://github.com/user-attachments/assets/2078807e-60f5-4ff7-8be8-fbfe0a9ed9a9" />



cellpose:https://www.cellpose.org/
StarDist:https://github.com/stardist/stardist
