import sys
import tweepy
import os

#Set Twitter authentication keys
ckey = os.environ.get('CKEY')
ctoken = os.environ.get('CTOKEN')
atoken = os.environ.get('ATOKEN')
asecret = os.environ.get('ASECRET')
    
class CustomStreamListener(tweepy.streaming.StreamListener):

    def on_data(self, raw_data):
        with open('geotagged_tweets_english.txt','a') as tf:
            tf.write(raw_data)
        return True

    def on_error(self, status_code):
        print status_code
        return True # Don't kill the stream

    def on_timeout(self):
        print 'Timeout...'
        return True # Don't kill the stream

if __name__ == '__main__':

    my_listener = CustomStreamListener()
    auth = tweepy.OAuthHandler(ckey, ctoken)

    auth.set_access_token(atoken, asecret)
    sapi = tweepy.streaming.Stream(auth, my_listener)  

    # locations is given as East, North GPS of lower left coordinate and East, North of upper right GPS
    sapi.filter(locations=[-180,-90,180,90], languages = ['en'])
    
