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
    password VARCHAR(60) NOT NULL,
    remember_token VARCHAR(100),
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
    password VARCHAR(60) NOT NULL,
    remember_token VARCHAR(100),
    name VARCHAR(35),
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
    is_certified BOOLEAN NOT NULL DEFAULT false,
    country_id INTEGER,
    CONSTRAINT member_pk PRIMARY KEY (id),
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
    content text NOT NULL DEFAULT '',
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

-- Triggers
-- User cannot rate his own questions
CREATE FUNCTION member_question_rating() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT member.id FROM question INNER JOIN member ON question.author_id = member.id WHERE question.id = NEW.question_id) THEN
    RAISE EXCEPTION 'A member cannot rate his own questions';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_question_rating
  BEFORE INSERT OR UPDATE OF member_id, question_id ON question_rating
  FOR EACH ROW
    EXECUTE PROCEDURE member_question_rating();

-- User cannot rate his own answers
CREATE FUNCTION member_answer_rating() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT member.id FROM answer INNER JOIN member ON answer.author_id = member.id WHERE answer.id = NEW.answer_id) THEN
    RAISE EXCEPTION 'A member cannot rate his own answers';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_answer_rating
  BEFORE INSERT OR UPDATE OF member_id, answer_id ON answer_rating
  FOR EACH ROW
    EXECUTE PROCEDURE member_answer_rating();

-- User cannot rate his own comments
CREATE FUNCTION member_comment_rating() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT member.id FROM comment INNER JOIN member ON comment.author_id = member.id WHERE comment.id = NEW.comment_id) THEN
    RAISE EXCEPTION 'A member cannot rate his own comments';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_comment_rating
  BEFORE INSERT OR UPDATE OF member_id, comment_id ON comment_rating
  FOR EACH ROW
    EXECUTE PROCEDURE member_comment_rating();

-- User cannot report his own questions
CREATE FUNCTION member_question_report() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT member.id FROM question INNER JOIN member ON question.author_id = member.id WHERE question.id = NEW.question_id) THEN
    RAISE EXCEPTION 'A member cannot report his own questions';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_question_report
  BEFORE INSERT OR UPDATE OF member_id, question_id ON question_report
  FOR EACH ROW
    EXECUTE PROCEDURE member_question_report();

-- User cannot report his own answers
CREATE FUNCTION member_answer_report() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT member.id FROM answer INNER JOIN member ON answer.author_id = member.id WHERE answer.id = NEW.answer_id) THEN
    RAISE EXCEPTION 'A member cannot report his own answers';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_answer_report
  BEFORE INSERT OR UPDATE OF member_id, answer_id ON answer_report
  FOR EACH ROW
    EXECUTE PROCEDURE member_answer_report();

-- User cannot report his own comments
CREATE FUNCTION member_comment_report() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.member_id = (SELECT member.id FROM comment INNER JOIN member ON comment.author_id = member.id WHERE comment.id = NEW.comment_id) THEN
    RAISE EXCEPTION 'A member cannot report his own comments';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER member_comment_report
  BEFORE INSERT OR UPDATE OF member_id, comment_id ON comment_report
  FOR EACH ROW
    EXECUTE PROCEDURE member_comment_report();

--Unique email between admins and members
CREATE FUNCTION admin_member_email() RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS(SELECT email FROM admin WHERE email = NEW.email UNION SELECT email FROM member WHERE email = NEW.email) THEN
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
  IF NOT EXISTS (SELECT question.id FROM question_topic INNER JOIN question ON question.id = question_topic.question_id WHERE question.id = OLD.question_id) THEN
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
  IF NEW.date < (SELECT question.date FROM question INNER JOIN answer ON answer.question_id = question.id WHERE answer.id = NEW.id) THEN
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
    IF NEW.date < (SELECT answer.date FROM answer INNER JOIN comment ON comment.answer_id = answer.id WHERE comment.id = NEW.id) THEN
      RAISE EXCEPTION 'Comment date must be further than its associated answer';
    END IF;
  ELSE --Comment is associated to a question
    IF NEW.date < (SELECT question.date FROM question INNER JOIN comment ON comment.question_id = question.id WHERE comment.id = NEW.id) THEN
      RAISE EXCEPTION 'Comment date must be further than its associated question';
    END IF;
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER comment_date
  BEFORE INSERT OR UPDATE OF "date" ON comment
  FOR EACH ROW
    EXECUTE PROCEDURE comment_date();

-- Only moderators can flag members
CREATE FUNCTION moderator_flag() RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT is_moderator FROM flag INNER JOIN member ON flag.moderator_id = member.id WHERE flag.moderator_id = NEW.moderator_id AND flag.member_id = NEW.member_id) = false THEN
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

  IF TG_OP = 'INSERT' THEN
    UPDATE member
    SET score = round((1+positive_votes/(1+total_votes))*(0.4*nr_questions+0.6*nr_answers))
    WHERE id = NEW.author_id;
    RETURN NEW;
  ELSE
    UPDATE member
    SET score = round((1+positive_votes/(1+total_votes))*(0.4*nr_questions+0.6*nr_answers))
    WHERE id = OLD.author_id;
    RETURN OLD;
  END IF;
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
    user_id = (SELECT question.author_id FROM question WHERE question.id =  NEW.question_id);
  ELSIF TG_TABLE_NAME = 'answer_rating' THEN
    user_id = (SELECT answer.author_id FROM answer WHERE answer.id = NEW.answer_id);
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
    user_id = (SELECT question.author_id FROM question WHERE question.id = NEW.question_id);
  ELSIF TG_TABLE_NAME = 'answer_rating' THEN
    user_id = (SELECT answer.author_id FROM answer WHERE answer.id = NEW.answer_id);
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
    user_id = (SELECT question.author_id FROM question WHERE question.id = OLD.question_id);
  ELSIF TG_TABLE_NAME = 'answer_rating' THEN
    user_id = (SELECT answer.author_id FROM answer WHERE answer.id = OLD.answer_id);
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
   NEW.search = setweight(to_tsvector('english', coalesce(NEW.title,'')), 'A') || setweight(to_tsvector('english', coalesce(NEW.content,'')), 'B');
 RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER question_search_update
  BEFORE INSERT OR UPDATE OF title, content ON question
  FOR EACH ROW
    EXECUTE PROCEDURE question_search_update();

CREATE FUNCTION answer_search_update() RETURNS TRIGGER AS $$
BEGIN
   NEW.search = to_tsvector('english', coalesce(NEW.content,''));
 RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER answer_search_update
  BEFORE INSERT OR UPDATE OF content ON answer
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
  RETURN NEW;
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
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_comment_question
  AFTER INSERT ON comment
  FOR EACH ROW
  WHEN (NEW.question_id IS NOT NULL)
    EXECUTE PROCEDURE notify_on_comment_question();

-- A member is notified when someone else comments his answer
CREATE FUNCTION notify_on_comment_answer() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.author_id <> (SELECT answer.author_id FROM answer INNER JOIN comment ON answer.id = comment.answer_id WHERE comment.id = NEW.id) THEN --Avoid notification when answering one's own question
    INSERT INTO notification (type, "date", content, member_id) VALUES ('Comment', now(),
      (SELECT name FROM comment INNER JOIN member ON author_id = member.id WHERE comment.id = NEW.id) || ' left a comment on your answer to the question ' || (SELECT title FROM answer INNER JOIN comment ON answer.id = comment.answer_id INNER JOIN question ON answer.question_id = question.id WHERE comment.id = NEW.id),
      (SELECT member.id FROM answer INNER JOIN comment ON answer.id = comment.answer_id INNER JOIN member ON answer.author_id = member.id WHERE comment.id = NEW.id));
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_comment_answer
  AFTER INSERT ON comment
  FOR EACH ROW
  WHEN (NEW.answer_id IS NOT NULL)
    EXECUTE PROCEDURE notify_on_comment_answer();

-- A member is notified when someone else upvotes his question
CREATE FUNCTION notify_on_question_rating() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO notification (type, "date", content, member_id) VALUES ('Rating', now(),
    (SELECT name from question_rating INNER JOIN member ON question_rating.member_id = member.id WHERE question_rating.question_id = NEW.question_id AND member.id = NEW.member_id) || ' upvoted your question: ' || (SELECT title FROM question INNER JOIN question_rating ON question_rating.question_id = question.id WHERE question_rating.member_id = NEW.member_id AND question.id = NEW.question_id),
    (SELECT member.id FROM question INNER JOIN member ON question.author_id = member.id WHERE question.id = NEW.question_id));
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_question_rating
  AFTER INSERT ON question_rating
  FOR EACH ROW
  WHEN (NEW.rate = 1)
    EXECUTE PROCEDURE notify_on_question_rating();

