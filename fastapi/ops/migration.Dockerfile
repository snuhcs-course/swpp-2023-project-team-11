FROM snek:base

# Run Migration
ENTRYPOINT [ "alembic", "upgrade", "head" ]
