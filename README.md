# Hep_Ploidy_protocol

This is the ploidy identification workflow from the article "Stereo-cell Deciphers the Spatial and Functional Heterogeneity of Polyploid Hepatocytes". 
The method employs deep learning techniques: Cellpose & StarDist to accurately identify DAPI fluorescence-stained images and brightfield images, respectively. 
It acquires detailed information on the morphological characteristics and spatial localization of nuclei and cells, which serves as the core process for hepatocyte ploidy identification.
Leveraging Stereo-cell technology, this workflow significantly enhances both the quantity of hepatocytes for which ploidy information can be obtained and the number of genes detected in the new workflow.


<img width="1391" height="385" alt="new_fig1" src="https://github.com/user-attachments/assets/1715f8f5-ea70-429c-8b39-407827760ce4" />


<img width="1354" height="686" alt="workflow" src="https://github.com/user-attachments/assets/e351bd09-2214-4ee1-a93b-ca73370f0d5f" />


<img width="1345" height="485" alt="fig2" src="https://github.com/user-attachments/assets/b0d844a2-9db1-4def-8132-75c3d831693f" />




cellpose:https://www.cellpose.org/

StarDist:https://github.com/stardist/stardist
