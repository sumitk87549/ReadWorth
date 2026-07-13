-- Seed admin  (password: admin)
MERGE INTO admin_users (id, username, password, role) KEY(id)
VALUES (1, 'admin', '$2a$10$xEE0kCPzyeOk/PL2nQJZ0.K0v.rpU7u9BTkr7o7xrZu9LHp5gSS3K', 'ROLE_ADMIN');

-- Categories
MERGE INTO categories (id, name) KEY(id)
VALUES (1,'Business'), (2,'Philosophy'), (3,'Fiction'), (4,'Self-Help'), (5,'History'), (6,'Science'), (7,'Psychology');

-- 1. Atomic Habits
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  1, 'atomic-habits', 'Atomic Habits', 'James Clear',
  'https://m.media-amazon.com/images/I/81bGKUa1e0L._AC_UF1000,1000_QL80_.jpg',
  'A scientifically backed, deeply practical guide to building good habits and breaking bad ones through tiny, 1% improvements every day. James Clear distills decades of research into a four-step loop — cue, craving, response, reward — and shows how to engineer your environment, identity, and routines to make change effortless.',
  'James Clear was hit in the face by a baseball bat during a high-school game, suffering a fractured skull. His long recovery forced him to rely on small, consistent habits to rebuild strength and coordination. He later became a competitive weightlifter by applying the same principles, and started blogging about habit formation before this book exploded into a global phenomenon.',
  'EASY', '320 pages', 'Actionable, Direct, Clear',
  'A step-by-step framework: the four laws of behavior change. Expect concrete tactics — habit stacking, implementation intentions, temptation bundling, and designing your environment. No filler chapters.',
  'Do not judge it as motivational fluff. It is a systems-design manual for human behavior. The title is literal: "atomic" means both tiny and foundational — not "nuclear-strength". Expect a reference manual, not a one-read wonder.',
  'A permanent shift in how you think about change. You will audit your environment differently, notice habit loops you were blind to, and have a concrete vocabulary for designing daily routines.',
  6.5, 5, 'YES', 95, 'Very High — saves months of wasted trial-and-error', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (1, 4), (1, 1);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (1, 'The most actionable habit book ever written — frameworks actually work in real life.'),
       (1, 'Permanent mental model shift on identity-based behavior change.'),
       (1, 'Avoids fluff entirely; every page earns its place.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (1, 1, 'Amazon', 'https://www.amazon.com/Atomic-Habits-Proven-Build-Break/dp/0735211299');

-- 2. Thinking, Fast and Slow
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  2, 'thinking-fast-and-slow', 'Thinking, Fast and Slow', 'Daniel Kahneman',
  'https://m.media-amazon.com/images/I/71f6Dcg9ENL._AC_UF1000,1000_QL80_.jpg',
  'A Nobel laureate psychologist reveals the two systems that drive the way we think: System 1 (fast, intuitive, emotional) and System 2 (slow, deliberative, logical). Kahneman unpacks cognitive biases — anchoring, availability heuristic, loss aversion — that shape every decision we make, often without our awareness.',
  'Daniel Kahneman won the Nobel Prize in Economics despite being a psychologist, because his behavioral economics research (done with his lifelong collaborator Amos Tversky) fundamentally overturned rational-agent theory. Tversky died before the Nobel was awarded; Kahneman has said the prize should have been shared.',
  'CHALLENGING', '499 pages', 'Academic, Dense, Fascinating',
  'Dense, research-heavy chapters. Expect statistical concepts, clinical studies, and deep analysis of human error. The book is structured as a journey, but each chapter stands alone. Plan to read slowly.',
  'Do not expect a light beach read. It requires active concentration. Also do not expect prescriptions — Kahneman is honest that knowing about biases barely helps you avoid them.',
  'You will recognize cognitive biases in yourself, in news media, in financial decisions. A fundamental vocabulary upgrade for any serious thinker.',
  15.0, 4, 'CONDITIONAL', 80, 'Moderate — essential knowledge, but takes real effort to internalize', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (2, 7), (2, 1);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (2, 'Incredible, paradigm-shifting insights into human irrationality.'),
       (2, 'Can be very dense and academic — requires patience.'),
       (2, 'Worth reading slowly rather than racing through it.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (2, 2, 'Amazon', 'https://www.amazon.com/Thinking-Fast-Slow-Daniel-Kahneman/dp/0374533555');

-- 3. Dune
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  3, 'dune', 'Dune', 'Frank Herbert',
  'https://m.media-amazon.com/images/I/81ym3QUd3KL._AC_UF1000,1000_QL80_.jpg',
  'Set on the desert planet Arrakis, Dune tells the story of Paul Atreides as his noble family is thrust into a brutal political struggle for control of the most valuable substance in the galaxy — spice melange. A sweeping epic of political intrigue, religion, ecology, and human destiny that reshaped the entire science-fiction genre.',
  'Frank Herbert was a journalist researching sand dunes in Oregon for a magazine article about the USDA''s project to stop the dunes'' spread. The article was never published, but his obsession with ecology deepened into a 6-year research project that became Dune. It was rejected by 23 publishers before being accepted — by a car-manual publisher.',
  'CHALLENGING', '896 pages', 'Epic, Atmospheric, Complex',
  'Immersive world-building so deep it has its own glossary. Slow opening 100 pages that reward patience. Political intrigue, philosophical musings, and multiple POV characters. Not a plot-driven thriller.',
  'Do not judge it like a plot-driven action novel. The first 100 pages are setup-heavy. Do not compare it to the films — the book goes far deeper into Paul''s prescient consciousness and the political machinations.',
  'An appreciation for one of the foundational texts of modern science fiction. A new framework for thinking about ecology, power, and the danger of charismatic leaders.',
  25.0, 5, 'YES', 95, 'High — profound cultural literacy and lifelong reference point', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (3, 3);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (3, 'Unmatched world-building — ecology, religion, and politics woven into one epic.'),
       (3, 'Explores timeless themes of power, messiahs, and ecological collapse.'),
       (3, 'The foundational science-fiction novel — cultural literacy alone makes it worth it.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (3, 3, 'Amazon', 'https://www.amazon.com/Dune-Frank-Herbert/dp/0441172717');

-- 4. Sapiens
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  4, 'sapiens', 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari',
  'https://m.media-amazon.com/images/I/713jIoMO3UL._AC_UF1000,1000_QL80_.jpg',
  'A sweeping narrative from the Stone Age to the 21st century asking one deceptively simple question: what made Homo sapiens the dominant species on Earth? Harari''s answer — our unique ability to believe in shared myths like nations, money, and corporations — is simultaneously humbling and thrilling.',
  'Harari originally wrote this in Hebrew as a university history textbook. When it became a surprise bestseller in Israel, he expanded and translated it. Barack Obama, Bill Gates, and Mark Zuckerberg have all publicly recommended it, launching it to 25 million+ copies sold worldwide.',
  'MODERATE', '464 pages', 'Engaging, Provocative, Broad',
  'Sweeping historical narratives told at 10,000-foot altitude. Challenging, sometimes uncomfortable, assertions about human nature. Not a peer-reviewed text — it synthesizes widely. Some chapters hit harder than others.',
  'Do not expect academic rigor or footnoted citations for every claim. Harari is a storyteller with a thesis, not a historian presenting a case. Take his provocations as invitations to think, not conclusions to accept.',
  'A unified, macro-perspective on human history. You will see money, religion, and empire completely differently.',
  12.0, 5, 'YES', 85, 'High — changes how you see civilization itself', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (4, 5);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (4, 'Brilliantly connects the Agricultural Revolution to modern capitalism in one coherent story.'),
       (4, 'The "shared myths" thesis alone is worth the price.'),
       (4, 'Written for a general audience — accessible and engaging throughout.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (4, 4, 'Amazon', 'https://www.amazon.com/Sapiens-Humankind-Yuval-Noah-Harari/dp/0062316095');

-- 5. Meditations
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  5, 'meditations', 'Meditations', 'Marcus Aurelius',
  'https://m.media-amazon.com/images/I/81c2P6Bbn8L._AC_UF1000,1000_QL80_.jpg',
  'The private journal of a Roman Emperor — the most powerful man in the world at the height of Roman civilization — recording his daily Stoic philosophy practice. Written entirely for himself with no intention of publication, it is the most honest and intimate account of a leader''s inner struggle ever committed to paper.',
  'Marcus Aurelius governed Rome from 161 to 180 AD during a period of constant warfare (the Marcomannic Wars) and devastating plague. He wrote these reflections while on military campaigns, in command of half a million soldiers. He never intended them to be read by anyone else — which is why they''re so brutally honest.',
  'MODERATE', '254 pages', 'Aphoristic, Reflective, Ancient',
  'Short, standalone passages — some a sentence, some a paragraph. No narrative arc. Best read slowly, one passage per day. Expect repetition of themes: impermanence, duty, emotional control, and the dichotomy of control.',
  'Do not expect a structured philosophical treatise. It is fragmentary and repetitive by nature — these are daily journal entries, not published essays. Also: some translations are radically different; the Gregory Hays (Modern Library) translation is by far the most readable.',
  'A robust, time-tested mental framework for dealing with adversity, loss, anger, and uncertainty — from someone who faced all of them at scale.',
  6.0, 5, 'YES', 97, 'Extremely High — 2,000-year-old wisdom that applies to every single day', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (5, 2);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (5, 'The most honest and practical philosophy book ever written — from a man with everything at stake.'),
       (5, '2,000-year-old wisdom that reads like it was written this morning.'),
       (5, 'The Gregory Hays translation (Modern Library) is essential — do not pick up a Victorian version.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (5, 5, 'Amazon', 'https://www.amazon.com/Meditations-New-Translation-Marcus-Aurelius/dp/0812968255');

-- 6. The Subtle Art of Not Giving a F*ck
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  6, 'the-subtle-art', 'The Subtle Art of Not Giving a F*ck', 'Mark Manson',
  'https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg',
  'A counterintuitive self-help guide arguing that the key to a good life is not caring about everything — but rather choosing very deliberately what you do care about. Manson argues that modern "positive thinking" culture is toxic, and that embracing pain, failure, and uncertainty is the only path to genuine meaning.',
  'Mark Manson started as a pickup artist blogger who evolved into a personal development writer when he realized most self-help advice was superficial. He packaged Stoic and existentialist philosophy in a profane, conversational voice that resonated with a generation exhausted by toxic positivity.',
  'EASY', '224 pages', 'Irreverent, Honest, Conversational',
  'Humorous, story-driven chapters. Profane language throughout. Surprisingly thoughtful philosophy beneath the brash exterior. A quick read — 4-5 hours. Best consumed in one or two sessions.',
  'Do not dismiss it because of the title or the language. It is actually a modern repackaging of Stoicism and Existentialism. Do not read it expecting life advice you''ve never heard before — the ideas aren''t new, the delivery is.',
  'A useful recalibration of your priorities. You will question which things you actually care about vs. which things you feel culturally obligated to care about.',
  4.5, 4, 'YES', 88, 'High — fast read, genuine perspective shift', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (6, 4);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (6, 'A refreshing antidote to toxic positivity culture.'),
       (6, 'Quick, genuinely funny, and surprisingly deep in places.'),
       (6, 'Accessible entry point to Stoic ideas for readers who find philosophy books dry.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (6, 6, 'Amazon', 'https://www.amazon.com/Subtle-Art-Not-Giving-Counterintuitive/dp/0062457713');

-- 7. Zero to One
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  7, 'zero-to-one', 'Zero to One', 'Peter Thiel',
  'https://m.media-amazon.com/images/I/71RY1L6SmRL._AC_UF1000,1000_QL80_.jpg',
  'Peter Thiel''s contrarian startup philosophy, based on his Stanford lectures. His central thesis: going from 0 to 1 (creating something genuinely new) is infinitely harder and more valuable than going from 1 to n (copying existing models). He argues monopolies are good, competition is for losers, and that most "disruptive" companies aren''t really creating anything new.',
  'Thiel co-founded PayPal, became the first outside investor in Facebook (buying 10% for $500k), and later founded Palantir. He was the first venture capitalist to publicly back Donald Trump in 2016. Love him or hate him, his track record of contrarian bets is extraordinary.',
  'EASY', '195 pages', 'Contrarian, Dense with Ideas, Direct',
  'A short book packed with provocative assertions. Each chapter centers on a bold claim. Not a how-to guide — more a philosophical framework for ambitious thinkers. Some chapters hit harder than others.',
  'Do not judge it by whether you agree with Thiel politically. The business insights stand entirely on their own. Also do not expect operational startup advice — this is strategic and philosophical, not tactical.',
  'A fundamentally different lens for evaluating business ideas. You will stop admiring "competition" and start asking: what valuable company is nobody building?',
  4.0, 4, 'YES', 85, 'High — concise and full of ideas you won''t find in typical business books', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (7, 1);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (7, 'Contrarian ideas that genuinely make you question consensus thinking.'),
       (7, 'Extremely short — reads in a single evening, delivers lasting impact.'),
       (7, 'The "last mover advantage" and "secrets" chapters alone justify reading it.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (7, 7, 'Amazon', 'https://www.amazon.com/Zero-One-Notes-Startups-Future/dp/0804139296');

-- 8. Man's Search for Meaning
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  8, 'mans-search-for-meaning', 'Man''s Search for Meaning', 'Viktor Frankl',
  'https://m.media-amazon.com/images/I/61157nSQEAL._AC_UF1000,1000_QL80_.jpg',
  'A psychiatrist''s account of surviving four Nazi concentration camps — including Auschwitz — and the psychological framework (Logotherapy) he developed from observing what separated those who survived mentally from those who didn''t. The core insight: meaning, not pleasure or power, is the primary human motivational force.',
  'Viktor Frankl was a Viennese psychiatrist who had already developed the foundations of Logotherapy before the war. He, his wife, and his parents were deported to camps in 1942. He survived; most of his family did not. He wrote the first draft of this book in nine days after liberation, intentionally published anonymously because he thought no one would care.',
  'EASY', '165 pages', 'Profound, Personal, Direct',
  'Part memoir, part philosophy. The first half is an account of camp life — brutal, unflinching, but never gratuitous. The second half explains Logotherapy. It is a very short book — readable in a single afternoon.',
  'Do not approach it as a Holocaust history text. It is a psychological and philosophical inquiry into meaning. The suffering is the context, not the subject.',
  'A permanently altered relationship with suffering and purpose. You will ask "why" before you ask "how" in difficult situations. One of the most life-changing short books ever written.',
  3.0, 5, 'YES', 99, 'Incalculably High — one of the most important books ever written', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (8, 2), (8, 7);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (8, 'The most important book on meaning and suffering ever written — full stop.'),
       (8, 'Absurdly short for how much it changes you. A single afternoon investment.'),
       (8, 'Reframes every personal hardship you will ever face.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (8, 8, 'Amazon', 'https://www.amazon.com/Mans-Search-Meaning-Viktor-Frankl/dp/0807014273');

-- 9. The Psychology of Money
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  9, 'psychology-of-money', 'The Psychology of Money', 'Morgan Housel',
  'https://m.media-amazon.com/images/I/71g2ednj0JL._AC_UF1000,1000_QL80_.jpg',
  'A collection of 19 short stories exploring the strange and counterintuitive ways people think about money. Housel argues that financial success has less to do with intelligence or access to information and more to do with behavior, temperament, and long time-horizons. The most underrated personal finance book of the decade.',
  'Morgan Housel is a former Wall Street Journal columnist who became a partner at the Collaborative Fund. He started writing this book as a memo that went viral in the investing community. He deliberately wrote it as standalone essays rather than a linear argument, which is why it is so re-readable.',
  'EASY', '256 pages', 'Conversational, Storytelling, Insightful',
  'Short, self-contained chapters — each a standalone essay with a single core idea. Stories from history woven into practical insight. No spreadsheets, no financial formulas. Accessible to anyone.',
  'Do not expect specific investment advice or asset allocation strategies. This is behavioral finance, not financial planning. Do not read it for a "system" — read it for a worldview.',
  'A completely different relationship with risk, wealth, and long-term thinking. You will stop comparing your portfolio to others and start asking if your financial behavior matches your actual goals.',
  5.0, 5, 'YES', 93, 'Very High — behavioral shift that compounds over your lifetime', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (9, 1), (9, 7);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (9, 'The best explanation of why smart people make terrible financial decisions.'),
       (9, 'Story-driven and effortlessly readable — no finance background needed.'),
       (9, 'The chapter on "room for error" alone is worth the price of the book.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (9, 9, 'Amazon', 'https://www.amazon.com/Psychology-Money-Timeless-lessons-happiness/dp/0857197681');

-- 10. Project Hail Mary
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story,
  difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge,
  expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (
  10, 'project-hail-mary', 'Project Hail Mary', 'Andy Weir',
  'https://m.media-amazon.com/images/I/811mXzGeE2L._AC_UF1000,1000_QL80_.jpg',
  'A lone astronaut wakes up with amnesia on a spaceship millions of miles from Earth. He has no idea why he''s there. As his memory returns, he realizes he is humanity''s last hope against an extinction-level threat to the Sun. A masterpiece of hard science fiction that is also, somehow, a joyful and profoundly moving story of friendship.',
  'Andy Weir wrote The Martian as a free blog serial, self-published it for 99 cents, then watched it become a Ridley Scott film. Project Hail Mary took 5 years to write. He validated every single scientific concept in the book against actual physics and biology, consulting researchers to ensure even the alien biology was plausible.',
  'EASY', '476 pages', 'Fast-Paced, Scientific, Joyful',
  'A page-turner from page one, even though the setup is deliberately mysterious. Lots of science problem-solving that reads like watching someone crack a puzzle in real time. The alien relationship develops slowly and pays off enormously.',
  'Do not be put off by the science — it is explained in a way that makes you feel clever for following it. Do not read the back cover or any review that hints at the plot twist.',
  'Pure, elated, reading joy. This is the rare book that makes you feel good about being a human and about science. One of the most purely entertaining books of the decade.',
  14.0, 5, 'YES', 92, 'High — 14 hours of the best entertainment hard sci-fi can offer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (10, 3), (10, 6);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason)
VALUES (10, 'The most genuinely joyful reading experience in modern science fiction.'),
       (10, 'The alien relationship is unlike anything else in the genre.'),
       (10, 'Hard science that is completely accessible — makes you feel like a scientist.');
MERGE INTO external_links (id, book_id, label, url) KEY(id) VALUES (10, 10, 'Amazon', 'https://www.amazon.com/Project-Hail-Mary-Andy-Weir/dp/0593135202');


-- 11. Deep Work
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (11, 'deep-work', 'Deep Work', 'Cal Newport', 'https://m.media-amazon.com/images/I/71N2HwXkGUL._AC_UF1000,1000_QL80_.jpg', 'A compelling case for cultivating the ability to focus without distraction in a distracted world.', 'Newport earned his PhD from MIT and achieved tenure at Georgetown while rarely working past 5 PM.', 'MODERATE', '304 pages', 'Analytical, Academic, Direct', 'A mix of philosophical arguments against distraction and practical advice on scheduling focus time.', 'Do not judge it as just anti-social media rhetoric. It is about creating cognitive value.', 'You will restructure your workday to protect focus time.', 7.0, 5, 'YES', 95, 'High — double your productivity', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (11, 1), (11, 4);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (11, 'Essential skill for the 21st century.'), (11, 'Actionable frameworks for restructuring work.');

-- 12. Essentialism
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (12, 'essentialism', 'Essentialism', 'Greg McKeown', 'https://m.media-amazon.com/images/I/71vK0NAjT2L._AC_UF1000,1000_QL80_.jpg', 'The disciplined pursuit of less. A guide to figuring out what is essential and eliminating everything else.', 'McKeown was stretched thin consulting in Silicon Valley when he realized he was successful but miserable.', 'EASY', '272 pages', 'Encouraging, Minimalist, Clear', 'Short chapters, lots of diagrams. Easy to read quickly.', 'Do not expect a time management book. It is a priority management book.', 'You will learn how to gracefully say no to 90% of requests.', 5.0, 4, 'YES', 90, 'High — reclaims hours every week', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (12, 1), (12, 4);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (12, 'The best book on the art of saying no.'), (12, 'Helps cure "straddling" multiple conflicting priorities.');

-- 13. Range
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (13, 'range', 'Range', 'David Epstein', 'https://m.media-amazon.com/images/I/71J1x8gP-5L._AC_UF1000,1000_QL80_.jpg', 'Why generalists triumph in a specialized world. Argues against early specialization in sports, music, and careers.', 'Epstein started as an environmental scientist before becoming an investigative journalist.', 'MODERATE', '352 pages', 'Journalistic, Research-heavy, Engaging', 'Story-driven chapters backed by sports science and psychology.', 'Do not read it as an excuse to never commit. It is about lateral thinking.', 'You will stop feeling behind if you have not picked a single lane in life.', 9.0, 5, 'YES', 92, 'Very High — cures career anxiety', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (13, 6), (13, 7);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (13, 'Brilliantly dismantles the 10,000 hours rule.'), (13, 'Incredibly reassuring for anyone with diverse interests.');

-- 14. The Alchemist
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (14, 'the-alchemist', 'The Alchemist', 'Paulo Coelho', 'https://m.media-amazon.com/images/I/71aFt4+OTOL._AC_UF1000,1000_QL80_.jpg', 'A fable about a shepherd boy on a journey to realize his Personal Legend.', 'Coelho wrote it in just two weeks in 1987, stating the story was already written in his soul.', 'EASY', '167 pages', 'Lyrical, Simple, Allegorical', 'A simple story that reads like a fairy tale. Very short.', 'Do not read it expecting a complex fantasy novel. It is an allegory.', 'A sense of renewed purpose and belief in following your intuition.', 3.5, 3, 'CONDITIONAL', 75, 'Moderate — highly polarizing', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (14, 3);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (14, 'Inspiring for some, too simplistic for others.'), (14, 'A fast read that feels like a modern myth.');

-- 15. Shoe Dog
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (15, 'shoe-dog', 'Shoe Dog', 'Phil Knight', 'https://m.media-amazon.com/images/I/71W8hCgH3sL._AC_UF1000,1000_QL80_.jpg', 'A memoir by the creator of Nike, exploring the messy, near-disastrous early days of the company.', 'Knight started by selling shoes out of the trunk of his Plymouth Valiant in 1963.', 'MODERATE', '400 pages', 'Narrative, Candid, Humorous', 'Reads like a novel. Fast-paced and brutally honest about mistakes.', 'Do not expect a business strategy manual. It is a pure memoir.', 'An understanding of how chaotic building a generational company actually is.', 10.0, 5, 'YES', 96, 'High — the best business memoir ever written', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (15, 1), (15, 5);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (15, 'Incredibly well-written and absorbing.'), (15, 'Demystifies the idea that successful founders always know what they are doing.');

-- 16. Outliers
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (16, 'outliers', 'Outliers', 'Malcolm Gladwell', 'https://m.media-amazon.com/images/I/71wLpW1y1PL._AC_UF1000,1000_QL80_.jpg', 'Explores the story of success, arguing that we pay too much attention to what successful people are like, and too little to where they are from.', 'Gladwell popularized the "10,000-Hour Rule" in this exact book.', 'EASY', '304 pages', 'Engaging, Story-driven, Popular Science', 'Fascinating anecdotes woven into sociological observations.', 'Do not take the 10,000 hour rule as rigid scientific law.', 'You will appreciate the role of timing, culture, and luck in extreme success.', 7.5, 4, 'YES', 85, 'High — changes how you view meritocracy', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (16, 7), (16, 1);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (16, 'Classic Gladwell storytelling — unputdownable.'), (16, 'Provides essential context for understanding extreme outliers.');

-- 17. Good to Great
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (17, 'good-to-great', 'Good to Great', 'Jim Collins', 'https://m.media-amazon.com/images/I/61y4mC70-9L._AC_UF1000,1000_QL80_.jpg', 'Examines how good companies make the leap to truly great companies based on a 5-year research project.', 'Collins assembled a team of 21 researchers who read and coded 6,000 articles and generated 2,000 pages of interview transcripts.', 'MODERATE', '320 pages', 'Analytical, Corporate, Research-backed', 'Core concepts like Level 5 Leadership, the Hedgehog Concept, and the Flywheel.', 'Do not dismiss it because some of the featured companies later failed. The principles hold.', 'A framework for evaluating corporate leadership and strategy.', 8.0, 4, 'YES', 88, 'High — foundational business vocabulary', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (17, 1);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (17, 'The Flywheel effect is a critical mental model.'), (17, 'Data-driven rather than purely anecdotal.');

-- 18. Thinking in Bets
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (18, 'thinking-in-bets', 'Thinking in Bets', 'Annie Duke', 'https://m.media-amazon.com/images/I/71I2tI+8fYL._AC_UF1000,1000_QL80_.jpg', 'A former World Series of Poker champion explains how to make decisions when you do not have all the facts.', 'Duke was an academic studying cognitive psychology before she dropped out to play professional poker.', 'MODERATE', '288 pages', 'Practical, Insightful, Direct', 'Combines poker anecdotes with behavioral economics.', 'Do not expect poker strategies. It is entirely about decision theory.', 'You will stop equating the quality of a decision with the quality of its outcome (resulting).', 6.5, 4, 'YES', 91, 'High — drastically reduces outcome-based regret', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (18, 1), (18, 7);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (18, 'Cures "resulting" — judging decisions strictly by outcomes.'), (18, 'Makes probability and risk assessment accessible.');

-- 19. Educated
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (19, 'educated', 'Educated', 'Tara Westover', 'https://m.media-amazon.com/images/I/81WojUxbbFL._AC_UF1000,1000_QL80_.jpg', 'A memoir about growing up in a survivalist family in Idaho, with no formal education, and eventually earning a PhD from Cambridge.', 'Westover did not set foot in a classroom until she was 17 years old.', 'MODERATE', '352 pages', 'Gripping, Emotional, Reflective', 'A harrowing, beautifully written memoir. Heavy themes of abuse and gaslighting.', 'Do not read it as a political statement; it is deeply personal.', 'Profound appreciation for the privilege and transformative power of education.', 9.0, 5, 'YES', 95, 'High — a masterpiece of modern memoir', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (19, 5);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (19, 'Incredibly moving narrative of self-invention.'), (19, 'Explores the painful cost of breaking away from family.');

-- 20. Factfulness
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (20, 'factfulness', 'Factfulness', 'Hans Rosling', 'https://m.media-amazon.com/images/I/812P-jIDiIL._AC_UF1000,1000_QL80_.jpg', 'Ten reasons we are wrong about the world — and why things are better than you think. A data-driven antidote to pessimism.', 'Rosling wrote the final chapters of this book from his deathbed, determined to leave a legacy of optimism.', 'EASY', '352 pages', 'Optimistic, Data-heavy, Accessible', 'Full of charts, quizzes, and surprising statistics about global health and wealth.', 'Do not mistake it for blind optimism; it is "possibilism".', 'You will realize the world is steadily improving on almost every macro metric.', 8.0, 4, 'YES', 93, 'High — permanently cures cynical worldviews', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (20, 6), (20, 7);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (20, 'The best defense against news-induced despair.'), (20, 'Data visualization at its absolute best.');

-- 21. Drive
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (21, 'drive', 'Drive', 'Daniel H. Pink', 'https://m.media-amazon.com/images/I/71LqO6XvM2L._AC_UF1000,1000_QL80_.jpg', 'The surprising truth about what motivates us. Argues that autonomy, mastery, and purpose are the real drivers of high performance, not carrots and sticks.', 'Pink served as Al Gore''s chief speechwriter before becoming a business author.', 'EASY', '288 pages', 'Engaging, Synthesis, Practical', 'A synthesis of decades of psychological research on motivation.', 'Do not apply it to algorithmic, repetitive tasks where carrots/sticks still work.', 'You will rethink how you manage teams and yourself.', 6.0, 4, 'YES', 87, 'High — essential for managers and creatives', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (21, 1), (21, 7);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (21, 'Clear articulation of Autonomy, Mastery, and Purpose.'), (21, 'Highly applicable to modern knowledge work.');

-- 22. Born a Crime
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (22, 'born-a-crime', 'Born a Crime', 'Trevor Noah', 'https://m.media-amazon.com/images/I/81xDcyV2nVL._AC_UF1000,1000_QL80_.jpg', 'Stories from a South African childhood. Trevor Noah''s unbelievable path from apartheid South Africa to the desk of The Daily Show.', 'Noah was literally born a crime — the mixed-race child of a white Swiss father and a black Xhosa mother, which was illegal in South Africa at the time.', 'EASY', '304 pages', 'Hilarious, Heartbreaking, Honest', 'Incredible storytelling. Best consumed as an audiobook (read by Trevor Noah himself).', 'Do not think it is just a comedian''s vanity project. It is deeply moving literature.', 'A vivid, personal understanding of apartheid''s absurdity and horror.', 8.0, 5, 'YES', 98, 'Very High — one of the most entertaining memoirs ever', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (22, 5);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (22, 'Masterful balance of comedy and profound tragedy.'), (22, 'A beautiful tribute to his fearless mother.');

-- 23. Principles
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (23, 'principles', 'Principles', 'Ray Dalio', 'https://m.media-amazon.com/images/I/71uAI28kBjL._AC_UF1000,1000_QL80_.jpg', 'Life and work principles from the founder of Bridgewater Associates, the largest hedge fund in the world. Centers on "radical transparency" and algorithmic decision-making.', 'Dalio was fired from his early job for punching his boss in the face, which led him to start Bridgewater from his apartment.', 'CHALLENGING', '592 pages', 'Systematic, Dense, Repetitive', 'Part autobiography, part reference manual. Best read in chunks.', 'Do not expect to adopt every principle. It is an extreme system that works for him.', 'You will view your own life as an evolving machine that can be debugged.', 15.0, 4, 'CONDITIONAL', 82, 'Moderate — valuable but requires filtering for your own life', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (23, 1), (23, 4);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (23, 'Incredible insights on building "idea meritocracies".'), (23, 'Can be extremely dry and robotic in tone.');

-- 24. The Lean Startup
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (24, 'the-lean-startup', 'The Lean Startup', 'Eric Ries', 'https://m.media-amazon.com/images/I/81-QB7nDh4L._AC_UF1000,1000_QL80_.jpg', 'A methodology for building companies under conditions of extreme uncertainty. Focuses on the Build-Measure-Learn feedback loop and validated learning.', 'Ries developed the methodology after a massive failure at his previous startup, where they built a product for months that nobody wanted.', 'MODERATE', '336 pages', 'Tactical, Iterative, Silicon-Valley', 'Core concepts like MVP (Minimum Viable Product) and pivoting.', 'Do not assume it only applies to tech startups. It applies to any new venture.', 'A framework for testing assumptions before wasting time building the wrong thing.', 7.0, 4, 'YES', 90, 'High — mandatory reading for any entrepreneur', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (24, 1);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (24, 'The foundational text for modern product development.'), (24, 'Saves founders years of wasted engineering time.');

-- 25. Why We Sleep
MERGE INTO books (id, slug, title, author_name, cover_image, about_description, author_true_story, difficulty_level, length_label, language_tone, what_to_expect, how_not_to_judge, expected_outcome, expected_time_investment, our_rating, verdict, confidence_percentage, estimated_roi, created_at, updated_at)
KEY(id) VALUES (25, 'why-we-sleep', 'Why We Sleep', 'Matthew Walker', 'https://m.media-amazon.com/images/I/71uKzR8jYTL._AC_UF1000,1000_QL80_.jpg', 'A neuroscientist explains the critical importance of sleep and dreams. Unlocks the science behind how sleep enriches our ability to learn, memorize, and make logical decisions.', 'Walker has spent decades as a professor of neuroscience and psychology at UC Berkeley, researching the impact of sleep on human health.', 'MODERATE', '368 pages', 'Scientific, Alarming, Fascinating', 'A lot of terrifying data about what happens when you sleep less than 7 hours.', 'Do not read it right before bed if you have insomnia — it might give you anxiety.', 'You will permanently prioritize 8 hours of sleep over almost anything else.', 9.0, 4, 'YES', 88, 'High — a literal life-extender', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
MERGE INTO book_categories (book_id, category_id) KEY(book_id, category_id) VALUES (25, 6), (25, 4);
MERGE INTO book_verdict_reasons (book_id, reason) KEY(book_id, reason) VALUES (25, 'The most convincing argument for prioritizing sleep ever written.'), (25, 'Some claims have been criticized as exaggerated, but the core thesis holds.');

