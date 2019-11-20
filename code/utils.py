import string
import random
import json

class Utils:
    def _randomize_job_name(self):
        letters = string.ascii_lowercase
        return ''.join(random.choice(letters) for i in range(6))

    def _get_timestamp(self, seconds):
        seconds = float(seconds)
        thund = int(seconds % 1 * 1000)
        tseconds = int(seconds)
        tsecs = ((float(tseconds) / 60) % 1) * 60
        tmins = int(tseconds / 60)
        return str("%02d:%02d:%02d,%03d" % (00, tmins, int(tsecs), thund))

    def _new_phrase(self):
	    return {'seq_order': '', 'start_time': '', 'end_time': '', 'words': []}

    def _parse_transcribe(self, transcribe_result):
        with open(transcribe_result) as file:
            raw_result = json.load(file)

        items = raw_result['results']['items']

        phrase = self._new_phrase()
        phrases = []
        nPhrase = True
        nb_words = 0
        seq_order = 1  # SRT start with 1

        for item in items:
            if nPhrase == True:
                if item['type'] == 'pronunciation':
                    phrase['start_time'] = self._get_timestamp(float(item['start_time']))
                    nPhrase = False
            else:
                if item['type'] == 'pronunciation':
                    phrase['end_time'] = self._get_timestamp(float(item['end_time']))

            phrase['seq_order'] = seq_order
            phrase['words'].append(item['alternatives'][0]['content'])
            nb_words += 1

            if nb_words == 3:
                phrases.append(phrase)
                phrase = self._new_phrase()
                nPhrase = True
                nb_words = 0
                seq_order += 1

        return phrases

    def _write_srt_file(self, phrases, sutitle_file_name):
        with open(sutitle_file_name, 'w+') as out_file:
            for phrase in phrases:
                out_file.write(str(phrase['seq_order']))
                out_file.write('\n')
                out_file.write(str(phrase['start_time']) + ' --> ' + str(phrase['end_time']))
                out_file.write('\n')
                out_file.write(' '.join(phrase['words']))
                out_file.write('\n\n')
