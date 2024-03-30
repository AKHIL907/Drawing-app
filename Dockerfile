FROM python:3.8-slim
WORKDIR /app
RUN pip install flask
COPY . .
EXPOSE 5000 
CMD [ "python" , "app.py" ]
