from src.user.constants import *
from src.user.schemas import *
from src.user.models import *


def from_profile(profile: Profile) -> ProfileData:
    return ProfileData(
        name=profile.name,
        birth=profile.birth,
        sex=profile.sex,
        major=profile.major,
        admission_year=profile.admission_year,
        about_me=profile.about_me,
        mbti=profile.mbti,
        nation_code=profile.nation_code,
        foods=list(food.name for food in profile.foods),
        movies=list(movie.name for movie in profile.movies),
        hobbies=list(hobby.name for hobby in profile.hobbies),
        locations=list(location.name for location in profile.locations),
    )


def from_user(user: User) -> UserResponse:
    profile = from_profile(user.profile)
    type = UserType.Kor if profile.nation_code == KOREA_CODE else UserType.For
    return UserResponse(
        name=profile.name,
        email=user.verification.email.email,
        profile=profile,
        type=type.value,
        main_language=user.main_language.name,
        languages=list(language.name for language in user.languages),
    )
