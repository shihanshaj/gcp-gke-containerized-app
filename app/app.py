from flask import Flask, jsonify
import socket
import os

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "message": "Hello from GKE!",
        "pod":     socket.gethostname(),
        "version": os.environ.get("APP_VERSION", "1.0.0"),
        "status":  "healthy"
    })

@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200

@app.route("/info")
def info():
    return jsonify({
        "pod_name":  socket.gethostname(),
        "node":      os.environ.get("NODE_NAME", "unknown"),
        "namespace": os.environ.get("POD_NAMESPACE", "default"),
        "version":   os.environ.get("APP_VERSION", "1.0.0")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
