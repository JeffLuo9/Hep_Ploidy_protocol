import pandas as pd
import numpy as np
import skimage as ski

bright_agg = pd.read_csv(output_file+sample_name+"_nucle_info.csv",index=False) 

bright_agg.index = bright_agg['value']
bright_img_nuclei = np.zeros((bright_img.shape[0],bright_img.shape[1],3),dtype='uint8')
bright['dapi_counts'] = bright_agg.loc[bright['value']]['dapi_counts'].tolist()
add_counts = list(range(5,bright_agg['dapi_counts'].max()+1))
color_map = pd.DataFrame({'dapi_counts':[0,1,2,3,4]+add_counts,
                          'R':[150,255,255,0,0]+[255]*len(add_counts),
                          'G':[150,255,0,255,0]+[0]*len(add_counts),
                          'B':[150,255,0,0,255]+[255]*len(add_counts)})
color_map.index = color_map['dapi_counts']
bright['R'] = color_map.loc[bright['dapi_counts']]['R'].tolist()
bright['G'] = color_map.loc[bright['dapi_counts']]['G'].tolist()
bright['B'] = color_map.loc[bright['dapi_counts']]['B'].tolist()
bright_img_nuclei[bright['y'],bright['x'],0] = bright['R']
bright_img_nuclei[bright['y'],bright['x'],1] = bright['G']
bright_img_nuclei[bright['y'],bright['x'],2] = bright['B']
#The color coding for the number of nuclei within cells: Gray: 0;White: 1;Red: 2;Green: 3;Blue: 4;Purple: 5 or more

ski.io.imsave(output_file+sample_name+"_nucle_info.tif",bright_img_nuclei)