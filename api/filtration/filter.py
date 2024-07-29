import firebase_admin
from firebase_admin import credentials, firestore
from better_profanity import profanity
import logging
import time

# Initialize Firestore
cred = credentials.Certificate(r'C:\Users\visha\Github\Crisis-HackFest\api\filtration\crisis-hackfest-firebase-adminsdk-14i15-98452f3c65.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

# Load profanity words
profanity.load_censor_words()

# Set up logging
logging.basicConfig(level=logging.INFO)

def check_and_delete_profanity(change, collection_name):
    document_data = change.document.to_dict()
    posts = document_data.get('posts', [])
    if not posts:
        print(f'No posts found in document: {change.document.id}')
        return []

    profane_uids = []
    for post in posts:
        post_content = post.get('postcontent', 'No post content available')
        uid = post.get('uid', 'No UID available')
        contains_profanity = profanity.contains_profanity(post_content)
        print(f'Checking post in document {change.document.id} => {post_content}')
        print(f'Contains profanity: {contains_profanity}')

        if contains_profanity:
            profane_uids.append({'uid': uid, 'is_profane': False, 'post_content': post_content})
            # Delete the entire document
            db.collection(collection_name).document(change.document.id).delete()
            print(f'Document {change.document.id} deleted due to profanity.')
            break  # Exit the loop after deleting the document
        else:
            profane_uids.append({'uid': uid, 'is_profane': True})

    return profane_uids

def on_snapshot(col_snapshot, changes, read_time, collection_name):
    print(f'Collection snapshot received at {read_time}')
    for change in changes:
        if change.type.name in ['ADDED', 'MODIFIED']:
            profane_uids = check_and_delete_profanity(change, collection_name)
            for entry in profane_uids:
                print(f'UID: {entry["uid"]}, Is Profane: {entry["is_profane"]}, Post Content: {entry.get("post_content", "")}')
        elif change.type.name == 'REMOVED':
            print(f'Removed document: {change.document.id}')

# Set up listeners on both collections
collection_names = ['posts', 'posts-volunteer']
for collection_name in collection_names:
    col_ref = db.collection(collection_name)
    col_watch = col_ref.on_snapshot(lambda col_snapshot, changes, read_time, col_name=collection_name: on_snapshot(col_snapshot, changes, read_time, col_name))

# Keep the server running
print('Listening for changes...')
while True:
    time.sleep(1)
