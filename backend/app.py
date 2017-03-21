from flask import Flask, session, redirect, url_for, escape, request, render_template
import os
import config
import controllers

# Initialize Flask app with the template folder address
app = Flask(__name__, template_folder='templates')

# Register the controllers
app.register_blueprint(controllers.APIs_v1, url_prefix=config.env['url_prefix'])
app.register_blueprint(controllers.static_handler, url_prefix=config.env['url_prefix'])

# Listen on external IPs
# For us, listen to port 3000 so you can just run 'python app.py' to start the server
if __name__ == '__main__':
    # listen on external IPs
    app.run(host=config.env['host'], port=config.env['port'], debug=True)
