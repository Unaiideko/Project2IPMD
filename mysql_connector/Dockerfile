FROM python:3

WORKDIR /Project2IPMD/mysql_connector

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app.py ./app.py
RUN chmod +x app.py

CMD [ "python", "./app.py" ]