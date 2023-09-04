import json
import os

from flask import Flask, redirect, url_for

app = Flask(__name__)


@app.route("/status")
def status():
    status_response = os.environ.get("STATUS_RESPONSE", "success")
    ret = {"result": status_response}

    return json.dumps(ret)


@app.route("/")
def root():
    return redirect(url_for("status"))


def get_port(default_port: int = 5000) -> int:
    try:
        port = int(os.environ.get("PORT"))
    except (ValueError, TypeError):
        port = default_port

    return port


def run_app():
    debug = bool(os.environ.get("DEBUG_MODE", False))
    port = get_port()
    app.run(debug=debug, host="0.0.0.0", port=port)


if __name__ == "__main__":
    run_app()
