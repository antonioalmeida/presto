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

-- Have to review these drops, some are missing, some do not apply anymore
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
DROP TRIGGER IF EXISTS update_score_comment ON comment;
DROP TRIGGER IF EXISTS update_score_question_rating ON question_rating;
DROP TRIGGER IF EXISTS update_score_answer_rating ON answer_rating;
DROP TRIGGER IF EXISTS update_score_comment_rating ON comment_rating;
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
DROP FUNCTION IF EXISTS update_score();

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
    score INTEGER NOT NULL,
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
    search text,
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
    search text,
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

-- Triggers
-- User cannot rate his own questions
CREATE FUNCTION member_question_rating() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT id FROM question_rating INNER JOIN question ON question_rating.question_id = question.id INNER JOIN member ON question.author_id = member.id WHERE question.id = NEW.question_id) THEN
    RAISE EXCEPTION 'A member cannot rate his own questions';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_question_rating
  BEFORE INSERT OR UPDATE ON question_rating
  FOR EACH ROW
    EXECUTE PROCEDURE member_question_rating();

-- User cannot rate his own answers
CREATE FUNCTION member_answer_rating() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT id FROM answer_rating INNER JOIN answer ON answer_rating.answer_id = answer.id INNER JOIN member ON answer.author_id = member.id WHERE answer.id = NEW.answer_id) THEN
    RAISE EXCEPTION 'A member cannot rate his own answers';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_answer_rating
  BEFORE INSERT OR UPDATE ON answer_rating
  FOR EACH ROW
    EXECUTE PROCEDURE member_answer_rating();

-- User cannot rate his own comments
CREATE FUNCTION member_comment_rating() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT id FROM comment_rating INNER JOIN comment ON comment_rating.comment_id = comment.id INNER JOIN member ON comment.author_id = member.id WHERE comment.id = NEW.comment_id) THEN
    RAISE EXCEPTION 'A member cannot rate his own comments';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_comment_rating
  BEFORE INSERT OR UPDATE ON comment_rating
  FOR EACH ROW
    EXECUTE PROCEDURE member_comment_rating();

-- User cannot report his own questions
CREATE FUNCTION member_question_report() RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT id FROM member INNER JOIN question_report ON member.id = question_report.member_id INNER JOIN question ON question_report.question_id = question.id WHERE question.author_id = member.id) THEN
    RAISE EXCEPTION 'A member cannot report his own questions';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_question_report
  BEFORE INSERT OR UPDATE ON question_report
  FOR EACH ROW
    EXECUTE PROCEDURE member_question_report();

-- User cannot report his own answers
CREATE FUNCTION member_answer_report() RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT id FROM member INNER JOIN answer_report ON member.id = answer_report.member_id INNER JOIN answer ON answer_report.answer_id = answer.id WHERE answer.author_id = member.id) THEN
    RAISE EXCEPTION 'A member cannot report his own answers';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_answer_report
  BEFORE INSERT OR UPDATE ON answer_report
  FOR EACH ROW
    EXECUTE PROCEDURE member_answer_report();

-- User cannot report his own comments
CREATE FUNCTION member_comment_report() RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT id FROM member INNER JOIN comment_report ON member.id = comment_report.member_id INNER JOIN comment ON comment_report.comment_id = comment.id WHERE comment.author_id = member.id) THEN
    RAISE EXCEPTION 'A member cannot report his own comments';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_comment_report
  BEFORE INSERT OR UPDATE ON comment_report
  FOR EACH ROW
    EXECUTE PROCEDURE member_comment_report();

--Unique email between admins and members
CREATE FUNCTION admin_member_email() RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS(SELECT * FROM admin INNER JOIN member ON admin.email = member.email) THEN
    RAISE EXCEPTION 'Email must be unique';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER admin_email
  BEFORE INSERT OR UPDATE OF email ON admin
  FOR EACH ROW
    EXECUTE PROCEDURE admin_member_email();

