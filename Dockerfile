FROM python:3.8
WORKDIR /app
RUN pip install flask
COPY . .
EXPOSE 5000 
CMD [ "python" , "app.py" ]
