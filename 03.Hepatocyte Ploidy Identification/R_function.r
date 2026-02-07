addPloidy <- function(df, num1, num2){
  # 加载依赖包
  library(dplyr)
  # 计算覆盖率，与原逻辑保持一致
  if (!hasName(df, "cover_percentage")){
    df$cover_percentage <- df$bright_area / df$area
  }
  df <- df[df$bright != 0, ]
  df <- df[df$cover_percentage > 0.5, ]
  df_aggregated <- df %>%
    group_by(bright) %>%
    summarise(
      dapi_counts = sum(cover_percentage > 0.5),
      ploidy_cu = paste(
        case_when(
          area < num1 ~ 2,     
          area > num1 & area < num2 ~ 4, 
          area > num2 ~ 8       
        ), 
        collapse = "_"
      ),
      area_combined = paste(area, collapse = "_"),
      ploidy = sum(
        case_when(
          area < num1 ~ 2,
          area > num1 & area < num2 ~ 4,
          area > num2 ~ 8
        )
      ),
      dapi_area = sum(area),
      .groups = "drop"  
    )
  df_filter <- df_aggregated[df_aggregated$dapi_counts %in% c(1, 2), ]
  df_filter <- as.data.frame(df_filter)
  if(nrow(df_filter) > 0){
    rownames(df_filter) <- df_filter[, 1]
  }
  
  return(df_filter)
}


gem2rds<-function(gem_path){
gem=fread(gem_path)
    gem=gem[gem$mask!=0,]
gene=1:length(unique(gem$geneID))
names(gene)=unique(gem$geneID)
cell=1:length(unique(gem$mask))
names(cell)=unique(gem$mask)
mat1=sparseMatrix(i = gene[gem$geneID],j=cell[ as.character(gem$mask) ], x=gem$MIDCount)
rownames(mat1)=names(gene)
colnames(mat1)=names(cell)
    obj1=CreateSeuratObject(counts = mat1)
    return(obj1)
} 

