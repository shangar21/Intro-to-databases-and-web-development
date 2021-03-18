#allows us to use the flask framework which will look for the template file in the folder
from flask import Flask, render_template, url_for, request

#allows us to use flask
app = Flask(__name__)


@app.route('/<username>')
def generateResponse(username):
    returnName = username
    if (username.isupper()) and (not(any(char.isdigit() for char in username))):
        returnName = username.lower()
    elif username.islower() and (not(any(char.isdigit() for char in username))):
        returnName=username.upper()
    elif any(char.isdigit() for char in username):
        returnName = ''.join([i for i in username if not i.isdigit()])  

    return 'Welcome, ' +returnName+ ', to my CSCB20 website!'

if __name__ == '__main__':
    app.run(debug=True)