CREATE TRIGGER member_email
  BEFORE INSERT OR UPDATE OF email ON member
  FOR EACH ROW
    EXECUTE PROCEDURE admin_member_email();

-- A question must always have at least 1 topic associated with it
CREATE FUNCTION question_topic() RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS(SELECT * FROM question_topic INNER JOIN question ON question.id = question_topic.question_id) THEN
    RAISE EXCEPTION 'Question must have at least 1 topic associated';
  END IF;
  RETURN OLD;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER question_topic
  BEFORE DELETE ON question_topic
  FOR EACH ROW
    EXECUTE PROCEDURE question_topic();

-- Answers' dates must be consistent
CREATE FUNCTION answer_date() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.date > (SELECT "date" FROM question INNER JOIN answer ON answer.question_id = question.id WHERE answer.id = NEW.id) THEN
    RAISE EXCEPTION 'Answer date must be further than its associated question';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER answer_date
  BEFORE INSERT OR UPDATE OF "date" ON answer
  FOR EACH ROW
    EXECUTE PROCEDURE answer_date();

-- Comment' dates must be consistent
CREATE FUNCTION comment_date() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.question_id IS NULL THEN --Comment is associated to an answer
    IF NEW.date > (SELECT "date" FROM answer INNER JOIN comment ON comment.answer_id = answer.id WHERE comment.id = NEW.id) THEN
      RAISE EXCEPTION 'Comment date must be further than its associated answer';
    END IF;
  END IF;
  IF NEW.answer_id IS NULL THEN --Comment is associated to a question
    IF NEW.date > (SELECT "date" FROM question INNER JOIN comment ON comment.question_id = question.id WHERE comment.id = NEW.id) THEN
      RAISE EXCEPTION 'Comment date must be further than its associated question';
    END IF;
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER comment
  BEFORE INSERT OR UPDATE OF "date" ON comment
  FOR EACH ROW
    EXECUTE PROCEDURE comment_date();

-- Only moderators can flag members
CREATE FUNCTION moderator_flag() RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (SELECT * FROM member INNER JOIN flag ON flag.moderator_id = member.id WHERE member.is_moderator = true AND flag.moderator_id = NEW.moderator_id) THEN
    RAISE EXCEPTION 'Only moderators can flag members';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER moderator_flag
  BEFORE INSERT OR UPDATE OF moderator_id ON flag
  FOR EACH ROW
    EXECUTE PROCEDURE moderator_flag();

-- A user's score is updated when there is new activity from him (posts)
CREATE FUNCTION update_score_post() RETURNS TRIGGER AS $$
BEGIN
  IF TG_TABLE_NAME = 'question' THEN
    IF TG_OP = 'INSERT' THEN
      UPDATE member
      SET nr_questions = nr_questions + 1
      WHERE id = NEW.author_id;
    ELSIF TG_OP = 'DELETE' THEN
      UPDATE member
      SET nr_questions = nr_questions - 1
      WHERE id = OLD.author_id;
    END IF;
  ELSIF TG_TABLE_NAME = 'answer' THEN
    IF TG_OP = 'INSERT' THEN
      UPDATE member
      SET nr_answers = nr_answers + 1
      WHERE id = NEW.author_id;
    ELSIF TG_OP = 'DELETE' THEN
      UPDATE member
      SET nr_answers = nr_answers - 1
      WHERE id = OLD.author_id;
    END IF;
  END IF;

  UPDATE member
  SET score = round((1+positive_votes/(1+total_votes))*(0.4*nr_questions+0.6*nr_answers))
  WHERE id = NEW.author_id;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_score_question
AFTER INSERT OR DELETE ON question
FOR EACH ROW
  EXECUTE PROCEDURE update_score_post();

CREATE TRIGGER update_score_answer
AFTER INSERT OR DELETE ON answer
FOR EACH ROW
  EXECUTE PROCEDURE update_score_post();

