### Build and install packages
FROM python:3.8 as build-python

# hadolint ignore=DL3018,DL3015,DL3008
RUN apt-get -y update \
  && apt-get install -y gettext \
  && apt-get install -y python3-psycopg2 \
  # Cleanup apt cache
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /jaguar/
WORKDIR /jaguar
# uwsgi has lots of compatibility errors on windows so it's better don't include it in the requirements file
RUN pip install -r requirements.txt && pip install uwsgi==2.0.19.1

### Final image
FROM python:3.8-slim
LABEL maintainer="jhonsfran <jhonsfran@gmail.com>"

RUN groupadd -r jaguar && useradd -r -g jaguar jaguar

# uwsgi dependencies
# hadolint ignore=DL3018,DL3015,DL3008
RUN apt-get update && apt-get install -y \
  libxml2 \
  libssl1.1 \
  libcairo2 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libgdk-pixbuf2.0-0 \
  shared-mime-info \
  mime-support && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY jaguar/ /jaguar
COPY run/ /jaguar/run
COPY --from=build-python /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/
COPY --from=build-python /usr/local/bin/ /usr/local/bin/
WORKDIR /jaguar

RUN chown -R jaguar:jaguar /jaguar/

EXPOSE 8088
ENV PORT 8088
ENV PYTHONUNBUFFERED 1
ENV PROCESSES 4

CMD ["bash", "-c", "python3 waitForPostgres.py && python3 manage.py makemigrations && python3 manage.py migrate && uwsgi --ini /jaguar/jaguar/uwsgi.ini"]
