FROM snek:base

# Start service
ENTRYPOINT [ "uvicorn", "src.main:app", "--host=0.0.0.0" ]
