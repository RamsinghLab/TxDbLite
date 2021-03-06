#' find any duplicate seqnames in FASTA files BEFORE creating an index...
#' FIXME: remove them, write out a de-duped merged FASTA, and index that.
#' 
#' @param  fastaFiles       vector of the FASTA file names (may be compressed, doesn't matter)
#'
#' @return data.frame of duplicate seqnames and fasta filenames, else NULL
#'
#' @importFrom Biostrings readDNAStringSet
#' 
#' @export
findDupes <- function(fastaFiles=NULL) { 
     #repBase names are tab separated.  we defined dupes as matching names and matching sequences
     seqInput<-sapply(fastaFiles,function(x) readDNAStringSet(x)) #read input
      #find duplicated sequences first 
     dupeSeqs<-lapply(seqInput,function(x) x[duplicated(x)])
     seqLengths<-lapply(dupeSeqs,function(x) length(x))
    
     if(all(seqLengths==0) ) {#no dupe seqs. exit
    message("found no duplicated sequence names .... no dupes found")
    duplicateDF<-data.frame(duplicates=unlist(seqLengths))
    duplicateDF<-suppressWarnings(as.data.frame(duplicateDF,stringsAsFactors=FALSE))
    return(suppressWarnings(duplicateDF)) #0
    }#no dupes were found 

          
     tabSplit<-lapply(Filter(length,dupeSeqs),function(x) strsplit(names(x),"\t") )
     filteredSeqs<-lapply(tabSplit,function(x) (sapply(x,"[", c(1))))
     spaceSplit<-lapply(filteredSeqs,function(x) strsplit(x," ") )
     ensemblNames.duplicatedSequences<-lapply(spaceSplit,function(x) (sapply(x,"[",c(1))))
     #ensemblNames with duplicated sequences



     #all names that are duplicated 
     nameSearch<-lapply(seqInput,function(x) strsplit(names(x),"\t") )
     namesFilter<-lapply(nameSearch,function(x) (sapply(x,"[", c(1))) )
     dupeNames<-lapply(namesFilter,function(x) x[duplicated(x)])
     dupeNames<-Filter(length,dupeNames)
     dupeLengths<-sapply(dupeNames,function(x) length(x) ) 
     

 
     if(all(length(dupeLengths)>0)  ) {#if dupe was detected
     #FIX ME: a dupe must match the dupe sequence with dupe names. 
     #find the duplicated names in the list of duplicated sequnces
     #find set of intersection between dupeNames (dupe names) and filteredSeqs(dupe sequences) 
     duplicates<- unlist(ensemblNames.duplicatedSequences) %in% unlist(dupeNames)
     duplicates<-unlist(ensemblNames.duplicatedSequences)[duplicates]
     if(length(duplicates)==0) {
     message("there exist duplicated names, but the sequences may not be actual duplicates; please pluck out or rename ...")
     duplicates<-as.data.frame(unlist(dupeNames))
     return(duplicates)
     } 
     
     else {
     duplicates<-Filter(length,duplicates)
     duplicateDF<-data.frame(duplicates)
     duplicateDF<-suppressWarnings(as.data.frame(duplicateDF,stringsAsFactors=FALSE))#factors errors indexKallisto
     duplicateLengths<-lengths(duplicateDF)
     message("there are duplicated sequences: ")
     #print(duplicateDF)
     return(suppressWarnings(duplicateDF))
     } #dupeLengths contains a dupe
   }

    if(length(dupeLengths)==0) {#empty list
    message("found no duplicated sequence names .... no dupes found")
    return(data.frame(row.names=names(dupeSeqs),duplicates=rep(0,length(names(dupeSeqs))))) #0

    }#no dupes were found 


}
#  else{  #stuff to delete...  chrs does not work with dupes FIX ME

 #   fastaFiles <- as.list(do.call(c, fastaFiles))
  #  allChrs <- do.call(rbind, lapply(fastaFiles, chrs))
 # if (anyDuplicated(allChrs$seqnames)) {
  #  dupes <- allChrs$seqnames[duplicated(allChrs$seqnames)]
  #  duped <- allChrs[which(allChrs$seqnames %in% dupes),]
  #  duped <- duped[order(duped$seqnames),]
  #  duped$allIdentical<-NA 
  #  duped$ID<-rownames(duped)#unique IDs
  #  dupeSeqs <- DNAStringSet(apply(duped, 1, getDupeSeq))
  #  duped<-.determineIdentical(duped,dupeSeqs)
    #creates a list each entry has duplicated sequence under the sequence name
    #splitDupe<-split(dupeSeqs,duped$seqname)[duped$seqnames]
    #  .printIdentical(splitDupe)
   #  return(duped)
  #}#

  # if no dupes,
#  return(NULL)
#}

#} #{{{ main

.determineIdentical<-function(duped,dupeSeqs)  {   
    
    for(i in 1:nrow(duped)){
         id<-duped$ID[duped$seqnames %in% duped$seqnames[i]]
         groupID<-dupeSeqs[which(names(dupeSeqs)==id)]
          #need to run toString and check seed match
          #output is identical Y or N
             seed<-groupID[1]
             for ( g in 1:length(groupID)){
                 if(setequal(seed,groupID[g])==TRUE){
                 duped[id,which(colnames(duped)=="allIdentical")][g]<-"Y"   
                  }#{{{ if seed is true
                           
                 if(setequal(seed,groupID[g])==FALSE){
                 duped[id,which(colnames(duped)=="allIdentical")][g]<-"N"
                   }#{{{ if seed FALSE
 
             }#{{{ for group ID
                
              
   } # for
     return(duped)
}#{{{ main
 

.printIdentical<-function(splitDupe){

uniqueDupe<-splitDupe[!duplicated(names(splitDupe))]
df<-sapply(uniqueDupe,function(x) length(x))
  for(j in 1:length(df)){  
   for( i in 1:df[j]){
 stopifnot(lapply(uniqueDupe[j],function(x) setequal(x[1],x[i]))==TRUE)
 message(paste0("The duplicated repeats ", names(df)[j]  ," at row number ", names(uniqueDupe[[j]])[i], " have identical sequences: ",lapply(uniqueDupe[j],function(x) setequal(x[1],x[i]))==TRUE))
  }# for i 
}#for j

}#{{{ printIdentical main

