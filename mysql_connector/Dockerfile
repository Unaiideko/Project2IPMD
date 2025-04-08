FROM python:3

WORKDIR /Project2IPMD/mysql_connector

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./main.py ./main.py
RUN chmod +x main.py

CMD [ "python", "./main.py" ]