import boto3
import json


def get_timestamp(seconds):
  seconds = float(seconds)
  thund = int(seconds % 1 * 1000)
  tseconds = int(seconds)
  tsecs = ((float(tseconds) / 60) % 1) * 60
  tmins = int(tseconds / 60)
  return str("%02d:%02d:%02d,%03d" % (00, tmins, int(tsecs), thund))

def write_srt_file(phrases, sutitle_file_name):
  with open(sutitle_file_name, 'w+') as out_file:
    for phrase in phrases:
      out_file.write(str(phrase['seq_order']))
      out_file.write('\n')
      out_file.write(str(phrase['start_time']) + ' --> ' + str(phrase['end_time']))
      out_file.write('\n')
      out_file.write(' '.join(phrase['words']))
      out_file.write('\n\n')
  print('Translation done and saved under: ' + sutitle_file_name)

def new_phrase():
  return {'seq_order': '', 'start_time': '', 'end_time': '', 'words': []}

def parse_transcribe_result():
  with open('./tmp.json') as file:
    raw_result = json.load(file)

  items = raw_result['results']['items']

  phrase = new_phrase()
  phrases = []
  nPhrase = True
  nb_words = 0
  seq_order = 1  # SRT start with 1

  for item in items:
    if nPhrase == True:
      if item['type'] == 'pronunciation':
        phrase['start_time'] = get_timestamp(float(item['start_time']))
        nPhrase = False
    else:
      if item['type'] == 'pronunciation':
        phrase['end_time'] = get_timestamp(float(item['end_time']))

    phrase['seq_order'] = seq_order
    phrase['words'].append(item['alternatives'][0]['content'])
    nb_words += 1

    if nb_words == 5:
      phrases.append(phrase)
      phrase = new_phrase()
      nPhrase = True
      nb_words = 0
      seq_order += 1

  return phrases

def run():
  phrases = parse_transcribe_result()
  write_srt_file(phrases, 'out.srt')

run()

# def handler(event, context):
#   print('TODO')
