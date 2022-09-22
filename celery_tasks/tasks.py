from typing import List
import json
from urllib import request
from celery import shared_task

from api import universities
import requests


@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_backoff=True,
    retry_kwargs={"max_retries": 5},
    name="universities:get_all_universities_task",
)
def get_all_universities_task(self, countries: List[str]):
    data: dict = {}
    for cnt in countries:
        data.update(universities.get_all_universities_for_country(cnt))
    return data


@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_backoff=True,
    retry_kwargs={"max_retries": 5},
    name="university:get_university_task",
)
def get_university_task(self, country: str):
    university = universities.get_all_universities_for_country(country)
    return university


@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_backoff=True,
    retry_kwargs={"max_retries": 5},
    name="celery:send_data_webhook",
)
def send_data_webhook(self, data: dict):
    webhook_url = "https://webhook.site/stratatest-dev/celery"

    json_data = json.dumps(data)

    response = requests.post(webhook_url, data=json_data, headers={"Content-Type": "application/json"}, timeout=30)

    dict_response = {
        "status_code": response.status_code,
        "data": response.json,
        "headers": response.headers,
    }

    return dict_response