-- A member's score is updated when there is activity on his content
CREATE FUNCTION update_score_new_rating() RETURNS TRIGGER AS $$
DECLARE
  user_id int;
BEGIN
  IF TG_TABLE_NAME = 'question_rating' THEN
    user_id = (SELECT question.author_id FROM question_rating INNER JOIN question ON question_rating.question_id = question.id WHERE question_rating.member_id =  NEW.member_id);
  ELSIF TG_TABLE_NAME = 'answer_rating' THEN
    user_id = (SELECT answer.author_id FROM answer_rating INNER JOIN answer ON answer_rating.answer_id = answer.id WHERE answer_rating.member_id = NEW.member_id);
  ELSE
    RAISE EXCEPTION 'Invalid operation triggering score update';
  END IF;
  IF NEW.rate = 1 THEN
    UPDATE member
    SET positive_votes = positive_votes + 1
    WHERE id = user_id;
  END IF;

  UPDATE member
  SET total_votes = total_votes + 1, score = round((1+positive_votes/(1+total_votes))*(0.4*nr_questions+0.6*nr_answers))
  WHERE id = user_id;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_score_new_question_rating
  AFTER INSERT ON question_rating
  FOR EACH ROW
    EXECUTE PROCEDURE update_score_new_rating();

CREATE TRIGGER update_score_new_answer_rating
  AFTER INSERT ON answer_rating
  FOR EACH ROW
    EXECUTE PROCEDURE update_score_new_rating();

CREATE FUNCTION update_score_update_rating() RETURNS TRIGGER AS $$
DECLARE
  user_id int;
BEGIN
  IF TG_TABLE_NAME = 'question_rating' THEN
    user_id = (SELECT question.author_id FROM question_rating INNER JOIN question ON question_rating.question_id = question.id WHERE question_rating.member_id =  NEW.member_id);
  ELSIF TG_TABLE_NAME = 'answer_rating' THEN
    user_id = (SELECT answer.author_id FROM answer_rating INNER JOIN answer ON answer_rating.answer_id = answer.id WHERE answer_rating.member_id = NEW.member_id);
  ELSE
    RAISE EXCEPTION 'Invalid operation triggering score update';
  END IF;

  UPDATE member
  SET positive_votes = positive_votes + NEW.rate, score = round((1+positive_votes/(1+total_votes))*(0.4*nr_questions+0.6*nr_answers))
  WHERE id = user_id;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_score_update_question_rating
  AFTER UPDATE OF rate ON question_rating
  FOR EACH ROW
    EXECUTE PROCEDURE update_score_update_rating();

CREATE TRIGGER update_score_update_answer_rating
  AFTER UPDATE OF rate ON answer_rating
  FOR EACH ROW
    EXECUTE PROCEDURE update_score_update_rating();

CREATE FUNCTION update_score_delete_rating() RETURNS TRIGGER AS $$
DECLARE
  user_id int;
BEGIN
  IF TG_TABLE_NAME = 'question_rating' THEN
    user_id = (SELECT question.author_id FROM question_rating INNER JOIN question ON question_rating.question_id = question.id WHERE question_rating.member_id =  OLD.member_id);
  ELSIF TG_TABLE_NAME = 'answer_rating' THEN
    user_id = (SELECT answer.author_id FROM answer_rating INNER JOIN answer ON answer_rating.answer_id = answer.id WHERE answer_rating.member_id = OLD.member_id);
  ELSE
    RAISE EXCEPTION 'Invalid operation triggering score update';
  END IF;
  IF OLD.rate = 1 THEN
    UPDATE member
    SET positive_votes = positive_votes - 1
    WHERE id = user_id;
  END IF;

  UPDATE member
  SET total_votes = total_votes - 1, score = round((1+positive_votes/(1+total_votes))*(0.4*nr_questions+0.6*nr_answers))
  WHERE id = user_id;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_score_delete_question_rating
  AFTER DELETE ON question_rating
  FOR EACH ROW
    EXECUTE PROCEDURE update_score_delete_rating();

