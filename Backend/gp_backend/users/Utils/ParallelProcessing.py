from concurrent.futures import ThreadPoolExecutor
from .vid_to_text import *
from .AudioEvaluation import AudioClassifier
from .final_text import TextModel
from .VideoEvaluation import VideoEvaluation
import time



def get_and_process_text(Audio_Classifier, audio_path, file_name):

    start = time.time() 
    print("Inside process and get text")
    response = get_text_path_from_audio(audio_path, file_name)
    if response['status_ok']:
        text_json_path = response["data"]
    else: 
        return response
    print("Got text")

    response_text_audio = Audio_Classifier.eval_text_from_audio(text_json_path)
    if response_text_audio['status_ok']:
        result_text_audio = response_text_audio['data']
    else:
        return response_text_audio
    
    print("Got reponse fromaudio calss")

    # text model eval scoring: 
    text_model = TextModel()
    response_text_text = text_model.run(result_text_audio['transcription'])
    if response_text_text['status_ok']:
        result_text_text = response_text_text['data']
    else:
        return response_text_text

    print("process text done in ", (time.time() - start))

    return  {'status_ok' : True, 'data' : {**result_text_audio, **result_text_text}}
    
def get_and_process_only_text(text):

    start = time.time() 
    print("Inside process and get text")

    # text model eval scoring: 
    text_model = TextModel()
    response_text_text = text_model.run(text)
    if response_text_text['status_ok']:
        result_text_text = response_text_text['data']
    else:
        return response_text_text

    print("process text done in ", (time.time() - start))

    return  {'status_ok' : True, 'data' : {**result_text_text}}

def process_audio(Audio_Classifier, audio_path):
    # return {'status_ok': True, 'data':{'pdq' : 1}}
    start = time.time()
    print("iniside process audio")
    response_pdq =  Audio_Classifier.eval_audio(audio_path)
    print("process audio done in " , (time.time() - start))
    return response_pdq

def audio_parallel(video_path, file_name):
    # return {'status_ok' : True, 'data': {'idk':1}}
    print("inside audio parallel")
    response_audio = convert_video_to_audio(video_path, file_name)
    if response_audio['status_ok']:
        audio_path = response_audio['data']
    else:
        return response_audio
    Audio_Classifier = AudioClassifier()

    with ThreadPoolExecutor(max_workers=2) as subexecuter:
        # get text andprocesstext
        subfuture1 = subexecuter.submit(get_and_process_text,Audio_Classifier, audio_path, file_name)
        # process audio
        subfuture2 = subexecuter.submit(process_audio, Audio_Classifier, audio_path)

        response_text = subfuture1.result()
        response_pdq = subfuture2.result()

    print("audio parallel done")
    if response_text['status_ok']:
        result_text = response_text['data']
    else:
        return response_text
    
    if response_pdq['status_ok']:
        result_pdq = response_pdq['data']
    else:
        return response_pdq
    return {'status_ok' : True, 'data' : {**result_text, **result_pdq}}

def video_parallel(video_path):
    print("inside video parallel")
    frames_to_skip = 10
    videval = VideoEvaluation(video_path=video_path, frames_to_skip=frames_to_skip)
    video_response = videval.run()
    if video_response['status_ok']:
        video_result = video_response['data']
    else:
        return video_response
    print("video parallel done")
    return {'status_ok': True, 'data':video_result}


def get_results(video_path, file_name):
    with ThreadPoolExecutor(max_workers=2) as executor:
        future1 = executor.submit(audio_parallel, video_path, file_name)
        future2 = executor.submit(video_parallel, video_path)
        response_audio = future1.result()
        response_video = future2.result()

    print("done parallel proceessing")
    if response_audio['status_ok']:
        result_audio = response_audio['data']
    else:
        return response_audio
    
    if response_video['status_ok']:
        result_video = response_video['data']
    else:
        return response_video
    return  {'status_ok' : True, 'data' :{**result_audio, **result_video}}

