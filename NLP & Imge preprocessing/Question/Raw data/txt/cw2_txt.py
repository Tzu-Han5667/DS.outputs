from textblob import TextBlob
text="I am happy today. I feel sad today."
blob=TextBlob(text)
print(blob.sentences)
