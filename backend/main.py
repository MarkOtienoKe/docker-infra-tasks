from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv
import os
from google.cloud import secretmanager
import json

load_dotenv()

app = Flask(__name__)

def get_secret(secret_name):
    client = secretmanager.SecretManagerServiceClient()
    project_id = os.getenv('GOOGLE_CLOUD_PROJECT')  # Ensure this is set in your environment
    secret_path = f"projects/{project_id}/secrets/{secret_name}/versions/latest"
    
    response = client.access_secret_version(name=secret_path)
    secret_data = response.payload.data.decode('UTF-8')
    print(secret_data)
    return secret_data

# Configure the database connection using environment variables
db_username = get_secret('secret')
db_credentials = json.loads(db_username)

print(db_credentials);

db_username = db_credentials.get('username')
db_password = db_credentials.get('password')

app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"mysql+pymysql://{db_username}:{db_password}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)


app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define the Message model
class Message(db.Model):
    __tablename__ = 'messages'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    message = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now())

# Initialize the database
with app.app_context():
    db.create_all()

@app.route('/')
def is_alive():
    return jsonify('live')


@app.route('/api/msg/<string:msg>', methods=['POST'])
def msg_post_api(msg):
    print(f"msg_post_api with message: {msg}")

    # A message instance
    new_message = Message(message=msg)
    db.session.add(new_message)
    db.session.commit()

    msg_id = new_message.id
    
    return jsonify({'msg_id': msg_id})


@app.route('/api/msg/<int:msg_id>', methods=['GET'])
def msg_get_api(msg_id):
    print(f"msg_get_api > msg_id = {msg_id}")

    msg = Message.query.get(msg_id)
    
    # Check if message is not found
    if not msg:
        return jsonify({'error': 'Message not found'}), 404
        
    return jsonify({'msg': msg})


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
