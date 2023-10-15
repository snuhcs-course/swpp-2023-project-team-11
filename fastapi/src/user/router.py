from typing import List

from fastapi import APIRouter, Depends

from src.auth.schemas import SessionResponse
from src.auth.service import create_session
from src.user.dependencies import *
from src.user.schemas import *
from src.user import service


router = APIRouter(prefix="/user", tags=["user"])


@router.post("/email/code")
def create_verification_code(email: str = Depends(check_snu_email)):
    code = service.create_verification_code(email)
    service.send_code_via_email(email, code)


@router.post("/email/verify", response_model=VerificationResponse)
def create_email_verification(email: str = Depends(check_verification_code)):
    token = service.create_verification(email)
    return VerificationResponse(token=token)


@router.post("/sign_up", response_model=SessionResponse)
def create_user(req: CreateUserRequest = Depends(check_verification_token)):
    service.create_user(req.email, req.password, req.user)
    session_key = create_session(req.email)
    return SessionResponse(access_token=session_key, token_type="bearer")


@router.get("/me", response_model=UserProfile)
def get_me(user: UserProfile = Depends(get_user)):
    return user


@router.get("/all", response_model=List[UserProfile])
def get_all_users(user: UserProfile = Depends(get_user)):
    return service.get_user_recommendations(user)

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