-- A member is notified when someone else upvotes his answer
CREATE FUNCTION notify_on_answer_rating() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO notification (type, "date", content, member_id) VALUES ('Rating', now(),
    (SELECT name FROM answer_rating INNER JOIN member ON answer_rating.member_id = member.id WHERE answer_rating.answer_id = NEW.answer_id AND member.id = NEW.member_id) || ' upvoted your answer to the question ' || (SELECT title FROM answer INNER JOIN question ON answer.question_id = question.id WHERE answer.id = NEW.answer_id),
    (SELECT member.id FROM answer INNER JOIN member ON answer.author_id = member.id WHERE answer.id = NEW.answer_id));
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_answer_rating
  AFTER INSERT ON answer_rating
  FOR EACH ROW
  WHEN (NEW.rate = 1)
    EXECUTE PROCEDURE notify_on_answer_rating();

-- A member is notified when someone else follows him
CREATE FUNCTION notify_on_follow() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO notification (type, "date", content, member_id) VALUES ('Follow', now(),
    (SELECT name FROM follow_member INNER JOIN member ON follow_member.follower_id = member.id WHERE follow_member.following_id = NEW.following_id AND member.id = NEW.follower_id) || ' followed you',
    NEW.following_id);
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER notify_on_follow
  AFTER INSERT ON follow_member
  FOR EACH ROW
    EXECUTE PROCEDURE notify_on_follow();

--Indexes
CREATE UNIQUE INDEX idx_topic_name ON topic USING btree (lower(name));
CREATE INDEX idx_question_author_id ON question USING btree (author_id);
CREATE INDEX idx_answer_author_id ON answer USING btree (author_id);
CREATE INDEX idx_answer_question_id ON answer USING btree (question_id);
CREATE INDEX idx_comment_author_id ON comment USING btree (author_id);
CREATE INDEX idx_member_score ON member USING btree (score);
CREATE UNIQUE INDEX idx_member_username ON member USING btree (lower(username));
CREATE INDEX idx_comment_question_id ON comment USING btree (question_id);
CREATE INDEX idx_comment_answer_id ON comment USING btree (answer_id);
CREATE INDEX idx_question_date ON question USING btree ("date");
CREATE INDEX idx_answer_date ON answer USING btree ("date");
CREATE INDEX question_search_index ON question USING GIST (search);
CREATE INDEX answer_search_index ON answer USING GIST (search);

--Populate
INSERT INTO admin (email, password) VALUES ('admin@presto.com', '$2y$10$Akv1cjAsBv8i8MLwJRxJQOe9OSyCygfrjhL89lx9Qf678138cxDh6');

INSERT INTO country (name) VALUES ('Falkland Islands');
INSERT INTO country (name) VALUES ('Nicaragua');
INSERT INTO country (name) VALUES ('Colombia');
INSERT INTO country (name) VALUES ('Austria');
INSERT INTO country (name) VALUES ('Tonga');
INSERT INTO country (name) VALUES ('Lebanon');
INSERT INTO country (name) VALUES ('Sierra Leone');
INSERT INTO country (name) VALUES ('Bouvet Island');
INSERT INTO country (name) VALUES ('Costa Rica');
INSERT INTO country (name) VALUES ('Suriname');
INSERT INTO country (name) VALUES ('Wallis and Futuna');
INSERT INTO country (name) VALUES ('Lesotho');
INSERT INTO country (name) VALUES ('Estonia');
INSERT INTO country (name) VALUES ('Djibouti');
INSERT INTO country (name) VALUES ('New Zealand');

insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('blarby0', 'blarby0@marketwatch.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Brenden Larby', 'Staff Accountant II', 'https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1', false, 11);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('jgaish1', 'jgaish1@tumblr.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Jeffy Gaish', 'Help Desk Operator', 'https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1', false, 8);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('aoxer2', 'aoxer2@free.fr', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Aprilette Oxer', 'Cost Accountant', 'https://robohash.org/etdelenitirerum.png?size=200x200&set=set1', true, 11);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('cmcreath3', 'cmcreath3@instagram.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Cliff McReath', 'Physical Therapy Assistant', 'https://robohash.org/suntquosex.png?size=200x200&set=set1', false, 6);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('aemmett4', 'aemmett4@yahoo.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Alethea Emmett', 'Financial Advisor', 'https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1', false, 11);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('mblonfield5', 'mblonfield5@shareasale.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Marlin Blonfield', 'Desktop Support Technician', 'https://robohash.org/sedquisipsa.png?size=200x200&set=set1', true, 1);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('adono6', 'adono6@woothemes.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Adelheid Dono', 'Civil Engineer', 'https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1', false, 3);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('ecuddy7', 'ecuddy7@cmu.edu', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Emylee Cuddy', 'Desktop Support Technician', 'https://robohash.org/temporedolorquam.png?size=200x200&set=set1', false, 2);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('jzanetello8', 'jzanetello8@howstuffworks.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Jefferson Zanetello', 'Business Systems Development Analyst', 'https://robohash.org/fugiatquisnon.png?size=200x200&set=set1', false, 9);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('rsolesbury9', 'rsolesbury9@reddit.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Rickard Solesbury', 'Research Nurse', 'https://robohash.org/quodatquedicta.png?size=200x200&set=set1', true, 6);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('mburcha', 'mburcha@chron.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Mickie Burch', 'Community Outreach Specialist', 'https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1', true, 5);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('obarthotb', 'obarthotb@sakura.ne.jp', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Oneida Barthot', 'Speech Pathologist', 'https://robohash.org/consequunturestin.png?size=200x200&set=set1', false, 3);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('czolinic', 'czolinic@xinhuanet.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Clarisse Zolini', 'Nuclear Power Engineer', 'https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1', true, 5);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('rmapstoned', 'rmapstoned@biblegateway.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Reynard Mapstone', 'Payment Adjustment Coordinator', 'https://robohash.org/repellatsitet.png?size=200x200&set=set1', true, 12);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('cgoldbye', 'cgoldbye@netscape.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Catherina Goldby', 'Editor', 'https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1', false, 3);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('smussingtonf', 'smussingtonf@topsy.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Sebastiano Mussington', 'Assistant Manager', 'https://robohash.org/etdoloreseaque.png?size=200x200&set=set1', false, 7);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('mroparsg', 'mroparsg@hibu.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Martguerita Ropars', 'Office Assistant II', 'https://robohash.org/etquia.png?size=200x200&set=set1', false, 8);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('llethemh', 'llethemh@goo.gl', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Lilllie Lethem', 'Civil Engineer', 'https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1', false, 4);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('szavattarii', 'szavattarii@yellowpages.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Sonya Zavattari', 'VP Marketing', 'https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1', true, 15);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('aklimmekj', 'aklimmekj@sbwire.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Ambrosius Klimmek', 'Community Outreach Specialist', 'https://robohash.org/minusaliasquasi.png?size=200x200&set=set1', true, 12);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('closebyk', 'closebyk@1und1.de', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Clem Loseby', 'Web Developer I', 'https://robohash.org/quidolorpariatur.png?size=200x200&set=set1', false, 3);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('fbosomworthl', 'kubix20@gmail.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Flem Bosomworth', 'Quality Engineer', 'https://robohash.org/quidemeumsit.png?size=200x200&set=set1', false, 3);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('sromanetm', 'antonioalmeida@gmail.com', '$2y$10$Akv1cjAsBv8i8MLwJRxJQOe9OSyCygfrjhL89lx9Qf678138cxDh6', 'Suzann Romanet', 'VP Accounting', 'https://robohash.org/minimaimpeditest.png?size=200x200&set=set1', false, 2);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('dcollyn', 'cyrilico@gmail.com', '$2y$10$xtVSp5JiSRec9Do8ZWvVcuFnzUx48mP4k70EIPIo160xMD/M8FlXa', 'Daron Colly', 'Operator', 'https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1', false, 6);
insert into member (username, email, password, name, bio, profile_picture, is_moderator, country_id) values ('aalvaradoo', 'diogo.rey@gmail.com', '$2y$10$xtVSp5JiSRec9Do8ZWvVcuFnzUx48mP4k70EIPIo160xMD/M8FlXa', 'Amanda Alvarado', 'Budget/Accounting Analyst IV', 'https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1', true, 8);

insert into flag (member_id, moderator_id, reason, "date") values (24, 25, 'Rude language', '2017-09-01 18:17:33');
insert into flag (member_id, moderator_id, reason, "date") values (2, 25, 'Unecessary vocabulary', '2017-06-26 11:06:11');
insert into flag (member_id, moderator_id, reason, "date") values (21, 25, 'Racist comments', '2017-04-23 09:28:44');
insert into flag (member_id, moderator_id, reason, "date") values (24, 10, 'Constant off topic content', '2017-10-25 15:15:15');
insert into flag (member_id, moderator_id, reason, "date") values (24, 20, 'Slept too much', '2017-08-23 04:05:42');

insert into follow_member (follower_id, following_id) values (12, 24);
insert into follow_member (follower_id, following_id) values (12, 7);
insert into follow_member (follower_id, following_id) values (14, 2);
insert into follow_member (follower_id, following_id) values (24, 5);
insert into follow_member (follower_id, following_id) values (9, 21);
insert into follow_member (follower_id, following_id) values (13, 12);
insert into follow_member (follower_id, following_id) values (19, 13);
insert into follow_member (follower_id, following_id) values (9, 17);
insert into follow_member (follower_id, following_id) values (5, 3);
insert into follow_member (follower_id, following_id) values (18, 11);
insert into follow_member (follower_id, following_id) values (11, 23);
insert into follow_member (follower_id, following_id) values (3, 17);
insert into follow_member (follower_id, following_id) values (11, 4);
insert into follow_member (follower_id, following_id) values (12, 23);
insert into follow_member (follower_id, following_id) values (23, 3);
insert into follow_member (follower_id, following_id) values (16, 2);
insert into follow_member (follower_id, following_id) values (12, 16);
insert into follow_member (follower_id, following_id) values (7, 6);
insert into follow_member (follower_id, following_id) values (18, 22);
insert into follow_member (follower_id, following_id) values (3, 9);
insert into follow_member (follower_id, following_id) values (11, 3);
insert into follow_member (follower_id, following_id) values (4, 18);
insert into follow_member (follower_id, following_id) values (13, 19);
insert into follow_member (follower_id, following_id) values (11, 22);
insert into follow_member (follower_id, following_id) values (21, 7);
insert into follow_member (follower_id, following_id) values (8, 3);
insert into follow_member (follower_id, following_id) values (21, 10);
insert into follow_member (follower_id, following_id) values (15, 22);
insert into follow_member (follower_id, following_id) values (13, 25);
insert into follow_member (follower_id, following_id) values (8, 5);
insert into follow_member (follower_id, following_id) values (7, 25);
insert into follow_member (follower_id, following_id) values (23, 24);
insert into follow_member (follower_id, following_id) values (16, 11);
insert into follow_member (follower_id, following_id) values (2, 11);
insert into follow_member (follower_id, following_id) values (8, 16);
insert into follow_member (follower_id, following_id) values (13, 3);
insert into follow_member (follower_id, following_id) values (6, 21);
insert into follow_member (follower_id, following_id) values (23, 22);
insert into follow_member (follower_id, following_id) values (16, 8);
insert into follow_member (follower_id, following_id) values (20, 4);
insert into follow_member (follower_id, following_id) values (7, 9);
insert into follow_member (follower_id, following_id) values (8, 4);
insert into follow_member (follower_id, following_id) values (6, 12);
insert into follow_member (follower_id, following_id) values (3, 22);
insert into follow_member (follower_id, following_id) values (18, 2);
insert into follow_member (follower_id, following_id) values (9, 12);
insert into follow_member (follower_id, following_id) values (21, 12);
insert into follow_member (follower_id, following_id) values (5, 12);
insert into follow_member (follower_id, following_id) values (10, 25);
insert into follow_member (follower_id, following_id) values (19, 5);
insert into follow_member (follower_id, following_id) values (2, 25);
insert into follow_member (follower_id, following_id) values (5, 1);
insert into follow_member (follower_id, following_id) values (20, 17);
insert into follow_member (follower_id, following_id) values (3, 4);
insert into follow_member (follower_id, following_id) values (25, 3);
insert into follow_member (follower_id, following_id) values (15, 3);
insert into follow_member (follower_id, following_id) values (10, 1);
insert into follow_member (follower_id, following_id) values (11, 13);
insert into follow_member (follower_id, following_id) values (14, 20);
insert into follow_member (follower_id, following_id) values (20, 24);
insert into follow_member (follower_id, following_id) values (14, 16);
insert into follow_member (follower_id, following_id) values (21, 9);
insert into follow_member (follower_id, following_id) values (11, 25);
insert into follow_member (follower_id, following_id) values (16, 14);
insert into follow_member (follower_id, following_id) values (11, 9);
insert into follow_member (follower_id, following_id) values (14, 21);
insert into follow_member (follower_id, following_id) values (2, 1);
insert into follow_member (follower_id, following_id) values (11, 2);
insert into follow_member (follower_id, following_id) values (9, 15);
insert into follow_member (follower_id, following_id) values (11, 17);
insert into follow_member (follower_id, following_id) values (18, 4);
insert into follow_member (follower_id, following_id) values (15, 24);
insert into follow_member (follower_id, following_id) values (14, 8);
insert into follow_member (follower_id, following_id) values (10, 15);
insert into follow_member (follower_id, following_id) values (4, 7);
insert into follow_member (follower_id, following_id) values (17, 14);
insert into follow_member (follower_id, following_id) values (1, 19);
insert into follow_member (follower_id, following_id) values (6, 22);
insert into follow_member (follower_id, following_id) values (6, 8);
insert into follow_member (follower_id, following_id) values (5, 4);
insert into follow_member (follower_id, following_id) values (7, 12);
insert into follow_member (follower_id, following_id) values (8, 18);
insert into follow_member (follower_id, following_id) values (9, 18);
insert into follow_member (follower_id, following_id) values (12, 6);
insert into follow_member (follower_id, following_id) values (2, 9);
insert into follow_member (follower_id, following_id) values (14, 25);
insert into follow_member (follower_id, following_id) values (19, 18);
insert into follow_member (follower_id, following_id) values (10, 14);
insert into follow_member (follower_id, following_id) values (22, 13);
insert into follow_member (follower_id, following_id) values (4, 20);
insert into follow_member (follower_id, following_id) values (12, 14);
insert into follow_member (follower_id, following_id) values (7, 18);
insert into follow_member (follower_id, following_id) values (4, 25);
insert into follow_member (follower_id, following_id) values (22, 16);
insert into follow_member (follower_id, following_id) values (25, 5);
insert into follow_member (follower_id, following_id) values (25, 10);
insert into follow_member (follower_id, following_id) values (23, 6);
insert into follow_member (follower_id, following_id) values (25, 2);
insert into follow_member (follower_id, following_id) values (23, 19);
insert into follow_member (follower_id, following_id) values (6, 25);
insert into follow_member (follower_id, following_id) values (11, 15);
insert into follow_member (follower_id, following_id) values (2, 13);
insert into follow_member (follower_id, following_id) values (20, 9);
insert into follow_member (follower_id, following_id) values (13, 21);
insert into follow_member (follower_id, following_id) values (21, 16);
insert into follow_member (follower_id, following_id) values (17, 4);
insert into follow_member (follower_id, following_id) values (21, 8);
insert into follow_member (follower_id, following_id) values (24, 22);
insert into follow_member (follower_id, following_id) values (24, 7);
insert into follow_member (follower_id, following_id) values (19, 14);
insert into follow_member (follower_id, following_id) values (21, 13);
insert into follow_member (follower_id, following_id) values (12, 3);
insert into follow_member (follower_id, following_id) values (14, 1);
insert into follow_member (follower_id, following_id) values (23, 8);
insert into follow_member (follower_id, following_id) values (20, 19);
insert into follow_member (follower_id, following_id) values (23, 2);
insert into follow_member (follower_id, following_id) values (3, 20);
insert into follow_member (follower_id, following_id) values (6, 4);
insert into follow_member (follower_id, following_id) values (25, 23);
insert into follow_member (follower_id, following_id) values (24, 18);
insert into follow_member (follower_id, following_id) values (15, 1);
insert into follow_member (follower_id, following_id) values (7, 1);
insert into follow_member (follower_id, following_id) values (17, 22);
insert into follow_member (follower_id, following_id) values (23, 15);
insert into follow_member (follower_id, following_id) values (22, 18);
insert into follow_member (follower_id, following_id) values (9, 22);
insert into follow_member (follower_id, following_id) values (3, 8);
insert into follow_member (follower_id, following_id) values (24, 10);
insert into follow_member (follower_id, following_id) values (14, 9);

insert into topic (name) values ('Outdoors');
insert into topic (name) values ('Sports');
insert into topic (name) values ('Computers');
insert into topic (name) values ('Electronics');
insert into topic (name) values ('Tools');
insert into topic (name) values ('Toys');
insert into topic (name) values ('Programming');
insert into topic (name) values ('Industrial');
insert into topic (name) values ('Baby');
insert into topic (name) values ('Books');
insert into topic (name) values ('Jewelery');
insert into topic (name) values ('Movies');
insert into topic (name) values ('Music');
insert into topic (name) values ('College');
insert into topic (name) values ('Education');
insert into topic (name) values ('Home');
insert into topic (name) values ('Children');
insert into topic (name) values ('Garden');
insert into topic (name) values ('Hardware');
insert into topic (name) values ('Grocery');
insert into topic (name) values ('Automotive');
insert into topic (name) values ('Cinema');
insert into topic (name) values ('Life');
insert into topic (name) values ('Scheme');
insert into topic (name) values ('Games');
insert into topic (name) values ('Chores');
insert into topic (name) values ('Kids');
insert into topic (name) values ('Shoes');
insert into topic (name) values ('Shopping');
insert into topic (name) values ('SQL');
insert into topic (name) values ('Java');
insert into topic (name) values ('Databases');
insert into topic (name) values ('RCOM');
insert into topic (name) values ('PC Gaming');
insert into topic (name) values ('Sex');
insert into topic (name) values ('PostgreSQL');
insert into topic (name) values ('Health');
insert into topic (name) values ('SQLite');
insert into topic (name) values ('C++');
insert into topic (name) values ('Home Stuff');
insert into topic (name) values ('Piracy');

insert into follow_topic (topic_id, member_id) values (9, 17);
insert into follow_topic (topic_id, member_id) values (29, 3);
insert into follow_topic (topic_id, member_id) values (8, 20);
insert into follow_topic (topic_id, member_id) values (33, 10);
insert into follow_topic (topic_id, member_id) values (19, 14);
insert into follow_topic (topic_id, member_id) values (37, 8);
insert into follow_topic (topic_id, member_id) values (8, 4);
insert into follow_topic (topic_id, member_id) values (3, 22);
insert into follow_topic (topic_id, member_id) values (38, 3);
insert into follow_topic (topic_id, member_id) values (3, 7);
insert into follow_topic (topic_id, member_id) values (28, 6);
insert into follow_topic (topic_id, member_id) values (36, 9);
insert into follow_topic (topic_id, member_id) values (22, 2);
insert into follow_topic (topic_id, member_id) values (3, 23);
insert into follow_topic (topic_id, member_id) values (1, 24);
insert into follow_topic (topic_id, member_id) values (19, 5);
insert into follow_topic (topic_id, member_id) values (25, 10);
insert into follow_topic (topic_id, member_id) values (34, 12);
insert into follow_topic (topic_id, member_id) values (25, 9);
insert into follow_topic (topic_id, member_id) values (36, 22);
insert into follow_topic (topic_id, member_id) values (28, 10);
insert into follow_topic (topic_id, member_id) values (36, 24);
insert into follow_topic (topic_id, member_id) values (31, 14);
insert into follow_topic (topic_id, member_id) values (16, 12);
insert into follow_topic (topic_id, member_id) values (14, 5);
insert into follow_topic (topic_id, member_id) values (1, 1);
insert into follow_topic (topic_id, member_id) values (11, 23);
insert into follow_topic (topic_id, member_id) values (29, 23);
insert into follow_topic (topic_id, member_id) values (27, 12);
insert into follow_topic (topic_id, member_id) values (28, 12);
insert into follow_topic (topic_id, member_id) values (5, 18);
insert into follow_topic (topic_id, member_id) values (31, 18);
insert into follow_topic (topic_id, member_id) values (11, 21);
insert into follow_topic (topic_id, member_id) values (22, 18);
insert into follow_topic (topic_id, member_id) values (12, 13);
insert into follow_topic (topic_id, member_id) values (10, 20);
insert into follow_topic (topic_id, member_id) values (2, 6);
insert into follow_topic (topic_id, member_id) values (1, 6);
insert into follow_topic (topic_id, member_id) values (9, 2);
insert into follow_topic (topic_id, member_id) values (37, 21);
insert into follow_topic (topic_id, member_id) values (33, 8);
insert into follow_topic (topic_id, member_id) values (27, 16);
insert into follow_topic (topic_id, member_id) values (41, 14);
insert into follow_topic (topic_id, member_id) values (27, 7);
insert into follow_topic (topic_id, member_id) values (17, 24);
insert into follow_topic (topic_id, member_id) values (29, 21);
insert into follow_topic (topic_id, member_id) values (37, 6);
insert into follow_topic (topic_id, member_id) values (7, 15);
insert into follow_topic (topic_id, member_id) values (38, 6);
insert into follow_topic (topic_id, member_id) values (4, 7);

insert into question (title, content, "date", views, author_id) values ('Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-04-19 16:23:48', 50598, 14);
insert into question (title, content, "date", views, author_id) values ('Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2017-04-18 01:39:19', 14837, 3);
insert into question (title, content, "date", views, author_id) values ('Nam nulla?', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2017-04-05 17:37:55', 81757, 23);
insert into question (title, content, "date", views, author_id) values ('Maecenas pulvinar lobortis est?', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2017-04-16 00:11:55', 48667, 20);
insert into question (title, content, "date", views, author_id) values ('Pellentesque eget nunc?', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-04-07 10:15:35', 44880, 24);
insert into question (title, content, "date", views, author_id) values ('Curabitur convallis?', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2017-04-29 15:13:55', 34568, 19);
insert into question (title, content, "date", views, author_id) values ('Aliquam non mauris?', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2017-04-14 08:13:54', 70405, 4);
insert into question (title, content, "date", views, author_id) values ('Proin leo odio, porttitor id, consequat in, consequat ut, nulla?', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-04-07 19:39:23', 7261, 10);
insert into question (title, content, "date", views, author_id) values ('Integer ac neque?', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2017-04-01 02:51:00', 37955, 19);
insert into question (title, content, "date", views, author_id) values ('Curabitur at ipsum ac tellus semper interdum?', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-03-31 22:49:29', 21027, 23);
insert into question (title, content, "date", views, author_id) values ('Fusce posuere felis sed lacus?', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2017-04-12 12:09:52', 11428, 18);
insert into question (title, content, "date", views, author_id) values ('Sed vel enim sit amet nunc viverra dapibus?', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-04-07 18:08:10', 66009, 7);
insert into question (title, content, "date", views, author_id) values ('Vestibulum quam sapien, varius ut, blandit non, interdum in, ante?', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2017-04-23 19:55:22', 68298, 16);
insert into question (title, content, "date", views, author_id) values ('Integer tincidunt ante vel ipsum?', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2017-04-07 13:09:47', 50172, 1);
insert into question (title, content, "date", views, author_id) values ('Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2017-04-20 08:01:23', 57098, 8);
insert into question (title, content, "date", views, author_id) values ('Morbi vel lectus in quam fringilla rhoncus?', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2017-04-20 00:29:42', 30205, 14);
insert into question (title, content, "date", views, author_id) values ('Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa?', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2017-04-26 21:27:43', 30180, 20);
insert into question (title, content, "date", views, author_id) values ('Nulla tellus?', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2017-04-28 03:33:42', 49142, 20);
insert into question (title, content, "date", views, author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2017-04-28 01:56:14', 54059, 21);
insert into question (title, content, "date", views, author_id) values ('Quisque ut erat?', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-04-19 05:51:49', 29456, 11);
insert into question (title, content, "date", views, author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?', 'In congue. Etiam justo. Etiam pretium iaculis justo.', '2017-04-27 16:29:35', 41590, 24);
insert into question (title, content, "date", views, author_id) values ('Fusce posuere felis sed lacus?', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2017-04-14 18:35:09', 76618, 8);
insert into question (title, content, "date", views, author_id) values ('Nunc purus?', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2017-03-30 00:11:46', 41155, 25);
insert into question (title, content, "date", views, author_id) values ('Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-04-04 14:46:51', 70809, 10);
insert into question (title, content, "date", views, author_id) values ('In est risus, auctor sed, tristique in, tempus sit amet, sem?', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', '2017-04-10 04:18:42', 10394, 23);
insert into question (title, content, "date", views, author_id) values ('Maecenas rhoncus aliquam lacus?', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2017-04-18 00:29:19', 23620, 2);
insert into question (title, content, "date", views, author_id) values ('Aenean auctor gravida sem?', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2017-04-09 02:26:27', 67867, 14);
insert into question (title, content, "date", views, author_id) values ('Duis bibendum?', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-04-09 11:11:35', 77269, 5);
insert into question (title, content, "date", views, author_id) values ('Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-03-31 18:30:44', 43702, 17);
insert into question (title, content, "date", views, author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-04-16 00:05:38', 53537, 15);
insert into question (title, content, "date", views, author_id) values ('Praesent blandit?', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2017-04-10 16:59:56', 51795, 21);
insert into question (title, content, "date", views, author_id) values ('Nam dui?', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-04-07 02:54:59', 76661, 8);
insert into question (title, content, "date", views, author_id) values ('Integer tincidunt ante vel ipsum?', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2017-04-14 02:11:09', 58520, 1);
insert into question (title, content, "date", views, author_id) values ('Etiam faucibus cursus urna?', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-04-17 07:29:25', 54273, 23);
insert into question (title, content, "date", views, author_id) values ('Aenean fermentum?', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2017-04-08 07:29:20', 77418, 25);
insert into question (title, content, "date", views, author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus?', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2017-04-14 21:28:37', 17967, 10);
insert into question (title, content, "date", views, author_id) values ('Maecenas tincidunt lacus at velit?', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', '2017-04-12 03:23:09', 75859, 25);
insert into question (title, content, "date", views, author_id) values ('Morbi non lectus?', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2017-04-23 01:57:00', 38757, 19);
insert into question (title, content, "date", views, author_id) values ('Nulla nisl?', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2017-03-30 01:45:05', 14924, 18);
insert into question (title, content, "date", views, author_id) values ('Duis bibendum?', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-04-21 05:33:01', 59618, 11);

insert into answer (content, "date", views, question_id, author_id) values ('In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2017-05-09 13:05:19', 33295, 15, 1);
insert into answer (content, "date", views, question_id, author_id) values ('In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2017-05-04 05:20:21', 55477, 7, 8);
insert into answer (content, "date", views, question_id, author_id) values ('Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2017-05-25 00:16:19', 46955, 1, 3);
insert into answer (content, "date", views, question_id, author_id) values ('Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2017-05-08 15:49:17', 69240, 34, 18);
insert into answer (content, "date", views, question_id, author_id) values ('Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2017-05-20 02:08:21', 65909, 20, 19);
insert into answer (content, "date", views, question_id, author_id) values ('In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2017-05-13 12:41:21', 98505, 11, 19);
insert into answer (content, "date", views, question_id, author_id) values ('Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2017-05-03 06:48:37', 74674, 21, 20);
insert into answer (content, "date", views, question_id, author_id) values ('Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2017-05-22 11:32:39', 32710, 13, 24);
insert into answer (content, "date", views, question_id, author_id) values ('Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2017-05-15 17:01:09', 77060, 3, 24);
insert into answer (content, "date", views, question_id, author_id) values ('Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-05-17 12:18:36', 77946, 13, 10);
insert into answer (content, "date", views, question_id, author_id) values ('Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-05-04 18:34:22', 64024, 15, 7);
insert into answer (content, "date", views, question_id, author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-05-28 04:59:06', 32490, 19, 16);
insert into answer (content, "date", views, question_id, author_id) values ('Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2017-05-17 22:23:40', 23714, 19, 19);
insert into answer (content, "date", views, question_id, author_id) values ('In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2017-05-29 20:40:58', 19366, 8, 13);
insert into answer (content, "date", views, question_id, author_id) values ('Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-05-16 18:05:54', 64332, 23, 2);
insert into answer (content, "date", views, question_id, author_id) values ('Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2017-05-17 14:34:13', 57638, 27, 19);
insert into answer (content, "date", views, question_id, author_id) values ('Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2017-05-20 00:32:47', 31779, 25, 20);
insert into answer (content, "date", views, question_id, author_id) values ('Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2017-05-19 22:22:44', 58016, 29, 8);
insert into answer (content, "date", views, question_id, author_id) values ('In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2017-05-18 22:30:11', 86130, 7, 24);
insert into answer (content, "date", views, question_id, author_id) values ('Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-05-07 06:43:47', 68075, 34, 3);
insert into answer (content, "date", views, question_id, author_id) values ('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2017-05-24 09:51:06', 55480, 6, 5);
insert into answer (content, "date", views, question_id, author_id) values ('Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-05-29 10:38:38', 50188, 18, 7);
insert into answer (content, "date", views, question_id, author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2017-05-07 09:12:24', 64149, 10, 8);
insert into answer (content, "date", views, question_id, author_id) values ('Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-05-23 07:22:51', 55400, 29, 6);
insert into answer (content, "date", views, question_id, author_id) values ('Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-05-01 10:38:44', 72249, 16, 14);
insert into answer (content, "date", views, question_id, author_id) values ('Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2017-05-30 12:26:28', 6043, 31, 10);
insert into answer (content, "date", views, question_id, author_id) values ('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', '2017-05-18 08:42:29', 93503, 33, 17);
insert into answer (content, "date", views, question_id, author_id) values ('Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2017-05-23 19:05:07', 83420, 28, 12);
insert into answer (content, "date", views, question_id, author_id) values ('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2017-05-28 08:47:04', 11373, 11, 4);
insert into answer (content, "date", views, question_id, author_id) values ('Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-05-20 00:12:26', 84053, 23, 4);
insert into answer (content, "date", views, question_id, author_id) values ('In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2017-05-26 14:08:37', 6651, 39, 10);
insert into answer (content, "date", views, question_id, author_id) values ('Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-05-01 18:42:16', 92550, 16, 12);
insert into answer (content, "date", views, question_id, author_id) values ('Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-05-16 03:58:14', 15750, 28, 10);
insert into answer (content, "date", views, question_id, author_id) values ('Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2017-05-12 13:08:35', 91397, 31, 11);
insert into answer (content, "date", views, question_id, author_id) values ('Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2017-05-28 07:38:53', 29462, 27, 9);
insert into answer (content, "date", views, question_id, author_id) values ('Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2017-05-09 02:14:37', 19554, 14, 19);
insert into answer (content, "date", views, question_id, author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2017-05-24 23:43:37', 52118, 31, 18);
insert into answer (content, "date", views, question_id, author_id) values ('Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2017-05-18 12:32:32', 58791, 7, 20);
insert into answer (content, "date", views, question_id, author_id) values ('In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2017-05-18 14:18:59', 54830, 31, 11);
insert into answer (content, "date", views, question_id, author_id) values ('Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2017-05-07 04:13:53', 36780, 18, 25);
insert into answer (content, "date", views, question_id, author_id) values ('Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2017-05-16 22:26:03', 6774, 30, 11);
insert into answer (content, "date", views, question_id, author_id) values ('Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-05-25 07:42:03', 68795, 40, 10);
insert into answer (content, "date", views, question_id, author_id) values ('Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2017-05-11 20:02:00', 76012, 26, 6);
insert into answer (content, "date", views, question_id, author_id) values ('Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-05-13 07:29:24', 24460, 33, 6);
insert into answer (content, "date", views, question_id, author_id) values ('Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2017-05-04 09:46:37', 96600, 11, 21);
insert into answer (content, "date", views, question_id, author_id) values ('Fusce consequat. Nulla nisl. Nunc nisl.', '2017-05-30 08:21:52', 3227, 21, 5);
insert into answer (content, "date", views, question_id, author_id) values ('Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-05-07 12:16:03', 74851, 21, 3);
insert into answer (content, "date", views, question_id, author_id) values ('Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-05-10 13:29:46', 40126, 33, 15);
insert into answer (content, "date", views, question_id, author_id) values ('In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2017-05-14 05:43:54', 84222, 38, 15);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2017-05-30 10:53:25', 4837, 6, 9);
insert into answer (content, "date", views, question_id, author_id) values ('Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-05-25 08:17:44', 40054, 12, 6);
insert into answer (content, "date", views, question_id, author_id) values ('Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2017-05-14 21:40:26', 22715, 40, 22);
insert into answer (content, "date", views, question_id, author_id) values ('Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2017-05-24 23:09:13', 94077, 26, 20);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-05-30 21:06:54', 96956, 8, 24);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2017-05-24 07:28:43', 83735, 28, 15);
insert into answer (content, "date", views, question_id, author_id) values ('In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2017-05-04 07:44:01', 57164, 35, 1);
insert into answer (content, "date", views, question_id, author_id) values ('Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2017-05-14 10:50:20', 36337, 4, 23);
insert into answer (content, "date", views, question_id, author_id) values ('Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', '2017-05-29 11:14:40', 51025, 39, 3);
insert into answer (content, "date", views, question_id, author_id) values ('Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2017-05-01 09:00:27', 72337, 15, 12);
insert into answer (content, "date", views, question_id, author_id) values ('In congue. Etiam justo. Etiam pretium iaculis justo.', '2017-05-22 06:26:38', 1531, 15, 5);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-05-15 01:31:41', 11627, 33, 8);
insert into answer (content, "date", views, question_id, author_id) values ('Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2017-05-20 02:14:14', 79174, 35, 20);
insert into answer (content, "date", views, question_id, author_id) values ('Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2017-05-03 06:18:01', 36931, 2, 20);
insert into answer (content, "date", views, question_id, author_id) values ('Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-05-26 10:33:45', 57668, 14, 9);
insert into answer (content, "date", views, question_id, author_id) values ('Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2017-05-20 02:06:44', 61918, 12, 4);
insert into answer (content, "date", views, question_id, author_id) values ('Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2017-05-05 10:57:42', 69857, 39, 18);
insert into answer (content, "date", views, question_id, author_id) values ('Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2017-05-28 12:59:24', 14088, 14, 25);
insert into answer (content, "date", views, question_id, author_id) values ('Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-05-02 07:52:08', 49641, 1, 11);
insert into answer (content, "date", views, question_id, author_id) values ('Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', '2017-05-18 01:04:05', 20364, 24, 13);
insert into answer (content, "date", views, question_id, author_id) values ('Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2017-05-07 22:38:04', 93326, 24, 4);
insert into answer (content, "date", views, question_id, author_id) values ('Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2017-05-23 19:23:06', 12741, 6, 23);
insert into answer (content, "date", views, question_id, author_id) values ('Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2017-05-27 10:02:49', 97570, 40, 20);
insert into answer (content, "date", views, question_id, author_id) values ('Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2017-05-28 04:43:09', 92454, 9, 11);
insert into answer (content, "date", views, question_id, author_id) values ('Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2017-05-24 03:44:20', 83402, 16, 16);
insert into answer (content, "date", views, question_id, author_id) values ('Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2017-05-08 12:29:24', 67016, 8, 9);
insert into answer (content, "date", views, question_id, author_id) values ('Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-05-16 17:27:42', 45665, 19, 17);
insert into answer (content, "date", views, question_id, author_id) values ('Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2017-05-08 22:09:58', 90905, 40, 22);
insert into answer (content, "date", views, question_id, author_id) values ('Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-05-13 17:31:25', 25754, 21, 25);
insert into answer (content, "date", views, question_id, author_id) values ('Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2017-05-19 08:36:06', 33766, 27, 7);
insert into answer (content, "date", views, question_id, author_id) values ('Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-05-30 22:53:30', 32017, 38, 25);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-05-28 03:17:56', 48021, 1, 21);
insert into answer (content, "date", views, question_id, author_id) values ('In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2017-05-18 05:58:21', 66441, 15, 2);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-05-12 13:23:55', 10241, 22, 9);
insert into answer (content, "date", views, question_id, author_id) values ('Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-05-05 12:16:11', 39547, 39, 17);
insert into answer (content, "date", views, question_id, author_id) values ('Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-05-06 20:19:38', 84415, 32, 23);
insert into answer (content, "date", views, question_id, author_id) values ('Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-05-25 03:26:07', 92974, 19, 23);
insert into answer (content, "date", views, question_id, author_id) values ('Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2017-05-17 19:55:35', 38126, 40, 7);
insert into answer (content, "date", views, question_id, author_id) values ('Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', '2017-05-20 06:07:28', 50859, 25, 13);
insert into answer (content, "date", views, question_id, author_id) values ('In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2017-05-04 07:45:25', 92034, 8, 7);
insert into answer (content, "date", views, question_id, author_id) values ('Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2017-05-04 03:44:43', 98001, 14, 5);
insert into answer (content, "date", views, question_id, author_id) values ('Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2017-05-14 18:38:33', 17628, 26, 25);
insert into answer (content, "date", views, question_id, author_id) values ('Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2017-05-28 02:14:10', 30880, 34, 18);
insert into answer (content, "date", views, question_id, author_id) values ('Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2017-05-11 09:51:17', 6799, 33, 13);
insert into answer (content, "date", views, question_id, author_id) values ('Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2017-05-10 22:59:48', 11481, 29, 12);
insert into answer (content, "date", views, question_id, author_id) values ('Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2017-05-04 09:26:02', 42027, 9, 11);
insert into answer (content, "date", views, question_id, author_id) values ('In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2017-05-20 12:11:43', 7206, 1, 17);
insert into answer (content, "date", views, question_id, author_id) values ('In congue. Etiam justo. Etiam pretium iaculis justo.', '2017-05-28 22:00:28', 64117, 6, 10);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-05-08 16:07:58', 80464, 11, 4);
insert into answer (content, "date", views, question_id, author_id) values ('Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2017-05-03 05:12:46', 29872, 27, 5);
insert into answer (content, "date", views, question_id, author_id) values ('In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2017-05-14 01:05:26', 65053, 30, 2);

insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2017-06-25 20:48:19', 25, null, 11);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-06-26 19:05:02', 2, null, 3);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2017-06-18 11:47:58', 26, null, 4);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi non quam nec dui luctus rutrum.', '2017-06-17 01:32:57', 24, null, 14);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2017-06-29 17:50:57', 29, null, 14);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Integer ac leo. Pellentesque ultrices mattis odio.', '2017-06-23 07:57:49', 12, null, 3);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2017-06-19 18:11:42', 17, null, 21);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2017-06-01 05:45:38', 1, null, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Aliquam sit amet diam in magna bibendum imperdiet.', '2017-06-22 09:52:54', 24, null, 12);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Pellentesque ultrices mattis odio.', '2017-06-08 05:54:13', 20, null, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2017-06-06 00:55:43', 25, null, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Praesent blandit lacinia erat.', '2017-06-17 21:14:51', 1, null, 11);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla tellus. In sagittis dui vel nisl. Duis ac nibh.', '2017-06-29 00:11:48', 1, null, 7);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2017-06-21 17:21:52', 8, null, 18);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2017-06-20 20:00:12', 18, null, 5);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-06-18 09:37:14', 3, null, 10);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-06-01 01:22:43', 33, null, 6);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2017-06-26 11:12:28', 2, null, 15);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nullam varius. Nulla facilisi.', '2017-06-29 01:57:33', 9, null, 14);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi quis tortor id nulla ultrices aliquet.', '2017-06-25 13:34:55', 14, null, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Praesent blandit.', '2017-06-21 00:36:08', 33, null, 18);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-06-10 14:48:42', 39, null, 18);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse ornare consequat lectus.', '2017-06-22 12:16:34', 34, null, 25);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Etiam faucibus cursus urna.', '2017-06-11 21:22:38', 21, null, 5);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2017-06-18 01:51:19', 14, null, 23);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Curabitur in libero ut massa volutpat convallis.', '2017-06-17 18:25:18', 31, null, 8);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2017-06-07 08:49:41', 23, null, 13);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2017-06-03 04:03:54', 40, null, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Curabitur at ipsum ac tellus semper interdum.', '2017-06-15 16:30:12', 37, null, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nunc rhoncus dui vel sem. Sed sagittis.', '2017-06-18 13:55:42', 33, null, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2017-06-25 01:33:20', 4, null, 7);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2017-06-20 23:27:02', 36, null, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2017-06-01 07:29:20', 10, null, 17);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vivamus vestibulum sagittis sapien.', '2017-06-01 20:28:38', 40, null, 5);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2017-06-12 11:52:59', 40, null, 5);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla nisl. Nunc nisl.', '2017-06-03 13:35:10', 33, null, 13);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2017-06-25 15:00:17', 33, null, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nullam porttitor lacus at turpis.', '2017-06-01 03:18:31', 39, null, 3);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Proin interdum mauris non ligula pellentesque ultrices.', '2017-06-24 15:26:17', 25, null, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Aliquam erat volutpat. In congue.', '2017-06-12 09:47:51', 12, null, 23);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Etiam faucibus cursus urna. Ut tellus.', '2017-06-27 11:12:40', 24, null, 3);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vestibulum ac est lacinia nisi venenatis tristique.', '2017-06-15 08:02:52', 35, null, 15);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2017-06-10 04:01:08', 35, null, 17);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2017-06-22 13:33:13', 1, null, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Maecenas pulvinar lobortis est.', '2017-06-05 19:50:35', 24, null, 11);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vivamus tortor.', '2017-06-23 13:31:47', 19, null, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2017-06-05 11:09:30', 27, null, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-06-22 13:15:11', 28, null, 8);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla tempus.', '2017-06-01 12:24:49', 38, null, 8);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2017-06-27 00:34:29', 31, null, 21);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi non lectus.', '2017-06-28 04:54:03', 5, null, 21);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2017-06-14 16:53:29', 26, null, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2017-06-29 17:32:22', 8, null, 3);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2017-06-11 01:43:12', 16, null, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2017-06-12 12:56:55', 38, null, 23);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vestibulum rutrum rutrum neque.', '2017-06-19 22:06:11', null, 19, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2017-06-13 11:56:52', null, 1, 10);
insert into comment (content, "date", question_id, answer_id, author_id) values ('In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2017-06-20 03:40:39', null, 24, 20);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2017-06-14 21:07:03', null, 80, 14);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2017-06-01 00:47:11', null, 14, 22);
insert into comment (content, "date", question_id, answer_id, author_id) values ('In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2017-06-22 09:37:49', null, 27, 7);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '2017-06-03 09:02:10', null, 17, 3);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2017-06-20 16:52:23', null, 25, 16);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2017-06-29 10:12:48', null, 60, 5);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nullam sit amet turpis elementum ligula vehicula consequat.', '2017-06-21 13:13:36', null, 78, 23);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2017-06-08 07:36:50', null, 95, 7);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vivamus tortor.', '2017-06-09 23:21:23', null, 34, 18);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.', '2017-06-23 03:04:00', null, 7, 18);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse accumsan tortor quis turpis.', '2017-06-29 04:56:18', null, 28, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cras in purus eu magna vulputate luctus.', '2017-06-12 09:44:40', null, 94, 4);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nullam varius. Nulla facilisi.', '2017-06-24 02:04:43', null, 33, 22);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Sed ante. Vivamus tortor.', '2017-06-20 07:30:09', null, 18, 12);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2017-06-14 04:41:18', null, 43, 15);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2017-06-20 10:41:37', null, 70, 16);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2017-06-29 20:12:42', null, 76, 18);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2017-06-03 02:26:13', null, 27, 3);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi quis tortor id nulla ultrices aliquet.', '2017-06-12 09:02:35', null, 87, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla nisl.', '2017-06-11 04:34:03', null, 54, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla nisl.', '2017-06-09 06:48:34', null, 42, 20);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Aenean lectus.', '2017-06-18 05:36:41', null, 84, 5);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis ac nibh.', '2017-06-16 13:53:54', null, 20, 7);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2017-06-28 16:00:06', null, 54, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Fusce posuere felis sed lacus.', '2017-06-15 23:22:46', null, 55, 19);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2017-06-21 07:20:11', null, 9, 19);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2017-06-19 23:58:45', null, 78, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Sed accumsan felis.', '2017-06-05 13:25:08', null, 22, 22);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2017-06-15 22:02:50', null, 34, 21);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2017-06-13 02:07:05', null, 11, 7);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-06-09 06:01:26', null, 49, 21);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2017-06-07 07:11:20', null, 15, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Donec posuere metus vitae ipsum. Aliquam non mauris.', '2017-06-26 05:12:21', null, 85, 8);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2017-06-06 21:46:41', null, 89, 6);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-06-10 15:46:13', null, 89, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis consequat dui nec nisi volutpat eleifend.', '2017-06-16 09:19:20', null, 99, 17);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2017-06-22 08:17:06', null, 41, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse potenti. Nullam porttitor lacus at turpis.', '2017-06-09 20:47:15', null, 25, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus.', '2017-06-12 01:08:30', null, 86, 4);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-06-15 01:54:08', null, 40, 20);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Praesent id massa id nisl venenatis lacinia.', '2017-06-12 02:23:52', null, 87, 23);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2017-06-18 23:27:03', null, 80, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2017-06-01 23:46:01', null, 65, 25);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2017-06-01 09:19:41', null, 94, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2017-06-25 11:40:12', null, 79, 25);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2017-06-19 22:46:35', null, 40, 11);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2017-06-14 02:19:31', null, 67, 11);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '2017-06-17 15:52:18', null, 72, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Mauris sit amet eros.', '2017-06-11 05:45:44', null, 83, 16);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nunc nisl.', '2017-06-11 08:32:49', null, 8, 5);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2017-06-22 15:27:15', null, 49, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-06-21 12:19:58', null, 11, 22);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2017-06-04 05:00:04', null, 68, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi quis tortor id nulla ultrices aliquet.', '2017-06-07 10:48:21', null, 68, 10);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2017-06-06 18:37:30', null, 100, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Nam dui.', '2017-06-13 01:41:36', null, 58, 25);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Pellentesque ultrices mattis odio. Donec vitae nisi.', '2017-06-08 17:07:34', null, 42, 22);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', '2017-06-11 04:41:34', null, 13, 24);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2017-06-26 03:43:32', null, 62, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Integer non velit.', '2017-06-08 20:24:44', null, 21, 13);
insert into comment (content, "date", question_id, answer_id, author_id) values ('In eleifend quam a odio.', '2017-06-08 14:45:26', null, 82, 15);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2017-06-21 09:37:36', null, 2, 9);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2017-06-14 07:22:22', null, 78, 23);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2017-06-04 00:03:41', null, 89, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Suspendisse accumsan tortor quis turpis.', '2017-06-02 15:32:47', null, 30, 1);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2017-06-24 10:09:00', null, 72, 17);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2017-06-20 17:08:26', null, 11, 19);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Curabitur in libero ut massa volutpat convallis.', '2017-06-28 05:09:46', null, 70, 25);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-06-27 16:12:54', null, 85, 12);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cras non velit nec nisi vulputate nonummy.', '2017-06-14 04:13:37', null, 46, 2);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2017-06-29 11:27:18', null, 92, 8);
insert into comment (content, "date", question_id, answer_id, author_id) values ('Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2017-06-12 17:47:57', null, 56, 12);

