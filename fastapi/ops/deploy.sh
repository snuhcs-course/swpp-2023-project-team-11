# Build images (optional)
docker build -t snek:base -f ops/snek.Dockerfile .
docker build -t snek:migration -f ops/migration.Dockerfile .
docker build -t snek:it-test -f ops/backend.Dockerfile .
docker build -t snek:chatting -f ops/chatting.Dockerfile .

# Run database
docker run --name snek-db --rm -d -p 5432:5432 \
    --add-host host.docker.internal:host-gateway \
    --env-file deploy.conf \
    postgres:latest

# Run migrations
docker run --name snek-migration --rm -d \
    --add-host host.docker.internal:host-gateway \
    --env-file deploy.conf \
    snek:migration

# Run service
docker run --name snek-it-test --rm -d -p 8000:8000 \
    --add-host host.docker.internal:host-gateway \
    --env-file deploy.conf \
    snek:it-test

# Healthcheck
sleep 3
echo ======Healthcheck======
docker logs snek-it-test

# Add users
echo "======Add User1 (IT_KOR)======"
curl -X 'POST' \
  'http://127.0.0.1:8000/user/sign_up' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "integration1@snu.ac.kr",
  "token": "token",
  "password": "password",
  "profile": {
    "name": "IT_KOR",
    "birth": "2023-12-09",
    "sex": "male",
    "major": "CLS",
    "admission_year": 2023,
    "about_me": "The best app, SNEK",
    "mbti": "INTJ",
    "nation_code": 82,
    "foods": [],
    "movies": [],
    "hobbies": [],
    "locations": []
  },
  "main_language": "korean",
  "languages": [
    "english"
  ]
}'
echo ""
echo "======Add User2 (IT_FOR)======"
curl -X 'POST' \
  'http://127.0.0.1:8000/user/sign_up' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "integration2@snu.ac.kr",
  "token": "token",
  "password": "password",
  "profile": {
    "name": "IT_FOR",
    "birth": "2023-12-09",
    "sex": "male",
    "major": "CSE",
    "admission_year": 2023,
    "about_me": "The best app, SNEK",
    "mbti": "INTJ",
    "nation_code": 13,
    "foods": [],
    "movies": [],
    "hobbies": [],
    "locations": []
  },
  "main_language": "english",
  "languages": [
    "spanish"
  ]
}'
echo ""

# Create chatting
docker run --name snek-chatting --rm -d \
    --add-host host.docker.internal:host-gateway \
    --env INITIATOR="'IT_KOR'" \
    --env RESPONDER="'IT_FOR'" \
    --env-file deploy.conf \
    snek:chatting
