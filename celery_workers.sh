echo "Starting 'University' worker..."
celery -A main.celery worker -Q university -n university@%h --detach & echo "${!} university" > celery.pid
echo "Starting 'Universities' worker..."
celery -A main.celery worker -Q universities -n universities@%h -P threads -c 10 --detach & echo "${!} universities" >> celery.pid
echo "Starting 'Webhook' worker..."
celery -A main.celery worker -Q webhook -n webhook@%h -P threads -c 10 --detach & echo "${!} webhook" >> celery.pid

sleep 3s

celery -A main.celery flower --port=5556 --broker_api=http://guest:guest@some-rabbit:5672/api/ --db=flower.sqlite --persistent=True