insert into question_topic (question_id, topic_id) values (11, 29);
insert into question_topic (question_id, topic_id) values (6, 26);
insert into question_topic (question_id, topic_id) values (26, 15);
insert into question_topic (question_id, topic_id) values (13, 18);
insert into question_topic (question_id, topic_id) values (29, 23);
insert into question_topic (question_id, topic_id) values (35, 5);
insert into question_topic (question_id, topic_id) values (30, 26);
insert into question_topic (question_id, topic_id) values (22, 26);
insert into question_topic (question_id, topic_id) values (12, 40);
insert into question_topic (question_id, topic_id) values (36, 22);
insert into question_topic (question_id, topic_id) values (8, 20);
insert into question_topic (question_id, topic_id) values (40, 29);
insert into question_topic (question_id, topic_id) values (38, 20);
insert into question_topic (question_id, topic_id) values (11, 21);
insert into question_topic (question_id, topic_id) values (20, 3);
insert into question_topic (question_id, topic_id) values (3, 2);
insert into question_topic (question_id, topic_id) values (24, 22);
insert into question_topic (question_id, topic_id) values (18, 1);
insert into question_topic (question_id, topic_id) values (7, 14);
insert into question_topic (question_id, topic_id) values (29, 27);
insert into question_topic (question_id, topic_id) values (6, 25);
insert into question_topic (question_id, topic_id) values (30, 28);
insert into question_topic (question_id, topic_id) values (4, 9);
insert into question_topic (question_id, topic_id) values (31, 2);
insert into question_topic (question_id, topic_id) values (19, 15);
insert into question_topic (question_id, topic_id) values (7, 16);
insert into question_topic (question_id, topic_id) values (29, 26);
insert into question_topic (question_id, topic_id) values (36, 24);
insert into question_topic (question_id, topic_id) values (27, 12);
insert into question_topic (question_id, topic_id) values (3, 41);
insert into question_topic (question_id, topic_id) values (2, 6);
insert into question_topic (question_id, topic_id) values (17, 8);
insert into question_topic (question_id, topic_id) values (36, 38);
insert into question_topic (question_id, topic_id) values (3, 25);
insert into question_topic (question_id, topic_id) values (40, 6);
insert into question_topic (question_id, topic_id) values (10, 29);
insert into question_topic (question_id, topic_id) values (18, 2);
insert into question_topic (question_id, topic_id) values (15, 16);
insert into question_topic (question_id, topic_id) values (27, 27);
insert into question_topic (question_id, topic_id) values (39, 32);
insert into question_topic (question_id, topic_id) values (29, 29);
insert into question_topic (question_id, topic_id) values (32, 27);
insert into question_topic (question_id, topic_id) values (27, 33);
insert into question_topic (question_id, topic_id) values (23, 16);
insert into question_topic (question_id, topic_id) values (15, 33);
insert into question_topic (question_id, topic_id) values (40, 30);
insert into question_topic (question_id, topic_id) values (12, 27);
insert into question_topic (question_id, topic_id) values (11, 30);
insert into question_topic (question_id, topic_id) values (22, 30);
insert into question_topic (question_id, topic_id) values (11, 19);
insert into question_topic (question_id, topic_id) values (9, 19);
insert into question_topic (question_id, topic_id) values (33, 19);
insert into question_topic (question_id, topic_id) values (28, 29);
insert into question_topic (question_id, topic_id) values (11, 28);
insert into question_topic (question_id, topic_id) values (36, 8);
insert into question_topic (question_id, topic_id) values (36, 1);
insert into question_topic (question_id, topic_id) values (22, 9);
insert into question_topic (question_id, topic_id) values (23, 24);
insert into question_topic (question_id, topic_id) values (24, 40);
insert into question_topic (question_id, topic_id) values (27, 21);
insert into question_topic (question_id, topic_id) values (18, 10);
insert into question_topic (question_id, topic_id) values (13, 16);
insert into question_topic (question_id, topic_id) values (20, 10);
insert into question_topic (question_id, topic_id) values (17, 9);
insert into question_topic (question_id, topic_id) values (32, 20);
insert into question_topic (question_id, topic_id) values (19, 30);
insert into question_topic (question_id, topic_id) values (37, 17);
insert into question_topic (question_id, topic_id) values (9, 21);
insert into question_topic (question_id, topic_id) values (3, 17);
insert into question_topic (question_id, topic_id) values (5, 10);
insert into question_topic (question_id, topic_id) values (26, 25);
insert into question_topic (question_id, topic_id) values (19, 10);
insert into question_topic (question_id, topic_id) values (10, 35);
insert into question_topic (question_id, topic_id) values (11, 9);
insert into question_topic (question_id, topic_id) values (37, 34);
insert into question_topic (question_id, topic_id) values (12, 13);
insert into question_topic (question_id, topic_id) values (40, 38);
insert into question_topic (question_id, topic_id) values (8, 35);
insert into question_topic (question_id, topic_id) values (12, 31);
insert into question_topic (question_id, topic_id) values (20, 41);
insert into question_topic (question_id, topic_id) values (3, 21);
insert into question_topic (question_id, topic_id) values (29, 30);
insert into question_topic (question_id, topic_id) values (33, 30);
insert into question_topic (question_id, topic_id) values (9, 9);
insert into question_topic (question_id, topic_id) values (11, 36);
insert into question_topic (question_id, topic_id) values (3, 1);
insert into question_topic (question_id, topic_id) values (23, 34);
insert into question_topic (question_id, topic_id) values (35, 23);
insert into question_topic (question_id, topic_id) values (29, 35);
insert into question_topic (question_id, topic_id) values (3, 40);
insert into question_topic (question_id, topic_id) values (17, 29);
insert into question_topic (question_id, topic_id) values (22, 22);
insert into question_topic (question_id, topic_id) values (25, 23);
insert into question_topic (question_id, topic_id) values (25, 27);
insert into question_topic (question_id, topic_id) values (9, 16);
insert into question_topic (question_id, topic_id) values (38, 13);
insert into question_topic (question_id, topic_id) values (36, 30);
insert into question_topic (question_id, topic_id) values (26, 7);
insert into question_topic (question_id, topic_id) values (30, 20);

