addPloidy<-function(df,num){
library(dplyr)
if (hasName(df,"cover_percentage") == FALSE){
    df$cover_percentage <- df$bright_area / df$area
}
    df<-df[df$bright != 0,]
    df<-df[df$cover_percentage>0.5,]
df_aggregated <- df %>%
  group_by(bright) %>%
  summarise(
    dapi_counts = sum(cover_percentage > 0.5),
    ploidy_cu = paste(ifelse(area < num, 2, 4), collapse = "_"),
    area_combined = paste(area, collapse = "_"),
    ploidy = sum(ifelse(area<num,2,4)) ,
    dapi_area=sum(area)
  ) %>%
  ungroup()
    df_filter<-df_aggregated[df_aggregated$dapi_counts %in% c(1,2),]
    df_filter<-as.data.frame(df_filter)
    rownames(df_filter)<-df_filter[,1]

    return(df_filter)
}

new_ploidy<-function(df,x){
df<-df %>%
    rowwise() %>%
    mutate(
        areas = list(strsplit(as.character(area_combined),"_"))[[1]],
        ploidy_cu_new = paste(sapply(areas, function(area) ifelse(as.numeric(area) > x, 4, 2)), collapse = "_")  ,
        ploidy_new = sum(as.numeric(strsplit(ploidy_cu_new, "_")[[1]]))                                    
    ) %>%
    ungroup() %>%
    select(-areas)
df <- df %>%
    mutate(
        ploidy_cu = ploidy_cu_new,
        ploidy=ploidy_new
    ) %>%
return(df)    
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

