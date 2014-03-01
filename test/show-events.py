#!/usr/bin/python
import sys
import MySQLdb

db = MySQLdb.connect(host="172.16.243.174", # your host, usually localhost
                     user="spampot", # your username
                      passwd=".t3mp0r4l.", # your password
                      db="spampot") # name of the data base

# you must create a Cursor object. It will let
#  you execute all the query you need
cur = db.cursor() 
name=str(sys.argv[1])

# Use all the SQL you like
cur.execute("SELECT * FROM " + name) 

# print all the first cell of all the rows
for row in cur.fetchall() :
    print row
