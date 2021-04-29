import sqlite3 
from flask import Flask, render_template,  request, current_app
from flask import g
from flask.cli import with_appcontext
import os

cwd = os.getcwd()
DATABASE = 'assignment3.db'

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

def close_db(e=None):
    db = g.pop('db', None)
    if db is not None:
        db.close()

def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value) for idx, value in enumerate(row))

def convert_dict(lst, index):
    di = {}
    for i in lst:
        if i[index] in di:
            di[i[index]].append(list(i[:index])+list(i[index+1:]))
        else:
            di[i[index]] = [list(i[:index])+list(i[index+1:])]
    return di 

        
def weighted_avg_calc(info):
    di = convert_dict(info, 1)
    gw = lambda x: x[1]*x[2]
    w = lambda x: x[2]
    sxw = {k: sum(list(map(gw, v))) for k,v in di.items()}
    sw = {k: sum(list(map(w, v))) for k,v in di.items()}
    totals = {k: sxw[k]/v for k,v in sw.items()}
    return totals
