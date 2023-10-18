import os


MAIL_ADDRESS: str = os.environ.get('SNEK_MAIL_ADDRESS')
MAIL_PASSWORD: str = os.environ.get('SNEK_MAIL_PASSWORD')
MAIL_PORT: int = 465
MAIL_SERVER: str = 'smtp.gmail.com'
