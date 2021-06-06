import hashlib
def hash_user(uid):
    text = 'stonoga' + str(uid)
    h = hashlib.sha256(str(text).encode('utf-8'))
    return h.hexdigest()