CREATE TRIGGER update_score_delete_answer_rating
  AFTER DELETE ON answer_rating
  FOR EACH ROW
    EXECUTE PROCEDURE update_score_delete_rating();

-- Columns subject to full text search must keep their ts_vectors updated
CREATE FUNCTION question_search_update() RETURNS TRIGGER AS $$
BEGIN
   NEW.search = plainto_tsvector('english', NEW.title);
 RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER question_function
  AFTER INSERT OR UPDATE OF title ON question
  FOR EACH ROW
    EXECUTE PROCEDURE question_search_update();

CREATE FUNCTION answer_search_update() RETURNS TRIGGER AS $$
BEGIN
   NEW.search = plainto_tsvector('english', NEW.content);
 RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER question_function
  AFTER INSERT OR UPDATE OF content ON answer
  FOR EACH ROW
    EXECUTE PROCEDURE answer_search_update();

-- A member is notified when someone else answers his question
CREATE FUNCTION notify_on_answer() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.author_id <> (SELECT question.author_id FROM question INNER JOIN answer ON question.id = answer.question_id WHERE answer.id = NEW.id) THEN --Avoid notification when answering one's own question
    INSERT INTO notification (type, "date", content, member_id) VALUES ('Answer', now(),
      (SELECT name FROM answer INNER JOIN member ON author_id = member.id WHERE answer.id = NEW.id) || ' answered your question: ' || (SELECT title FROM question INNER JOIN answer ON question.id = answer.question_id WHERE answer.id = NEW.id),
      (SELECT member.id FROM question INNER JOIN answer ON question.id = answer.question_id INNER JOIN member ON question.author_id = member.id WHERE answer.id = NEW.id));
  END IF;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_answer
  AFTER INSERT ON answer
  FOR EACH ROW
    EXECUTE PROCEDURE notify_on_answer();

-- A member is notified when someone else comments his question
CREATE FUNCTION notify_on_comment_question() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.author_id <> (SELECT question.author_id FROM question INNER JOIN comment ON question.id = comment.question_id WHERE comment.id = NEW.id) THEN --Avoid notification when answering one's own question
    INSERT INTO notification (type, "date", content, member_id) VALUES ('Comment', now(),
      (SELECT name FROM comment INNER JOIN member ON author_id = member.id WHERE comment.id = NEW.id) || ' left a comment on your question: ' || (SELECT title FROM question INNER JOIN comment ON question.id = comment.question_id WHERE comment.id = NEW.id),
      (SELECT member.id FROM question INNER JOIN comment ON question.id = comment.question_id INNER JOIN member ON question.author_id = member.id WHERE comment.id = NEW.id));
  END IF;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_comment_question
  AFTER INSERT ON answer
  FOR EACH ROW
  WHEN NEW.question_id IS NOT NULL
    EXECUTE PROCEDURE notify_on_comment_question();

-- A member is notified when someone else comments his answer
CREATE FUNCTION notify_on_comment_answer() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.author_id <> (SELECT answer.author_id FROM answer INNER JOIN comment ON answer.id = comment.answer_id WHERE comment.id = NEW.id) THEN --Avoid notification when answering one's own question
    INSERT INTO notification (type, "date", content, member_id) VALUES ('Comment', now(),
      (SELECT name FROM comment INNER JOIN member ON author_id = member.id WHERE comment.id = NEW.id) || ' left a comment on your answer: ' || (SELECT title FROM answer INNER JOIN comment ON answer.id = comment.answer_id WHERE comment.id = NEW.id),
      (SELECT member.id FROM answer INNER JOIN comment ON answer.id = comment.answer_id INNER JOIN member ON answer.author_id = member.id WHERE comment.id = NEW.id));
  END IF;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_comment_answer
  AFTER INSERT ON answer
  FOR EACH ROW
  WHEN NEW.answer_id IS NOT NULL
    EXECUTE PROCEDURE notify_on_comment_answer();
