import utils
import aws_interact
import urllib
import shutil

class Transcribe():
    def __init__(self, path_audio_input, path_transcribe_result_output, region, bucket):
        self.utils = utils.Utils()
        self.transcribe_job_name = self.utils._randomize_job_name()
        self.s3_file_name = self.utils._randomize_job_name()+'.mp3'
        self.path_audio_input = path_audio_input
        self.aws_region = region
        self.bucket_name = bucket
        self._path_transcribe_result_output = path_transcribe_result_output
        self.aws_interract = aws_interact.AwsInteract('eu-central-1', self.path_audio_input, bucket, self.s3_file_name)

    # Run the AWS Transcribe job, download and locally save the result
    def _transcribe_and_save(self):
        transcribe_file_url = self.aws_interract._transribe(self.transcribe_job_name)
        self.aws_interract._download_from_url(transcribe_file_url, self._path_transcribe_result_output)

    # Parse the Transcribe result JSON file into .srt format
    def _parse_transcribe_result(self):
        phrases = self.utils._parse_transcribe(self._path_transcribe_result_output)
        self.utils._write_srt_file(phrases, self._path_transcribe_result_output)

    def run(self):
        print('TODO')
