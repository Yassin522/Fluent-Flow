import numpy as np
import joblib
import json
from scipy.spatial.distance import jensenshannon

class AudioClassifier:
    def __init__(self):
        # initialize scalers + stats
        root_path = './Saved_utils/'
        self.scaler = {
            "filler" : joblib.load(f'{root_path}filler_scaler.joblib'),
            "speed" : joblib.load(f'{root_path}speed_scaler.joblib'), 
            "pdq" : joblib.load(f'{root_path}pdq_scaler.joblib'), 
            "pause" : joblib.load(f'{root_path}pause_scaler.joblib'),
            "sentence" : joblib.load(f'{root_path}sentence_scaler.joblib'),
        }
        self.stats = {}
        with open(f'{root_path}filler_stats.json', 'r') as f:
            self.stats["filler"] = json.load(f)
        with open(f'{root_path}speed_stats.json', 'r') as f:
            self.stats["speed"] = json.load(f)
        with open(f'{root_path}pdq_stats.json', 'r') as f:
            self.stats["pdq"] = json.load(f)
        with open(f'{root_path}pause_stats.json', 'r') as f:
            self.stats["pause"] = json.load(f)
        with open(f'{root_path}sentence_stats.json', 'r') as f:
            self.stats["sentence"] = json.load(f)
        with open(f'{root_path}speed_variation.json', 'r') as f:
            self.stats["speed_variation"] = json.load(f)
    
    def eval_audio(self, input_audio_path):
        try:
            result_audio = features_from_audio(input_audio_path)
            pdq_score=self.classify_pdq(result_audio["PDQ"])
            return {
                'status_ok' : True,
                'data': {"pdq_score":pdq_score}
            }
        except Exception as e:
            return{
                'status_ok' : False,
                'error' : str(e)
            }

    
    def eval_text_from_audio(self, input_text_path):
        try:
            result_text = features_from_text(input_text_path)
            if(result_text is None):
                raise Exception("No one is speaking in the video")
            filler_score = self.classify_filler(result_text["fillers_to_all_ratio"])
            # TODO: mix speed and speed variation scores togethor
            speed_score = self.classify_speed(result_text["syllables_per_second"])
            speed_variation_score=self.classify_speed_variation(result_text["sps_distribution"])

            pause_score = self.classify_pause(result_text["pause_to_text_ratio"])
            # sentence_length_score = self.classify_avg_sentence_length(result_text["average_sentence_word_count"])

            return {
                'status_ok' : True,
                'data': {
                    "transcription" : result_text['transcription'],
                    "filler_score":filler_score,
                    "speed_score" : speed_score,
                    "speed_variation_score" : speed_variation_score,
                    "pause_score":pause_score,
                    "sentence_length_score":result_text["average_sentence_word_count"]
                }
            }
        except Exception as e:
            return{
                'status_ok' : False,
                'error' : str(e)
            }


    def classify_filler(self, filler_to_all_ratio, fine_tune_val = 10):
        q3 = self.stats["filler"]["q3"]
        filler_to_all_ratio = self.scaler["filler"].transform(np.array([filler_to_all_ratio]).reshape(-1, 1)).flatten()[0]
        if filler_to_all_ratio <= q3:
            return 0
        percentage = (filler_to_all_ratio-q3)/ fine_tune_val
        return min(5, percentage * 4 + 1)
    
    
    def classify_speed(self, speed, fine_tune_val = 7):
        q1 = self.stats["speed"]['q1']
        q3 = self.stats["speed"]['q3']
        iqr = self.stats["speed"]['iqr']
        upper_fence = q3 + 1.5 * iqr
        lower_fence = q1 - 1.5 * iqr
        speed = np.array([speed]).reshape(-1, 1)
        speed = self.scaler["speed"].transform(speed)
        speed = speed.flatten()[0]
        if(speed <= q3 and speed >= q1): return 0 
        if speed > q3:
            if speed < upper_fence:
                percentage = (speed - q3)/(upper_fence - q3)    
                return percentage * 3 + 1
            else:
                percentage = (speed - q3) / (fine_tune_val)
                return min(5, percentage * 2 + 4)
        else:
            if speed > lower_fence:
                percentage = (speed - q1)/(lower_fence - q1)
                return -1 * (percentage * 3 + 1)
            else:
                percentage = (speed - q1) / (fine_tune_val)
                return max(-5, -1 * (percentage * 2 + 4))

    def classify_speed_variation(self, distribution_values):
        def transform_range(val , OldMax):
            OldMin = 0
            NewMin = 0
            NewMax = 5
            OldRange = (OldMax - OldMin)  
            NewRange = (NewMax - NewMin)  
            return (((val - OldMin) * NewRange) / OldRange) + NewMin


        extreme_variation = np.array(self.stats["speed_variation"]["extreme_variation"])
        extreme_monotone = np.array(self.stats["speed_variation"]["extreme_monotone"])
        base_data = np.array(self.stats["speed_variation"]["base_data"])

        test_data = np.array(distribution_values)
        similarity_to_base = jensenshannon(test_data, base_data)
        similarity_to_extreme_monotone = jensenshannon(test_data, extreme_monotone)
        similarity_to_extreme_variation = jensenshannon(test_data, extreme_variation)

        if(similarity_to_extreme_monotone < similarity_to_extreme_variation):
            # if the distribution is more siilar to a monotone districbution then its in the negative
            result = transform_range(similarity_to_base, self.stats["speed_variation"]["monotone_min"])
            result *= -1
        else:
            result = transform_range(similarity_to_base, self.stats["speed_variation"]["varaition_min"])

        return result
    
    def classify_pdq(self, mean_pdq, fine_tune_val = 7):

        q1 = self.stats["pdq"]['q1']
        q3 = self.stats["pdq"]['q3']
        iqr = self.stats["pdq"]['iqr']
        upper_fence = q3 + 1.5 * iqr
        lower_fence = q1 - 1.5 * iqr
        mean_pdq = np.array([mean_pdq]).reshape(-1, 1)
        mean_pdq = self.scaler["pdq"].transform(mean_pdq).flatten()[0]
        lower_zero_val = self.scaler["pdq"].transform(np.array([0]).reshape(-1,1)).flatten()[0]

        if mean_pdq <= q3 and mean_pdq>= q1:
            return 0
        if mean_pdq < q1:
            percentage = (mean_pdq - q1)/(lower_zero_val - q1)
            return max(-5, -1 * (percentage * 4 + 1))
        else:
            if mean_pdq <= upper_fence:
                percentage = (mean_pdq - q3)/(upper_fence - q3)
                return percentage * 3 + 1
            else:
                percentage = (mean_pdq - q3)/(fine_tune_val)
                return min(5, percentage * 2 + 4)
            
    def classify_pause(self, pause_ratio, fine_tune_val = 7):
        q1 = self.stats["pause"]['q1']
        q3 = self.stats["pause"]['q3']
        iqr = self.stats["pause"]['iqr']
        upper_fence = q3 + 1.5 * iqr
        lower_fence = q1 - 1.5 * iqr
    
        pause_ratio = self.scaler["pause"].transform(np.array([pause_ratio]).reshape(-1, 1)).flatten()[0]

        if(pause_ratio <= q3 and pause_ratio >= q1): return 0 
        if pause_ratio > q3:
            if pause_ratio < upper_fence:
                percentage = (pause_ratio - q3)/(upper_fence - q3)    
                return percentage * 3 + 1
            else:
                percentage = (pause_ratio - q3) / (fine_tune_val)
                return min(5, percentage * 2 + 4)
        else:
            if pause_ratio > lower_fence:
                percentage = (pause_ratio - q1)/(lower_fence - q1)
                return -1 * (percentage * 3 + 1)
            else:
                percentage = (pause_ratio - q1) / (fine_tune_val)
                return max(-5, -1 * (percentage * 2 + 4))
        
    def classify_avg_sentence_length(self,sentence_length, fine_tune_val = 7):
        q1 = self.stats["sentence"]['q1']
        q3 = self.stats["sentence"]['q3']
        iqr = self.stats["sentence"]['iqr']
        upper_fence = q3 + 1.5 * iqr
        lower_fence = q1 - 1.5 * iqr
        
        sentence_length = self.scaler["sentence"].transform(np.array([sentence_length]).reshape(-1, 1)).flatten()[0]

        if(sentence_length <= q3 and sentence_length >= q1): return 0 
        if sentence_length > q3:
            if sentence_length < upper_fence:
                percentage = (sentence_length - q3)/(upper_fence - q3)    
                return percentage * 3 + 1
            else:
                percentage = (sentence_length - q3) / (fine_tune_val)
                return min(5, percentage * 2 + 4)
        else:
            if sentence_length > lower_fence:
                percentage = (sentence_length - q1)/(lower_fence - q1)
                return -1 * (percentage * 3 + 1)
            else:
                percentage = (sentence_length - q1) / (fine_tune_val)
                return max(-5, -1 * (percentage * 2 + 4))