insert into question_rating (question_id, member_id, rate) values (17, 19, 1);
insert into question_rating (question_id, member_id, rate) values (18, 16, -1);
insert into question_rating (question_id, member_id, rate) values (3, 18, -1);
insert into question_rating (question_id, member_id, rate) values (37, 22, 1);
insert into question_rating (question_id, member_id, rate) values (20, 1, 1);
insert into question_rating (question_id, member_id, rate) values (27, 11, -1);
insert into question_rating (question_id, member_id, rate) values (38, 14, -1);
insert into question_rating (question_id, member_id, rate) values (13, 22, 1);
insert into question_rating (question_id, member_id, rate) values (18, 6, 1);
insert into question_rating (question_id, member_id, rate) values (28, 3, 1);
insert into question_rating (question_id, member_id, rate) values (28, 8, -1);
insert into question_rating (question_id, member_id, rate) values (38, 17, 1);
insert into question_rating (question_id, member_id, rate) values (19, 13, -1);
insert into question_rating (question_id, member_id, rate) values (25, 9, -1);
insert into question_rating (question_id, member_id, rate) values (39, 1, -1);
insert into question_rating (question_id, member_id, rate) values (21, 10, -1);
insert into question_rating (question_id, member_id, rate) values (39, 7, -1);
insert into question_rating (question_id, member_id, rate) values (37, 18, -1);
insert into question_rating (question_id, member_id, rate) values (2, 1, -1);
insert into question_rating (question_id, member_id, rate) values (32, 11, -1);
insert into question_rating (question_id, member_id, rate) values (18, 21, 1);
insert into question_rating (question_id, member_id, rate) values (18, 2, 1);
insert into question_rating (question_id, member_id, rate) values (22, 17, -1);
insert into question_rating (question_id, member_id, rate) values (9, 22, 1);
insert into question_rating (question_id, member_id, rate) values (17, 11, 1);
insert into question_rating (question_id, member_id, rate) values (27, 6, 1);
insert into question_rating (question_id, member_id, rate) values (24, 25, 1);
insert into question_rating (question_id, member_id, rate) values (39, 17, 1);
insert into question_rating (question_id, member_id, rate) values (28, 7, -1);
insert into question_rating (question_id, member_id, rate) values (4, 8, 1);
insert into question_rating (question_id, member_id, rate) values (40, 5, 1);
insert into question_rating (question_id, member_id, rate) values (16, 22, 1);
insert into question_rating (question_id, member_id, rate) values (6, 6, -1);
insert into question_rating (question_id, member_id, rate) values (5, 12, 1);
insert into question_rating (question_id, member_id, rate) values (6, 11, 1);
insert into question_rating (question_id, member_id, rate) values (11, 6, 1);
insert into question_rating (question_id, member_id, rate) values (5, 6, 1);
insert into question_rating (question_id, member_id, rate) values (2, 4, -1);
insert into question_rating (question_id, member_id, rate) values (37, 4, -1);
insert into question_rating (question_id, member_id, rate) values (11, 4, 1);
insert into question_rating (question_id, member_id, rate) values (6, 2, -1);
insert into question_rating (question_id, member_id, rate) values (8, 24, -1);
insert into question_rating (question_id, member_id, rate) values (2, 11, 1);

