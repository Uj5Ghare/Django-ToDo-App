FROM python:3

WORKDIR /todo-app

COPY . . 

RUN pip install -r requirements.txt
 
RUN python3 manage.py migrate 

Expose 8000

CMD ["python","manage.py","runserver","0.0.0.0:8000"]

