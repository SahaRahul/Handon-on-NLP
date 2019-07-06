# Install necessary packages
install.packages("rJava")
install.packages('NLP')
install.packages('openNLP')

# require those packages
library(NLP)

# check your version of Java and modify accordingly
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_131') # for 64-bit version
library(rJava)
library(openNLP)


s <- paste(c("Pierre Vinken, 61 years old, will join the board as a ",
             "nonexecutive director Nov. 29.\n",
             "Mr. Vinken is chairman of Elsevier N.V., ",
             "the Dutch publishing group."),
           collapse = "")
s <- as.String(s)


## Chunking needs word token annotations with POS tags.
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()

a3 <- annotate(s,
               list(sent_token_annotator,
                    word_token_annotator))

pos_tag_annotator <- Maxent_POS_Tag_Annotator()

a4 <- annotate(s, pos_tag_annotator, a3)

install.packages("openNLPmodels.en", repos = "http://datacube.wu.ac.at", type="source")
library(openNLPmodels.en)

annotate(s, Maxent_Chunk_Annotator(), a4)
annotate(s, Maxent_Chunk_Annotator(probs = TRUE), a4)

a4w <- subset(a4, type == 'word')
tags <- sapply(a4w$features, '[[', "POS")

table(tags)

paste(s[a4w], tags, sep = '/')

install.packages("corpus")
library(corpus)

text <- "love loving lovingly loved lover lovely love"
text_tokens(text, stemmer = "en") # english stemmer


install.packages("hunspell")
library(hunspell)

stem_spellcorrect <- function(term) {
  # if the term is spelled correctly, leave it as-is
  if (hunspell::hunspell_check(term)) {
    return(term)
  }
  
  suggestions <- hunspell::hunspell_suggest(term)[[1]]
  
  # if hunspell found a suggestion, use the first one
  if (length(suggestions) > 0) {
    suggestions[[1]]
  } else {
    # otherwise, use the original term
    term
  }
}

text <- "spell checkers are not neccessairy for langauge ninja's"
text_tokens(text, stemmer = stem_spellcorrect)