insert into answer_rating (answer_id, member_id, rate) values (22, 17, -1);
insert into answer_rating (answer_id, member_id, rate) values (82, 3, 1);
insert into answer_rating (answer_id, member_id, rate) values (72, 12, -1);
insert into answer_rating (answer_id, member_id, rate) values (53, 9, 1);
insert into answer_rating (answer_id, member_id, rate) values (7, 9, 1);
insert into answer_rating (answer_id, member_id, rate) values (25, 1, 1);
insert into answer_rating (answer_id, member_id, rate) values (45, 15, 1);
insert into answer_rating (answer_id, member_id, rate) values (68, 23, -1);
insert into answer_rating (answer_id, member_id, rate) values (53, 6, 1);
insert into answer_rating (answer_id, member_id, rate) values (10, 21, -1);
insert into answer_rating (answer_id, member_id, rate) values (96, 8, 1);
insert into answer_rating (answer_id, member_id, rate) values (9, 10, 1);
insert into answer_rating (answer_id, member_id, rate) values (32, 3, 1);
insert into answer_rating (answer_id, member_id, rate) values (30, 22, 1);
insert into answer_rating (answer_id, member_id, rate) values (34, 25, -1);
insert into answer_rating (answer_id, member_id, rate) values (95, 22, 1);
insert into answer_rating (answer_id, member_id, rate) values (67, 10, -1);
insert into answer_rating (answer_id, member_id, rate) values (85, 22, -1);
insert into answer_rating (answer_id, member_id, rate) values (52, 8, -1);
insert into answer_rating (answer_id, member_id, rate) values (32, 2, 1);
insert into answer_rating (answer_id, member_id, rate) values (74, 17, 1);
insert into answer_rating (answer_id, member_id, rate) values (63, 22, 1);
insert into answer_rating (answer_id, member_id, rate) values (68, 22, -1);
insert into answer_rating (answer_id, member_id, rate) values (25, 13, -1);
insert into answer_rating (answer_id, member_id, rate) values (35, 3, 1);
insert into answer_rating (answer_id, member_id, rate) values (96, 10, 1);
insert into answer_rating (answer_id, member_id, rate) values (54, 23, 1);
insert into answer_rating (answer_id, member_id, rate) values (79, 6, 1);
insert into answer_rating (answer_id, member_id, rate) values (74, 3, -1);
insert into answer_rating (answer_id, member_id, rate) values (25, 18, -1);
insert into answer_rating (answer_id, member_id, rate) values (50, 19, 1);
insert into answer_rating (answer_id, member_id, rate) values (7, 14, 1);
insert into answer_rating (answer_id, member_id, rate) values (15, 17, 1);
insert into answer_rating (answer_id, member_id, rate) values (53, 3, -1);
insert into answer_rating (answer_id, member_id, rate) values (86, 17, -1);
insert into answer_rating (answer_id, member_id, rate) values (97, 7, 1);
insert into answer_rating (answer_id, member_id, rate) values (28, 10, -1);
insert into answer_rating (answer_id, member_id, rate) values (7, 5, -1);
insert into answer_rating (answer_id, member_id, rate) values (79, 20, -1);
insert into answer_rating (answer_id, member_id, rate) values (20, 6, -1);
insert into answer_rating (answer_id, member_id, rate) values (10, 11, -1);
insert into answer_rating (answer_id, member_id, rate) values (4, 9, -1);
insert into answer_rating (answer_id, member_id, rate) values (46, 7, -1);
insert into answer_rating (answer_id, member_id, rate) values (47, 6, 1);
insert into answer_rating (answer_id, member_id, rate) values (8, 19, -1);
insert into answer_rating (answer_id, member_id, rate) values (6, 5, 1);

