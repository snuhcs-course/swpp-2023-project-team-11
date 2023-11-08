import os

CLOVA_API_URL: str = "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
CLOVA_CLIENT_ID: str = os.environ.get('SNEK_CLOVA_CLIENT_ID')
CLOVA_CLIENT_SECRET: str = os.environ.get('SNEK_CLOVA_CLIENT_SECRET')
PAPAGO_API_URL: str = "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation"
PAPAGO_CLIENT_ID: str = os.environ.get('SNEK_PAPAGO_CLIENT_ID')
PAPAGO_CLIENT_SECRET: str = os.environ.get('SNEK_PAPAGO_CLIENT_SECRET')
DEFAULT_INTIMACY: float = 36.5
