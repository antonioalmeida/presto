DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS answer_rating CASCADE;
DROP TABLE IF EXISTS answer_report CASCADE;
DROP TABLE IF EXISTS comment_rating CASCADE;
DROP TABLE IF EXISTS comment_report CASCADE;
DROP TABLE IF EXISTS comment CASCADE;
DROP TABLE IF EXISTS answer CASCADE;
DROP TABLE IF EXISTS question CASCADE;
DROP TABLE IF EXISTS question_rating CASCADE;
DROP TABLE IF EXISTS question_report CASCADE;
DROP TABLE IF EXISTS member CASCADE;
DROP TABLE IF EXISTS topic CASCADE;
DROP TABLE IF EXISTS follow_member CASCADE;
DROP TABLE IF EXISTS follow_topic CASCADE;
DROP TABLE IF EXISTS question_topic CASCADE;
DROP TABLE IF EXISTS notification CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS flag CASCADE;
DROP TYPE IF EXISTS notification_origin CASCADE;

-- NotificationOrigin enum
CREATE TYPE notification_origin AS ENUM (
    'Question',
    'Answer',
    'Comment',
    'Rating',
    'Follow',
    'Mention'
);

-- R01 admin
CREATE TABLE admin (
    id SERIAL NOT NULL,
    email text NOT NULL,
    password text NOT NULL
);

-- R02 country
CREATE TABLE country (
    id SERIAL NOT NULL,
    name text NOT NULL
);

-- R03 member
CREATE TABLE member (
    id SERIAL NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    bio text,
    profilePic text,
    score INTEGER NOT NULL,
    isBanned BOOLEAN NOT NULL,
    isModerator BOOLEAN NOT NULL,
    country_id INTEGER NOT NULL --FK
);

-- R04 flag
CREATE TABLE flag (
    member_id INTEGER NOT NULL, --FK
    moderator_id INTEGER NOT NULL, --FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R05 follow_member
CREATE TABLE follow_member (
    follower_id INTEGER NOT NULL, --FK
    following_id INTEGER NOT NULL, --FK
    CONSTRAINT follow_member_ck CHECK (follower_id <> following_id)
);

-- R06 notification
CREATE TABLE notification (
    id SERIAL NOT NULL,
    type notification_origin NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    content text NOT NULL,
    member_id INTEGER NOT NULL --FK
);

-- R07 topic
CREATE TABLE topic (
    id SERIAL NOT NULL,
    name text NOT NULL,
    description text,
    picture text
);

-- R08 follow_topic
CREATE TABLE follow_topic (
    member_id INTEGER NOT NULL, --FK
    topic_id INTEGER NOT NULL --FK
);

-- R09 question
CREATE TABLE question (
    id SERIAL NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL CHECK (views >= 0),
    solved BOOLEAN NOT NULL,
    author_id INTEGER NOT NULL --FK
);

-- R10 answer
CREATE TABLE answer (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL CHECK (views >= 0),
    question_id INTEGER NOT NULL, --FK
    author_id INTEGER NOT NULL --FK
);

-- R11 comment
CREATE TABLE comment (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    --TODO: Correct this if needed
    question_id INTEGER, --FK
    answer_id INTEGER, --FK
    author_id INTEGER NOT NULL --FK
);

-- R12 question_topic
CREATE TABLE question_topic (
    question_id INTEGER NOT NULL, --FK
    topic_id INTEGER NOT NULL --FK
);

-- R13 question_rating
CREATE TABLE question_rating (
    question_id INTEGER NOT NULL, --FK
    member_id INTEGER NOT NULL, --FK
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1)
);

-- R14 answer_rating
CREATE TABLE answer_rating (
    answer_id INTEGER NOT NULL, --FK
    member_id INTEGER NOT NULL, --FK
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1)
);

-- R15 comment_rating
CREATE TABLE comment_rating (
    comment_id INTEGER NOT NULL, --FK
    member_id INTEGER NOT NULL, --FK
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1)
);

-- R16 question_report
CREATE TABLE question_report (
    question_id INTEGER NOT NULL, --FK
    member_id INTEGER NOT NULL, --FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R17 answer_report
CREATE TABLE answer_report (
    answer_id INTEGER NOT NULL, --FK
    member_id INTEGER NOT NULL, --FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R18 comment_report
CREATE TABLE comment_report (
    comment_id INTEGER NOT NULL, --FK
    member_id INTEGER NOT NULL, --FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- Primary keys and unique constraints
-- Foreign keys constraints
ALTER TABLE ONLY admin
  ADD CONSTRAINT admin_pk PRIMARY KEY (id);

ALTER TABLE ONLY admin
  ADD CONSTRAINT admin_uk UNIQUE (email);

ALTER TABLE ONLY country
  ADD CONSTRAINT country_pk PRIMARY KEY (id);

ALTER TABLE ONLY country
  ADD CONSTRAINT country_uk UNIQUE (name);

ALTER TABLE ONLY member
  ADD CONSTRAINT member_pk PRIMARY KEY (id);

ALTER TABLE ONLY member
  ADD CONSTRAINT member_username_uk UNIQUE (username);

ALTER TABLE ONLY member
  ADD CONSTRAINT member_email_uk UNIQUE (email);

ALTER TABLE ONLY flag
  ADD CONSTRAINT flag_pk PRIMARY KEY (member_id, moderator_id);

ALTER TABLE ONLY follow_member
  ADD CONSTRAINT follow_member_pk PRIMARY KEY (follower_id, following_id);

ALTER TABLE ONLY notification
  ADD CONSTRAINT notification_pk PRIMARY KEY (id);

ALTER TABLE ONLY topic
  ADD CONSTRAINT topic_pk PRIMARY KEY (id);

ALTER TABLE ONLY follow_topic
  ADD CONSTRAINT follow_topic_pk PRIMARY KEY (member_id, topic_id);

ALTER TABLE ONLY question
  ADD CONSTRAINT question_pk PRIMARY KEY (id);

ALTER TABLE ONLY answer
  ADD CONSTRAINT answer_pk PRIMARY KEY (id);

ALTER TABLE ONLY comment
  ADD CONSTRAINT comment_pk PRIMARY KEY (id);

ALTER TABLE ONLY question_topic
  ADD CONSTRAINT question_topic_pk PRIMARY KEY (question_id, topic_id);

ALTER TABLE ONLY question_rating
  ADD CONSTRAINT question_rating_pk PRIMARY KEY (question_id, member_id);

ALTER TABLE ONLY answer_rating
  ADD CONSTRAINT answer_rating_pk PRIMARY KEY (answer_id, member_id);

ALTER TABLE ONLY comment_rating
  ADD CONSTRAINT comment_rating_pk PRIMARY KEY (comment_id, member_id);

ALTER TABLE ONLY question_report
  ADD CONSTRAINT question_report_pk PRIMARY KEY (question_id, member_id);

ALTER TABLE ONLY answer_report
  ADD CONSTRAINT answer_report_pk PRIMARY KEY (answer_id, member_id);

ALTER TABLE ONLY comment_report
  ADD CONSTRAINT comment_report_pk PRIMARY KEY (comment_id, member_id);
