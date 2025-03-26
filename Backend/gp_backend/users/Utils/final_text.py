import pandas as pd
import numpy as np
import re
import joblib
import spacy
import nltk
import language_tool_python
from gensim.models import Word2Vec
from string import punctuation
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from spacy.lang.en.stop_words import STOP_WORDS
import warnings
warnings.simplefilter('ignore')
import os
script_dir = os.path.dirname(os.path.abspath(__file__))
################### load models 

snow = nltk.stem.SnowballStemmer('english')
nlp = spacy.load('en_core_web_sm')
tool = language_tool_python.LanguageTool('en-US')

word2vec_model = Word2Vec.load(f'{script_dir}/Models/word2vec_model.model')

# text model that we built
model = joblib.load(f'{script_dir}/Models/xgb_word2vec_model')


class TextModel():
    input_1 = pd.DataFrame()

    best_essays = [
        nlp('Since computers were invented, a colossal change in the way society functions has taken place. People how can go on to their computers to communicate with peers, get information on any topic for a school paper, or just because the internet to watch videos and stories. Magazine and newspaper articles, books and even movies and shows sre available on today\'s computer! This advancement in technology has made the @NUM1 century the most modern era this world has ever seen, and is beneficial to society. The "computer age" has given people in today\'s society the incredible opportunity to broaden their imaginations through technology. You can, in less than one minute go on the internet type in to @ORGANIZATION1 whatever movie or book you want and start watching instantly. People have always said that books can take you anywhere you want. Well, the computers can do the same thing, expect with greater efficiency and with more places to choosen from. You can, instead of buying a book, go online and read of the faraway city of @LOCATION1, or of the eruption of the @CAPS1 @CAPS2, and you can do it with mind-blowing speed. Some think that by wasting time on computers, people are using up time that could be spent studying or with family. Howeer, any information needed to your knowledge on a topic can be found on the internet. And if you want to spent time with your family, you can even look your computer up to a tv and watch a free movie with the family! The computer age is here and it is exactly. What society needs. Picture this: you\'re doing a school project on the you know nothing about it. Would you rather drive minutes going and thirty minutes looking withb everything you need, or do you think it\'s more to spend five minutes looking for the website you need on the internet? Obviously, the later of the is much more reasonable. The computer makes getting research for school or work substantially easier. In addition,you can create entire presentations on a computers with surprising ease! Being an eighth grade student, I dont know I would ever do woithout the internet. I rely on my computer to get all of my research for almost every project, and I even make some of my best project on it! The computer is the likes of all the hard working students and adults much, much easier. People\'s lives have not only been made easier in the field of research; computer make communicating with friends and familyeasier as well! Through e-mail, video chat and instant messaging., we can communicate with whoever we would, whenever we wort. With some computers, you can even see and talk to any person you wish. Without these computers, we will one again have to resort to snail mail, whcih makes instant communication @CAPS3 telephones, we would have no other way to talk. Computers have enhanced communication chill likes so graetly that it\'s foolish to say their not beneficial to society. How can a machine with so many abilities be for see the computer as a brooden research for school and we want! Bottom line the computer age is here and its amazing.'),
        nlp("Censorship is the most foul and terrifying part of society.  Our lives have been taken over by politcal correctness, so much so that our voices are no longer our own.  Until recently we had the freedom to convey our thoughts, no matter what those thoughts were, in any form of media.  But now if something is found to be offensive in any way it is essentially burned.  Censorship limits our freedoms, takes away our @CAPS2 as citizens and people, shields us from the truths of the world, and limits the knowledge we can take from, as well as ensuring that one day there will be nothing left of media.     The @CAPS1 of @CAPS2, the document that our country lives by, says that we as people have the right of free speech.  Censorship actively and violently violates that right.  Our country was built on free speech, and now it is being taken away.  Our own words forced down our throats, never allowed to come out.  Censorship ensures that no opinions will be heard, that no one's beliefs will be questioned, that no one can assume or think for themselves.  Is this not what we are supposedly guaranteed by freedom of speech?  We are supposed to be able to say anything we want to say.  We know there are consequences for saying certain things, but we are supposed to be allowed to say them.  Letting our own ideas into the world allows for new ideas to form.  Arguements come, but these arguements allow people to see other ideas that they hadn't thought of and look at issues from new perspectives.  We are able to see our world through different eyes when we hear or read someone else's opinions.  And from there we can form our own opinions, allowing our world to be rich with iddeas and knowledge, and allowing our society to advance.  But censorship wants to take this all away from us in order to please everyone.  But there will always be someone who is unhappy.  It's the inevitable truth.     Censorship is trying to shield us from the ugliness of this world.  In a way this makes sense.  We don't want our children to understand the atrocities that happen in everyday life.  We don't want them knowing what's happening behind closed doors.  However, if we don't allow people to open these doors, they can never understand the world or be prepared for the experiences that are to come.  Learning the harsh realities of our society educates people, allowing them to stop these realities as well as be prepared for when they happen to them.  For example, let's look at the issue of rape.  Rape is a horrible thing, but it happens.  It is a nasty part of reality.  Rape can be censored from books, televsion, and other forms of media.  We can walk around pretending rape doesn't exist.  But that doesn't accomplish anything.  That doesn't get rid of rape.  It still exists.  And if the people are uneducated on the issue of rape, how will it ever stop?  How will a rape ever be able to be prevented?  How will someone know what to expect or what to do?  By censoring rape from media, we are ensuring that the people in future generations never learn about rape.  Knowledge of rape is important if it is ever going to be stopped.  Pretending something doesn't exist doesn't get rid of it.  Censorship is supposed to protect the people, but it doesn't.  It hurts the people, cutting off their access to knowledge.     We as people need knowledge.  We live off of knowledge.  And the way we obtain this knowledge is through media.  Censorship takes away pieces of knowledge gradually.  It @MONTH1 not seem like a lot is missing now, but as time goes on the gap will increase, and more knowledge will be taken from our grasp.  Is this fair?  Is this right?  Is this helping us?  How does cutting out knowledge ever help?  It brings us backwards in time, makes us fear.  It is human nature to fear the unknown.  The more that becomes unknown, the more we have to fear.  Censorship is taking away crucial pieces of knowledge that we must understand to get along in society.  This is wrong and immoral.  It is unfair, if nothing else.  We should be allowed to take from any knowledge that exists.  No good comes from hiding it.     Lastly, this gradual burning of knowledge is affecting society in horrid ways.  And as time goes on it can only get worse.  Censorship is based off of offensiveness.  If something could be offensive, it is disposed of.  However, everything that exists in society could be offensive to someone.  Therefore everything and everyone should be censored in order to fulfill the goal of censorship.  This means all media of any kind should be destroyed.  No one should say anything.  The world would be forced to be silent.  All knowledge would be taken away.  Chaos would ensue.  The people's freedom would be completely taken away.  The freedom to know would vaporize right in front of their eyes.  This is our future if we allow the censorship to continue.  We cannot allow our lives to be taken over by censorship.  Yes, people's feelings will be hurt, but we cannot rid our world of ideas and knowledge purely to spare feelings.  These ideas and knowledge are too important to let censorship take away.     Censorship is taking away our freedoms and @CAPS2, slowly stealing them away from us.  It also tries to shield us from reality, but instead hurts us, ensuring that we will never understand our world and never be able to stop the very things that are being censored.  Censorship is affecting society, ensuring that our freedoms are to be taken away.  All knowledge will be trashed and no one will be able to voice their opinions.  A very dark future waits for us if censorship continues.  Only by helping people to understand censorship and the wrong it does to society can we gain back our freedom of speech; the freedom we are supposedly guaranteed, but censorship is desperately trying to take away."),
        nlp('In \x93Rough Road Ahead: Do Not Exceed Posted Speed Limit\x94, the author faces many obstacles because of the different terrain changes on his journey to Yosemite National Park. Taking advice from a group of old men, he headed to his first stop. The old men said he would see a town but what he really saw was a sort of ruined "ghost" town. Then he came to a fork in the road and was running out of water. He had been riding on flat road when the terrain dramatically changed. It became hilly and very inconsistent. This sudden change in terrain caused him to get more tired, thirsty, and hot. The cyclist then came to a huge hill and, using his last bit of energy, rode down. He was exhausted. All the terrain changes not only changed the cyclist\x92s physical state, but his mood and determination as well.  '),
        nlp('The author concludes the story, \x93winter hibiscus,\x94 with this paragraph of the story, for several relevant reasons. By concluding the story, in this way it shows Saeng\x92s growth, and more willingness to strive, and do her best. When she says she will take the test again, it shows her gain of confidence, and her beginning to gain comfort in the place that is not her home country. She is now striving and working toward doing her best to become successful. And she is making the very best of the given situation. The author is trying to give more depth and meaning to the study in this way. Saeng went from being nervous and worried when saying, \x93I-I failed the test,\x94 to now setting a goal for herself to take it again, the time the bud blooms next year. Basically, the author did a full circle, by ending the story in this way. From speaking of the test, to sharing the flower experience with her mother, to state that she will re-take the test, next year. '),
        nlp('The mood created by the author, Narciso Rodriguez, is clear in the memoir. You can sense throughout the whole story that he is completely grateful to his parents for the love they gave him, and their home life.                 In paragraph @NUM1, it says "Within its walls, my young parents created our traditional Cuban home, the very heart of which was the kitchen". Rodriguez is "eternally grateful" for his parents who "unwittingly passed on to meet their rich culinary skills and a love of cooking that is still with me today". They always had Passionate Cuban music that filled the air "Mixing with kitchen aromas." At the end of paragraph @NUM1, he says "Here, the innocence of childhood, congregation of family + friends, and endless celebrations form the backdrop to life in our warm home. I will never forget how my parents turned this house into a home."'),
        nlp('The builders of the Empire State Building faced many obstacles trying to construct this marvelous building One obstacle was making sure the stress of the building from the dirigible would go to the foundation of the building and not the top or middle where it could cause it to collapse. As said in the text "The steel frame of the Empire State Building would have to be modified and strengthened to accommodate this new situation. Over @MONEY1 worth of modifications had to be made to the building\'s framework." @CAPS1 the building had to be changed in many ways to make it stable enough for dirigible to dock.Another obstacle was the weather above the building which was very strong winds and air currents. This would mean that the dirigible would just be "dangling high above pedestrians on the street" and that\'s not a safe thing to have highly flammable hydrogen floating around above millions. An obstacle as well that came with these dirigibles was all the time and effort they had to put in to learn how to safely install a mooring mast. This took people going to professionals like the Navy and finding out the proper way. The mooring mast on the Empire State Building caused many obstacles to get in the way.'),
        nlp('Lots of people are good at being patient I\x92m not so good at it. But when your traveling along distance, you have to learn how to be patient. Several times a year, my mom, my sister, sometimes my dad, and I drive up to my @LOCATION2\x92s house. She lives about @NUM1 hours away, near @LOCATION1. My @LOCATION2 loves when family visits, so we don\x92t mind taking one weekend every few months to go and see her. I\x92ve had to have been there at least @NUM2 times in my life time. My mom works the night shift at a well known hardware store. Usually, she works @NUM3 @CAPS1 to @NUM4 @CAPS2. So when she gets off work we would pack up and leave. I always bring my @CAPS3 with me to keep me entertained. But most of the time I sleep. One time, I had drunk lots of pop and was very hyper. I was annoying my mom a lot. So, I put in my @CAPS3 with me to keep me entertained. But most of the time I sleep. One time, I had drank lots of pop and was very hyper. I was annoying my mom a lot. So, I put in my @CAPS3 and started acting like an idiot, singing along to the songs. Until, my @CAPS3 died. I felt my heart break a little. I couldn\x92t fall asleep now. I was still hyper. I started listening to the radio, but all we could listen to was country. Since, we were going @CAPS7, we were traveling away from the control tower of the cool radio stations. Finally, we reached, \x93The up @CAPS7 store\x94 where we always stop to get gas and food when we go to @LOCATION2\x92s. I got @CAPS8 and even more pop. I gave a tiny evil laugh to myself as I handed the items to my mom. In the car, I finished my food and was bored once again. There was nothing to do in that car. I was angry at that point. I looked out the window and sighed. Soon enough, I had fallen asleep. I woke up to the sound of us pulling into the drive way, and my @LOCATION2 running to come greet us. Finally, we were there. I had survived yet another, ride to @LOCATION2\x92s house. Then I remembered, we had to drive home too. Even though I make this trip several times a year, I\x92m almost positive will never stop getting bored during the ride. Being patient, is not one of my favorite things to do.'),
        nlp(' Bell rings.  Shuffle, shuffle. @CAPS1. Snap. EEEE. Crack. Slam. Click, stomp, @CAPS1. Tap tap tap. SLAM. Creak. Shoof, shoof.  Sigh. Seventh class of the day. Here we go. "@CAPS2! Tu va ou pas? On a +¬tude cette class-l+á. Tu peux aller au bibliotheque si tu veux...." @CAPS3 all blinked at me, @PERSON1, @NUM1le and @ORGANIZATION1, chocolate-haired and mocha skinned, impatiently awaiting my answer. The truth was, I knew @CAPS3 didn\'t really care if I came or not. It made no difference to them if I trailed a few feet behind like some pathetic puppy. I was silent but adorable, loved only because I was an @CAPS4. Because I spoke fidgety @CAPS5. Because I was the exchange student, because my translator and colorful clothes were so shocking for ten seconds, and were then forgotten about.  I was a flock of seagulls haircut. So why are you here? I thought. Why did you go on exchange at all? You are the complete opposite of everyone here. No one wants you. Just go home.  But my ego had a ready answer. You begged for this remember? For months and months, it was all you wanted, all you thought about, all you dreamt about. So I went with the girls. As expected, @CAPS3 walked down the three-person wide staircase side-by-side, and I shuffled awkwardly behind them. Finally arriving at @NUM2scalier, we sat at a table, the three girls talking. I glazed my eyes over, attempting to look lost in thought, as if I didn\'t care I wasn\'t included. Selfish thoughts buzzed in my head; if @CAPS3 weren\'t talking to me, why should I make the effort to talk to them?   I really had no idea how @CAPS3 felt about me. How does someone feel about their shadow? @CAPS3 notice it, sure, but it never offers up insight, it never makes you laugh. It\'s all in the confidence, said my mother\'s voice, all how you carry yourself. But I knew it wasn\'t that simple. I was just too alien. These girls would never understand me, as I would never understand them. In frustration, I started to flick peas across the room with my spoon. Pat, flick, sproing.  This caught the interest of @PERSON1, as @NUM1le and @ORGANIZATION1 were discussing something very emotional. Tears began to pour out of @ORGANIZATION1\'s eyes. Sniffling, she and @NUM1le went to the bathroom, leaving me all alone with @PERSON1. Only @PERSON2 could have felt my felt my same emotion as he stared up at @CAPS6. Silently, I continued shooting peas. @PERSON1 just stared at them as @CAPS3 darted around the room. Suddenly, with a horrible miscalculation, a pea hit a boy in the face. And then, he turned around and swore. And then, @PERSON1 and I looked at each other from across the table.  And then, we laughed.  We laughed so hard I cried. So hard that huge, alien tears flooded from my eyes. People around us were laughing too, even though @CAPS3 had no idea what was so funny. I didn\'t even know what was so funny. But it didn\'t matter, because we were dripping tears and snot, reaching for each other, reenacting the pea hitting the boy\'s face. It was as if we had been friends for years, and laughing happened all the time. It was saturated with all the angst and lonliness and despair I had felt the past four weeks. The connection we felt was instantaneous, like lightening, the kind of connection I felt with my best friends back home. I felt that huge swelling sensation in my chest, like a balloon was stuck inside. My stomach was aching and my cheeks were so sore I felt them seizing up. My heart felt whole even for that second. My soul was open. It was the best laugh of my life.  Sniffle sniffle. GASP. Laughter. GASP. Swipe of tears. Sniffle sniffle. Laughter. GASP. This is why. I thought. This is why you came.  Bell rings.')
    ]

    numerical_features = [  'corrections',
        'similarity',
        'token_count',
        'unique_token_count',
        'nostop_count',
        'sent_count',
        'ner_count',
        'comma',
        'question',
        'exclamation',
        'quotation',
        'organization',
        'caps',
        'person',
        'location',
        'money',
        'time',
        'date',
        'percent',
        'noun',
        'adj',
        'pron',
        'verb',
        'cconj',
        'adv',
        'det',
        'propn',
        'num',
        'part',
        'intj',
    ]

    def snowball_stemming(self, text):
        text = re.sub('[^a-zA-Z]', ' ', text)
        text = text.lower()
        text = text.split()
        text = [snow.stem(word) for word in text if not word in stopwords.words('english')]
        return ' '.join(text)

    def get_doc_embedding(self, tokens):
        embeddings = [word2vec_model.wv[word] for word in tokens if word in word2vec_model.wv]
        if embeddings:
            return np.mean(embeddings, axis=0)
        else:
            return np.zeros(word2vec_model.vector_size)
    
        
    def get_feature(self, text):
        self.input_1['essay'] = [text]
        self.input_1['matches'] = self.input_1['essay'].apply(lambda txt: tool.check(txt))
        self.input_1['corrections'] = self.input_1.apply(lambda l: len(l['matches']), axis=1)
        self.input_1['corrected'] = self.input_1.apply(lambda l: tool.correct(l['essay']), axis=1)

        sents = []
        tokens = []
        lemma = []
        pos = []
        ner = []

        stop_words = set(STOP_WORDS)
        stop_words.update(punctuation)
        
        for essay in nlp.pipe([text], batch_size=100, n_process=3):
            if essay.is_parsed:
                tokens.append([e.text for e in essay])
                sents.append([sent.text.strip() for sent in essay.sents])
                pos.append([e.pos_ for e in essay])
                ner.append([e.text for e in essay.ents])
                lemma.append([n.lemma_ for n in essay])
            else:
                # We want to make sure that the lists of parsed results have the
                # same number of entries of the original Dataframe, so add some blanks in case the parse fails
                tokens.append(None)
                lemma.append(None)
                pos.append(None)
                sents.append(None)
                ner.append(None)
        
        self.input_1['tokens'] = tokens
        self.input_1['lemma'] = lemma
        self.input_1['pos'] = pos
        self.input_1['sents'] = sents
        self.input_1['ner'] = ner

        self.input_1['token_count'] = self.input_1.apply(lambda x: len(x['tokens']), axis=1)
        self.input_1['unique_token_count'] = self.input_1.apply(lambda x: len(set(x['tokens'])), axis=1)
        self.input_1['nostop_count'] = self.input_1 \
            .apply(lambda x: len([token for token in x['tokens'] if token not in stop_words]), axis=1)
        
        self.input_1['sent_count'] = self.input_1.apply(lambda x: len(x['sents']), axis=1)
        self.input_1['ner_count'] = self.input_1.apply(lambda x: len(x['ner']), axis=1)
        self.input_1['comma'] = self.input_1.apply(lambda x: x['corrected'].count(','), axis=1)
        self.input_1['question'] = self.input_1.apply(lambda x: x['corrected'].count('?'), axis=1)
        self.input_1['exclamation'] = self.input_1.apply(lambda x: x['corrected'].count('!'), axis=1)
        self.input_1['quotation'] = self.input_1.apply(lambda x: x['corrected'].count('"') + x['corrected'].count("'"), axis=1)
        self.input_1['organization'] = self.input_1.apply(lambda x: x['corrected'].count(r'@ORGANIZATION'), axis=1)
        self.input_1['caps'] = self.input_1.apply(lambda x: x['corrected'].count(r'@CAPS'), axis=1)
        self.input_1['person'] = self.input_1.apply(lambda x: x['corrected'].count(r'@PERSON'), axis=1)
        self.input_1['location'] = self.input_1.apply(lambda x: x['corrected'].count(r'@LOCATION'), axis=1)
        self.input_1['money'] = self.input_1.apply(lambda x: x['corrected'].count(r'@MONEY'), axis=1)
        self.input_1['time'] = self.input_1.apply(lambda x: x['corrected'].count(r'@TIME'), axis=1)
        self.input_1['date'] = self.input_1.apply(lambda x: x['corrected'].count(r'@DATE'), axis=1)
        self.input_1['percent'] = self.input_1.apply(lambda x: x['corrected'].count(r'@PERCENT'), axis=1)
        self.input_1['noun'] = self.input_1.apply(lambda x: x['pos'].count('NOUN'), axis=1)
        self.input_1['adj'] = self.input_1.apply(lambda x: x['pos'].count('ADJ'), axis=1)
        self.input_1['pron'] = self.input_1.apply(lambda x: x['pos'].count('PRON'), axis=1)
        self.input_1['verb'] = self.input_1.apply(lambda x: x['pos'].count('VERB'), axis=1)
        self.input_1['noun'] = self.input_1.apply(lambda x: x['pos'].count('NOUN'), axis=1)
        self.input_1['cconj'] = self.input_1.apply(lambda x: x['pos'].count('CCONJ'), axis=1)
        self.input_1['adv'] = self.input_1.apply(lambda x: x['pos'].count('ADV'), axis=1)
        self.input_1['det'] = self.input_1.apply(lambda x: x['pos'].count('DET'), axis=1)
        self.input_1['propn'] = self.input_1.apply(lambda x: x['pos'].count('PROPN'), axis=1)
        self.input_1['num'] = self.input_1.apply(lambda x: x['pos'].count('NUM'), axis=1)
        self.input_1['part'] = self.input_1.apply(lambda x: x['pos'].count('PART'), axis=1)
        self.input_1['intj'] = self.input_1.apply(lambda x: x['pos'].count('INTJ'), axis=1) 
        best_similarity = 0
        for best_essay in self.best_essays:
            best_similarity = max(best_similarity, nlp(text).similarity(best_essay))
        self.input_1['similarity'] = best_similarity
        self.input_1['clean_essay'] = self.input_1['corrected'].apply(self.snowball_stemming)
        self.input_1['clean_essay_tokens'] = self.input_1['clean_essay'].apply(word_tokenize)
        
    def result(self, predictions):
        
        return {
            'Total_Score': predictions[0], 
            'Unique_Tokens_Count': self.input_1["unique_token_count"][0],
            'Tokens_Count': self.input_1["token_count"][0],
            'Stopwords_Count': self.input_1["token_count"][0] - self.input_1["nostop_count"][0],
            'Sentences_Count': self.input_1["sent_count"][0],
            'Number_of_grammatical_error' : self.input_1["corrections"][0],
            'corrected_text' : self.input_1["corrected"][0],
        }
    
    def run(self, test):
        try:
            self.input_1.drop(self.input_1.index, inplace=True)
            self.get_feature(test)

            tokenized_essays = self.input_1['clean_essay_tokens']

            X_numeric = self.input_1[self.numerical_features]

            X_word_embeddings = tokenized_essays.apply(self.get_doc_embedding).tolist()

            X_combined = np.hstack([X_numeric.values, np.array(X_word_embeddings)])

            predictions = model.predict(X_combined)

            return {
                'status_ok' : True,
                'data': self.result(predictions)
            }
        except Exception as e:
            return {
                'status_ok' : False,
                'error' : str(e)
            }
