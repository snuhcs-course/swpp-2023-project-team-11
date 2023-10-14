from fastapi import APIRouter

from src.user.schemas import *
from src.user.service import *

router = APIRouter("/user")


@router.post("/email/code")
def create_verification_code(req: EmailRequest):
    pass
    # service.auth_request(req.email)


@router.post("/email/verify", response_model=VerificationResponse)
def create_email_verification(req: VerificationRequest):
    pass
    # token = service.get_token(email, code)
    # return {"token":token}


@router.post("/auth/sign_in")
def create_session(req: SessionRequest):
    pass
    # session_id = service.get_session_id(email, password)
    # return {"session_id":session_id}


@router.post("/auth/sign_up")
def create_user(req: CreateUserRequest):
    pass
    # session_id = service.get_session_id(email, password)
    # return {"session_id":session_id}


@router.post("/auth/sign_out")
def delete_session():
    pass
    # result = service.delete_session_id(session_id)
    # return {"result":result}


@router.get("/me")
def get_me():
    pass
    # return {"user":}


@router.get("/all")
def get_all_users():
    pass
    # return {"user":}

# @router.post("email/send_by_gmail")
# async def email_by_gmail(request: Request, mailing_list: SendEmail, background_tasks: BackgroundTasks):
#     t = time()
#     background_tasks.add_task(
#         send_email, mailing_list=mailing_list.email_to
#     )
#     return MessageOk()
#
#
# def send_email(**kwargs):
#     mailing_list = kwargs.get("mailing_list", None)
#     email_pw = os.environ.get("EMAIL_PW", None)
#     email_addr = os.environ.get("EMAIL_ADDR", None)
#     last_email = ""
#     if mailing_list:
#         try:
#             yag = yagmail.SMTP({email_addr: "swpp11@gmail.com"}, email_pw)
#             for m_l in mailing_list:
#                 contents = [
#                     email_content.format(m_l.name)
#                 ]
#                 sleep(1)
#                 yag.send(m_l.email, '이렇게 한번 보내봅시다.', contents)
#                 last_email = m_l.email
#             return True
#         except Exception as e:
#             print(e)
#             print(last_email)
