import dropbox
import json
import httpx
from dropbox.exceptions import ApiError
from deepgram import DeepgramClient, PrerecordedOptions
from moviepy.editor import VideoFileClip
import os
from dotenv import load_dotenv
load_dotenv()
DEEPGRAM_API_KEY = os.getenv('DEEPGRAM_API_KEY')

def convert_video_to_audio(video_path, file_name):
    try:
        video = VideoFileClip(video_path)
        audio = video.audio
        target_audio_path = f'./Saved/{file_name}.wav'
        audio.write_audiofile(target_audio_path)
        return {"status_ok" : True,
                 "data": target_audio_path}
    except Exception as e:
        return {"status_ok" : False,
                 "error": "Couldn't open video file"}
    


def get_text_path_from_audio(file_path, file_name, timeout=1200):

    # get access token
    load_dotenv()
    DROPBOX_ACCESS_TOKEN = os.getenv('DROPBOX_ACCESS_TOKEN')
    root_target_path = '/Apps/Fluent Flow/'
    target_path = f'{root_target_path}{file_name}'
    try:
        dbx = dropbox.Dropbox(DROPBOX_ACCESS_TOKEN, timeout=timeout)
        dbx._session.verify = False
    except Exception as e:
        print('error in connecting')
        return {"status_ok" : False, "error": str(e)}
    with open(file_path, "rb") as f:
        try:
            dbx.files_upload(f.read(), target_path)
        except Exception as e:
            print('error in file upload to dropbox')
            return {"status_ok" : False, "error": str(e)}

    shared_link_metadata = dbx.sharing_create_shared_link_with_settings(target_path)
    url = shared_link_metadata.url
    download_url = url.replace("&dl=0", "&dl=1")
    json_file_path = f'./Saved/{file_name}.json'
    print('Got downloadable link')
    print(download_url)
    AUDIO_URL = {
        "url": download_url
    }   
    try:
        deepgram = DeepgramClient(DEEPGRAM_API_KEY)

        options = PrerecordedOptions(
            model="nova-2",
            language="en",
            smart_format=True, 
            punctuate=True, 
            filler_words=True, 
            sentiment=True, 
        )

        response = deepgram.listen.prerecorded.v("1").transcribe_url(AUDIO_URL, options, timeout=httpx.Timeout(timeout, connect=10.0))
        json_data = json.loads(response.to_json(indent=4))
        with open(json_file_path, 'w') as file:
            json.dump(json_data, file, indent=4) 

    except Exception as e:
        return {"status_ok" : False, "error": "Connection Error(Deepgram)"}
    return {"status_ok" : True, "data": json_file_path}
