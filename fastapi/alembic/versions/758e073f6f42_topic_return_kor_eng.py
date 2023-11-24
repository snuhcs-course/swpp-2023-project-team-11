"""topic_return_kor_eng

Revision ID: 758e073f6f42
Revises: c7f913827b11
Create Date: 2023-11-24 15:30:49.380695

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '758e073f6f42'
down_revision: Union[str, None] = 'c7f913827b11'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:

    meta = sa.MetaData()
    meta.reflect(only=('topic',),bind= op.get_bind())
    topic_tbl = sa.Table('topic', meta)
    #delete every record in topic table
    op.execute(topic_tbl.delete())
    op.add_column('topic', sa.Column('topic_kor', sa.String(), nullable=False))
    op.add_column('topic', sa.Column('topic_eng', sa.String(), nullable=False))
    op.drop_column('topic', 'is_korean')
    op.drop_column('topic', 'topic')

    #주석 없애고 데이터만 넣어주시면 됩니다!
    #topic_data = []
    #op.bulk_insert(topic_tbl, topic_data)
    


def downgrade() -> None:

    op.add_column('topic', sa.Column('topic', sa.VARCHAR(), autoincrement=False, nullable=False))
    op.add_column('topic', sa.Column('is_korean', sa.BOOLEAN(), server_default=sa.text('true'), autoincrement=False, nullable=True))
    op.drop_column('topic', 'topic_eng')
    op.drop_column('topic', 'topic_kor')
    topic_data = [
        {
            "topic": "Conversation about the ultimate goal in life",
            "tag": "A",
            "is_korean": False,
        },
        {"topic": "Conversation about one's beliefs", "tag": "A", "is_korean": False},
        {
            "topic": "Discussion on the lack of ethical awareness among modern teenagers",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the impact of media usage on human intelligence",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the issue of room temperature superconductors in Korea",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about personal experiences related to mental health",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the hardships faced in life and the growth resulting from them",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the effectiveness of meditation",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the complexity of modern art",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about vision and goals related to self-development and self-completion",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about social service experiences and reflections after becoming an adult",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the practical help of philosophical contemplation for modern individuals",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the most important historical event in the 20th century, in one's opinion",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the side effects of genetic engineering",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on one's country's political issues and desired international relations",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the research topic in the academic field one is studying",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on whether celebrities are public figures",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the world cultural heritage of one's own country",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the characteristics and issues of education policies in each country",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the role of music and art and the value of artists",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on economic issues in Korea and possible solutions",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the necessity of nature and environmental protection",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Personal thoughts on the unique cultures and customs around the world",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on ethical considerations in the field of science and technology, especially in weapons",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about sustainable technology and discussions about the future",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about lessons learned through historical figures",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about astronomy and the universe",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Trends in social movements, student movements, etc., in each country",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the meaning of life and one's attitude towards it",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about classic works of art and literature that deeply impacted the individual",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "In-depth discussion on the ideal political and government system",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the government's intervention in health and welfare",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about personal efforts for earth and environmental protection",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the individual's role in solving social problems",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the increasing importance of psychological therapy in modern society",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on embracing multiculturalism and ways to do so",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on whether humanity can progress beyond its current state",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the alienation caused by the development of science and technology",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about personal experiences with sleep disorders and their resolutions",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the global political trends and the possibility of war",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about personal transformation through literary works",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the scope of human rights that a nation should guarantee and social justice",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the negative impact of economic entities on policy decisions",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about efforts for health management",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about addressing issues arising from global warming",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on political systems like democracy, socialism, etc.",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Individual assessment of internet culture in one's own country",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on differences in human attitudes towards livestock and pets",
            "tag": "A",
            "is_korean": False,
        },
        {"topic": "Tips for language study one has", "tag": "A", "is_korean": False},
        {
            "topic": "Conversation about the ethical consciousness scientists should have",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about how much social equality should be guaranteed",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the economic evaluation of artists in the phenomenon of art",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on the practical influence of politicians on the lives of citizens",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on political solutions to environmental issues caused by neighboring countries",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the current status and utility of recycling and waste separation in one's own country",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the negative social impact of the growth of social media",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about efforts by one's own government to address income inequality",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on the factors contributing to the growth of K-POP",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the political characteristics of each East Asian country, their strengths, and weaknesses",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about recent health issues experienced and efforts to address them",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the gap between advanced and developing countries caused by sustainable energy solutions",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about elements that give meaning to life (family, material prosperity, occupational achievements, etc.)",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on the most important aspect of balancing family and work",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about one's core values in life and efforts to achieve them",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about addressing the growing phenomenon of crime and solutions",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on the serious issue of low birth rates in Korea and its factors",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the most unique cultural aspects of other countries",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about the harmful effects of alcohol and smoking and government policy solutions",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about one's ideal family and its characteristics",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Debate on the legitimacy of nuclear development in countries with a high possibility of war",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Discussion on the efficiency of universal welfare and selective welfare",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about addressing social phenomena like 'N-kids' and 'F-kids'",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about one's opinion on the introduction of a windfall tax",
            "tag": "A",
            "is_korean": False,
        },
        {
            "topic": "Conversation about family and family history",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Preference between mountains and the sea",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Conversation about favorite local restaurants",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Conversation about parks suitable for a stroll near home",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "If you want to be a celebrity, who would you want to be?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Asking about favorite regular restaurants",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "If you could turn back time, when would you want to go back?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Teleportation ability to anywhere vs Shapeshifting ability to anyone",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Talk about your ideal type", "tag": "B", "is_korean": False},
        {
            "topic": "Share experiences about being a vegan or vegetarian",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Discuss the latest AI technology", "tag": "B", "is_korean": False},
        {
            "topic": "Eating seafood for a lifetime vs Eating meat for a lifetime",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Talk about your family", "tag": "B", "is_korean": False},
        {"topic": "Thoughts on tipping culture", "tag": "B", "is_korean": False},
        {
            "topic": "Discussion about low birth rates in Korea",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Conversation about rising home prices",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Talk about your investment experiences",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Are you a morning person or an evening person?",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Belief in fate", "tag": "B", "is_korean": False},
        {"topic": "Discussion about favorite fruits", "tag": "B", "is_korean": False},
        {
            "topic": "Which comes first, what you want to do or what you have to do?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "What you want to do vs What you are good at",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "If you can only live for a month, what would you do?",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Generational conflicts", "tag": "B", "is_korean": False},
        {"topic": "Discussion about life goals", "tag": "B", "is_korean": False},
        {
            "topic": "No one coming to your wedding vs No one coming to your funeral",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Thoughts on ChatGPT", "tag": "B", "is_korean": False},
        {
            "topic": "Thoughts on the importance of money in life",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Talk about the craziest thing you've ever done",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Talk about post-graduation career plans",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Areas of interest", "tag": "B", "is_korean": False},
        {
            "topic": "Favorite time of the day: Morning vs Afternoon vs Evening vs Night",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Lotto win vs Double lifespan", "tag": "B", "is_korean": False},
        {
            "topic": "38-degree summer vs Minus 15-degree winter",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Live as a 15-year-old forever vs Live as a 50-year-old forever",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Seafood for a lifetime vs Meat for a lifetime",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Cultural shock experiences", "tag": "B", "is_korean": False},
        {
            "topic": "Stories about the history of each country",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Stories about notable figures in each country",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Explanations about figures on each country's currency",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Talk about someone you admire", "tag": "B", "is_korean": False},
        {
            "topic": "Thoughts on environmental pollution",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Thoughts on climate change", "tag": "B", "is_korean": False},
        {"topic": "Thoughts on income inequality", "tag": "B", "is_korean": False},
        {"topic": "Episodes during COVID-19", "tag": "B", "is_korean": False},
        {"topic": "Do you have a favorite game?", "tag": "B", "is_korean": False},
        {"topic": "Favorite foreign cuisine", "tag": "B", "is_korean": False},
        {"topic": "A place only you know", "tag": "B", "is_korean": False},
        {
            "topic": "If you could only eat one type of food for a week, what would it be?",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Share how your day went today", "tag": "B", "is_korean": False},
        {
            "topic": "Talk about the first impression of someone that surprised you",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Who would you prefer to work with? Capable but grumpy A vs Friendly but incompetent B",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Compliments for each other", "tag": "B", "is_korean": False},
        {"topic": "Experience of traveling alone", "tag": "B", "is_korean": False},
        {
            "topic": "Do you use social media? Thoughts on being active on social media",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Talk about your interest in scientific fields",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Which area occupies the largest part of your consumption pattern?",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Current concerns", "tag": "B", "is_korean": False},
        {
            "topic": "Share interesting experiences related to the partner's country",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Difficulties in learning the partner's language",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Activity you wanted to try when making friends with a foreigner",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Reasons for being interested in Korea",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Favorite aspect of Korean culture", "tag": "B", "is_korean": False},
        {"topic": "Talk about your bucket list", "tag": "B", "is_korean": False},
        {
            "topic": "Do you believe true friendship between a man and a woman is possible?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Talk about the club you were involved in",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Experience of going to an amusement park",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Share a recent dream", "tag": "B", "is_korean": False},
        {
            "topic": "If you could change one thing that happened in the past week",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "What is most important to you when deciding a career path?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Which is more important, career or family?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "How to quickly become close with someone you just met",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Experience of having a crush", "tag": "B", "is_korean": False},
        {
            "topic": "Which country would you like to live in later?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Experience of fighting with a friend",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Experience of being hurt by a friend",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "If you could choose a different major, what would it be?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "If you could change one thing about your appearance, where would you change?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "What is currently causing you the most stress?",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "When do you feel happy?", "tag": "B", "is_korean": False},
        {
            "topic": "What was the saddest experience in your life?",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Favorite musical instrument", "tag": "B", "is_korean": False},
        {"topic": "Ultimate goal in life", "tag": "B", "is_korean": False},
        {
            "topic": "Deep and narrow human relationships vs Wide and shallow human relationships",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Prefer meeting with just one or meeting with many friends",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Is there something you've always dreamed of but haven't had the courage to do?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "What activities do you usually do when meeting friends?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Are you more of a talker or a listener when meeting people?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Do you have a sports team you support?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "What do you find charming about Korea?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "How do you react if someone takes your idea?",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Recent issues related to movies and TV programs",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Discussion about social responsibility and contributions through volunteer activities",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Debate on topics related to the music field and the music industry",
            "tag": "B",
            "is_korean": False,
        },
        {
            "topic": "Talk about research topics and theories in anthropology and cultural sociology",
            "tag": "B",
            "is_korean": False,
        },
        {"topic": "Talking about favorite books", "tag": "C", "is_korean": False},
        {"topic": "Discussing favorite book genres", "tag": "C", "is_korean": False},
        {"topic": "Talking about favorite authors", "tag": "C", "is_korean": False},
        {"topic": "Discussing recent movies watched", "tag": "C", "is_korean": False},
        {"topic": "Talking about favorite TV programs", "tag": "C", "is_korean": False},
        {
            "topic": "Discussing interesting Netflix content",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about Marvel movies", "tag": "C", "is_korean": False},
        {"topic": "Discussing favorite movie genres", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about life-changing movies or dramas",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Discussing worst movies or dramas", "tag": "C", "is_korean": False},
        {"topic": "Talking about favorite actors", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about favorite movie directors",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Discussing K-POP", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about favorite music genres",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about favorite singers", "tag": "C", "is_korean": False},
        {"topic": "Talking about favorite songs", "tag": "C", "is_korean": False},
        {
            "topic": "Discussing most memorable travel destinations",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing worst travel destinations",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about amusing travel experiences",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about foods eaten during travels",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about MBTI personality types",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about favorite sports", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about favorite sports stars",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Discussing activities on holidays", "tag": "C", "is_korean": False},
        {"topic": "Discussing personal hobbies", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about favorite foods or restaurants",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing preferred coffee at cafes",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about favorite musicals or plays",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about the most liked food", "tag": "C", "is_korean": False},
        {"topic": "Talking about foods one cannot eat", "tag": "C", "is_korean": False},
        {"topic": "Discussing Korean food culture", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about personal alcohol tolerance",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about favorite drinks", "tag": "C", "is_korean": False},
        {
            "topic": "Discussing desired travel destinations",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Discussing upcoming travel plans", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about the first overseas trip",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Discussing travel preparation tips", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about episodes of cultural differences during travel",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about food allergies", "tag": "C", "is_korean": False},
        {"topic": "Talking about favorite desserts", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about personal characteristics",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about personal strengths", "tag": "C", "is_korean": False},
        {"topic": "Talking about personal weaknesses", "tag": "C", "is_korean": False},
        {"topic": "Talking about good habits", "tag": "C", "is_korean": False},
        {"topic": "Talking about bad habits", "tag": "C", "is_korean": False},
        {"topic": "Talking about personal interests", "tag": "C", "is_korean": False},
        {"topic": "Talking about personal skills", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about the person one wants to become",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing recent exhibition visits",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about favorite clothing styles",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing preference for dogs or cats",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing happy experiences related to pets",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about experiences of raising pets",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about Korean street food", "tag": "C", "is_korean": False},
        {
            "topic": "Discussing recommended street food in one's own country",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about Korean delivery culture",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about favorite delivery foods",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Discussing recent weather", "tag": "C", "is_korean": False},
        {"topic": "Talking about favorite seasons", "tag": "C", "is_korean": False},
        {
            "topic": "Discussing useful apps used recently",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about one's major", "tag": "C", "is_korean": False},
        {
            "topic": "Discussing reasons for choosing one's major",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about experiences of cooking",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about dishes one is good at cooking",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about memorable gifts", "tag": "C", "is_korean": False},
        {"topic": "Talking about the favorite month", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about activities on the last Christmas",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about recent favorite YouTubers",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about the happiest moment of the past week",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about memorable high school experiences",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about one's hometown", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about fulfilling activities",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Describing first impressions with food",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing team projects vs. individual assignments",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Discussing personal boundaries", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about the most different aspect between how others see you and how you see yourself",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about one's favorite weather",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing actions taken when feeling lonely",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Summer clothes in winter vs. Winter clothes in summer",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "True friendship vs. True love", "tag": "C", "is_korean": False},
        {
            "topic": "Cola without carbonation vs. Pizza without cheese",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Monthly salary of 5 million KRW employee vs. Unemployed with a monthly salary of 2 million KRW",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about actions others should not do",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing the superpower one would want if given a choice",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Instagram banned for a month vs. YouTube banned for a month",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about oneself 10 years from now",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Talking about part-time jobs one would like to try",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing personal part-time job experiences",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing the most enjoyable experience during university life",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Discussing the most challenging experience during university life",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about favorite colors", "tag": "C", "is_korean": False},
        {
            "topic": "If you could go back 5 years, what would you do?",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about one's zodiac sign", "tag": "C", "is_korean": False},
        {"topic": "Talking about personal jinxes", "tag": "C", "is_korean": False},
        {
            "topic": "If you could be born as a different animal, what would it be?",
            "tag": "C",
            "is_korean": False,
        },
        {
            "topic": "Meeting someone you like vs. Meeting someone who likes you",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about drinking habits", "tag": "C", "is_korean": False},
        {
            "topic": "Discussing experiences of seeing ghosts",
            "tag": "C",
            "is_korean": False,
        },
        {"topic": "Talking about personal routines", "tag": "C", "is_korean": False},
        {
            "topic": "Talking about recent shopping experiences",
            "tag": "C",
            "is_korean": False,
        },
    ]
    meta = sa.MetaData()
    meta.reflect(only=('topic',),bind= op.get_bind())
    topic_tbl = sa.Table('topic', meta)
    op.bulk_insert(topic_tbl, topic_data)
