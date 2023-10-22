from src.user.schemas import *
from src.user.exceptions import *


def check_snu_email(req: EmailRequest) -> str:
    if req.email.endswith('@snu.ac.kr') is False:
        raise InvalidEmailException(req.email)
    
    return req.email
