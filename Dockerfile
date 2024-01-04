FROM python:3 AS build

WORKDIR /django

COPY requirements.txt /django

RUN pip install -r requirements.txt

COPY . /django

RUN python3 manage.py migrate


FROM python:alpine

WORKDIR /app

COPY --from=build /django /app

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python3","manage.py","runserver","0.0.0.0:8000"]


