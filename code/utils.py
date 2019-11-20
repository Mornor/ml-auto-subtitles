import string
import random

class Utils:
    def randomize_job_name(self):
        letters = string.ascii_lowercase
        return ''.join(random.choice(letters) for i in range(6))

    def get_timestamp(self, seconds):
        seconds = float(seconds)
        thund = int(seconds % 1 * 1000)
        tseconds = int(seconds)
        tsecs = ((float(tseconds) / 60) % 1) * 60
        tmins = int(tseconds / 60)
        return str("%02d:%02d:%02d,%03d" % (00, tmins, int(tsecs), thund))
