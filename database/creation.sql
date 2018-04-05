DROP TABLE IF EXISTS flag CASCADE;
DROP TABLE IF EXISTS answer_rating CASCADE;
DROP TABLE IF EXISTS answer_report CASCADE;
DROP TABLE IF EXISTS comment_rating CASCADE;
DROP TABLE IF EXISTS comment_report CASCADE;
DROP TABLE IF EXISTS question_rating CASCADE;
DROP TABLE IF EXISTS question_report CASCADE;
DROP TABLE IF EXISTS follow_member CASCADE;
DROP TABLE IF EXISTS follow_topic CASCADE;
DROP TABLE IF EXISTS question_topic CASCADE;
DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS notification CASCADE;
DROP TABLE IF EXISTS comment CASCADE;
DROP TABLE IF EXISTS answer CASCADE;
DROP TABLE IF EXISTS question CASCADE;
DROP TABLE IF EXISTS topic CASCADE;
DROP TABLE IF EXISTS member CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TYPE IF EXISTS notification_origin CASCADE;

DROP TRIGGER IF EXISTS member_question_rating ON question_rating;
DROP TRIGGER IF EXISTS member_answer_rating ON answer_rating;
DROP TRIGGER IF EXISTS member_comment_rating ON comment_rating;
DROP TRIGGER IF EXISTS member_question_report ON question_report;
DROP TRIGGER IF EXISTS member_answer_report ON answer_report;
DROP TRIGGER IF EXISTS member_comment_report ON comment_report;
DROP TRIGGER IF EXISTS admin_email ON admin;
DROP TRIGGER IF EXISTS member_email ON member;
DROP TRIGGER IF EXISTS question_topic ON question_topic;
DROP TRIGGER IF EXISTS answer_date ON answer;
DROP TRIGGER IF EXISTS comment_date ON comment;
DROP TRIGGER IF EXISTS moderator_flag ON flag;
DROP TRIGGER IF EXISTS update_score_question ON question;
DROP TRIGGER IF EXISTS update_score_answer ON answer;
DROP TRIGGER IF EXISTS update_score_question_rating ON question_rating;
DROP TRIGGER IF EXISTS update_score_answer_rating ON answer_rating;
DROP TRIGGER IF EXISTS update_score_delete_question_rating ON question_rating;
DROP TRIGGER IF EXISTS update_score_delete_answer_rating ON answer_rating;
DROP TRIGGER IF EXISTS question_search_update ON question;
DROP TRIGGER IF EXISTS answer_search_update ON answer;
DROP TRIGGER IF EXISTS notify_on_answer ON answer;
DROP TRIGGER IF EXISTS notify_on_comment_question ON comment;
DROP TRIGGER IF EXISTS notify_on_comment_answer ON comment;
DROP TRIGGER IF EXISTS notify_on_question_rating ON question_rating;
DROP TRIGGER IF EXISTS notify_on_answer_rating ON answer_rating;
DROP TRIGGER IF EXISTS notify_on_follow ON follow_member;
DROP FUNCTION IF EXISTS member_question_rating();
DROP FUNCTION IF EXISTS member_answer_rating();
DROP FUNCTION IF EXISTS member_comment_rating();
DROP FUNCTION IF EXISTS member_question_report();
DROP FUNCTION IF EXISTS member_answer_report();
DROP FUNCTION IF EXISTS member_comment_report();
DROP FUNCTION IF EXISTS admin_member_email();
DROP FUNCTION IF EXISTS question_topic();
DROP FUNCTION IF EXISTS answer_date();
DROP FUNCTION IF EXISTS comment_date();
DROP FUNCTION IF EXISTS moderator_flag();
DROP FUNCTION IF EXISTS update_score_post();
DROP FUNCTION IF EXISTS update_score_new_rating();
DROP FUNCTION IF EXISTS update_score_update_rating();
DROP FUNCTION IF EXISTS update_score_delete_rating();
DROP FUNCTION IF EXISTS question_search_update();
DROP FUNCTION IF EXISTS answer_search_update();
DROP FUNCTION IF EXISTS notify_on_answer();
DROP FUNCTION IF EXISTS notify_on_comment_question();
DROP FUNCTION IF EXISTS notify_on_comment_answer();
DROP FUNCTION IF EXISTS notify_on_question_rating();
DROP FUNCTION IF EXISTS notify_on_answer_rating();
DROP FUNCTION IF EXISTS notify_on_follow();

-- NotificationOrigin enum
CREATE TYPE notification_origin AS ENUM (
    'Question',
    'Answer',
    'Comment',
    'Rating',
    'Follow',
    'Mention'
);

CREATE TABLE admin (
    id SERIAL NOT NULL,
    email VARCHAR(40) NOT NULL,
    password VARCHAR(35) NOT NULL,
    CONSTRAINT admin_pk PRIMARY KEY (id),
    CONSTRAINT admin_uk UNIQUE (email)
);

CREATE TABLE country (
    id SERIAL NOT NULL,
    name VARCHAR(30) NOT NULL,
    CONSTRAINT country_pk PRIMARY KEY (id),
    CONSTRAINT country_uk UNIQUE (name)
);