# ________________________HELPER FUNCTIONS__________________________
import numpy as np
import json
import pandas as pd
import librosa

import nltk
import pyphen
from nltk.corpus import cmudict
# nltk.download('cmudict')
d = cmudict.dict()
from collections import Counter
# GLOBAL VARIABLES
EPSILON=0.5
CUT = 43

# HELPER FUNCTIONS
def count_syllables1(word):
    dic = pyphen.Pyphen(lang='en')
    hyphenated = dic.inserted(word)
    syllables = hyphenated.split('-')
    return len(syllables)

def count_syllables(word):
    word = word.lower()
    if word in d:
        pronunciation = d[word][0]
        syllable_count = len([phoneme for phoneme in pronunciation if phoneme[-1].isdigit()])
        return syllable_count
    else:
        return count_syllables1(word)

def round_to_nearest_np(arr, min_val, max_val, step):
    ref_values = np.arange(min_val, max_val, step)
    arr = arr[:, np.newaxis]  # Shape (n, 1)
    ref_values = ref_values[np.newaxis, :]  # Shape (1, m)
    diff = np.abs(arr - ref_values)

    nearest_indices = diff.argmin(axis=1)

    rounded_array = ref_values[0, nearest_indices]
    return rounded_array

def calc_PDQ(f0):
    std = np.std(f0)
    mean = np.mean(f0)
    return std / mean

