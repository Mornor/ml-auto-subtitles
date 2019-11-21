import utils
import aws_interact
import urllib
import json
import shutil

class Transcribe():
    def __init__(self, path_audio_input, path_subtitle_file, region, bucket):
        self.utils = utils.Utils()
        self.aws_interact = aws_interact.AwsInteract()
        self.transcribe_job_name = self.utils._randomize_job_name()
        self.s3_file_name = self.utils._randomize_job_name()+'.mp3'
        self.path_audio_input = path_audio_input
        self.aws_region = region
        self.bucket_name = bucket
        self._path_transcribe_result_output = './transcribe_result.json'
        self._path_subtitle_file = path_subtitle_file

    # Upload audio file to S3 Bucket
    def _upload_audio_to_s3(self):
        self.aws_interact._upload_audio_to_s3(self.path_audio_input, self.bucket_name, self.s3_file_name)

    # Run the AWS Transcribe job, download and locally save the result
    def _transcribe_and_save(self):
        transcribe_file_url = self.aws_interact._transribe(self.transcribe_job_name, self.aws_region, self.bucket_name, self.s3_file_name)
        self.aws_interact._download_from_url(transcribe_file_url, self._path_transcribe_result_output)

    # Parse the Transcribe result JSON file into .srt format
    def _parse_transcribe_result(self):
        phrases = self.utils._parse_transcribe(self._path_transcribe_result_output)
        self.utils._write_srt_file(phrases, self._path_subtitle_file)

    def run(self):
        self._upload_audio_to_s3()
        self._transcribe_and_save()
        self._parse_transcribe_result()


if __name__ == '__main__':
    # Load config object
    with open('./config.json') as file:
        config = json.load(file)

    Transcribe(
        config['path_audio_input'],
        config['path_srt_output'],
        config['aws_region'],
        config['bucket']
    ).run()
