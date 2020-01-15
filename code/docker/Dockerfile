FROM python:3.8

WORKDIR /home

RUN pip3 install moviepy && \
    pip3 install boto3

COPY ./extract_sound_for_docker.py  .
COPY ./video.mp4 .

CMD ["python3", "extract_sound_for_docker.py"]