from fastapi import APIRouter, Depends

from src.auth.dependencies import oauth2_scheme
from src.user.schemas import *


router = APIRouter(prefix="/user", tags=["user"])


@router.post("/email/code")
def create_verification_code(req: EmailRequest):
    pass
    # code = service.create_verification_code(req.email)
    # service.send_code_via_email(req.email, code)


@router.post("/email/verify", response_model=VerificationResponse)
def create_email_verification(req: VerificationRequest):
    pass
    # if service.check_verificaiton_code(req.email, req.code):
    #     token = service.create_verification(req.email)
    #     return VerificationResponse(token=token)


@router.post("/sign_up")
def create_user(req: CreateUserRequest):
    pass
    # service.create_user(req.email, req.password, req.user)
    # session_id = service.create_session(req.email)
    # # TODO add session id into the header


@router.get("/me", response_model=UserProfile)
def get_me(session_id: str = Depends(oauth2_scheme)):
    pass
    # return service.get_user_by_session_id(session_id)


@router.get("/all")
def get_all_users(session_id: str = Depends(oauth2_scheme)):
    pass
    # user = service.get_user_by_session_id(session_id)
    # return service.get_user_recommendations(user)

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