CREATE TABLE member (
    id SERIAL NOT NULL,
    username VARCHAR(20) NOT NULL,
    email VARCHAR(40) NOT NULL,
    password VARCHAR(35) NOT NULL,
    name VARCHAR(35) NOT NULL,
    bio text,
    profile_picture text,
    -- redundant data (for better performance on score update)
    positive_votes INTEGER NOT NULL DEFAULT 0,
    total_votes INTEGER NOT NULL DEFAULT 0,
    nr_questions INTEGER NOT NULL DEFAULT 0,
    nr_answers INTEGER NOT NULL DEFAULT 0,
    --
    score INTEGER NOT NULL DEFAULT 0,
    is_banned BOOLEAN NOT NULL DEFAULT false,
    is_moderator BOOLEAN NOT NULL DEFAULT false,
    country_id INTEGER NOT NULL,
    CONSTRAINT member_pk PRIMARY KEY (id),
    CONSTRAINT member_username_uk UNIQUE (username),
    CONSTRAINT member_email_uk UNIQUE (email),
    CONSTRAINT member_fk FOREIGN KEY (country_id) REFERENCES country (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE flag (
    member_id INTEGER NOT NULL,
    moderator_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL,
    CONSTRAINT flag_pk PRIMARY KEY (member_id, moderator_id),
    CONSTRAINT flag_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT flag_moderator_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE

);

CREATE TABLE follow_member (
    follower_id INTEGER NOT NULL,
    following_id INTEGER NOT NULL,
    CONSTRAINT follow_member_ck CHECK (follower_id <> following_id),
    CONSTRAINT follow_member_pk PRIMARY KEY (follower_id, following_id),
    CONSTRAINT follow_member_follower_fk FOREIGN KEY (follower_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT follow_member_following_fk FOREIGN KEY (following_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE notification (
    id SERIAL NOT NULL,
    type notification_origin NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    content text NOT NULL,
    member_id INTEGER NOT NULL,
    read BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT notification_pk PRIMARY KEY (id),
    CONSTRAINT notification_fk FOREIGN KEY (member_id) REFERENCES member (id)
);

CREATE TABLE topic (
    id SERIAL NOT NULL,
    name VARCHAR(25) NOT NULL,
    description text,
    picture text,
    CONSTRAINT topic_pk PRIMARY KEY (id)
);

CREATE TABLE follow_topic (
    member_id INTEGER NOT NULL,
    topic_id INTEGER NOT NULL,
    CONSTRAINT follow_topic_pk PRIMARY KEY (member_id, topic_id),
    CONSTRAINT follow_topic_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT follow_topic_topic_fk FOREIGN KEY (topic_id) REFERENCES topic (id) ON UPDATE CASCADE ON DELETE CASCADE

);

CREATE TABLE question (
    id SERIAL NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL CHECK (views >= 0) DEFAULT 0,
    solved BOOLEAN NOT NULL DEFAULT false,
    author_id INTEGER NOT NULL,
    search tsvector NOT NULL,
    CONSTRAINT question_pk PRIMARY KEY (id),
    CONSTRAINT question_fk FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE answer (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    views INTEGER NOT NULL CHECK (views >= 0),
    question_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    search tsvector NOT NULL,
    CONSTRAINT answer_pk PRIMARY KEY (id),
    CONSTRAINT answer_member_fk FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT answer_question_fk FOREIGN KEY (question_id) REFERENCES question (id)
);

CREATE TABLE comment (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    question_id INTEGER,
    answer_id INTEGER,
    author_id INTEGER NOT NULL,
    CONSTRAINT comment_ck CHECK ((question_id IS NULL AND answer_id IS NOT NULL) OR (question_id IS NOT NULL AND answer_id IS NULL)), --XOR
    CONSTRAINT comment_pk PRIMARY KEY (id),
    CONSTRAINT comment_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT comment_member_fk FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT comment_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE question_topic (
    question_id INTEGER NOT NULL,
    topic_id INTEGER NOT NULL,
    CONSTRAINT question_topic_pk PRIMARY KEY (question_id, topic_id),
    CONSTRAINT question_topic_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT question_topic_topic_fk FOREIGN KEY (topic_id) REFERENCES topic (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE question_rating (
    question_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1),
    CONSTRAINT question_rating_pk PRIMARY KEY (question_id, member_id),
    CONSTRAINT question_rating_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT question_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE answer_rating (
    answer_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1),
    CONSTRAINT answer_rating_pk PRIMARY KEY (answer_id, member_id),
    CONSTRAINT answer_rating_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT answer_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE comment_rating (
    comment_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1),
    CONSTRAINT comment_rating_pk PRIMARY KEY (comment_id, member_id),
    CONSTRAINT comment_rating_comment_fk FOREIGN KEY (comment_id) REFERENCES comment (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT comment_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE question_report (
    question_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL,
    CONSTRAINT question_report_pk PRIMARY KEY (question_id, member_id),
    CONSTRAINT question_report_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT question_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE answer_report (
    answer_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL,
    CONSTRAINT answer_report_pk PRIMARY KEY (answer_id, member_id),
    CONSTRAINT answer_report_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT answer_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE comment_report (
    comment_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITH TIME zone NOT NULL,
    reason text NOT NULL,
    CONSTRAINT comment_report_pk PRIMARY KEY (comment_id, member_id),
    CONSTRAINT comment_report_comment_fk FOREIGN KEY (comment_id) REFERENCES comment (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT comment_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);
