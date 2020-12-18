FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=on \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv" \
    MPLCONFIGDIR=/tmp/mpl \
    TORCH_HOME="/app/pretrained"

RUN apt-get update \
    && apt-get install --no-install-recommends -yqq gosu build-essential libgl1-mesa-glx libglib2.0-0

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN rm -rf /tmp/requirements.txt

COPY dockerfiles/entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

WORKDIR /app
