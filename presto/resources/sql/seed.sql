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
DROP TABLE IF EXISTS comment CASCADE;
DROP TABLE IF EXISTS answer CASCADE;
DROP TABLE IF EXISTS question CASCADE;
DROP TABLE IF EXISTS topic CASCADE;
DROP TABLE IF EXISTS member CASCADE;

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
DROP TRIGGER IF EXISTS chosen_answer_on_solve ON answer;
DROP TRIGGER IF EXISTS chosen_answer_on_unsolve ON question;
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

CREATE TABLE admin (
    id SERIAL NOT NULL,
    email VARCHAR(40) NOT NULL,
    password VARCHAR(60) NOT NULL,
    remember_token VARCHAR(100),
    CONSTRAINT admin_pk PRIMARY KEY (id),
    CONSTRAINT admin_uk UNIQUE (email)
);

CREATE TABLE member (
    id SERIAL NOT NULL,
    username text NOT NULL,
    email VARCHAR(40) NOT NULL,
    password VARCHAR(60),
    remember_token VARCHAR(100),
    name VARCHAR(35),
    bio text,
    profile_picture text,
    provider text,
    provider_id text,
    -- redundant data (for better performance on score update)
    positive_votes INTEGER NOT NULL DEFAULT 0,
    total_votes INTEGER NOT NULL DEFAULT 0,
    nr_questions INTEGER NOT NULL DEFAULT 0,
    nr_answers INTEGER NOT NULL DEFAULT 0,
    --
    score INTEGER NOT NULL DEFAULT 0,
    is_banned BOOLEAN NOT NULL DEFAULT false,
    is_moderator BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT member_pk PRIMARY KEY (id),
    CONSTRAINT member_email_uk UNIQUE (email)
);

