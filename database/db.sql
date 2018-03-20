DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS comment CASCADE;
DROP TABLE IF EXISTS answer_rating CASCADE;
DROP TABLE IF EXISTS answer_report CASCADE;
DROP TABLE IF EXISTS comment_rating CASCADE;
DROP TABLE IF EXISTS comment_report CASCADE;
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
    country_id INTEGER NOT NULL
);

-- R04 flag
CREATE TABLE flag (
    member_id INTEGER NOT NULL,
    moderator_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R05 follow_member
CREATE TABLE follow_member (
    follower_id INTEGER NOT NULL,
    following_id INTEGER NOT NULL,
    CONSTRAINT follow_member_ck CHECK (follower_id <> following_id)
);

-- R06 notification
CREATE TABLE notification (
    id SERIAL NOT NULL,
    type notification_origin NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    content text NOT NULL,
    member_id INTEGER NOT NULL
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
    member_id INTEGER NOT NULL,
    topic_id INTEGER NOT NULL
);

-- R09 question
CREATE TABLE question (
    id SERIAL NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL CHECK (views >= 0),
    solved BOOLEAN NOT NULL,
    author_id INTEGER NOT NULL
);

-- R10 answer
CREATE TABLE answer (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL CHECK (views >= 0),
    question_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL
);

-- R11 comment
CREATE TABLE comment (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    question_id INTEGER,
    answer_id INTEGER,
    author_id INTEGER NOT NULL,
    CONSTRAINT comment_ck CHECK ((question_id IS NULL AND answer_id IS NOT NULL) OR (question_id IS NOT NULL AND answer_id IS NULL)) --XOR
);

-- R12 question_topic
CREATE TABLE question_topic (
    question_id INTEGER NOT NULL,
    topic_id INTEGER NOT NULL
);

-- R13 question_rating
CREATE TABLE question_rating (
    question_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1)
);

-- R14 answer_rating
CREATE TABLE answer_rating (
    answer_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1)
);

-- R15 comment_rating
CREATE TABLE comment_rating (
    comment_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1)
);

-- R16 question_report
CREATE TABLE question_report (
    question_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R17 answer_report
CREATE TABLE answer_report (
    answer_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R18 comment_report
CREATE TABLE comment_report (
    comment_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- Primary keys and unique constraints
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

-- Foreign keys constraints
ALTER TABLE ONLY member
  ADD CONSTRAINT member_fk FOREIGN KEY (country_id) REFERENCES country (id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY flag
  ADD CONSTRAINT flag_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY flag
  ADD CONSTRAINT flag_moderator_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY follow_member
  ADD CONSTRAINT follow_member_follower_fk FOREIGN KEY (follower_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY follow_member
  ADD CONSTRAINT follow_member_following_fk FOREIGN KEY (following_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY notification
  ADD CONSTRAINT notification_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY follow_topic
  ADD CONSTRAINT follow_topic_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY follow_topic
  ADD CONSTRAINT follow_topic_topic_fk FOREIGN KEY (topic_id) REFERENCES topic (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY question
  ADD CONSTRAINT question_fk FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY answer
  ADD CONSTRAINT answer_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY answer
  ADD CONSTRAINT answer_member_fk FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY comment
  ADD CONSTRAINT comment_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY comment
  ADD CONSTRAINT comment_member_fk FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY comment
  ADD CONSTRAINT comment_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY question_topic
  ADD CONSTRAINT question_topic_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY question_topic
  ADD CONSTRAINT question_topic_topic_fk FOREIGN KEY (topic_id) REFERENCES topic (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY question_rating
  ADD CONSTRAINT question_rating_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY question_rating
  ADD CONSTRAINT question_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY answer_rating
  ADD CONSTRAINT answer_rating_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY answer_rating
  ADD CONSTRAINT answer_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY comment_rating
  ADD CONSTRAINT comment_rating_comment_fk FOREIGN KEY (comment_id) REFERENCES comment (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY comment_rating
  ADD CONSTRAINT comment_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY question_report
  ADD CONSTRAINT question_report_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY question_report
  ADD CONSTRAINT question_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY answer_report
  ADD CONSTRAINT answer_report_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY answer_report
  ADD CONSTRAINT answer_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY comment_report
  ADD CONSTRAINT comment_report_comment_fk FOREIGN KEY (comment_id) REFERENCES comment (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY comment_report
  ADD CONSTRAINT comment_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE;
