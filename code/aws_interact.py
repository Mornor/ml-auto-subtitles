import boto3
import time
import urllib
import shutil

class AwsInteract:
    def _upload_audio_to_s3(self, path_audio_input, bucket_name, s3_file_name):
        s3 = boto3.resource('s3')
        s3.meta.client.upload_file(path_audio_input, bucket_name, s3_file_name)

    def _transribe(self, transcribe_job_name, aws_region, bucket_name, s3_file_name):
        transcribe = boto3.client('transcribe')
        job_name = transcribe_job_name
        job_uri = 'https://' + bucket_name + '.s3.' + aws_region + '.amazonaws.com/' + s3_file_name
        transcribe.start_transcription_job(
            TranscriptionJobName=job_name,
            Media={'MediaFileUri': job_uri},
            MediaFormat='mp3',
            LanguageCode='en-US'
        )

        while True:
            status = transcribe.get_transcription_job(
                TranscriptionJobName=job_name)
            if status['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
                break
            print('Translating audio...')
            time.sleep(5)

        response_url = transcribe.get_transcription_job(TranscriptionJobName=transcribe_job_name)
        translated_file_url = response_url['TranscriptionJob']['Transcript']['TranscriptFileUri']

        return translated_file_url

    def _download_from_url(self, url, local_output_path):
        with urllib.request.urlopen(url) as response, open(local_output_path, 'wb') as out_file:
            shutil.copyfileobj(response, out_file)
        print('Translation done and saved under: ' +local_output_path)
