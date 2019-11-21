import utils
import aws_interact
import urllib
import json
import shutil

class Transcribe():
    def __init__(self, config):
        self._utils = utils.Utils()
        self._aws_interact = aws_interact.AwsInteract()
        self._transcribe_job_name = self._utils._randomize_job_name()
        self._s3_file_name = self._utils._randomize_job_name()+'.mp3'
        self._path_audio_input = config['path_audio_input']
        self._aws_region = config['aws_region']
        self._bucket_name = config['bucket']
        self._path_transcribe_result_output = './transcribe_result.json'
        self._path_subtitle_file = config['path_srt_output']

    # Upload audio file to S3 Bucket
    def _upload_audio_to_s3(self):
        self._aws_interact._upload_audio_to_s3(self._path_audio_input, self._bucket_name, self._s3_file_name)

    # Run the AWS Transcribe job, download and locally save the result
    def _transcribe_and_save(self):
        transcribe_file_url = self._aws_interact._transribe(self._transcribe_job_name, self._aws_region, self._bucket_name, self._s3_file_name)
        self._aws_interact._download_from_url(transcribe_file_url, self._path_transcribe_result_output)

    # Parse the Transcribe result JSON file into .srt format
    def _parse_transcribe_result(self):
        phrases = self._utils._parse_transcribe(self._path_transcribe_result_output)
        self._utils._write_srt_file(phrases, self._path_subtitle_file)

    def run(self):
        self._upload_audio_to_s3()
        self._transcribe_and_save()
        self._parse_transcribe_result()


if __name__ == '__main__':
    # Load config object
    with open('./config.json') as file:
        config = json.load(file)

    Transcribe(config).run()