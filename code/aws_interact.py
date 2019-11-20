import boto3
import time

class AwsInteract:
    def __init__(self, aws_region, path_audio_input, bucket_name, s3_file_name):
        self.path_audio_input = path_audio_input
        self.bucket_name = bucket_name
        self.s3_file_name = s3_file_name
        self.aws_region = aws_region

    def upload_audio_to_s3(self):
        s3 = boto3.resource('s3')
        s3.meta.client.upload_file(self.path_audio_input, self.bucket_name, self.s3_file_name)

    def transribe(self, transcribe_job_name):
        transcribe = boto3.client('transcribe')
        job_name = transcribe_job_name
        job_uri = 'https://'+self.bucket_name+'.s3.' + self.aws_region+'.amazonaws.com/'+self.s3_file_name
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


