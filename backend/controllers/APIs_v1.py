from flask import *
from sympy import *
import urllib
import urllib2
import re
from tools import render_cache
from tools import render_cache_large
import time

APIs_v1 = Blueprint('APIs_v1', __name__, template_folder='templates')


# error handle example:     raise InvalidUsage('This view is gone', status_code=410)
class InvalidUsage(Exception):
    status_code = 400

    def __init__(self, message, status_code=None, payload=None):
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    def to_dict(self):
        rv = dict(self.payload or ())
        rv['message'] = self.message
        return rv


# send JSON error message decorator
@APIs_v1.errorhandler(InvalidUsage)
def handle_invalid_usage(error):
    response = jsonify(error.to_dict())
    response.status_code = error.status_code
    return response


def make_json_response_with_status_code(content_dict, code=200):
    response = jsonify(content_dict)
    response.status_code = code
    return response


@APIs_v1.route('/api/v1/render', methods=['POST'])
def render_API():
    if request.method == 'POST':
        try:
            latexString = request.form['src']
            if latexString in render_cache:
                cache_address = render_cache[latexString][0]
                timestamp = render_cache[latexString][1]
                if time.clock() - timestamp < 2*3600:
                    print("valid cache found for " + latexString)
                    return cache_address


            print(latexString + " is going to rendered small")

            url = 'http://www.quicklatex.com/latex3.f'
            data = "formula=" + latexString + "&out=1&fsize=23px&mode=0&fcolor=000000&remhost=quicklatex.com&preamble=\usepackage{amsmath} \usepackage{amsfonts} \usepackage{amssymb}"
            print("outgoing: " + data)
            req = urllib2.Request(url, data)
            response = urllib2.urlopen(req)
            the_page = response.read()

            target_url = \
                re.findall('http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', the_page)[
                    0]

            print(target_url + " get cached")
            render_cache[latexString] = [target_url, time.clock()]

            #print("now cache " + str(render_cache))

            return target_url
        except:
            #    print
            raise InvalidUsage('error happened', status_code=410)


@APIs_v1.route('/api/v1/render_big', methods=['POST'])
def render_big_API():
    if request.method == 'POST':
        try:
            latexString = request.form['src']
            if latexString in render_cache_large:
                cache_address = render_cache_large[latexString][0]
                timestamp = render_cache_large[latexString][1]
                if time.clock() - timestamp < 2*3600:
                    print("valid cache found for " + latexString)
                    return cache_address


            print(latexString + " is going to rendered")

            url = 'http://www.quicklatex.com/latex3.f'
            values = dict(
                formula="",
                fsize="100px",
                fcolor="000000",
                mode="0",
                out="1"
            )
            #latexString
            #data = urllib.urlencode(values).replace("+", " ").
            data = "formula=" + latexString + "&out=1&fsize=100px&mode=0&fcolor=000000&remhost=quicklatex.com&preamble=\usepackage{amsmath} \usepackage{amsfonts} \usepackage{amssymb}"
            print("outgoing: " + data)
            req = urllib2.Request(url, data)
            response = urllib2.urlopen(req)
            the_page = response.read()

            target_url = \
                re.findall('http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', the_page)[
                    0]

            print(target_url + " get cached")
            render_cache_large[latexString] = [target_url, time.clock()]

            #print("now cache " + str(render_cache))

            return target_url
        except:
            #    print
            raise InvalidUsage('error happened', status_code=410)


@APIs_v1.route('/api/v1/query', methods=['POST'])
def query_API():
    raise InvalidUsage('Not available yet', status_code=404)
