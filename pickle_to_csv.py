import pickle
import csv

def load(filename):
    with open(filename, "rb") as f:
        while True:
            try:
                yield pickle.load(f)
            except EOFError:
                break

def addToCSV(filename):
    items = load(filename)
# text, hashtags, id, coordinates

    for tweet_dict in items:
        for i in range(len(tweet_dict["hashtags"])):
            row = []
            coorx = tweet_dict["coordinates"]["coordinates"][0]
            coory = tweet_dict["coordinates"]["coordinates"][1]
            row.append(('%.2f' % (coorx)))
            row.append(('%.2f' % (coory)))
            row.append(tweet_dict["hashtags"][i]['text'].encode('utf8'))
            with open('text-hashtag-id-co.csv', 'a') as csvf:
                csvfw = csv.writer(csvf)
                csvfw.writerow(row)
            
        

def main():
    addToCSV("geohashtag_2.txt")
    addToCSV("geohashtag.txt")

if __name__ == '__main__':
   main()