insert into comment_rating (comment_id, member_id, rate) values (95, 11, -1);
insert into comment_rating (comment_id, member_id, rate) values (77, 23, 1);
insert into comment_rating (comment_id, member_id, rate) values (10, 16, -1);
insert into comment_rating (comment_id, member_id, rate) values (22, 8, 1);
insert into comment_rating (comment_id, member_id, rate) values (111, 18, 1);
insert into comment_rating (comment_id, member_id, rate) values (117, 7, -1);
insert into comment_rating (comment_id, member_id, rate) values (17, 12, -1);
insert into comment_rating (comment_id, member_id, rate) values (67, 23, 1);
insert into comment_rating (comment_id, member_id, rate) values (115, 8, -1);
insert into comment_rating (comment_id, member_id, rate) values (12, 18, -1);
insert into comment_rating (comment_id, member_id, rate) values (24, 4, 1);
insert into comment_rating (comment_id, member_id, rate) values (119, 11, -1);
insert into comment_rating (comment_id, member_id, rate) values (67, 22, -1);
insert into comment_rating (comment_id, member_id, rate) values (129, 22, -1);
insert into comment_rating (comment_id, member_id, rate) values (46, 5, -1);
insert into comment_rating (comment_id, member_id, rate) values (67, 25, -1);
insert into comment_rating (comment_id, member_id, rate) values (33, 7, 1);
insert into comment_rating (comment_id, member_id, rate) values (5, 23, -1);
insert into comment_rating (comment_id, member_id, rate) values (4, 11, -1);
insert into comment_rating (comment_id, member_id, rate) values (84, 12, 1);
insert into comment_rating (comment_id, member_id, rate) values (74, 23, -1);
insert into comment_rating (comment_id, member_id, rate) values (93, 15, 1);
insert into comment_rating (comment_id, member_id, rate) values (116, 19, -1);
insert into comment_rating (comment_id, member_id, rate) values (117, 14, -1);
insert into comment_rating (comment_id, member_id, rate) values (57, 13, -1);

insert into question_report (question_id, member_id, "date", reason) values (40, 2, '2017-12-27 03:05:35', 'Off context');
insert into question_report (question_id, member_id, "date", reason) values (30, 23, '2018-02-18 22:24:56', 'Offensive language');
insert into answer_report (answer_id, member_id, "date", reason) values (54, 14, '2017-10-22 01:41:43', 'Racist comments');
insert into answer_report (answer_id, member_id, "date", reason) values (100, 19, '2018-03-29 14:15:39', 'Avoids the question entirely');
insert into comment_report (comment_id, member_id, "date", reason) values (96, 12, '2018-03-25 21:08:09', 'Self promoting instead of giving feedback');
insert into comment_report (comment_id, member_id, "date", reason) values (83, 18, '2017-11-16 20:46:32', 'Just a laugh');
