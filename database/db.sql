-- NotificationOrigin enum
CREATE Type NotificationOrigin AS ENUM (
    'Question',
    'Answer',
    'Comment',
    'Rating',
    'Follow',
    'Mention'
);

-- R01 admin
CREATE TABLE admin (
    id SERIAL NOT NULL, -- PK
    email text NOT NULL, -- UK
    password text NOT NULL
);

-- R02 country
CREATE TABLE country (
    id SERIAL NOT NULL, -- PK
    name text NOT NULL -- UK
);

-- R03 member
CREATE TABLE member (
    id SERIAL NOT NULL, -- PK
    username text NOT NULL, --UK
    email text NOT NULL, --UK
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
    member_id INTEGER NOT NULL, --PK FK
    moderator_id INTEGER NOT NULL, --PK FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R05 follow_member
CREATE TABLE follow_member (
    follower_id INTEGER NOT NULL, --PK FK
    following_id INTEGER NOT NULL --PK FK
);

-- R06 notification
CREATE TABLE notification (
    id SERIAL NOT NULL, --PK
    type NotificationOrigin NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    content text NOT NULL,
    member_id INTEGER NOT NULL --FK
);

-- R07 topic
CREATE TABLE topic (
    id SERIAL NOT NULL, --PK
    name text NOT NULL,
    description text,
    picture text
);

-- R08 follow_topic
CREATE TABLE follow_topic (
    member_id INTEGER NOT NULL, --PK FK
    topic_id INTEGER NOT NULL --PK FK
);

-- R09 question
CREATE TABLE question (
    id SERIAL NOT NULL, --PK
    title text NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL,
    solved BOOLEAN NOT NULL,
    author_id INTEGER NOT NULL --FK
);

-- R10 answer
CREATE TABLE answer (
    id SERIAL NOT NULL, --PK
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL CHECK views >= 0,
    question_id INTEGER NOT NULL, --FK
    author_id INTEGER NOT NULL --FK
);

-- R11 comment
CREATE TABLE comment (
    id SERIAL NOT NULL, --PK
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    --TODO: Correct this if needed
    question_id INTEGER, --FK
    answer_id INTEGER, --FK
    author_id INTEGER NOT NULL --FK
);

-- R12 question_topic
CREATE TABLE question_topic (
    question_id INTEGER NOT NULL, --PK FK
    topic_id INTEGER NOT NULL --PK FK
);

-- R13 question_rating
CREATE TABLE question_rating (
    question_id INTEGER NOT NULL, --PK FK
    member_id INTEGER NOT NULL, --PK FK
    rate INTEGER NOT NULL
);

-- R14 answer_rating
CREATE TABLE answer_rating (
    answer_id INTEGER NOT NULL, --PK FK
    member_id INTEGER NOT NULL, --PK FK
    rate INTEGER NOT NULL
);

-- R15 comment_rating
CREATE TABLE comment_rating (
    comment_id INTEGER NOT NULL, --PK FK
    member_id INTEGER NOT NULL, --PK FK
    rate INTEGER NOT NULL
);

-- R16 question_report
CREATE TABLE question_report (
    question_id INTEGER NOT NULL, --PK FK
    member_id INTEGER NOT NULL, --PK FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R17 answer_report
CREATE TABLE answer_report (
    answer_id INTEGER NOT NULL, --PK FK
    member_id INTEGER NOT NULL, --PK FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);

-- R18 comment_report
CREATE TABLE comment_report (
    comment_id INTEGER NOT NULL, --PK FK
    member_id INTEGER NOT NULL, --PK FK
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL
);
