"""
Triggered when the Transcribe job is finished.
- Fetch the result from the Transcribe job
- Parse it to a .srt format
- Upload it to the app bucket under /outputs
"""