# https://dbdiagram.io/d/Instagram-65cb698bac844320ae0b6df6

CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "username" VARCHAR(50),
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "posts" (
  "id" SERIAL PRIMARY KEY,
  "title" VARCHAR(200),
  "url" VARCHAR(200),
  "created_at" timestamp,
  "updated_at" timestamp,
  "user_id" integer
);

CREATE TABLE "comments" (
  "id" SERIAL PRIMARY KEY,
  "contents" TEXT,
  "created_at" timestamp,
  "updated_at" timestamp,
  "user_id" integer,
  "post_id" integer
);

ALTER TABLE "posts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");
