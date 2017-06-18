from bottle import get, template, run, request
from bottle.ext.websocket import GeventWebSocketServer
from bottle.ext.websocket import websocket
from pymongo import MongoClient
from bson.json_util import dumps
import httpagentparser
import json

users = set()

@get('/')
def index():
    return template('index')

@get('/websocket', apply=[websocket])
def chat(ws):
    print ws

    agent = request.environ.get('HTTP_USER_AGENT')
    browser = httpagentparser.detect(agent)

    print browser

    client = MongoClient()
    db = client.test
    
    users.add(ws)

    cur = db.socket_count.find_one()
    data = json.loads(dumps(cur))
    count = int(data['count'])
    cur = db.socket_count.update({'soc': 'true'},{'$set':{'count': count+1}})
    
    print 'Clients online :', count+1

    while True:
        msg = ws.receive()
        if msg is not None:
            for u in users:
                u.send(msg)
        else:
            break
    
    cur = db.socket_count.find_one()
    data = json.loads(dumps(cur))
    count = int(data['count'])
    cur = db.socket_count.update({'soc': 'true'},{'$set':{'count': count-1}})

    print 'Clients online :', count-1

    users.remove(ws)

@get('/refresh')
def refresh():
    client = MongoClient()
    db = client.test
    cur = db.socket_count.update({'soc': 'true'},{'$set':{'count': 0}})

    return 'DB Refreshed'

run(host='192.168.43.69', port=8080, server=GeventWebSocketServer)