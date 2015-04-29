import json
import re
import csv
import twokenizer

'''
Each line contains valid JSON, but as a whole, it 
is not a valid JSON value as there is no top-level 
list or object definition.
'''

def processJSON_text(filename):

    '''
    Go through tweets save each as a list of tuples with tweet ID, text 
    and country ID as values
    '''
    data = []
    for line in open(filename, 'r'):
        line = line.strip()
        if line:
            json_line = json.loads(line)
            if json_line.get("place") and json_line.get("lang"):
                data.append((json_line.get("id"), json_line.get("text"), 
                    json_line.get("place").get("country_code")))
    return data

def processTweets(tweet_tuples):
    filter_prefix_set = ('@', 'http', 'rt', 'www')
    real_tweets = []
    # filter for english
    for status in tweet_tuples:
        tweet_split = status[1].encode('ascii', 'ignore').lower()
        if tweet_split:
            tokenized = twokenizer.tokenize(tweet_split)
            # get rid of stopwords
            # no_stopwords_tweet = [word for word in tokenized if word not in common_words_set]
            # get rid of punctuation and internet terms
            just_real_words = [re.sub(r'[^\w\s]','', word) for word 
                                        in tokenized 
                                        if not word.startswith(filter_prefix_set)
                                    ]
            if just_real_words:
                real_tweets.append((status[0], ' '.join(just_real_words), status[2]))
    return real_tweets

# test = processTweets(processJSON_text('geotagged_tweets.txt'))

#def main():
json_data =  processJSON_text('geotagged_tweets_english.txt')
print len(json_data)
real_tweets_tuple_list = processTweets(json_data)
print real_tweets_tuple_list[0:10]
print len(real_tweets_tuple_list)

#if __name__ == '__main__':
#    main()
# 

## Countries in the set
country = set([country for (id, text, country) in real_tweets_tuple_list])

## 
counts_per_country = {}

for c in country:
    counts_per_country[c] = len([id for (id, text, country) in real_tweets_tuple_list if country == c])

with open('id-text-country.csv', 'w') as filename:
    f = csv.writer(filename)
    for t in real_tweets_tuple_list:
        f.writerow(t)

