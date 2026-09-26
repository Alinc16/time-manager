#!/bin/sh

echo "Waiting for database to be ready..."
while ! pg_isready -q -h $DATABASE_HOST -p 5432 -U $DATABASE_USER
do
  sleep 1
done

echo "Running migrations..."
mix ecto.create || true
mix ecto.migrate

echo "Starting Phoenix server..."
exec mix phx.server
