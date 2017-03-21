from flask import *

static_handler = Blueprint('static_handler', __name__, template_folder='templates')

@static_handler.route('/static/<path:path>')
def handler(path):
    print path + "\n\n\n\n"
    #file = open(path, 'r').read()
    return send_file(path, mimetype='image/gif')