CREATE TABLE flag (
    id SERIAL NOT NULL,
    member_id INTEGER NOT NULL,
    moderator_id INTEGER NOT NULL,
    "date" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
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
    "date" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    solved BOOLEAN NOT NULL DEFAULT false,
    author_id INTEGER NOT NULL,
    search tsvector NOT NULL,
    CONSTRAINT question_pk PRIMARY KEY (id),
    CONSTRAINT question_fk_member FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE answer (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    question_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    is_chosen_answer BOOLEAN NOT NULL DEFAULT false,
    search tsvector NOT NULL,
    CONSTRAINT answer_pk PRIMARY KEY (id),
    CONSTRAINT answer_member_fk FOREIGN KEY (author_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT answer_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE comment (
    id SERIAL NOT NULL,
    content text NOT NULL,
    "date" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
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
    id SERIAL NOT NULL,
    question_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1),
    deleted_at DATE,
    CONSTRAINT question_rating_pk PRIMARY KEY (question_id, member_id),
    CONSTRAINT question_rating_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT question_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE answer_rating (
    id SERIAL NOT NULL,
    answer_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1),
    deleted_at DATE,
    CONSTRAINT answer_rating_pk PRIMARY KEY (answer_id, member_id),
    CONSTRAINT answer_rating_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT answer_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE comment_rating (
    id SERIAL NOT NULL,
    comment_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    rate INTEGER NOT NULL CHECK (rate = 1 OR rate = -1),
    deleted_at DATE,
    CONSTRAINT comment_rating_pk PRIMARY KEY (comment_id, member_id),
    CONSTRAINT comment_rating_comment_fk FOREIGN KEY (comment_id) REFERENCES comment (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT comment_rating_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE question_report (
    id SERIAL NOT NULL,
    question_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    reason text NOT NULL,
    CONSTRAINT question_report_pk PRIMARY KEY (question_id, member_id),
    CONSTRAINT question_report_question_fk FOREIGN KEY (question_id) REFERENCES question (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT question_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE answer_report (
    id SERIAL NOT NULL,
    answer_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    reason text NOT NULL,
    CONSTRAINT answer_report_pk PRIMARY KEY (answer_id, member_id),
    CONSTRAINT answer_report_answer_fk FOREIGN KEY (answer_id) REFERENCES answer (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT answer_report_member_fk FOREIGN KEY (member_id) REFERENCES member (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE comment_report (
    id SERIAL NOT NULL,
    comment_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    "date" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
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
  NEW.search = to_tsvector('english', coalesce(array_to_string(xpath('//text()', NEW.content::xml), ' ', ' '), ''));
 RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER answer_search_update
  BEFORE INSERT OR UPDATE OF content ON answer
  FOR EACH ROW
    EXECUTE PROCEDURE answer_search_update();

CREATE OR REPLACE FUNCTION verify_chosen_answer() RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT solved FROM question WHERE id = NEW.question_id) <> true THEN --Can't choose a correct answer for unsolved questions
    RAISE EXCEPTION 'Can not choose an answer for an unsolved question!';
  ELSIF (SELECT count(*) FROM answer WHERE is_chosen_answer = true AND question_id = NEW.question_id) > 0 THEN --Question has 1 chosen answer max
    RAISE EXCEPTION 'Question can only have 1 chosen answer';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION delete_chosen_answer_association() RETURNS TRIGGER AS $$
BEGIN
  UPDATE answer SET is_chosen_answer = false WHERE question_id = NEW.id AND is_chosen_answer = true;
  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER chosen_answer_on_solve
  BEFORE INSERT OR UPDATE OF is_chosen_answer ON answer
  FOR EACH ROW
    WHEN (NEW.is_chosen_answer = true)
      EXECUTE PROCEDURE verify_chosen_answer();

CREATE TRIGGER chosen_answer_on_unsolve
  BEFORE UPDATE OF solved ON question
  FOR EACH ROW
    WHEN (NEW.solved = false)
      EXECUTE PROCEDURE delete_chosen_answer_association();

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

insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('blarby0', 'blarby0@marketwatch.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Brenden Larby', 'Staff Accountant II', 'https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('jgaish1', 'jgaish1@tumblr.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Jeffy Gaish', 'Help Desk Operator', 'https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('aoxer2', 'aoxer2@free.fr', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Aprilette Oxer', 'Cost Accountant', 'https://robohash.org/etdelenitirerum.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('cmcreath3', 'cmcreath3@instagram.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Cliff McReath', 'Physical Therapy Assistant', 'https://robohash.org/suntquosex.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('aemmett4', 'aemmett4@yahoo.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Alethea Emmett', 'Financial Advisor', 'https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('mblonfield5', 'mblonfield5@shareasale.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Marlin Blonfield', 'Desktop Support Technician', 'https://robohash.org/sedquisipsa.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('adono6', 'adono6@woothemes.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Adelheid Dono', 'Civil Engineer', 'https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('ecuddy7', 'ecuddy7@cmu.edu', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Emylee Cuddy', 'Desktop Support Technician', 'https://robohash.org/temporedolorquam.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('jzanetello8', 'jzanetello8@howstuffworks.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Jefferson Zanetello', 'Business Systems Development Analyst', 'https://robohash.org/fugiatquisnon.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('rsolesbury9', 'rsolesbury9@reddit.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Rickard Solesbury', 'Research Nurse', 'https://robohash.org/quodatquedicta.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('mburcha', 'mburcha@chron.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Mickie Burch', 'Community Outreach Specialist', 'https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('obarthotb', 'obarthotb@sakura.ne.jp', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Oneida Barthot', 'Speech Pathologist', 'https://robohash.org/consequunturestin.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('czolinic', 'czolinic@xinhuanet.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Clarisse Zolini', 'Nuclear Power Engineer', 'https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('rmapstoned', 'rmapstoned@biblegateway.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Reynard Mapstone', 'Payment Adjustment Coordinator', 'https://robohash.org/repellatsitet.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('cgoldbye', 'cgoldbye@netscape.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Catherina Goldby', 'Editor', 'https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('smussingtonf', 'smussingtonf@topsy.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Sebastiano Mussington', 'Assistant Manager', 'https://robohash.org/etdoloreseaque.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('mroparsg', 'mroparsg@hibu.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Martguerita Ropars', 'Office Assistant II', 'https://robohash.org/etquia.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('llethemh', 'llethemh@goo.gl', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Lilllie Lethem', 'Civil Engineer', 'https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('szavattarii', 'szavattarii@yellowpages.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Sonya Zavattari', 'VP Marketing', 'https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('aklimmekj', 'aklimmekj@sbwire.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Ambrosius Klimmek', 'Community Outreach Specialist', 'https://robohash.org/minusaliasquasi.png?size=200x200&set=set1', true);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('closebyk', 'closebyk@1und1.de', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Clem Loseby', 'Web Developer I', 'https://robohash.org/quidolorpariatur.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('fbosomworthl', 'kubix20@gmail.com', '$2y$10$eOXGvXu9HQX9j8hLAIFKXu6eWVYLwB6zElrBQ3bE0rF/ANu0QqyGu', 'Flem Bosomworth', 'Quality Engineer', 'https://robohash.org/quidemeumsit.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('sromanetm', 'antonioalmeida@gmail.com', '$2y$10$Akv1cjAsBv8i8MLwJRxJQOe9OSyCygfrjhL89lx9Qf678138cxDh6', 'Suzann Romanet', 'VP Accounting', 'https://robohash.org/minimaimpeditest.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('dcollyn', 'cyrilico@gmail.com', '$2y$10$xtVSp5JiSRec9Do8ZWvVcuFnzUx48mP4k70EIPIo160xMD/M8FlXa', 'Daron Colly', 'Operator', 'https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1', false);
insert into member (username, email, password, name, bio, profile_picture, is_moderator) values ('aalvaradoo', 'diogo.rey@gmail.com', '$2y$10$xtVSp5JiSRec9Do8ZWvVcuFnzUx48mP4k70EIPIo160xMD/M8FlXa', 'Amanda Alvarado', 'Budget/Accounting Analyst IV', 'https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1', true);

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

insert into question (title, content, "date", author_id) values ('Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-04-19 16:23:48', 14);
insert into question (title, content, "date", author_id) values ('Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2017-04-18 01:39:19', 3);
insert into question (title, content, "date", author_id) values ('Nam nulla?', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2017-04-05 17:37:55', 23);
insert into question (title, content, "date", author_id) values ('Maecenas pulvinar lobortis est?', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2017-04-16 00:11:55', 20);
insert into question (title, content, "date", author_id) values ('Pellentesque eget nunc?', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-04-07 10:15:35', 24);
insert into question (title, content, "date", author_id) values ('Curabitur convallis?', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2017-04-29 15:13:55', 19);
insert into question (title, content, "date", author_id) values ('Aliquam non mauris?', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2017-04-14 08:13:54', 4);
insert into question (title, content, "date", author_id) values ('Proin leo odio, porttitor id, consequat in, consequat ut, nulla?', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-04-07 19:39:23', 10);
insert into question (title, content, "date", author_id) values ('Integer ac neque?', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2017-04-01 02:51:00', 19);
insert into question (title, content, "date", author_id) values ('Curabitur at ipsum ac tellus semper interdum?', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-03-31 22:49:29', 23);
insert into question (title, content, "date", author_id) values ('Fusce posuere felis sed lacus?', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2017-04-12 12:09:52', 18);
insert into question (title, content, "date", author_id) values ('Sed vel enim sit amet nunc viverra dapibus?', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-04-07 18:08:10', 7);
insert into question (title, content, "date", author_id) values ('Vestibulum quam sapien, varius ut, blandit non, interdum in, ante?', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2017-04-23 19:55:22', 16);
insert into question (title, content, "date", author_id) values ('Integer tincidunt ante vel ipsum?', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2017-04-07 13:09:47', 1);
insert into question (title, content, "date", author_id) values ('Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2017-04-20 08:01:23', 8);
insert into question (title, content, "date", author_id) values ('Morbi vel lectus in quam fringilla rhoncus?', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2017-04-20 00:29:42', 14);
insert into question (title, content, "date", author_id) values ('Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa?', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2017-04-26 21:27:43', 20);
insert into question (title, content, "date", author_id) values ('Nulla tellus?', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2017-04-28 03:33:42', 20);
insert into question (title, content, "date", author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2017-04-28 01:56:14', 21);
insert into question (title, content, "date", author_id) values ('Quisque ut erat?', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-04-19 05:51:49', 11);
insert into question (title, content, "date", author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?', 'In congue. Etiam justo. Etiam pretium iaculis justo.', '2017-04-27 16:29:35', 24);
insert into question (title, content, "date", author_id) values ('Fusce posuere felis sed lacus?', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2017-04-14 18:35:09', 8);
insert into question (title, content, "date", author_id) values ('Nunc purus?', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2017-03-30 00:11:46', 25);
insert into question (title, content, "date", author_id) values ('Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-04-04 14:46:51', 10);
insert into question (title, content, "date", author_id) values ('In est risus, auctor sed, tristique in, tempus sit amet, sem?', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', '2017-04-10 04:18:42', 23);
insert into question (title, content, "date", author_id) values ('Maecenas rhoncus aliquam lacus?', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2017-04-18 00:29:19', 2);
insert into question (title, content, "date", author_id) values ('Aenean auctor gravida sem?', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2017-04-09 02:26:27', 14);
insert into question (title, content, "date", author_id) values ('Duis bibendum?', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2017-04-09 11:11:35', 5);
insert into question (title, content, "date", author_id) values ('Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-03-31 18:30:44', 17);
insert into question (title, content, "date", author_id) values ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-04-16 00:05:38', 15);
insert into question (title, content, "date", author_id) values ('Praesent blandit?', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2017-04-10 16:59:56', 21);
insert into question (title, content, "date", author_id) values ('Nam dui?', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-04-07 02:54:59', 8);
insert into question (title, content, "date", author_id) values ('Integer tincidunt ante vel ipsum?', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2017-04-14 02:11:09', 1);
insert into question (title, content, "date", author_id) values ('Etiam faucibus cursus urna?', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-04-17 07:29:25', 23);
insert into question (title, content, "date", author_id) values ('Aenean fermentum?', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2017-04-08 07:29:20', 25);
insert into question (title, content, "date", author_id) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus?', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2017-04-14 21:28:37', 10);
insert into question (title, content, "date", author_id) values ('Maecenas tincidunt lacus at velit?', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', '2017-04-12 03:23:09', 25);
insert into question (title, content, "date", author_id) values ('Morbi non lectus?', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2017-04-23 01:57:00', 19);
insert into question (title, content, "date", author_id) values ('Nulla nisl?', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2017-03-30 01:45:05', 18);
insert into question (title, content, "date", author_id) values ('Duis bibendum?', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2017-04-21 05:33:01', 11);

insert into answer (content, "date", question_id, author_id) values ('<span>In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.</span>', '2017-05-09 13:05:19', 15, 1);
insert into answer (content, "date", question_id, author_id) values ('<span>In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.</span>', '2017-05-04 05:20:21', 7, 8);
insert into answer (content, "date", question_id, author_id) values ('<span>Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.</span>', '2017-05-25 00:16:19', 1, 3);
insert into answer (content, "date", question_id, author_id) values ('<span>Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.</span>', '2017-05-08 15:49:17', 34, 18);
insert into answer (content, "date", question_id, author_id) values ('<span>Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</span>', '2017-05-20 02:08:21', 20, 19);
insert into answer (content, "date", question_id, author_id) values ('<span>In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.</span>', '2017-05-13 12:41:21', 11, 19);
insert into answer (content, "date", question_id, author_id) values ('<span>Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.</span>', '2017-05-03 06:48:37', 21, 20);
insert into answer (content, "date", question_id, author_id) values ('<span>Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.</span>', '2017-05-22 11:32:39', 13, 24);
insert into answer (content, "date", question_id, author_id) values ('<span>Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.</span>', '2017-05-15 17:01:09', 3, 24);
insert into answer (content, "date", question_id, author_id) values ('<span>Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.</span>', '2017-05-17 12:18:36', 13, 10);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.</span>', '2017-05-04 18:34:22', 15, 7);
insert into answer (content, "date", question_id, author_id) values ('<span>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.</span>', '2017-05-28 04:59:06', 19, 16);
insert into answer (content, "date", question_id, author_id) values ('<span>Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.</span>', '2017-05-17 22:23:40', 19, 19);
insert into answer (content, "date", question_id, author_id) values ('<span>In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.</span>', '2017-05-29 20:40:58', 8, 13);
insert into answer (content, "date", question_id, author_id) values ('<span>Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.</span>', '2017-05-16 18:05:54', 23, 2);
insert into answer (content, "date", question_id, author_id) values ('<span>Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.</span>', '2017-05-17 14:34:13', 27, 19);
insert into answer (content, "date", question_id, author_id) values ('<span>Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.</span>', '2017-05-20 00:32:47', 25, 20);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.</span>', '2017-05-19 22:22:44', 29, 8);
insert into answer (content, "date", question_id, author_id) values ('<span>In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.</span>', '2017-05-18 22:30:11', 7, 24);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.</span>', '2017-05-07 06:43:47', 34, 3);
insert into answer (content, "date", question_id, author_id) values ('<span>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.</span>', '2017-05-24 09:51:06', 6, 5);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.</span>', '2017-05-29 10:38:38', 18, 7);
insert into answer (content, "date", question_id, author_id) values ('<span>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</span>', '2017-05-07 09:12:24', 10, 8);
insert into answer (content, "date", question_id, author_id) values ('<span>Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.</span>', '2017-05-23 07:22:51', 29, 6);
insert into answer (content, "date", question_id, author_id) values ('<span>Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.</span>', '2017-05-01 10:38:44', 16, 14);
insert into answer (content, "date", question_id, author_id) values ('<span>Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.</span>', '2017-05-30 12:26:28', 31, 10);
insert into answer (content, "date", question_id, author_id) values ('<span>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.</span>', '2017-05-18 08:42:29', 33, 17);
insert into answer (content, "date", question_id, author_id) values ('<span>Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.</span>', '2017-05-23 19:05:07', 28, 12);
insert into answer (content, "date", question_id, author_id) values ('<span>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.</span>', '2017-05-28 08:47:04', 11, 4);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.</span>', '2017-05-20 00:12:26', 23, 4);
insert into answer (content, "date", question_id, author_id) values ('<span>In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.</span>', '2017-05-26 14:08:37', 39, 10);
insert into answer (content, "date", question_id, author_id) values ('<span>Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.</span>', '2017-05-01 18:42:16', 16, 12);
insert into answer (content, "date", question_id, author_id) values ('<span>Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.</span>', '2017-05-16 03:58:14', 28, 10);
insert into answer (content, "date", question_id, author_id) values ('<span>Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.</span>', '2017-05-12 13:08:35', 31, 11);
insert into answer (content, "date", question_id, author_id) values ('<span>Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.</span>', '2017-05-28 07:38:53', 27, 9);
insert into answer (content, "date", question_id, author_id) values ('<span>Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.</span>', '2017-05-09 02:14:37', 14, 19);
insert into answer (content, "date", question_id, author_id) values ('<span>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.</span>', '2017-05-24 23:43:37', 31, 18);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.</span>', '2017-05-18 12:32:32', 7, 20);
insert into answer (content, "date", question_id, author_id) values ('<span>In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.</span>', '2017-05-18 14:18:59', 31, 11);
insert into answer (content, "date", question_id, author_id) values ('<span>Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.</span>', '2017-05-07 04:13:53', 18, 25);
insert into answer (content, "date", question_id, author_id) values ('<span>Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.</span>', '2017-05-16 22:26:03', 30, 11);
insert into answer (content, "date", question_id, author_id) values ('<span>Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.</span>', '2017-05-25 07:42:03', 40, 10);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.</span>', '2017-05-11 20:02:00', 26, 6);
insert into answer (content, "date", question_id, author_id) values ('<span>Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.</span>', '2017-05-13 07:29:24', 33, 6);
insert into answer (content, "date", question_id, author_id) values ('<span>Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.</span>', '2017-05-04 09:46:37', 11, 21);
insert into answer (content, "date", question_id, author_id) values ('<span>Fusce consequat. Nulla nisl. Nunc nisl.</span>', '2017-05-30 08:21:52', 21, 5);
insert into answer (content, "date", question_id, author_id) values ('<span>Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.</span>', '2017-05-07 12:16:03', 21, 3);
insert into answer (content, "date", question_id, author_id) values ('<span>Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.</span>', '2017-05-10 13:29:46', 33, 15);
insert into answer (content, "date", question_id, author_id) values ('<span>In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.</span>', '2017-05-14 05:43:54', 38, 15);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus in felis. Donec semper sapien a libero. Nam dui.</span>', '2017-05-30 10:53:25', 6, 9);
insert into answer (content, "date", question_id, author_id) values ('<span>Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.</span>', '2017-05-25 08:17:44', 12, 6);
insert into answer (content, "date", question_id, author_id) values ('<span>Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.</span>', '2017-05-14 21:40:26', 40, 22);
insert into answer (content, "date", question_id, author_id) values ('<span>Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.</span>', '2017-05-24 23:09:13', 26, 20);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.</span>', '2017-05-30 21:06:54', 8, 24);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.</span>', '2017-05-24 07:28:43', 28, 15);
insert into answer (content, "date", question_id, author_id) values ('<span>In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.</span>', '2017-05-04 07:44:01', 35, 1);
insert into answer (content, "date", question_id, author_id) values ('<span>Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.</span>', '2017-05-14 10:50:20', 4, 23);
insert into answer (content, "date", question_id, author_id) values ('<span>Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.</span>', '2017-05-29 11:14:40', 39, 3);
insert into answer (content, "date", question_id, author_id) values ('<span>Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.</span>', '2017-05-01 09:00:27', 15, 12);
insert into answer (content, "date", question_id, author_id) values ('<span>In congue. Etiam justo. Etiam pretium iaculis justo.</span>', '2017-05-22 06:26:38', 15, 5);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.</span>', '2017-05-15 01:31:41', 33, 8);
insert into answer (content, "date", question_id, author_id) values ('<span>Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.</span>', '2017-05-20 02:14:14', 35, 20);
insert into answer (content, "date", question_id, author_id) values ('<span>Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.</span>', '2017-05-03 06:18:01', 2, 20);
insert into answer (content, "date", question_id, author_id) values ('<span>Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.</span>', '2017-05-26 10:33:45', 14, 9);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.</span>', '2017-05-20 02:06:44', 12, 4);
insert into answer (content, "date", question_id, author_id) values ('<span>Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.</span>', '2017-05-05 10:57:42', 39, 18);
insert into answer (content, "date", question_id, author_id) values ('<span>Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.</span>', '2017-05-28 12:59:24', 14, 25);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.</span>', '2017-05-02 07:52:08', 1, 11);
insert into answer (content, "date", question_id, author_id) values ('<span>Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.</span>', '2017-05-18 01:04:05', 24, 13);
insert into answer (content, "date", question_id, author_id) values ('<span>Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.</span>', '2017-05-07 22:38:04', 24, 4);
insert into answer (content, "date", question_id, author_id) values ('<span>Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.</span>', '2017-05-23 19:23:06', 6, 23);
insert into answer (content, "date", question_id, author_id) values ('<span>Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.</span>', '2017-05-27 10:02:49', 40, 20);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.</span>', '2017-05-28 04:43:09', 9, 11);
insert into answer (content, "date", question_id, author_id) values ('<span>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.</span>', '2017-05-24 03:44:20', 16, 16);
insert into answer (content, "date", question_id, author_id) values ('<span>Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.</span>', '2017-05-08 12:29:24', 8, 9);
insert into answer (content, "date", question_id, author_id) values ('<span>Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.</span>', '2017-05-16 17:27:42', 19, 17);
insert into answer (content, "date", question_id, author_id) values ('<span>Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.</span>', '2017-05-08 22:09:58', 40, 22);
insert into answer (content, "date", question_id, author_id) values ('<span>Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.</span>', '2017-05-13 17:31:25', 21, 25);
insert into answer (content, "date", question_id, author_id) values ('<span>Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.</span>', '2017-05-19 08:36:06', 27, 7);
insert into answer (content, "date", question_id, author_id) values ('<span>Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.</span>', '2017-05-30 22:53:30', 38, 25);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.</span>', '2017-05-28 03:17:56', 1, 21);
insert into answer (content, "date", question_id, author_id) values ('<span>In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.</span>', '2017-05-18 05:58:21', 15, 2);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.</span>', '2017-05-12 13:23:55', 22, 9);
insert into answer (content, "date", question_id, author_id) values ('<span>Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.</span>', '2017-05-05 12:16:11', 39, 17);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.</span>', '2017-05-06 20:19:38', 32, 23);
insert into answer (content, "date", question_id, author_id) values ('<span>Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.</span>', '2017-05-25 03:26:07', 19, 23);
insert into answer (content, "date", question_id, author_id) values ('<span>Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.</span>', '2017-05-17 19:55:35', 40, 7);
insert into answer (content, "date", question_id, author_id) values ('<span>Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.</span>', '2017-05-20 06:07:28', 25, 13);
insert into answer (content, "date", question_id, author_id) values ('<span>In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.</span>', '2017-05-04 07:45:25', 8, 7);
insert into answer (content, "date", question_id, author_id) values ('<span>Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.</span>', '2017-05-04 03:44:43', 14, 5);
insert into answer (content, "date", question_id, author_id) values ('<span>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.</span>', '2017-05-14 18:38:33', 26, 25);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.</span>', '2017-05-28 02:14:10', 34, 18);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.</span>', '2017-05-11 09:51:17', 33, 13);
insert into answer (content, "date", question_id, author_id) values ('<span>Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.</span>', '2017-05-10 22:59:48', 29, 12);
insert into answer (content, "date", question_id, author_id) values ('<span>Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.</span>', '2017-05-04 09:26:02', 9, 11);
insert into answer (content, "date", question_id, author_id) values ('<span>In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.</span>', '2017-05-20 12:11:43', 1, 17);
insert into answer (content, "date", question_id, author_id) values ('<span>In congue. Etiam justo. Etiam pretium iaculis justo.</span>', '2017-05-28 22:00:28', 6, 10);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.</span>', '2017-05-08 16:07:58', 11, 4);
insert into answer (content, "date", question_id, author_id) values ('<span>Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.</span>', '2017-05-03 05:12:46', 27, 5);
insert into answer (content, "date", question_id, author_id) values ('<span>In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.</span>', '2017-05-14 01:05:26', 30, 2);

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

INSERT INTO notifications VALUES ('57f74719-9357-4831-aec2-4c755a85abbf', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5d1b1da5-de93-45bb-a93c-9765e18f2db6', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9ea0fe39-8d99-436e-894c-f6df379c2f6f', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7e4fe5b4-9471-4f7d-8a21-adad421fa762', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8654c18c-a89e-47b7-978f-39244c7101e8', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4f0355f9-ee7d-4bd5-8b2c-c7928172f942', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('16584cbf-9f57-4563-a9dc-eaddb2926819', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9af85490-4848-4564-8b82-c1a60e451df5', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5cefd2b2-2b6d-4e16-92c7-eead153e90b7', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a482a91a-87e0-4252-927e-37d9d312cf8a', 'App\Notifications\MemberFollowed', 11, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8dfd3905-a65e-4da3-9478-1ae3c7104fc9', 'App\Notifications\MemberFollowed', 23, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('296b770b-4892-427f-bed8-143940ed32d1', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b18e19cb-f5ae-48a8-92e4-5863881037e6', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('27aab725-9f35-493c-95ba-e5056e77687e', 'App\Notifications\MemberFollowed', 23, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8eb13ee7-7025-45ee-bb35-7e7fb7d750f8', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8f0dcf1b-e002-4826-80de-9c4e248bf2ac', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('51ad37ff-7bf0-4a3a-b508-cf8c11eec51e', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('70e5e62b-0236-463f-a933-19be95e54539', 'App\Notifications\MemberFollowed', 6, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0cd0436b-4f24-49aa-ba83-ecdffb60ad37', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3d249660-12c2-4747-97ef-4d412cc69b7c', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5cb7f4d0-a609-4451-809d-9afc3131bcfd', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('dbc772f9-8c8f-49a7-818d-47edc77212b0', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('daab54f5-f29b-42fa-a017-cc0f045c84eb', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('867f2476-3360-47ed-9676-78d724acb056', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('212e18b8-14ba-47f5-8ab7-496eef43e23d', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c93591d3-5aeb-4723-b99e-7c05cfe4283b', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('832b2448-bb3b-4dfe-819c-bc5f2c668be6', 'App\Notifications\MemberFollowed', 10, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('faca4ab4-b573-4224-881d-34e40fc9f58b', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('162cda5a-bcd5-4057-8c8b-11d0583c400c', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('81d985dc-7c78-4372-a684-00c64fdc37d6', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5a4baa6d-9719-4b79-bf29-22a4c0ef5464', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8cc18af7-5171-43fc-8239-7b7aa4773cd9', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0ab2ad84-fe3f-4f90-85a5-78c1fbeb2cf3', 'App\Notifications\MemberFollowed', 11, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d84d3e83-9eaa-4229-a3b6-006f3b96a9ee', 'App\Notifications\MemberFollowed', 11, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('06b8e31f-ee19-4f9f-8eae-6d2ac22bd7f0', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9e7aae22-8cbd-4947-a9f0-8e2a52436495', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2186719b-3d02-4074-ab06-67c9e7e6663e', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e56f5a4d-2c2b-45ac-a59f-416c6f0100cc', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7b72e999-f73c-4ab7-8a6d-670efac1e110', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b3ec4d01-5b77-4618-93ea-df7f6077a7c5', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fb054574-6187-455e-8883-de04197507ad', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('26d349a7-ac43-4341-99e8-710ff32084a8', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('677435c6-ac60-4db9-8a53-c082a57cf26c', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5264f246-5154-4877-8b3a-0cda277d4f67', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bbd822ba-80fd-41ed-a41d-45605213e8e3', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a9a545ba-ebfb-4d45-a9ab-3d882bc3c56e', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3363ac72-1d0f-45e1-8b52-8e5630f26d62', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('555cbc87-85d2-49a8-89d1-bae3305ef2a3', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6753daaf-66f6-4451-8101-32489a540e3a', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('435f3b95-d744-4815-9095-e6bf3ae798d3', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('cb0d4b26-8743-4358-977e-2b5f177592d9', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('648637f7-9669-44dd-8ff8-1fa25916bde6', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1691ad16-b7f1-4548-805b-0e1cea37c2cc', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4dd8d835-cf51-4768-9248-8e82b3883a06', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('718e265b-8210-4a89-b330-961d8e764be5', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e0c4bf70-9c17-4b45-a913-b0cb2986e937', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('14735a68-a8f6-439c-94fb-e5b7c46195e6', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('954ac6fe-e8fc-4515-aa93-53c51b152bc9', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d117fae4-e1b2-4744-beb1-1979afe713f0', 'App\Notifications\MemberFollowed', 20, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('06e4beb1-6c93-43f2-ad91-68f57eac6a64', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('98ac0b3e-1c73-4b20-b230-89324a76f507', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6a60fd07-2413-45f6-b492-37c1df25a32a', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('cd59ad80-4aa0-4f04-af0a-c0eaec1f2b97', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('51104514-2c8b-4f1a-a170-0d51730211ab', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2ef28aee-d624-410a-8cf9-77703deb9574', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9f81207b-2023-4836-a155-40cabb6ed08c', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b4e33989-a00b-4c21-a2e7-1af6b4c5d37d', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e694e0c0-6b1a-43c9-911f-f5a3ff92c634', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5385fdf4-9f1e-49d4-9a49-58fc026559fd', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f76c990b-98fa-4a1d-8f4e-1c7c745bdcae', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6cadd7df-325e-4034-aef2-887702e6fa17', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d55ec7c1-44e8-4dad-a99b-632ca16ab4e3', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b97a9767-763d-4bf9-9f97-c1b094bfbaac', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c0c2ac00-0ac6-4163-a4e7-b2062aaff7e0', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('41b28c52-e8c2-4171-bffe-7532ba418f7b', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c8f21d68-e99d-4f69-9716-f5c70123dbab', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 17, "follower_name" : "Martguerita Ropars", "follower_username" : "mroparsg", "follower_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "url" : "profile/mroparsg"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f3009273-bcf9-4eed-9bd9-180e3e34cef2', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 1, "follower_name" : "Brenden Larby", "follower_username" : "blarby0", "follower_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "url" : "profile/blarby0"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a92b74c3-5030-4f18-960a-d350111eadcb', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('76d59969-d361-445e-b2fd-2d3a63554a9b', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('66b702c2-a6a4-4466-8189-04a314a41618', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d501988d-1d87-4a4b-b5ed-3e441c3d645f', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('aab92c7f-4197-4dcb-8cf5-8200c05a0459', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fdaeeafd-c9f1-4749-8509-b357bd681ca6', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5e82daf6-8e7c-4eff-9882-69f0476672df', 'App\Notifications\MemberFollowed', 6, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d6e5a357-0343-473c-b584-3852c150c324', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f8000cad-e055-430d-8208-ab7ba9befff2', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9ad8e63d-6711-4018-96d7-aef3901d80e8', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c5e6ec07-5ed7-4cae-b908-5c980ec7498c', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bb1a7e0a-249d-47b9-a2b7-03053d0503a7', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 22, "follower_name" : "Flem Bosomworth", "follower_username" : "fbosomworthl", "follower_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "url" : "profile/fbosomworthl"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b24d39f0-3ca3-4418-8436-c1b2d4d52f4b', 'App\Notifications\MemberFollowed', 20, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7e72fbbc-cfc3-4ee9-8e49-e84a8b3b4ca7', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6b439d86-0031-49ab-99b3-fda61757a0ab', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7e42c2db-67fa-4913-9fed-3227a3c0602f', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b7d2f036-def7-4e8d-9d35-63d58363c862', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 22, "follower_name" : "Flem Bosomworth", "follower_username" : "fbosomworthl", "follower_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "url" : "profile/fbosomworthl"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b3968fc2-fc55-4378-8540-48a77c150308', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('84c96a14-4e23-4e99-82cd-d43a681f5827', 'App\Notifications\MemberFollowed', 10, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2fa64beb-0e36-4387-bdcc-ea6ed515dadc', 'App\Notifications\MemberFollowed', 6, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e1c3ee2a-a280-4f57-be58-46a0473bb65e', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f406f480-6122-456f-9bde-fe0663f4fff3', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e19f1290-8145-4679-8acc-ecd8ffec7800', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d6d0c6bd-eb6a-426e-87bb-09d9d8cacc1c', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d63125cc-07c5-4f89-8662-8a64cd20ad75', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5d5694ff-d2a1-4c59-9597-9a41d04b260c', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f64ce0b4-f324-4246-acdf-fcbb8a52a63d', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f72ca6d9-553c-4685-a20e-f6ede9b2237b', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1c4ad566-bd34-45d2-9e62-d3355d3c26e0', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 17, "follower_name" : "Martguerita Ropars", "follower_username" : "mroparsg", "follower_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "url" : "profile/mroparsg"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('83fc172c-25f4-489a-ac0f-9987505f2ca2', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a37b1c1f-417d-4ad0-9f23-f478b5637680', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('eff16bd6-ecd8-4978-b1dd-b4230fcb6261', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('189b3c38-5b76-4a15-b7d5-6cbea730e967', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('cab1a4ae-892a-423a-b829-75c6a1de7fc0', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e74bbd59-cd9d-41c6-8e3d-b1013016d8e3', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('13117a03-38c7-4471-b16f-d71f0ae925c0', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c356cb67-88e8-4fca-8fb3-91380eeba30e', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('97374476-f934-4bde-9af5-e654ae6456a1', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('905de77f-0c77-4e54-8693-92125d132043', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('516ce28d-59d7-41dd-8568-018b977278d3', 'App\Notifications\MemberFollowed', 20, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('547157a6-6197-4c2d-af38-132877c7ac09', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('26c9413b-8673-44c3-a9ca-f58d443c3bb3', 'App\Notifications\MemberFollowed', 23, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c9b35de1-b691-4631-ac95-7117f74ffa8f', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2c0e00f1-6ae4-494e-a280-1367c5be9bd9', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a7ed87ed-52ec-401c-b4d5-b88aada62dd3', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('442aca39-5369-4889-8d3e-54d0a95a50f6', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 17, "follower_name" : "Martguerita Ropars", "follower_username" : "mroparsg", "follower_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "url" : "profile/mroparsg"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('53410af5-a626-4f05-8ec0-42ed6edfd862', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fefcac54-a7b2-4376-af47-6e5b25bbd606', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 22, "follower_name" : "Flem Bosomworth", "follower_username" : "fbosomworthl", "follower_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "url" : "profile/fbosomworthl"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6b6642b1-fe70-4739-a736-25464cdee54f', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('236a7a3a-5a4b-472e-96b0-a0a2bc3fbe19', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('51dc8466-0e2e-4ef4-93b8-46a298807161', 'App\Notifications\MemberFollowed', 10, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c6e93e5e-01a1-4378-8b20-29967e103e69', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b4eb0cec-a9da-4e6d-bb42-6013bc837e2e', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 1, "following_name" : "Brenden Larby", "following_username" : "blarby0", "following_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('81076a4a-c0b6-47e6-8da8-c40555ad886f', 'App\Notifications\NewAnswer', 4, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 7, "question_title" : "Aliquam non mauris?", "url" : "questions/7/answers/2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6c018789-3d69-451e-bb48-f9c1a7067ddb', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('007ee3f7-ff82-4758-bfb5-2af8b0e9a060', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 18, "following_name" : "Lilllie Lethem", "following_username" : "llethemh", "following_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "question_id" : 34, "question_title" : "Etiam faucibus cursus urna?", "url" : "questions/34/answers/4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a4c9499d-ea80-407d-ab82-9b9a1260199f', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 20, "question_title" : "Quisque ut erat?", "url" : "questions/20/answers/5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a147abf7-a196-4f60-ae4f-1ad6d1fc8827', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d0b9a61c-eaaa-476c-a136-6c0b9fcde94e', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('de4da616-e18c-4e9f-b6e2-1acc0591e9fe', 'App\Notifications\NewAnswer', 16, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 13, "question_title" : "Vestibulum quam sapien, varius ut, blandit non, interdum in, ante?", "url" : "questions/13/answers/8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0948804d-b554-4c98-908d-40e5a636406e', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 3, "question_title" : "Nam nulla?", "url" : "questions/3/answers/9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('20aa912e-69f0-436f-aeb6-70e75360d47c', 'App\Notifications\NewAnswer', 16, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 13, "question_title" : "Vestibulum quam sapien, varius ut, blandit non, interdum in, ante?", "url" : "questions/13/answers/10"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1803e902-6349-4abf-9127-b6d821464dea', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/11"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('be5ac408-86a1-4b9e-a209-4ab860715756', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/32"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('405ff530-5c96-475e-accd-999863f5ccf1', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 16, "following_name" : "Sebastiano Mussington", "following_username" : "smussingtonf", "following_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/12"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b7e37dd8-aa42-46e6-a709-651744a9628b', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/13"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0522a5c9-351d-4ac1-b2ba-83a89543bc58', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/14"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b53a7f8e-90eb-492e-af23-b2ce9686c966', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/15"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7a7f3425-4dcc-4ca5-b550-baf3766d87a0', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/16"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b85563a8-b069-4838-ad56-2cf61eb41926', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 25, "question_title" : "In est risus, auctor sed, tristique in, tempus sit amet, sem?", "url" : "questions/25/answers/17"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a74140c0-1163-425f-b0a8-e68b47518e60', 'App\Notifications\NewAnswer', 17, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 29, "question_title" : "Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?", "url" : "questions/29/answers/18"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c9426328-5542-481c-b515-3d799b941d0f', 'App\Notifications\NewAnswer', 4, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 7, "question_title" : "Aliquam non mauris?", "url" : "questions/7/answers/19"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('faec73cb-19e4-455d-957e-e0bae9cc15b8', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 34, "question_title" : "Etiam faucibus cursus urna?", "url" : "questions/34/answers/20"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8e37bc73-29dd-48df-8740-c631fd2b445d', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/21"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8574b925-3deb-4a60-82b6-98698eec38fc', 'App\Notifications\NewAnswer', 20, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 18, "question_title" : "Nulla tellus?", "url" : "questions/18/answers/22"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e87af97d-526b-40fd-bc18-cca6e6ebdca1', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 10, "question_title" : "Curabitur at ipsum ac tellus semper interdum?", "url" : "questions/10/answers/23"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('858e9cce-d925-4aff-8707-b10afed72de0', 'App\Notifications\NewAnswer', 17, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 29, "question_title" : "Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?", "url" : "questions/29/answers/24"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('af61dd4a-e530-4a60-8efa-9d16a274ebf4', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/26"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d025e176-b83c-4fa9-bb67-557ee4131bff', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/27"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a412159a-66fc-4503-97b5-132655293fc0', 'App\Notifications\NewAnswer', 5, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 28, "question_title" : "Duis bibendum?", "url" : "questions/28/answers/28"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('cfa03a0b-e4cf-4dc0-8ca8-19a7a44a0f89', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/29"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b76bfdc2-aee4-4fab-b0bf-ca1e15c44682', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/30"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('343e65e7-44b6-454c-af65-3cf56f46ea76', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 39, "question_title" : "Nulla nisl?", "url" : "questions/39/answers/31"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bf349c5c-1ab0-4553-b7ae-dab700c7bda5', 'App\Notifications\NewAnswer', 5, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 28, "question_title" : "Duis bibendum?", "url" : "questions/28/answers/33"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e99d6575-e755-412c-9258-cd16e08102d9', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/34"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('92067639-ebe1-4936-8fe2-5752d8f7d149', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/35"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('cdbd1cbb-edff-4a0b-add7-859a83abedd4', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/36"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d738fa94-e5c7-4024-ae1b-516cec59f1a2', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 18, "following_name" : "Lilllie Lethem", "following_username" : "llethemh", "following_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/37"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('42c7c718-3e90-4a27-a657-8c00fef691b3', 'App\Notifications\NewAnswer', 4, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 7, "question_title" : "Aliquam non mauris?", "url" : "questions/7/answers/38"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9d16846a-0e83-498e-92bd-a66bf36cf66b', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/39"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('66dea7f6-c03d-4679-986f-a7901b09e75e', 'App\Notifications\NewAnswer', 20, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 18, "question_title" : "Nulla tellus?", "url" : "questions/18/answers/40"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3d0285eb-8a47-4901-b629-43c90950ed56', 'App\Notifications\NewAnswer', 15, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 30, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/30/answers/41"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1fdd3470-3ab0-4dc2-b2ef-4041a047c16c', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/42"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('abb9a172-2745-4a88-9243-575862e28515', 'App\Notifications\NewAnswer', 2, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/43"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('db3ac788-076b-4424-8bea-b554e41447e3', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/44"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fd5494ad-c3d8-4cb8-8e33-4d37b1346cf0', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 21, "following_name" : "Clem Loseby", "following_username" : "closebyk", "following_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/45"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7424db51-674b-430f-8228-f2fe8bc844e9', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/46"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8898e58f-4dd9-4690-a2d6-b23444c5ca59', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/47"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('59d7df30-2087-4e99-b877-bc9a0a5f7592', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/48"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('04db7748-dbc6-4ba8-aec8-7f6453e1633f', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 38, "question_title" : "Morbi non lectus?", "url" : "questions/38/answers/49"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('001c59a1-3f21-4201-bbd1-85b031784cfb', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/50"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f0a645dc-f33d-4d20-bb75-ee8ee9bbbcd4', 'App\Notifications\NewAnswer', 7, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 12, "question_title" : "Sed vel enim sit amet nunc viverra dapibus?", "url" : "questions/12/answers/51"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c8782185-edde-4b5d-9e75-a6a107223d2e', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/52"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('816d844d-df9b-4297-ad07-e4033289cdb1', 'App\Notifications\NewAnswer', 2, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/53"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5ec7b4d1-060f-47ea-9d5e-9e109b3609a3', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/54"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9bd442cc-a924-4c45-a158-f9f2b4520acb', 'App\Notifications\NewAnswer', 5, 'App\Member', '{"type" : "Answer", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 28, "question_title" : "Duis bibendum?", "url" : "questions/28/answers/55"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('15f68015-dc26-4e95-acb8-89ac0988c1af', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 1, "following_name" : "Brenden Larby", "following_username" : "blarby0", "following_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "question_id" : 35, "question_title" : "Aenean fermentum?", "url" : "questions/35/answers/56"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a5f127ad-f539-4cf7-9d68-5232072f2acf', 'App\Notifications\NewAnswer', 20, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 4, "question_title" : "Maecenas pulvinar lobortis est?", "url" : "questions/4/answers/57"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8b285a88-8a5f-4045-84d4-ae1864e3b3e6', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 39, "question_title" : "Nulla nisl?", "url" : "questions/39/answers/58"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e1ed8f02-7d68-4227-98c9-f28f443737be', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/59"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7547db73-a28c-42d0-a34a-a47550fc9699', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/60"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b48fed67-a130-4f10-a0c8-03946747c1b9', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/61"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3e4938bd-41f0-4600-8c66-d3cc8d52b92a', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 35, "question_title" : "Aenean fermentum?", "url" : "questions/35/answers/62"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ee6d60ad-59a4-4161-94f2-31c105f7892c', 'App\Notifications\NewAnswer', 3, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 2, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/2/answers/63"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a06ebc24-de8f-47c0-aa84-7a51fd168e78', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/64"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('55d23d60-9a42-41f4-9214-935861687545', 'App\Notifications\NewAnswer', 7, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 12, "question_title" : "Sed vel enim sit amet nunc viverra dapibus?", "url" : "questions/12/answers/65"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6e30fc0a-d43f-4b18-91af-e6047a7a09df', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/67"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('53f41355-c986-4161-b86e-21eb63bb842c', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/68"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4bb272cc-9d12-479d-84fe-0669ea75cf61', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 24, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/24/answers/69"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('128bd155-0e5d-4dcb-9fb9-cb3fae8721df', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 24, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/24/answers/70"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fd448075-ef04-4adc-ac4a-349dbf51e328', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/71"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b7526baa-e130-4d4b-baf0-006eab128550', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/72"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ec51c558-2b8a-4687-b9e6-c445738e570c', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 9, "question_title" : "Integer ac neque?", "url" : "questions/9/answers/73"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f86c8b7d-32ef-41d3-8375-7ab0f859f724', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 16, "following_name" : "Sebastiano Mussington", "following_username" : "smussingtonf", "following_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/74"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4b0cc362-6ec6-40aa-84c5-a8c3a0be29ba', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/75"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8bea3fb2-b964-4c17-bbc4-f5c7b7d17d7f', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/76"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('78ed75bd-1901-414b-b7af-6f50c4c67f39', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/77"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('14db7dd5-d4f4-40b7-9458-990954f3e218', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/78"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('19801693-24d4-432b-bd9f-8f083b34619d', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/79"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('810440cd-3ceb-4219-9439-23b6da038d96', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 38, "question_title" : "Morbi non lectus?", "url" : "questions/38/answers/80"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('595b49ec-e91b-45c9-bf26-e3bf541c02e3', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 21, "following_name" : "Clem Loseby", "following_username" : "closebyk", "following_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/81"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7ebe3fc8-abc1-48a8-8be3-cb0d8d86c6cf', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/82"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a63969ab-8a68-4ee5-a34c-0132c09026aa', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 22, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/22/answers/83"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ef7e5f3d-7f76-4ef6-bdf5-3c3ba4da2ed2', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 39, "question_title" : "Nulla nisl?", "url" : "questions/39/answers/84"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c7f06f4d-6328-4f90-8a6c-b8bbc080aac6', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 32, "question_title" : "Nam dui?", "url" : "questions/32/answers/85"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('61c38555-3b9d-4651-a797-33109b95525f', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/86"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('49c13e75-a745-44dd-b583-8f1662b89e30', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/87"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ec9ff328-1f2b-4b45-a2b4-b38ff74f045f', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 25, "question_title" : "In est risus, auctor sed, tristique in, tempus sit amet, sem?", "url" : "questions/25/answers/88"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('263f5ffa-a838-4b49-b907-f41e2ec85d38', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/89"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b2a887bb-dba5-4bb4-b22d-924208f34fcf', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/90"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('919e784a-3fa7-4f60-8651-d1fd3fa950a5', 'App\Notifications\NewAnswer', 2, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/91"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d2a52493-a109-4a13-ac3a-150a8b0fbd7d', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 18, "following_name" : "Lilllie Lethem", "following_username" : "llethemh", "following_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "question_id" : 34, "question_title" : "Etiam faucibus cursus urna?", "url" : "questions/34/answers/92"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('dee0f7b1-1d91-4fe4-b3aa-036201a6c054', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/93"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d720f397-7da5-4579-b6ec-5371698dda06', 'App\Notifications\NewAnswer', 17, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 29, "question_title" : "Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?", "url" : "questions/29/answers/94"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a3acb0fd-439d-4ae3-a277-1da232130c63', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 9, "question_title" : "Integer ac neque?", "url" : "questions/9/answers/95"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6f8fa959-d1ea-467c-aac3-8e1b5325566c', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/96"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('95b07be6-0f0f-4d5f-969b-195a8ac2b133', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/97"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('381ced4a-bed5-4e78-a9a7-02d9d807a4ac', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/98"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('57dc4bb3-ff12-442a-a350-8e2e92301739', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/99"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('594478fd-0586-4f48-a4c1-208619edbe57', 'App\Notifications\NewAnswer', 15, 'App\Member', '{"type" : "Answer", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 30, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/30/answers/100"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c943dfa1-ef86-4bb3-b689-3c53afb87301', 'App\Notifications\AnswerRated', 2, 'App\Member', '{"type" : "Rating", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/82"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b25f7237-8b34-4078-8bb3-15857c0f5b18', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/53"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2ad457e5-3149-45c6-90ee-d0b1a636291e', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('19fd07e1-7a1a-4887-9955-67e63fbede59', 'App\Notifications\AnswerRated', 14, 'App\Member', '{"type" : "Rating", "following_id" : 1, "following_name" : "Brenden Larby", "following_username" : "blarby0", "following_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/25"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('01f20aa0-872e-491a-ad9f-9466cdef8b94', 'App\Notifications\AnswerRated', 21, 'App\Member', '{"type" : "Rating", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/45"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4e4d391f-0ed3-4552-bf3d-91a8d25621dd', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/53"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2a57051f-a572-48e6-837a-6ca3223855a6', 'App\Notifications\AnswerRated', 17, 'App\Member', '{"type" : "Rating", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/96"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a4e6ec3d-a4c3-4d08-88d1-d40a1a2d7b00', 'App\Notifications\AnswerRated', 24, 'App\Member', '{"type" : "Rating", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 3, "question_title" : "Nam nulla?", "url" : "questions/3/answers/9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('66f7689a-55d9-4984-a876-1855fdf37188', 'App\Notifications\AnswerRated', 12, 'App\Member', '{"type" : "Rating", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/32"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4639474a-5392-41c9-ae5c-1518d467d0c9', 'App\Notifications\AnswerRated', 4, 'App\Member', '{"type" : "Rating", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/30"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c6fb3eba-1458-4186-953c-7d9936e7aafa', 'App\Notifications\AnswerRated', 11, 'App\Member', '{"type" : "Rating", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 9, "question_title" : "Integer ac neque?", "url" : "questions/9/answers/95"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c2eeab3a-d368-4da9-ad34-e8b60712b0e4', 'App\Notifications\AnswerRated', 12, 'App\Member', '{"type" : "Rating", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/32"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('423b8928-8280-4120-a813-9b6c0a2c3ded', 'App\Notifications\AnswerRated', 16, 'App\Member', '{"type" : "Rating", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/74"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('048bcb52-1242-4b62-bedc-297b0a09c84d', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 2, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/2/answers/63"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c3009c50-d509-477b-acbb-092dddc0e2f4', 'App\Notifications\AnswerRated', 9, 'App\Member', '{"type" : "Rating", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/35"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3030ad39-93a8-4281-b4cf-e8783e816212', 'App\Notifications\AnswerRated', 17, 'App\Member', '{"type" : "Rating", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/96"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('815c8310-ccb8-4d5a-be93-dd20cb49d139', 'App\Notifications\AnswerRated', 24, 'App\Member', '{"type" : "Rating", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/54"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9b80d598-c66b-4287-8562-3369bb564506', 'App\Notifications\AnswerRated', 7, 'App\Member', '{"type" : "Rating", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/79"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('646d7fef-13c9-43a5-98d2-42c281ee5de8', 'App\Notifications\AnswerRated', 9, 'App\Member', '{"type" : "Rating", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/50"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('43d55d9d-eea0-476a-84bb-8b9334e95695', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 14, "following_name" : "Reynard Mapstone", "following_username" : "rmapstoned", "following_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f87e94fc-2d2c-436d-8f36-3a3bd9aa5cfa', 'App\Notifications\AnswerRated', 2, 'App\Member', '{"type" : "Rating", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/15"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('aacd4733-d32e-4692-ba34-aef7cf4be91a', 'App\Notifications\AnswerRated', 10, 'App\Member', '{"type" : "Rating", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/97"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('716dbd2c-328a-4f24-96b7-32d001c7d21f', 'App\Notifications\AnswerRated', 3, 'App\Member', '{"type" : "Rating", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/47"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1888e968-bc49-4c9a-a335-63a66847218c', 'App\Notifications\AnswerRated', 19, 'App\Member', '{"type" : "Rating", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c5b7fe9e-e8c1-4a58-bad4-db5436052693', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('95084133-cb18-4915-a3a1-95fe1db7ba68', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('461e223e-d383-4cc9-91ef-471592ec839f', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e7a63b27-6efa-4172-9cb2-cf4258811ce4', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7288ce33-3dd6-4b8c-b6ab-281f2c5905ad', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('36efdbdd-ef1d-486b-aba9-85be7e214659', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2a963ce1-4420-4475-9d8f-a4d1d89f1201', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2850f375-b9aa-49b6-a835-ffc28a2b9a84', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fa7ab7c4-ccec-443b-836b-18e677683cca', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2c231c30-5178-4c10-8b8e-062a03d49375', 'App\Notifications\MemberFollowed', 11, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2e364be5-5941-4c8d-a9ba-f8c948b28562', 'App\Notifications\MemberFollowed', 23, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ced8e09b-97f4-4605-913d-c6b6b77fb856', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4cf83f4a-ac00-433e-8c5e-a7c7028663c9', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b3ac98db-6309-4f26-9ca7-5eecd5fce5e7', 'App\Notifications\MemberFollowed', 23, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d4080772-6bfd-4f99-99cf-92f855595653', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f1bb2be7-7907-4222-a7b8-df8a492d7ea3', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7c9bd07a-248c-4605-8d3a-89df40529ed5', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('11a67150-5cd6-4736-b48c-668bcb530605', 'App\Notifications\MemberFollowed', 6, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ed798aed-197a-4842-bf30-1b0b3c50d638', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('dcc22fe8-75f3-4e26-9faf-1dac4a2d1dc5', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('efca7144-4ae5-482b-9b6a-7d3e9dfc7fec', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('dc67ee7f-02ed-4912-98f6-8423f01fe125', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('791afbb6-74d6-4ff2-966f-3f05a1fba56b', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d15a5156-0a36-487f-9538-fdedc5a8d168', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1deb970f-3e09-4d12-87f3-711f138a93ba', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5f466cb3-e440-4e83-b250-c6394eaf5020', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('175a8342-0d24-4a43-bb1e-3ae1ecfe84eb', 'App\Notifications\MemberFollowed', 10, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fe28998a-24dc-490e-aa63-6ac3068179b7', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7c9def38-ff2d-4d3d-89a0-e7ae754e7c7a', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('05ef8ab8-a844-4f7f-aeee-664dcddc54c8', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('62a75003-da45-4e19-8c10-aa367c0104c2', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a009e512-27bd-4e99-944b-b422c6858181', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('35edd3f1-d272-4db4-93a0-1d64085cae95', 'App\Notifications\MemberFollowed', 11, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1d6d2d19-6f2e-4e95-80ff-730609173d9a', 'App\Notifications\MemberFollowed', 11, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bf967b5a-6152-49ce-9122-ee88490584ac', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('651af614-7c1e-46c7-87a4-7b0e1c9bd60a', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2ef44472-6390-4f1f-bda6-ba8cecdbbbb1', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c83f692f-4415-43e1-b1af-cc1a2b87f227', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('34dc16f5-12a4-49f7-bd56-b4ce904bf2b8', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1c25598c-9f9f-4a52-9b55-692299054cae', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6182f903-a25e-4245-98e2-4fc2fd083c5e', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c47c05be-9ad9-4a53-bc05-7e0543902a3f', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fdd795da-cbae-4c66-809c-9d84fef80bf7', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7434746f-7294-43a3-9a78-00982b50b05a', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c9e476a7-1382-445c-8e47-f7070fe2f485', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6a890c7c-6bae-4c63-abaa-bbcb429a12b6', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('63df2c79-2a3a-49f7-b3bf-f148e8fc5117', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8ba8395e-5cde-489e-b0a3-3bb87cd67ad1', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3cd8a097-e1d8-4798-808b-f0edb83751cd', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('91a2cad5-3fbf-4220-9d4c-79b9fd9bc601', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('918cb433-cc02-4008-ae68-0d52fd63f6a9', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d5ab7be0-53a9-42c3-a94f-f447238dbf2a', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a02fa58e-5d22-493a-99ec-5f6dd0b4013c', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9883a12d-53ef-4fae-9a3b-cacd052b39f7', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('654d6d31-d6f7-46ed-95cc-0e993cbdd270', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c4b004b8-fd57-4058-926e-342e5d44db81', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5a290700-b91d-40f1-9240-23063e8f9a47', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('55b26ec3-f034-428c-a8cf-4e19c5ec2c47', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('56fa1eec-b8b1-465a-84fe-1d8edef155df', 'App\Notifications\MemberFollowed', 20, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2bc7b4d2-1c7a-4f0d-94ce-b098a308be45', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a5f2185c-05bc-4d95-b8d1-abbe6040a6dd', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8bfbc228-9a1b-4ef1-85ae-7a0237553f47', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8066c3d8-e506-4dbe-b368-a5bb5a40c9f0', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1f60885f-cb04-4b40-8fe7-e09da2aad39c', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 16, "follower_name" : "Sebastiano Mussington", "follower_username" : "smussingtonf", "follower_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "url" : "profile/smussingtonf"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f63280b6-b1ca-4bc9-b07a-51da1c59de65', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('650cdbf7-dc80-4fa6-917b-1d233bdbd066', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b8c37295-7ca3-4ee2-a9fa-c54148f7c170', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('408a7da9-3065-4cef-bb31-e7feccf0e3b0', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('84005fbc-80d1-4cb8-844e-e29a29cd4ad6', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f30e8cb7-1bdc-4e35-b720-ddd3737e681a', 'App\Notifications\MemberFollowed', 17, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6ee95561-e3f9-49a2-9bb2-712a3b4d4918', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 18, "follower_name" : "Lilllie Lethem", "follower_username" : "llethemh", "follower_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "url" : "profile/llethemh"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b614a3f3-32d7-4ad5-9642-ff7ffee011e3', 'App\Notifications\MemberFollowed', 24, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('59fff700-c268-4624-9adc-2b3109fa9432', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('42b875ce-1a6d-4a9f-a19c-9030dfb7dada', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('56a73cf4-d679-47a0-a5db-ec72254ae0d9', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c0886d6b-a5e3-490a-864e-b5e1d5acbdc9', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 17, "follower_name" : "Martguerita Ropars", "follower_username" : "mroparsg", "follower_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "url" : "profile/mroparsg"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0bc6b8a9-6345-46e3-a5ba-37ab5e03b1e7', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 1, "follower_name" : "Brenden Larby", "follower_username" : "blarby0", "follower_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "url" : "profile/blarby0"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e492e7f5-7933-408d-bc15-98409ba6a2ec', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c32e2707-6e81-4d9e-892a-efaecb5515f0', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2c67c50e-ca05-4ff5-bca9-da097c3a373c', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 5, "follower_name" : "Alethea Emmett", "follower_username" : "aemmett4", "follower_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "url" : "profile/aemmett4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e527b0ac-c532-4a7c-99fd-04f7b24b2ca9', 'App\Notifications\MemberFollowed', 12, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('273cc692-8ac3-4938-9db7-67e15ad10cf0', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 8, "follower_name" : "Emylee Cuddy", "follower_username" : "ecuddy7", "follower_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "url" : "profile/ecuddy7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('49d713d2-a141-49f6-8870-a5dcf9c12956', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2f91f72b-5ef9-4e06-baf2-ca0aaf852640', 'App\Notifications\MemberFollowed', 6, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a4102c3d-0155-4cb3-9329-733a9eafad68', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4c282895-c7af-4947-bce1-381b9b9e825a', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('73426373-5a4c-40a0-aff6-6238446d0b75', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bb245575-f497-4a19-8f1e-1bf44e5ff7aa', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 10, "follower_name" : "Rickard Solesbury", "follower_username" : "rsolesbury9", "follower_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "url" : "profile/rsolesbury9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8dbced06-5429-492a-aa18-bab86a6eefc5', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 22, "follower_name" : "Flem Bosomworth", "follower_username" : "fbosomworthl", "follower_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "url" : "profile/fbosomworthl"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('86f2a49c-893e-4513-91eb-8ddb15d00152', 'App\Notifications\MemberFollowed', 20, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('227c55ab-2456-4cd9-b4bd-c34e6fa5cb90', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('94ccbca7-3173-4c6a-8b82-6c72825c5bfb', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fd22f19f-099e-4baa-a830-193d9063e41a', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 4, "follower_name" : "Cliff McReath", "follower_username" : "cmcreath3", "follower_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "url" : "profile/cmcreath3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('615dd21a-9676-4fdd-b8ec-95b4514eb698', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 22, "follower_name" : "Flem Bosomworth", "follower_username" : "fbosomworthl", "follower_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "url" : "profile/fbosomworthl"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('409df636-b399-41ba-9f2a-2672436c4ab8', 'App\Notifications\MemberFollowed', 5, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('26f00a39-5ef7-4789-a69e-b81a52390485', 'App\Notifications\MemberFollowed', 10, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('64ee4a96-ed4e-4e4d-a866-2af6da3733e2', 'App\Notifications\MemberFollowed', 6, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d31a3b92-e235-456a-954d-496b74526593', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('93e1c22b-1fe4-4474-9b4b-2ca9f7acf973', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('47b4a3eb-1ac8-458e-b72d-c11f7e99e698', 'App\Notifications\MemberFollowed', 25, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a166fc0e-7ef4-4c42-982e-867b9dd1ee4f', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 11, "follower_name" : "Mickie Burch", "follower_username" : "mburcha", "follower_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "url" : "profile/mburcha"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('15f61f69-0023-47bb-8540-b76a33af7d22', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 2, "follower_name" : "Jeffy Gaish", "follower_username" : "jgaish1", "follower_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "url" : "profile/jgaish1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('38ad6479-59ff-4885-aecf-1dd0bce232af', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d586ae9c-d3eb-4efc-8968-cf027f09be72', 'App\Notifications\MemberFollowed', 21, 'App\Member', '{"type" : "Follow", "follower_id" : 13, "follower_name" : "Clarisse Zolini", "follower_username" : "czolinic", "follower_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "url" : "profile/czolinic"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bd7e1197-232a-4ed6-908b-e283209491a0', 'App\Notifications\MemberFollowed', 16, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ba539bb4-e2ef-44ec-b1bd-019731b399ee', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 17, "follower_name" : "Martguerita Ropars", "follower_username" : "mroparsg", "follower_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "url" : "profile/mroparsg"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('7742b47a-fae1-47e6-8525-b5d6b3796d69', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('12a30ad5-3f86-48e4-9670-d9a93921261d', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d3b31ab6-47a5-48ed-a207-7247b15fe234', 'App\Notifications\MemberFollowed', 7, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e0ad901a-bd32-44de-bc6d-1dd893e42255', 'App\Notifications\MemberFollowed', 14, 'App\Member', '{"type" : "Follow", "follower_id" : 19, "follower_name" : "Sonya Zavattari", "follower_username" : "szavattarii", "follower_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "url" : "profile/szavattarii"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('94cc7f14-0991-4d76-bc05-fdee5580ddf2', 'App\Notifications\MemberFollowed', 13, 'App\Member', '{"type" : "Follow", "follower_id" : 21, "follower_name" : "Clem Loseby", "follower_username" : "closebyk", "follower_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "url" : "profile/closebyk"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('93f1f4de-d449-424d-8ba3-b0f65e938b7d', 'App\Notifications\MemberFollowed', 3, 'App\Member', '{"type" : "Follow", "follower_id" : 12, "follower_name" : "Oneida Barthot", "follower_username" : "obarthotb", "follower_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "url" : "profile/obarthotb"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ff2816f0-f835-4bc6-b70f-0f7f7db5b6f1', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('95bac795-d8a8-4dae-a099-ed29310c959e', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6744076f-5030-42bb-9393-26ee1c84fbf3', 'App\Notifications\MemberFollowed', 19, 'App\Member', '{"type" : "Follow", "follower_id" : 20, "follower_name" : "Ambrosius Klimmek", "follower_username" : "aklimmekj", "follower_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "url" : "profile/aklimmekj"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3f7e8b36-b974-4be4-ba6d-52d015cd43c7', 'App\Notifications\MemberFollowed', 2, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3c078de7-6964-4684-88ef-1e9a233d09dd', 'App\Notifications\MemberFollowed', 20, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('af0ae527-6f94-4960-bb17-aa876cedb739', 'App\Notifications\MemberFollowed', 4, 'App\Member', '{"type" : "Follow", "follower_id" : 6, "follower_name" : "Marlin Blonfield", "follower_username" : "mblonfield5", "follower_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "url" : "profile/mblonfield5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('af05770f-406b-4f05-9ba1-4b53e490adc1', 'App\Notifications\MemberFollowed', 23, 'App\Member', '{"type" : "Follow", "follower_id" : 25, "follower_name" : "Amanda Alvarado", "follower_username" : "aalvaradoo", "follower_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "url" : "profile/aalvaradoo"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1e5345e6-e368-4da7-b288-942da1488145', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('72d5ef52-9c41-440b-90ca-c735a0bb1bdb', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 15, "follower_name" : "Catherina Goldby", "follower_username" : "cgoldbye", "follower_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "url" : "profile/cgoldbye"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('48ad200d-7668-47cf-b604-4df6d7da2a1b', 'App\Notifications\MemberFollowed', 1, 'App\Member', '{"type" : "Follow", "follower_id" : 7, "follower_name" : "Adelheid Dono", "follower_username" : "adono6", "follower_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "url" : "profile/adono6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('56f6eae4-c65a-40bf-9fbd-aa7ca0051d4d', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 17, "follower_name" : "Martguerita Ropars", "follower_username" : "mroparsg", "follower_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "url" : "profile/mroparsg"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b5e84365-1ced-4e16-8fbd-4aed261b97c5', 'App\Notifications\MemberFollowed', 15, 'App\Member', '{"type" : "Follow", "follower_id" : 23, "follower_name" : "Suzann Romanet", "follower_username" : "sromanetm", "follower_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "url" : "profile/sromanetm"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0016bb42-84c1-403a-8fe7-cc66dd42a9a3', 'App\Notifications\MemberFollowed', 18, 'App\Member', '{"type" : "Follow", "follower_id" : 22, "follower_name" : "Flem Bosomworth", "follower_username" : "fbosomworthl", "follower_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "url" : "profile/fbosomworthl"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('43a3ba6c-2eaf-478d-9bf6-213bdc2fa6ac', 'App\Notifications\MemberFollowed', 22, 'App\Member', '{"type" : "Follow", "follower_id" : 9, "follower_name" : "Jefferson Zanetello", "follower_username" : "jzanetello8", "follower_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "url" : "profile/jzanetello8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4122409b-513d-49a1-8114-5e00ff92c3f9', 'App\Notifications\MemberFollowed', 8, 'App\Member', '{"type" : "Follow", "follower_id" : 3, "follower_name" : "Aprilette Oxer", "follower_username" : "aoxer2", "follower_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "url" : "profile/aoxer2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5635b670-1d4d-4891-a3cb-0e3c7490e704', 'App\Notifications\MemberFollowed', 10, 'App\Member', '{"type" : "Follow", "follower_id" : 24, "follower_name" : "Daron Colly", "follower_username" : "dcollyn", "follower_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "url" : "profile/dcollyn"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('06ead0f7-e932-4329-a025-2201d4b8d9ea', 'App\Notifications\MemberFollowed', 9, 'App\Member', '{"type" : "Follow", "follower_id" : 14, "follower_name" : "Reynard Mapstone", "follower_username" : "rmapstoned", "follower_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "url" : "profile/rmapstoned"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d37ed850-6f79-48f2-bf81-93b0a778e14f', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 1, "following_name" : "Brenden Larby", "following_username" : "blarby0", "following_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/1"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('398ded8e-9108-446c-a83f-49eec8f5cb59', 'App\Notifications\NewAnswer', 4, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 7, "question_title" : "Aliquam non mauris?", "url" : "questions/7/answers/2"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f694dffb-d36d-4957-aaea-7db35a28d944', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/3"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1e1edf05-34e9-4584-956b-aad334cb335e', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 18, "following_name" : "Lilllie Lethem", "following_username" : "llethemh", "following_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "question_id" : 34, "question_title" : "Etiam faucibus cursus urna?", "url" : "questions/34/answers/4"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9fce3749-757c-4fca-96e5-13bc5d92b7a0', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 20, "question_title" : "Quisque ut erat?", "url" : "questions/20/answers/5"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('99aedd1f-4435-4123-834b-4c31954126fb', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/6"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3ae04669-7172-4fcd-8f14-268870b22d0b', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8a823c70-8307-46f6-b8c6-0c450469e9d9', 'App\Notifications\NewAnswer', 16, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 13, "question_title" : "Vestibulum quam sapien, varius ut, blandit non, interdum in, ante?", "url" : "questions/13/answers/8"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('488ae482-ceea-440b-866f-28441bcaf842', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 3, "question_title" : "Nam nulla?", "url" : "questions/3/answers/9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('878fe922-5f49-4a55-b4ce-bacff42a57a2', 'App\Notifications\NewAnswer', 16, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 13, "question_title" : "Vestibulum quam sapien, varius ut, blandit non, interdum in, ante?", "url" : "questions/13/answers/10"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('55dad2ac-e116-4dd9-a854-f5a8cac65c28', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/11"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d9293645-e4d2-4f06-bd7e-d78fc01d0140', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 16, "following_name" : "Sebastiano Mussington", "following_username" : "smussingtonf", "following_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/12"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4fde2ef2-ec87-47c5-8726-051932fa6ec0', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/13"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('dca78d36-be8d-44bf-952b-8b941bb60639', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/14"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e9afc89c-375d-4efb-8723-1908293adb03', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/15"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a8c74b3c-7ea8-49d2-a240-a8f89e187e8e', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/16"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e048bcb5-aea4-4dc8-99bf-8342398880a2', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 25, "question_title" : "In est risus, auctor sed, tristique in, tempus sit amet, sem?", "url" : "questions/25/answers/17"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('44bc2ac7-2461-4690-95f4-66de22f8797f', 'App\Notifications\NewAnswer', 17, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 29, "question_title" : "Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?", "url" : "questions/29/answers/18"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('723fc95e-3823-4a53-87fc-4e5e346a78ec', 'App\Notifications\NewAnswer', 4, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 7, "question_title" : "Aliquam non mauris?", "url" : "questions/7/answers/19"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('53f42a60-00e2-48c2-b310-1d638844c237', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 34, "question_title" : "Etiam faucibus cursus urna?", "url" : "questions/34/answers/20"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ae75448a-8272-4ab5-a746-933d53060e31', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/21"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ca672d1f-5112-49ba-bb57-84003f57692a', 'App\Notifications\NewAnswer', 20, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 18, "question_title" : "Nulla tellus?", "url" : "questions/18/answers/22"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('450ad43e-a634-4b6e-8db8-b16215a23618', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 10, "question_title" : "Curabitur at ipsum ac tellus semper interdum?", "url" : "questions/10/answers/23"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('12f727c2-95f4-45d6-bbad-f8861cf094d5', 'App\Notifications\NewAnswer', 17, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 29, "question_title" : "Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?", "url" : "questions/29/answers/24"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9fd79d96-b0f2-40f6-be82-23e37f261198', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/26"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('cce99b11-a1c0-4e79-8038-a79525483437', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/27"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('96b86bb5-e584-4c55-b3a4-97d8e9be84a7', 'App\Notifications\NewAnswer', 5, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 28, "question_title" : "Duis bibendum?", "url" : "questions/28/answers/28"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d551618e-bafd-4143-accf-ca0005eb5990', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/29"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a19e051d-5ce5-4457-86c2-611a00cb954a', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/30"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ee53df63-bf14-45cd-aaad-8e1573f25d97', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 39, "question_title" : "Nulla nisl?", "url" : "questions/39/answers/31"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2ef3271d-e7a7-49f7-9470-9d2f8c593886', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/32"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('003ff691-42d3-4e96-b099-f07e12eae911', 'App\Notifications\NewAnswer', 5, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 28, "question_title" : "Duis bibendum?", "url" : "questions/28/answers/33"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8183197f-cb20-4e5e-984a-765071c16093', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/34"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ed4bf638-444d-4c89-9b27-5927901e38d2', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/35"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1565f1e4-36ca-49ea-ba70-9353c089c904', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/36"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a07dacf8-fa55-4246-bc60-8f816c469484', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 18, "following_name" : "Lilllie Lethem", "following_username" : "llethemh", "following_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/37"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e1811c69-d94c-4c31-a050-dbbce0456a64', 'App\Notifications\NewAnswer', 4, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 7, "question_title" : "Aliquam non mauris?", "url" : "questions/7/answers/38"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f75e2e2f-9c3d-48b4-99f8-beb6d84a45b0', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 31, "question_title" : "Praesent blandit?", "url" : "questions/31/answers/39"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f6fb5585-ebcc-4f1c-bec0-ec83f6832178', 'App\Notifications\NewAnswer', 20, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 18, "question_title" : "Nulla tellus?", "url" : "questions/18/answers/40"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3f2c4e49-7ad1-4ce9-aaf7-84816f9b6c0b', 'App\Notifications\NewAnswer', 15, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 30, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/30/answers/41"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('db581bb2-f389-4d49-bb23-e71b3fbb1281', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/42"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bfabf5e1-2c26-4783-83dd-a22274039187', 'App\Notifications\NewAnswer', 2, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/43"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('799938fc-0e6b-4ee1-8db9-76423288c57f', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/44"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ae16434e-f4a3-4884-b01d-0326a8811159', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 21, "following_name" : "Clem Loseby", "following_username" : "closebyk", "following_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/45"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0422918d-a9d8-4293-a651-b192a7f8bf35', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/46"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('954f2d61-5d11-49a6-bc8b-e4a1d240fc18', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/47"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e868d61f-bd36-431f-ab12-296c3a44f835', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/48"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('41db9c51-5e0c-4db3-8267-c0a48d931d5d', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 38, "question_title" : "Morbi non lectus?", "url" : "questions/38/answers/49"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('47342caa-1583-4ed6-897f-eb131fa65c7e', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/50"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c2b169ad-e591-46d6-a8bf-8a0cbb8bc17b', 'App\Notifications\NewAnswer', 7, 'App\Member', '{"type" : "Answer", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 12, "question_title" : "Sed vel enim sit amet nunc viverra dapibus?", "url" : "questions/12/answers/51"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('62625a7f-9d0e-4ab7-a8f3-3be7085bc073', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/52"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('16734eac-6e10-476a-a225-618d7ca8e8e5', 'App\Notifications\NewAnswer', 2, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/53"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4d3b1606-278d-4f6f-a954-084bf185991d', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 24, "following_name" : "Daron Colly", "following_username" : "dcollyn", "following_picture" : "https://robohash.org/molestiasplaceatrerum.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/54"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('f2fdb828-0288-4098-905c-b8c6d06a935d', 'App\Notifications\NewAnswer', 5, 'App\Member', '{"type" : "Answer", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 28, "question_title" : "Duis bibendum?", "url" : "questions/28/answers/55"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('602a9562-98cd-4ec0-862c-5814f7cd1d89', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 1, "following_name" : "Brenden Larby", "following_username" : "blarby0", "following_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "question_id" : 35, "question_title" : "Aenean fermentum?", "url" : "questions/35/answers/56"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0273bc62-e6da-42a4-a9c3-54620d7972ad', 'App\Notifications\NewAnswer', 20, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 4, "question_title" : "Maecenas pulvinar lobortis est?", "url" : "questions/4/answers/57"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('45c2d0f5-e4a5-4a1d-822a-fbc57f116172', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 39, "question_title" : "Nulla nisl?", "url" : "questions/39/answers/58"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('660031b9-fc1a-4ff9-b789-4ec4879f2f2c', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/59"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1af1b910-1a15-4121-91f0-c12521ebaa0d', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/60"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('12832b0f-744b-47e2-8385-7938ac6d2d47', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/61"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('a145d5c3-72ec-4d6c-9b2c-573b6c53015c', 'App\Notifications\NewAnswer', 25, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 35, "question_title" : "Aenean fermentum?", "url" : "questions/35/answers/62"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0a2a6100-9c11-4973-abb2-bf1334dc626c', 'App\Notifications\NewAnswer', 3, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 2, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/2/answers/63"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('cf429f26-9ba3-4679-ba39-fc5d0f4afb33', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/64"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('075bb1cf-2ec4-4f56-9ecc-4f266d944f55', 'App\Notifications\NewAnswer', 7, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 12, "question_title" : "Sed vel enim sit amet nunc viverra dapibus?", "url" : "questions/12/answers/65"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1ed29788-a928-4e1c-b438-525968cab06e', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/67"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e6b34d38-d0d5-4315-9815-e8c1b52b7491', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/68"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('58d99cb9-2a5f-4633-87d5-3d118a98ded7', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 24, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/24/answers/69"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('da0bb092-636b-4ec9-8188-b67debc10396', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 24, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/24/answers/70"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('d4454bc4-252c-45a4-b9e6-3c6d357cd55d', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/71"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('86898191-79ff-4a1d-baa0-7cb45217f8cb', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 20, "following_name" : "Ambrosius Klimmek", "following_username" : "aklimmekj", "following_picture" : "https://robohash.org/minusaliasquasi.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/72"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('29354264-de46-4e14-8945-f552208b58e3', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 9, "question_title" : "Integer ac neque?", "url" : "questions/9/answers/73"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1596251c-055c-47d0-9663-7f3b21c08e45', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 16, "following_name" : "Sebastiano Mussington", "following_username" : "smussingtonf", "following_picture" : "https://robohash.org/etdoloreseaque.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/74"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6e114c59-7e04-445a-b0bd-97d5f55bfdd1', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/75"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c7cea337-f0ef-4cbc-af36-90cb8f7a4aba', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/76"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('8ebf6c21-1348-4341-b318-af44c46ed9a4', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/77"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('481cb622-a204-481d-b5cb-16d321cb071a', 'App\Notifications\NewAnswer', 24, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/78"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('866e0936-3cbe-44af-b8ef-bdcfe62f9f09', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/79"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3fe3f9fe-b309-4223-a38b-05e5c3577724', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 38, "question_title" : "Morbi non lectus?", "url" : "questions/38/answers/80"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('af5e8991-4a3a-4ca6-a69f-6a3e8da684ec', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 21, "following_name" : "Clem Loseby", "following_username" : "closebyk", "following_picture" : "https://robohash.org/quidolorpariatur.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/81"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4b31e3c3-434c-4073-93c2-994b82944647', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/82"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('11b21052-6793-4d8e-ae63-0c1de1975a0f', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 22, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/22/answers/83"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c0576fe7-23de-4217-9770-2f2df22d40a8', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 39, "question_title" : "Nulla nisl?", "url" : "questions/39/answers/84"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e4a23596-2ad1-47b8-8b8f-bb90733018d7', 'App\Notifications\NewAnswer', 8, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 32, "question_title" : "Nam dui?", "url" : "questions/32/answers/85"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4a032802-0f9a-4f04-ab9e-c6318e2f591f', 'App\Notifications\NewAnswer', 21, 'App\Member', '{"type" : "Answer", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 19, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/19/answers/86"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('1737b4d8-2574-423d-a5f7-292d068f8f7d', 'App\Notifications\NewAnswer', 11, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 40, "question_title" : "Duis bibendum?", "url" : "questions/40/answers/87"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('46e4f9c2-737d-4ed1-8bd8-6c5a915ad444', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 25, "question_title" : "In est risus, auctor sed, tristique in, tempus sit amet, sem?", "url" : "questions/25/answers/88"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4d6bf89f-88a0-4313-a2f4-2fd74db50f2c', 'App\Notifications\NewAnswer', 10, 'App\Member', '{"type" : "Answer", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/89"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('4f269765-08a4-457a-898e-7116ce0db066', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 14, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/14/answers/90"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('51b5e2a5-20dd-4b02-9264-d70e1fe78644', 'App\Notifications\NewAnswer', 2, 'App\Member', '{"type" : "Answer", "following_id" : 25, "following_name" : "Amanda Alvarado", "following_username" : "aalvaradoo", "following_picture" : "https://robohash.org/etsimiliquevoluptas.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/91"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6d14de13-4683-435c-893e-7c338dd2caa5', 'App\Notifications\NewAnswer', 23, 'App\Member', '{"type" : "Answer", "following_id" : 18, "following_name" : "Lilllie Lethem", "following_username" : "llethemh", "following_picture" : "https://robohash.org/impeditquidemrepellendus.png?size=200x200&set=set1", "question_id" : 34, "question_title" : "Etiam faucibus cursus urna?", "url" : "questions/34/answers/92"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('9d9cb1ea-9fcc-4d42-8ed6-5031413921a9', 'App\Notifications\NewAnswer', 1, 'App\Member', '{"type" : "Answer", "following_id" : 13, "following_name" : "Clarisse Zolini", "following_username" : "czolinic", "following_picture" : "https://robohash.org/quiasolutaomnis.png?size=200x200&set=set1", "question_id" : 33, "question_title" : "Integer tincidunt ante vel ipsum?", "url" : "questions/33/answers/93"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e3839b88-a00d-441b-b512-3e9c069855b4', 'App\Notifications\NewAnswer', 17, 'App\Member', '{"type" : "Answer", "following_id" : 12, "following_name" : "Oneida Barthot", "following_username" : "obarthotb", "following_picture" : "https://robohash.org/consequunturestin.png?size=200x200&set=set1", "question_id" : 29, "question_title" : "Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede?", "url" : "questions/29/answers/94"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e6cc5e0e-6708-45ed-ada9-09c7f6aef88e', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 11, "following_name" : "Mickie Burch", "following_username" : "mburcha", "following_picture" : "https://robohash.org/expeditalaboreblanditiis.png?size=200x200&set=set1", "question_id" : 9, "question_title" : "Integer ac neque?", "url" : "questions/9/answers/95"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b796dc79-23f3-4d40-b002-07578553d520', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/96"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('eb278cd4-8b4e-4f00-b420-a6d86e383f8c', 'App\Notifications\NewAnswer', 19, 'App\Member', '{"type" : "Answer", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/97"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0eff09d2-068a-4062-95e4-60fbca88c516', 'App\Notifications\NewAnswer', 18, 'App\Member', '{"type" : "Answer", "following_id" : 4, "following_name" : "Cliff McReath", "following_username" : "cmcreath3", "following_picture" : "https://robohash.org/suntquosex.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/98"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fa597857-1281-4359-83af-a6aa124a15aa', 'App\Notifications\NewAnswer', 14, 'App\Member', '{"type" : "Answer", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/99"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('3d82969b-1d65-453c-a78e-98d2e9c6ec6f', 'App\Notifications\NewAnswer', 15, 'App\Member', '{"type" : "Answer", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 30, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio?", "url" : "questions/30/answers/100"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('37116203-e69b-47a6-aabb-7eb10af8e8d8', 'App\Notifications\AnswerRated', 2, 'App\Member', '{"type" : "Rating", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 15, "question_title" : "Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus?", "url" : "questions/15/answers/82"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('767dfda2-ec38-410a-a5f9-f9d4516d066b', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/53"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('648f2080-e0fc-49ac-92ca-6ce6d0f3f6ab', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 9, "following_name" : "Jefferson Zanetello", "following_username" : "jzanetello8", "following_picture" : "https://robohash.org/fugiatquisnon.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('6f60f6b8-adc4-42c5-b80f-6c6a057cf088', 'App\Notifications\AnswerRated', 14, 'App\Member', '{"type" : "Rating", "following_id" : 1, "following_name" : "Brenden Larby", "following_username" : "blarby0", "following_picture" : "https://robohash.org/occaecatimolestiaenam.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/25"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('eba8e9c0-9451-4d43-9a15-cc6b907d7f9c', 'App\Notifications\AnswerRated', 21, 'App\Member', '{"type" : "Rating", "following_id" : 15, "following_name" : "Catherina Goldby", "following_username" : "cgoldbye", "following_picture" : "https://robohash.org/possimusnonplaceat.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/45"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('822916c2-f5a9-42e7-9259-a0a8d4e74f67', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 26, "question_title" : "Maecenas rhoncus aliquam lacus?", "url" : "questions/26/answers/53"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ef5692ce-978e-451b-bd4c-774bfadfa110', 'App\Notifications\AnswerRated', 17, 'App\Member', '{"type" : "Rating", "following_id" : 8, "following_name" : "Emylee Cuddy", "following_username" : "ecuddy7", "following_picture" : "https://robohash.org/temporedolorquam.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/96"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('5121c831-e30e-4bf5-bb14-98b63a57aebd', 'App\Notifications\AnswerRated', 24, 'App\Member', '{"type" : "Rating", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 3, "question_title" : "Nam nulla?", "url" : "questions/3/answers/9"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('c0f39dd1-5e3f-4f38-bb0f-654dc705290a', 'App\Notifications\AnswerRated', 12, 'App\Member', '{"type" : "Rating", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/32"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e07c3050-6279-49dd-9321-388246084124', 'App\Notifications\AnswerRated', 4, 'App\Member', '{"type" : "Rating", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/30"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('078b13d2-4799-49e3-b0ac-6ea7afa871f1', 'App\Notifications\AnswerRated', 11, 'App\Member', '{"type" : "Rating", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 9, "question_title" : "Integer ac neque?", "url" : "questions/9/answers/95"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('541b87cd-9a9e-47c6-b60b-1ed97aa6fe82', 'App\Notifications\AnswerRated', 12, 'App\Member', '{"type" : "Rating", "following_id" : 2, "following_name" : "Jeffy Gaish", "following_username" : "jgaish1", "following_picture" : "https://robohash.org/veniamvoluptatemest.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/32"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('b11582ea-6a77-4508-ac3c-6e8f8249afdc', 'App\Notifications\AnswerRated', 16, 'App\Member', '{"type" : "Rating", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 16, "question_title" : "Morbi vel lectus in quam fringilla rhoncus?", "url" : "questions/16/answers/74"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('53e9772a-46c0-42f5-82fa-4e3b6b78e408', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 22, "following_name" : "Flem Bosomworth", "following_username" : "fbosomworthl", "following_picture" : "https://robohash.org/quidemeumsit.png?size=200x200&set=set1", "question_id" : 2, "question_title" : "Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla?", "url" : "questions/2/answers/63"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('0c09cbde-c5fa-4646-901c-a1f65945d7b7', 'App\Notifications\AnswerRated', 9, 'App\Member', '{"type" : "Rating", "following_id" : 3, "following_name" : "Aprilette Oxer", "following_username" : "aoxer2", "following_picture" : "https://robohash.org/etdelenitirerum.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/35"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('fd3b38ec-e510-4a5b-a3dc-efe7f39da877', 'App\Notifications\AnswerRated', 17, 'App\Member', '{"type" : "Rating", "following_id" : 10, "following_name" : "Rickard Solesbury", "following_username" : "rsolesbury9", "following_picture" : "https://robohash.org/quodatquedicta.png?size=200x200&set=set1", "question_id" : 1, "question_title" : "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue?", "url" : "questions/1/answers/96"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('722085d9-6453-4c77-9d05-8a035cdb8624', 'App\Notifications\AnswerRated', 24, 'App\Member', '{"type" : "Rating", "following_id" : 23, "following_name" : "Suzann Romanet", "following_username" : "sromanetm", "following_picture" : "https://robohash.org/minimaimpeditest.png?size=200x200&set=set1", "question_id" : 8, "question_title" : "Proin leo odio, porttitor id, consequat in, consequat ut, nulla?", "url" : "questions/8/answers/54"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('e74d7a0d-4bcd-4e01-a784-5e5f1c617f88', 'App\Notifications\AnswerRated', 7, 'App\Member', '{"type" : "Rating", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 27, "question_title" : "Aenean auctor gravida sem?", "url" : "questions/27/answers/79"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('bf6c2e3c-d726-4277-a8eb-3572aa0d484a', 'App\Notifications\AnswerRated', 9, 'App\Member', '{"type" : "Rating", "following_id" : 19, "following_name" : "Sonya Zavattari", "following_username" : "szavattarii", "following_picture" : "https://robohash.org/possimusestconsequatur.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/50"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('57e76a4b-fba1-4812-9f08-427dce3dda97', 'App\Notifications\AnswerRated', 20, 'App\Member', '{"type" : "Rating", "following_id" : 14, "following_name" : "Reynard Mapstone", "following_username" : "rmapstoned", "following_picture" : "https://robohash.org/repellatsitet.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/7"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('dda40b14-679e-4f55-b935-76165b56f634', 'App\Notifications\AnswerRated', 2, 'App\Member', '{"type" : "Rating", "following_id" : 17, "following_name" : "Martguerita Ropars", "following_username" : "mroparsg", "following_picture" : "https://robohash.org/etquia.png?size=200x200&set=set1", "question_id" : 23, "question_title" : "Nunc purus?", "url" : "questions/23/answers/15"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('2f6b30c8-699c-4839-8905-505f315f1f39', 'App\Notifications\AnswerRated', 10, 'App\Member', '{"type" : "Rating", "following_id" : 7, "following_name" : "Adelheid Dono", "following_username" : "adono6", "following_picture" : "https://robohash.org/ipsampariaturdeserunt.png?size=200x200&set=set1", "question_id" : 6, "question_title" : "Curabitur convallis?", "url" : "questions/6/answers/97"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('20acc785-4961-425a-aa63-78467ebe5a1d', 'App\Notifications\AnswerRated', 3, 'App\Member', '{"type" : "Rating", "following_id" : 6, "following_name" : "Marlin Blonfield", "following_username" : "mblonfield5", "following_picture" : "https://robohash.org/sedquisipsa.png?size=200x200&set=set1", "question_id" : 21, "question_title" : "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est?", "url" : "questions/21/answers/47"}', NULL, NULL, NULL);
INSERT INTO notifications VALUES ('ccbd0fc9-1a4a-4b39-8059-d4d79a931061', 'App\Notifications\AnswerRated', 19, 'App\Member', '{"type" : "Rating", "following_id" : 5, "following_name" : "Alethea Emmett", "following_username" : "aemmett4", "following_picture" : "https://robohash.org/velaspernaturasperiores.png?size=200x200&set=set1", "question_id" : 11, "question_title" : "Fusce posuere felis sed lacus?", "url" : "questions/11/answers/6"}', NULL, NULL, NULL);