# --- END HELPER FUNCTIONS

def features_from_text(json_file_path):
    with open(json_file_path, "r") as json_file:
        json_data = json.load(json_file)
    print(type(json_data))
    filler_words = ["uh", "um", "mhmm",  "mm-mm", "uh-uh", "uh-huh", "nuh-uh", "like", "well", "so", "yeah"]
    # you know, i mean I guess

    word_list = json_data["results"]["channels"][0]["alternatives"][0]["words"]
    full_transcription = json_data['results']['channels'][0]['alternatives'][0]['transcript']
    if(len(word_list) == 0):
        return None

    duration = word_list[len(word_list) - 1]["end"] - word_list[0]["start"]

    # ----------- FILLERS --------------
    filler_word_count = 0
    word_count_with_filler = len(word_list)

    for i, item in enumerate(word_list):
        if  item["word"].lower() in filler_words:
            filler_word_count += 1
        elif(item["word"].lower() == "i" and (i + 1 < len(word_list) and (word_list[i+1]["word"].lower() == "mean" or word_list[i+1]["word"].lower() == "guess"))):
            filler_word_count += 2
        elif(item["word"].lower() == "you" and (i + 1 < len(word_list) and word_list[i+1]["word"].lower() == "know")):
            filler_word_count += 2

    fillers_to_all_ratio = filler_word_count / word_count_with_filler

    # ----------- PAUSES --------------
    pauses = []
    n = len(word_list)
    for i in range(1, n):
        cur_item = word_list[i]
        last_item = word_list[i-1]
        dif = (cur_item["start"] - last_item["end"]) 
        if dif > EPSILON:
            # pauses.append((dif, last_item["end"], cur_item["start"]))
            pauses.append(dif)   
    pauses = np.array(pauses)
    number_of_pauses = len(pauses)
    pause_to_text_ratio = number_of_pauses/ duration

    # ---------- AVG SENTENCE LENGTH ----------
    sentence_word_count = []
    paragraphs_list = json_data["results"]["channels"][0]["alternatives"][0]["paragraphs"]["paragraphs"]
    for paragraph in paragraphs_list:
        sentences_list = paragraph["sentences"]
        for sentence in sentences_list:
            word = sentence["text"].split()
            sentence_word_count.append(len(word))

    sentence_word_count = np.array(sentence_word_count)
    average_sentence_word_count = np.mean(sentence_word_count)


    # -------- SPEED -------------------
    sps_variations = []
    syl_cnt = count_syllables(word_list[0]["word"])

    start = word_list[0]["start"]
    n = len(word_list)
    for i in range(1, n):
        cur_item = word_list[i]
        last_item = word_list[i-1]
        dif = (cur_item["start"] - last_item["end"]) 
        if dif > EPSILON:
            end = last_item["end"]
            syl_val = syl_cnt/(end - start)
            sps_variations.append(syl_val)
            start = cur_item["start"]
            syl_cnt = count_syllables(cur_item["word"])
        else:
            syl_cnt += count_syllables(cur_item["word"])



    sps_variations = np.array(sps_variations)

    mean_sps = np.mean(sps_variations)

    sps_dif_from_mean = mean_sps - sps_variations
    binned_sps_dif_from_mean = round_to_nearest_np(sps_dif_from_mean, -2.5, 3, 0.5)
    counts = Counter(binned_sps_dif_from_mean)
    percentage_dict = {}
    length = sps_dif_from_mean.shape[0]

    for key, val in counts.items():
        percentage_dict[key] = (val*100)/length
    
    sps_distribution = []
    for i in np.arange(-2.5, 3,0.5):
        sps_distribution.append(percentage_dict.get(i, 0))
        
    # ----------- DONE ----------------
    result = {
        "transcription": full_transcription, 
        "fillers_to_all_ratio" : fillers_to_all_ratio,
        "pause_to_text_ratio" : pause_to_text_ratio,
        "average_sentence_word_count" : average_sentence_word_count,
        "sps_distribution" : sps_distribution,
        "syllables_per_second" : mean_sps
    }
    return result

def features_from_audio(audio_file_path):
    y, _ = librosa.load(audio_file_path)
    f0, _, _ = librosa.pyin(y, fmin=librosa.note_to_hz('C2'), fmax=librosa.note_to_hz('C7'))
    mask = ~np.isnan(f0)
    f0 = f0[mask]
    f0 = np.array(f0)
    CV = calc_PDQ(f0)
    result = {"PDQ" : CV}
    return result
