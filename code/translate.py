import transcribe

if __name__ == '__main__':
    transcribe.Transcribe('../assets/audio_trimmed.mp3', './transcribe_result.json', './subtitles.srt', 'eu-central-1', 's3-ec1-app-bucket').run()


