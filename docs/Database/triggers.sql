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
  IF EXISTS(SELECT member.email FROM admin INNER JOIN member ON admin.email = member.email) THEN
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
