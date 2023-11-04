"""Topic

Revision ID: e297bbd64464
Revises: c8501f86a9ec
Create Date: 2023-11-04 20:22:23.008143

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = 'e297bbd64464'
down_revision: Union[str, None] = 'c8501f86a9ec'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    topic = op.create_table('topic',
                            sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
                            sa.Column('topic', sa.String(), nullable=False),
                            sa.Column('tag', sa.String(), nullable=False),
                            sa.PrimaryKeyConstraint('id')
                            )

    op.bulk_insert(topic, [{'topic': '좋아하는 책 또는 작가에 대한 이야기', 'tag': 'C'},
                           {'topic': '최근에 본 영화 또는 TV 프로그램에 대한 토론', 'tag': 'C'},
                           {'topic': '여행 경험 및 여행 목적지에 대한 이야기', 'tag': 'C'},
                           {'topic': '음식 및 레스토랑에서의 식사에 대한 토론', 'tag': 'C'},
                           {'topic': '취미와 관심사에 관한 이야기', 'tag': 'C'},
                           {'topic': '문화 이벤트 또는 공연에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '스포츠 및 경기 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '건강 및 피트니스 목표와 도전에 대한 이야기', 'tag': 'C'},
                           {'topic': '사진과 그래픽 아트에 관련된 주제에 대한 관심사', 'tag': 'C'},
                           {'topic': '음악과 가수, 밴드에 대한 이야기', 'tag': 'C'},
                           {'topic': '과학과 기술 분야의 최신 개발 및 놀라운 발견에 대한 토론', 'tag': 'C'},
                           {'topic': '역사와 역사적인 이벤트에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '포커 또는 보드 게임에 관한 이야기', 'tag': 'C'},
                           {'topic': '문화적인 차이와 다양성에 대한 이야기', 'tag': 'C'},
                           {'topic': '가상 현실 (VR) 또는 증강 현실 (AR) 기술에 관한 토론', 'tag': 'C'},
                           {'topic': '온라인 쇼핑 및 최신 소비자 전자제품에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '미래의 기술 및 인공 지능 (AI)에 관한 이야기', 'tag': 'C'},
                           {'topic': '휴식과 휴가 목적지에 대한 토론', 'tag': 'C'},
                           {'topic': '파란 하늘과 별빛 밑에서의 밤에 대한 이야기', 'tag': 'C'},
                           {'topic': '창작적인 예술와 창작성 관련 주제에 대한 관심사', 'tag': 'C'},
                           {'topic': '환경 보호와 지속 가능성에 관한 대화', 'tag': 'C'},
                           {'topic': '처음으로 했던 추억 있는 경험에 대한 이야기', 'tag': 'C'},
                           {'topic': '가치관과 도덕적인 이슈에 대한 토론', 'tag': 'C'},
                           {'topic': '미래의 목표와 꿈에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '애완동물과 반려동물에 대한 이야기', 'tag': 'C'},
                           {'topic': '종교와 신앙 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '사회적 약자와 인권 문제에 관한 이야기', 'tag': 'C'},
                           {'topic': '건축과 디자인 관련 주제에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '전통적인 예술 및 공예에 관한 이야기', 'tag': 'C'},
                           {'topic': '사이버 보안 및 온라인 개인 정보 보호에 대한 토론', 'tag': 'C'},
                           {'topic': '맛있는 음식 및 레시피에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '사회적 불평등과 사회 정의에 관한 이야기', 'tag': 'C'},
                           {'topic': '좋아하는 스포츠 팀 또는 선수에 대한 토론', 'tag': 'C'},
                           {'topic': '과학적인 역사 및 위대한 과학자에 대한 이야기', 'tag': 'C'},
                           {'topic': '독서 및 책 추천 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '생물학과 생태학에 관련된 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '공간 탐사와 천문학 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '코로나 바이러스 및 건강 관련 뉴스에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '연예계 및 영화 스타 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '환경 문제와 지속 가능한 에너지에 관한 토론', 'tag': 'C'},
                           {'topic': '경제와 금융 관련 주제에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '컬처와 문화적 이슈에 관한 이야기', 'tag': 'C'},
                           {'topic': '정치 및 정책 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '문학과 시와 작품 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '가정과 부모로서의 경험에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '미디어와 엔터테인먼트에 관한 이야기', 'tag': 'C'},
                           {'topic': '디지털 마케팅과 소셜 미디어 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '도시와 도시 계획에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '자연과 환경에서의 활동과 야외 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '건강 및 복지 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '인류학과 문화 사회학에 관련된 주제에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '컴퓨터 게임과 게임 개발 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '미래의 교육 방식과 학교 교육 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '예술과 창작성에 관련된 주제에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '다양성과 포용성에 관한 이야기', 'tag': 'C'},
                           {'topic': '페미니즘과 성평등 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '영화 음악 및 음악가에 관련된 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '가치관과 도덕적인 문제에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '사회 문제와 사회 운동 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '지구과 환경 보호 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '세계 정치와 국제 관계 관련 주제에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '음악 축제 및 공연 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '음악과 예술을 표현하는 방법에 대한 토론', 'tag': 'C'},
                           {'topic': '음악 밴드 및 가수의 업적과 영향력에 관한 이야기', 'tag': 'C'},
                           {'topic': '사회 변화와 개선에 기여하는 방법에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '과학과 연구 관련 주제에 대한 이야기', 'tag': 'C'},
                           {'topic': '기술과 혁신의 미래에 대한 토론', 'tag': 'C'},
                           {'topic': '문화 이벤트와 축제 관련 주제에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '전통 음식과 레시피에 대한 이야기', 'tag': 'C'},
                           {'topic': '시대와 세대 간 차이와 경험에 관한 토론', 'tag': 'C'},
                           {'topic': '영화와 TV 프로그램 캐릭터와 스토리에 관한 이야기', 'tag': 'C'},
                           {'topic': '건강 및 피트니스 목표 달성을 위한 방법에 대한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '미래의 환경 및 지구 온난화에 관한 이야기', 'tag': 'C'},
                           {'topic': '음악과 예술을 창조하고 창작하는 방법에 대한 토론', 'tag': 'C'},
                           {'topic': '음식과 요리 스킬 향상을 위한 조언과 팁에 대한 이야기', 'tag': 'C'},
                           {'topic': '사회적 네트워킹과 인간관계 스킬에 관한 관심사에 관한 대화', 'tag': 'C'},
                           {'topic': '스포츠 경기와 경기 스포츠에 대한 이야기', 'tag': 'C'},
                           {'topic': '사회문제와 사회 활동 관련 주제에 대한 토론', 'tag': 'C'},
                           {'topic': '인터넷과 디지털 미디어의 역할과 영향에 관한 이야기', 'tag': 'C'},
                           {'topic': '가족과 가족 역사에 관한 이야기', 'tag': 'B'},
                           {'topic': '개인적인 목표와 꿈에 대한 토론', 'tag': 'B'},
                           {'topic': '자기계발과 개인 성장에 관한 이야기', 'tag': 'B'},
                           {'topic': '학문적인 관심사와 학습 경험에 대한 이야기', 'tag': 'B'},
                           {'topic': '직업과 경력 계획에 대한 토론', 'tag': 'B'},
                           {'topic': '문화 및 예술 이벤트에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '인터넷과 디지털 미디어의 역할과 영향에 대한 이야기', 'tag': 'B'},
                           {'topic': '가치관과 도덕적인 이슈에 대한 토론', 'tag': 'B'},
                           {'topic': '미래에 대한 비전과 목표에 관한 이야기', 'tag': 'B'},
                           {'topic': '환경 보호와 지속 가능성에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '과학과 기술 분야에서의 열망과 흥미에 관한 이야기', 'tag': 'B'},
                           {'topic': '처음으로 여행한 장소에 관한 추억에 대한 이야기', 'tag': 'B'},
                           {'topic': '취미와 관심사에 대한 더 깊은 토론', 'tag': 'B'},
                           {'topic': '인간관계와 친구, 가족 관련 이야기', 'tag': 'B'},
                           {'topic': '자신의 가치관과 신념에 관한 이야기', 'tag': 'B'},
                           {'topic': '현재 진행 중인 프로젝트 또는 취미 활동에 대한 토론', 'tag': 'B'},
                           {'topic': '독서와 문학 작품에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '사회적 문제와 사회 운동에 관한 이야기', 'tag': 'B'},
                           {'topic': '자신의 인생에서 극복한 어려움에 대한 이야기', 'tag': 'B'},
                           {'topic': '음식과 요리의 예술에 관한 토론', 'tag': 'B'},
                           {'topic': '연예계 및 영화, 음악 스타 관련 주제에 대한 이야기', 'tag': 'B'},
                           {'topic': '마음의 평화와 스트레스 관리에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '인생의 돌파구 및 성취에 관한 이야기', 'tag': 'B'},
                           {'topic': '성격 유형과 심리학적 특징에 대한 토론', 'tag': 'B'},
                           {'topic': '미래의 가족 계획과 아이에 대한 이야기', 'tag': 'B'},
                           {'topic': '역사와 과거의 이야기에 관한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '자신을 위한 시간을 내고 싶은 활동에 대한 이야기', 'tag': 'B'},
                           {'topic': '문화 차이와 다양성에 관한 토론', 'tag': 'B'},
                           {'topic': '동호회 또는 그룹 참가와 그 경험에 대한 이야기', 'tag': 'B'},
                           {'topic': '도전과 어려움을 극복하는 방법에 관한 이야기', 'tag': 'B'},
                           {'topic': '사회적 책임감과 자원봉사에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '노래와 음악을 만들거나 연주하는 경험에 대한 이야기', 'tag': 'B'},
                           {'topic': '온라인 커뮤니티와 소셜 미디어 활동에 대한 토론', 'tag': 'B'},
                           {'topic': '스포츠와 운동에 대한 열정과 경험에 관한 이야기', 'tag': 'B'},
                           {'topic': '인간관계에서의 소통 스타일과 해결책에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '논쟁적인 주제에 대한 의견 교환과 토론', 'tag': 'B'},
                           {'topic': '여행과 탐험에 대한 열망과 목표에 관한 이야기', 'tag': 'B'},
                           {'topic': '사회적인 동향과 이슈에 대한 토론', 'tag': 'B'},
                           {'topic': '미디어와 미디어 엔터테인먼트 관련 주제에 대한 이야기', 'tag': 'B'},
                           {'topic': '페미니즘과 성평등에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '소프트웨어 개발과 프로그래밍 관련 주제에 대한 토론', 'tag': 'B'},
                           {'topic': '전통 문화와 문화 유산에 대한 이야기', 'tag': 'B'},
                           {'topic': '자신을 도울 수 있는 자기계발 책 또는 강연에 관한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '미래의 캐리어 및 직업에 대한 이야기', 'tag': 'B'},
                           {'topic': '사회적 네트워킹과 인간관계 스킬을 향상시키는 방법에 대한 토론', 'tag': 'B'},
                           {'topic': '미래의 기술 트렌드와 혁신에 관한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '건강 및 복지를 위한 신체적 및 정신적인 습관에 관한 이야기', 'tag': 'B'},
                           {'topic': '지구와 환경 보호에 대한 토론', 'tag': 'B'},
                           {'topic': '공공 정책과 정치 관련 주제에 대한 이야기', 'tag': 'B'},
                           {'topic': '영화와 문화 예술 관련 주제에 대한 토론', 'tag': 'B'},
                           {'topic': '사회 문제와 봉사 활동에 관한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '경제 및 금융 시장 관련 주제에 대한 이야기', 'tag': 'B'},
                           {'topic': '컴퓨터 과학과 프로그래밍 언어에 대한 토론', 'tag': 'B'},
                           {'topic': '미디어와 컨텐츠 생성 관련 주제에 대한 이야기', 'tag': 'B'},
                           {'topic': '사회문제와 다양성에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '학문적인 이론과 연구 주제에 관한 토론', 'tag': 'B'},
                           {'topic': '미래의 교육 방식과 학습 방법에 관한 이야기', 'tag': 'B'},
                           {'topic': '예술과 창작성을 표현하는 방법에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '봉사활동 및 사회 운동에 참여하는 방법에 관한 이야기', 'tag': 'B'},
                           {'topic': '과학과 연구 분야에서의 최근 개발과 발견에 관한 토론', 'tag': 'B'},
                           {'topic': '미디어 및 엔터테인먼트 산업의 미래에 대한 이야기', 'tag': 'B'},
                           {'topic': '사회적 변화와 영향력 있는 사람들에 관한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '신기술과 디지털 혁신에 대한 이야기', 'tag': 'B'},
                           {'topic': '자신의 도시 또는 지역에 대한 역사 및 특징에 관한 토론', 'tag': 'B'},
                           {'topic': '지속 가능한 라이프스타일 및 친환경 생활에 관한 이야기', 'tag': 'B'},
                           {'topic': '음악과 공연 아트 관련 주제에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '가치관과 도덕적인 이슈에 대한 논의', 'tag': 'B'},
                           {'topic': '인류학과 문화 사회학 관련 주제에 대한 이야기', 'tag': 'B'},
                           {'topic': '미디어 및 엔터테인먼트 분야의 최신 동향에 관한 토론', 'tag': 'B'},
                           {'topic': '코로나 바이러스와 건강 관련 주제에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '문화 이벤트와 축제 관련 주제에 대한 이야기', 'tag': 'B'},
                           {'topic': '디지털 아트와 창작성 관련 주제에 대한 토론', 'tag': 'B'},
                           {'topic': '영화와 TV 프로그램 캐릭터 및 스토리에 대한 이야기', 'tag': 'B'},
                           {'topic': '환경 문제와 지속 가능한 라이프스타일에 관한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '사회 문제와 사회 변화에 대한 이야기', 'tag': 'B'},
                           {'topic': '기술과 혁신의 역할과 미래에 대한 토론', 'tag': 'B'},
                           {'topic': '음악 밴드 및 가수의 음악적 스타일과 영향력에 관한 이야기', 'tag': 'B'},
                           {'topic': '컴퓨터 과학과 프로그래밍 관련 주제에 대한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '문화와 예술에서의 다양성과 포용성에 대한 이야기', 'tag': 'B'},
                           {'topic': '음식과 요리 스킬을 향상시키는 팁 및 레시피에 대한 토론', 'tag': 'B'},
                           {'topic': '영화와 TV 프로그램과 관련된 최근 이슈에 대한 이야기', 'tag': 'B'},
                           {'topic': '사회적 책임감 및 봉사 활동을 통한 사회 기여에 관한 관심사에 관한 대화', 'tag': 'B'},
                           {'topic': '음악 분야와 음악 산업 관련 주제에 대한 토론', 'tag': 'B'},
                           {'topic': '인류학과 문화 사회학에서의 연구 주제와 이론에 관한 이야기', 'tag': 'B'},
                           {'topic': '미래의 기술과 디지털 혁신에 관한 토론', 'tag': 'B'},
                           {'topic': '인생의 목표와 비전에 대한 논의', 'tag': 'A'},
                           {'topic': '자신의 가치관과 신념에 대한 깊은 대화', 'tag': 'A'},
                           {'topic': '철학적 주제와 윤리학에 관한 토론', 'tag': 'A'},
                           {'topic': '심리학 및 감정적 지능에 대한 이야기', 'tag': 'A'},
                           {'topic': '복잡한 과학 및 기술 이슈에 관한 토론', 'tag': 'A'},
                           {'topic': '정신 건강과 자기 돌봄에 대한 이야기', 'tag': 'A'},
                           {'topic': '인생의 역사와 성장에 관한 대화', 'tag': 'A'},
                           {'topic': '마음의 평화와 명상에 대한 토론', 'tag': 'A'},
                           {'topic': '미래의 예술 및 창작성에 관한 이야기', 'tag': 'A'},
                           {'topic': '자기계발과 자기 완성에 관한 논의', 'tag': 'A'},
                           {'topic': '비영리 단체와 사회 봉사에 대한 이야기', 'tag': 'A'},
                           {'topic': '정신적 탐구와 철학적 사색에 관한 토론', 'tag': 'A'},
                           {'topic': '역사적인 사건과 시대에 대한 이야기', 'tag': 'A'},
                           {'topic': '유전학 및 생물학의 최신 연구에 관한 토론', 'tag': 'A'},
                           {'topic': '역동적인 세계 정치와 국제 관계에 대한 대화', 'tag': 'A'},
                           {'topic': '인류학과 문화 사회학에서의 연구 주제에 관한 이야기', 'tag': 'A'},
                           {'topic': '연예계와 예술 분야의 영향력 있는 작품에 대한 토론', 'tag': 'A'},
                           {'topic': '세계의 문화 다양성과 유산에 대한 이야기', 'tag': 'A'},
                           {'topic': '미래의 교육과 학습 방법에 관한 토론', 'tag': 'A'},
                           {'topic': '음악과 예술의 역할과 예술가에 관한 논의', 'tag': 'A'},
                           {'topic': '사회적 경제학과 정치경제학에 관한 이야기', 'tag': 'A'},
                           {'topic': '현대 문화와 사회 문제에 대한 토론', 'tag': 'A'},
                           {'topic': '자연과 지구 환경 보호에 관한 대화', 'tag': 'A'},
                           {'topic': '세계의 독특한 문화와 관습에 대한 이야기', 'tag': 'A'},
                           {'topic': '과학과 기술 분야에서의 윤리적 고민에 관한 토론', 'tag': 'A'},
                           {'topic': '세계에서의 지속 가능한 미래에 관한 이야기', 'tag': 'A'},
                           {'topic': '역사적인 인물과 영향력 있는 사람에 대한 논의', 'tag': 'A'},
                           {'topic': '천문학 및 우주에 대한 깊은 이야기', 'tag': 'A'},
                           {'topic': '사회운동과 활동에 참여하는 방법에 관한 토론', 'tag': 'A'},
                           {'topic': '인생의 의미와 철학적 인사이트에 관한 대화', 'tag': 'A'},
                           {'topic': '세계의 예술 및 문학에서의 고전작에 대한 이야기', 'tag': 'A'},
                           {'topic': '정치 및 정부 체제에 관한 깊은 토론', 'tag': 'A'},
                           {'topic': '건강 및 복지에 관한 최신 연구와 추세에 대한 논의', 'tag': 'A'},
                           {'topic': '지구와 환경 보호를 위한 지속 가능한 라이프스타일에 관한 이야기', 'tag': 'A'},
                           {'topic': '사회 문제와 사회 운동의 복잡한 측면에 대한 토론', 'tag': 'A'},
                           {'topic': '심리학 및 심리치료의 동향과 혁신에 관한 대화', 'tag': 'A'},
                           {'topic': '예술과 창작성을 통한 정신적 탐구에 대한 이야기', 'tag': 'A'},
                           {'topic': '세계의 문화와 역사적 유산을 이해하는 방법에 관한 토론', 'tag': 'A'},
                           {'topic': '인류학과 인류 진화에 관한 깊은 대화', 'tag': 'A'},
                           {'topic': '과학과 기술의 미래와 윤리적 고민에 대한 논의', 'tag': 'A'},
                           {'topic': '사회적 변화와 이슈에 대한 심도 있는 토론', 'tag': 'A'},
                           {'topic': '인간의 마음과 정신에 관한 철학적 고민에 대한 이야기', 'tag': 'A'},
                           {'topic': '세계 정치와 국제 관계의 동향과 현실에 관한 대화', 'tag': 'A'},
                           {'topic': '문학과 작가의 역할과 영향력에 관한 토론', 'tag': 'A'},
                           {'topic': '사회적 공헌과 지속 가능한 발전에 대한 이야기', 'tag': 'A'},
                           {'topic': '과학적인 원리와 현상에 관한 깊은 토론', 'tag': 'A'},
                           {'topic': '세계에서의 인권과 사회 정의의 복잡한 문제에 대한 논의', 'tag': 'A'},
                           {'topic': '현대 예술과 창작성의 정체성에 관한 이야기', 'tag': 'A'},
                           {'topic': '정치와 정책 결정에 영향을 미치는 경제적 요인에 대한 토론', 'tag': 'A'},
                           {'topic': '건강과 복지 문제에 대한 심도 있는 대화', 'tag': 'A'},
                           {'topic': '환경 문제와 지구 온난화에 대한 깊은 토론', 'tag': 'A'},
                           {'topic': '사회 공동체와 민주주의에 관한 이야기', 'tag': 'A'},
                           {'topic': '사회적 운동과 활동에 참여하는 방법에 관한 토론', 'tag': 'A'},
                           {'topic': '역사적 사실과 이벤트에 대한 심도 있는 토론', 'tag': 'A'},
                           {'topic': '생명과 생명 윤리에 관한 깊은 대화', 'tag': 'A'},
                           {'topic': '세계의 문화와 언어 다양성을 이해하는 방법에 관한 이야기', 'tag': 'A'},
                           {'topic': '과학적 연구와 실험의 윤리적 쟁점에 대한 토론', 'tag': 'A'},
                           {'topic': '사회적 정의와 평등에 관한 심도 있는 대화', 'tag': 'A'},
                           {'topic': '현대 예술과 예술가의 역할과 의미에 관한 이야기', 'tag': 'A'},
                           {'topic': '정치적인 이슈와 정책에 대한 깊은 토론', 'tag': 'A'},
                           {'topic': '건강과 복지에 영향을 미치는 사회적 요인에 대한 토론', 'tag': 'A'},
                           {'topic': '환경 보호와 지속 가능한 생활에 대한 심도 있는 대화', 'tag': 'A'},
                           {'topic': '사회적 집단과 사회운동의 효과에 관한 이야기', 'tag': 'A'},
                           {'topic': '과학과 기술의 윤리와 사회적 책임에 대한 토론', 'tag': 'A'},
                           {'topic': '세계에서의 인권과 사회적 평등의 이해에 관한 깊은 대화', 'tag': 'A'},
                           {'topic': '음악과 미술이 사회적 변화와 활동에 미치는 영향에 대한 이야기', 'tag': 'A'},
                           {'topic': '정치적인 변화와 혁명에 대한 토론', 'tag': 'A'},
                           {'topic': '건강과 복지 문제에 대한 깊은 이야기', 'tag': 'A'},
                           {'topic': '환경 문제와 지속 가능한 에너지 솔루션에 대한 토론', 'tag': 'A'},
                           {'topic': '사회적 정의와 사회적 불평등에 대한 깊은 대화', 'tag': 'A'},
                           {'topic': '미술과 창작성이 사회적 변화와 개선에 어떻게 기여하는지에 대한 이야기', 'tag': 'A'},
                           {'topic': '정치와 정부 체제의 복잡한 현실에 대한 토론', 'tag': 'A'},
                           {'topic': '사회문제와 커뮤니티 개발에 대한 깊은 토론', 'tag': 'A'},
                           {'topic': '과학적 연구와 혁신의 윤리적 고민에 대한 이야기', 'tag': 'A'},
                           {'topic': '세계에서의 사회적 관계와 국제 협력에 관한 토론', 'tag': 'A'},
                           {'topic': '음악과 예술이 인류사와 문화에 미치는 영향에 대한 깊은 대화', 'tag': 'A'},
                           {'topic': '정치적인 조직과 이해관계에 대한 이야기', 'tag': 'A'},
                           {'topic': '건강 및 복지와 관련된 정책 결정과 민주주의에 대한 토론', 'tag': 'A'},
                           {'topic': '환경 문제와 지구 환경 보호를 위한 글로벌 대화에 대한 깊은 대화', 'tag': 'A'}])

    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('topic')
    # ### end Alembic commands ###