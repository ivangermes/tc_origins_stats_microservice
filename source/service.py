import os
import logging

#from datetime import datetime #python3.11 isoparse
from dateutil.parser import isoparse

import asyncio
from aiohttp import web
from aiohttp.web import HTTPBadRequest

from motor.motor_asyncio import AsyncIOMotorClient
from pymongo.server_api import ServerApi


# environment variables
LOG_LEVEL = os.environ.get('LOG_LEVEL', "DEBUG")

SERVICE_HOST = os.environ.get('SERVICE_HOST', None)
SERVICE_PORT = os.environ.get('SERVICE_PORT', None)

MONGO_URI = os.environ.get('MONGO_URI')

DB_NAME = os.environ.get("DB_NAME")
COLLECTION_NAME =  os.environ.get("COLLECTION_NAME")


async def health(request):
    app = request.app
    await app["db"].command('ping')
    return web.Response(text="HEALTHY")

async def get_origins_stats(request):
    app = request.app
    
    if request.method == "GET":
        params = request.query
    else:
        params = await request.post()

    time_from_str = params.get('time_from', None)
    time_from = None
    if time_from_str is not None:
        try:
            time_from =  isoparse(time_from_str)
        except ValueError:
            raise HTTPBadRequest

    time_to_str = params.get('time_to', None)
    time_to = None
    if time_to_str is not None:
        try:
            time_to =  isoparse(time_to_str)
        except ValueError:
            raise HTTPBadRequest


    stage_match_status = {
        '$match': {
            'status': 'done'
        }
    }

    if time_to or time_from:
        stage_match_status["$match"]["created_at"] = {}
        if time_from:
            stage_match_status["$match"]["created_at"]["$gte"] = time_from
        if time_to:
            stage_match_status["$match"]["created_at"]["$lte"] = time_to

    stage_project_trim = {
        '$project': {
            'total': 1, 
            'origin': 1, 
            'tickets': 1
        }
    }

    stage_group_origin = {
        '$group': {
            '_id': '$origin',
            'tickets': { '$sum': '$tickets' },
            'total': { '$sum': "$total" }
        }
    }

    stage_project_presentation = {
        '$project': {
            '_id': 0,
            'origin': "$_id",
            'total': { "$toInt": "$total"},
            'tickets': 1,
        }
    }

    pipeline = [
        stage_match_status,
        stage_project_trim,
        stage_group_origin,
        stage_project_presentation
    ]

    collection = app["collection"]
    cursor = collection.aggregate(pipeline)

    results = await cursor.to_list(length=None)
    
    return web.json_response(results)


async def setup_app(app):
    logging.info(f'setup app')
    logging.info(f'setup mongo connection')

    loop = asyncio.get_event_loop()
    client = AsyncIOMotorClient(MONGO_URI, server_api=ServerApi('1'), io_loop=loop)

    db = client.get_database(DB_NAME)

    # check collection exist
    await db.validate_collection(COLLECTION_NAME, scandata=False, full=False, background=False)

    # collections = await db.list_collection_names()
    # if COLLECTION_NAME not in collections:
    #     raise 

    collection = db.get_collection(COLLECTION_NAME)
    
    app["db"] = db
    app["collection"] = collection


async def close_app(app):
    logging.info(f'close mongo connection')
    app['db'].client.close()
    logging.info(f'close app')


def main():
    logging.basicConfig(level=logging.DEBUG)
    
    app = web.Application()

    app.router.add_get("/health", health)
    app.router.add_get('/v1/origins_stats', get_origins_stats)
    app.router.add_post('/v1/origins_stats', get_origins_stats)

    app.on_startup.append(setup_app)
    app.on_cleanup.append(close_app)

    web.run_app(app, host=SERVICE_HOST, port=SERVICE_PORT )


if __name__ == '__main__':
    main()