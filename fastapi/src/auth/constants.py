import os


HASH_SECRET: bytes = os.environ.get('SNEK_HASH_SECRET')
if HASH_SECRET is None:
    HASH_SECRET = b""
else:
    HASH_SECRET = bytes(HASH_SECRET, 'utf-8')
