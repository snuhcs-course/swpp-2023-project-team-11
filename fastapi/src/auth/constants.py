import os


HASH_SECRET: bytes = bytes(os.environ.get('SNEK_HASH_SECRET'), 'utf-8')
if HASH_SECRET is None:
    HASH_SECRET = b""
