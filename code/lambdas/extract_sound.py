from moviepy.editor import AudioFileClip
import boto3
import io

# Download movie from S3 (/inputs) onto memory
def download_movie_from_s3():
  print('TODO')

# Extract sound from the movie
def extract_sound(movie):
  print('TODO')

# Upload sound to S3 (/tmp)
def upload_audio():
  print('TODO')

def handler(event, context):
    # Retrieve bucket name and file_key from the S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    s3 = boto3.resource('s3')
    data_stream = io.BytesIO()
    s3.meta.client.download_fileobj(bucket_name, file_key, data_stream)
    print('Bucket = ' +bucket_name)
    print('File key = ' +file_key)
    return None



  # audio = AudioFileClip(video_path)
  # audio.write_audiofile('./audio.mp3')

"""
# Download file onto memory - example
import io

data_stream = io.BytesIO()
s3.meta.client.download_fileobj(const.bucket_name,
                               'class/raw/photo/' + message['photo_name'],
                                data_stream)
data_stream.seek(0)
"""
