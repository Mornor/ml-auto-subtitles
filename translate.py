import boto3

class VideoFile():
  def __init__(self):
    self._audio_track = self._extract_audio()

  def _extract_audio(self):
    return 0

def upload_audio_to_s3():
  s3 = boto3.resource('s3')
  s3.meta.client.upload_file('./audio_trimmed.mp3', 's3-ec1-app-bucket', 'audio.mp3')


upload_audio_to_s3()
