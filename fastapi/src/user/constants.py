import os


MAIL_USERNAME: str = os.environ.get('SNEK_MAIL_ADDRESS') #"swpp2023snek@gmail.com",  # os.environ.get or make .env file 로 바꾸기
MAIL_PASSWORD: str = os.environ.get('SNEK_MAIL_PASSWORD')#"vdht etkc sshn txhg"
MAIL_FROM: str = os.environ.get('SNEK_MAIL_ADDRESS')#"swpp2023snek@gmail.com",
MAIL_PORT: int = 587
