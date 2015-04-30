import pickle
import csv

def load(filename):
    with open(filename, "rb") as f:
        while True:
            try:
                yield pickle.load(f)
            except EOFError:
                break

items = load('geohashtag.txt')
# text, hashtags, id, coordinates
with open('text-hashtag-id-co.csv', 'a') as csvf:
    csvfw = csv.writer(csvf)
    for tweet_dict in items:
        for k in tweet_dict.keys():
            for i in range(len(tweet_dict[k])):
                dict_ascii = tweet_dict[k][i].encode('ascii', 'ignore').lower()
        # print [dict_ascii for k in tweet_dict.keys()]
        # csvfw.writerow((tweet_dict[k] 
            # for k in tweet_dict.keys()))




