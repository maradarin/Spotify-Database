-- Section 3
-- Inserting data into table
-- Alternating between manual and automatic
-- insertion to prove the sequences'
-- correctitude and utility

INSERT INTO artist VALUES (1, 'Arctic Monkeys', 7);
INSERT INTO artist VALUES (2,'Miley Cyrus', 7);
INSERT INTO artist VALUES (3,'Halsey', 5);
EXECUTE inserari.inserare_artist('P!nk', 10);
EXECUTE inserari.inserare_artist('Nothing But Thieves', 4);
EXECUTE inserari.inserare_artist('AC/DC', 21);
EXECUTE inserari.inserare_artist('Queen', 44);
EXECUTE inserari.inserare_artist('The Weeknd', 44);
COMMIT;

INSERT INTO artist VALUES (28,'Manual', 1);
EXECUTE inserari.inserare_artist('Automat', 2);
SELECT * FROM artist;
DELETE FROM artist WHERE id_artist IN (28, 29);


INSERT INTO ALBUM VALUES (1,1,'09-SEP-13','AM', null);
INSERT INTO ALBUM VALUES (2,1,'18-APR-07','Favourite Worst Nightmare', null);
INSERT INTO ALBUM VALUES (3,2,'27-NOV-20','Plastic Hearts',t_colaborator(r_colaborator('Billy Idol', 6), r_colaborator('Joan Jett', 10)));
INSERT INTO ALBUM VALUES (4,3,'02-JUN-17','Hopeless Fountain Kingdom',t_colaborator(r_colaborator('Lauren Jauregui', 13)));
EXECUTE inserari.inserare_album(5, '08-SEP-17', 'Broken Machine');
EXECUTE inserari.inserare_album(5, '16-OCT-15', 'Nothing but Thieves');
EXECUTE inserari.inserare_album(6, '25-JUL-80', 'Back in Black');
EXECUTE inserari.inserare_album(6, '27-JUL-79', 'Highway To Hell');
EXECUTE inserari.inserare_album(6, '20-SEP-76', 'Dirty Deeds Done Dirt Cheap');
EXECUTE inserari.inserare_album(7, '21-NOV-75', 'A Night at the Opera');
EXECUTE inserari.inserare_album(7, '08-MAR-74', 'Queen II');
EXECUTE inserari.inserare_album(8, '20-Mar-20', 'After Hours');
EXECUTE inserari.inserare_album(8, '28-AUG-15', 'Beauty Behind the Madness');
EXECUTE inserari.inserare_album(8, '21-MAR-11', 'House of Balloons');
EXECUTE inserari.inserare_album(4, '24-OCT-08', 'Funhouse');
EXECUTE inserari.inserare_album(4, '12-SEP-12', 'The Truth About Love');
EXECUTE inserari.inserare_album(5, '23-OCT-20', 'Moral Panic');
EXECUTE inserari.inserare_album(3, '17-JAN-20', 'Manic');
SELECT * FROM album;


EXECUTE inserari.inserare_genre('Indie Rock');
EXECUTE inserari.inserare_genre('Psychedelic rock');
EXECUTE inserari.inserare_genre('Alternative rock');
EXECUTE inserari.inserare_genre('Pop-rock');
EXECUTE inserari.inserare_genre('Rock-ballad');
EXECUTE inserari.inserare_genre('Alternative RB');
EXECUTE inserari.inserare_genre('Synth-Pop');
EXECUTE inserari.inserare_genre('Nu Disco');
EXECUTE inserari.inserare_genre('Electro-Pop');
EXECUTE inserari.inserare_genre('Dark-Pop');
EXECUTE inserari.inserare_genre('Punk-rock');
EXECUTE inserari.inserare_genre('Pop-punk');
EXECUTE inserari.inserare_genre('Alternative-pop');
EXECUTE inserari.inserare_genre('Electronic');
EXECUTE inserari.inserare_genre('Electro-pop');
EXECUTE inserari.inserare_genre('Synth-pop');
EXECUTE inserari.inserare_genre('Ballad');
EXECUTE inserari.inserare_genre('Baroque-pop');
EXECUTE inserari.inserare_genre('Pop-country');
EXECUTE inserari.inserare_genre('K-Pop');
EXECUTE inserari.inserare_genre('Electronic-rock');
EXECUTE inserari.inserare_genre('Experimental-rock');
EXECUTE inserari.inserare_genre('Heavy-metal');
SELECT * FROM GENRE order by id_genre;


EXECUTE inserari.inserare_song(1, 3, 'Do I Wanna Know', 'Diamond');
EXECUTE inserari.inserare_song(1, 2, 'R U Mine?', 'Multi-platinum');
EXECUTE inserari.inserare_song(1, 3, 'One for the Road', 'Gold');
EXECUTE inserari.inserare_song(1, 3, 'Arabella', 'Multi-platinum');
EXECUTE inserari.inserare_song(1, 3, 'I Want It All', 'Gold');
EXECUTE inserari.inserare_song(1, 1, 'No. 1 Party Anthem', 'Platinum');
EXECUTE inserari.inserare_song(1, 1, 'Mad Sounds', 'Gold');
EXECUTE inserari.inserare_song(1, 3, 'Fireside', 'Gold');
EXECUTE inserari.inserare_song(1, 3, 'Why''d You Only Call Me When You''re High', 'Platinum');
EXECUTE inserari.inserare_song(1, 4, 'Snap Out of It', 'Platinum');
EXECUTE inserari.inserare_song(1, 3, 'Knee Socks', 'Platinum');
EXECUTE inserari.inserare_song(1, 2, 'I Wanna Be Yours', 'Multi-platinum');

EXECUTE inserari.inserare_song(2, 2, 'Balaclava', 'Gold');

EXECUTE inserari.inserare_song(3, 4, 'WTF Do I Know', 'Platinum');
EXECUTE inserari.inserare_song(3, 3, 'Plastic Hearts', 'Platinum');
EXECUTE inserari.inserare_song(3, 5, 'Angels like you', 'Gold');
EXECUTE inserari.inserare_song(3, 10, 'Prisoner', 'Multi-platinum');
EXECUTE inserari.inserare_song(3, 11, 'Gimme What I Want', 'Gold');
EXECUTE inserari.inserare_song(3, 10, 'Night Crawling', 'Platinum');
EXECUTE inserari.inserare_song(3, 3, 'Midnight Sky', 'Multi-platinum');
EXECUTE inserari.inserare_song(3, 4, 'High', 'Platinum');
EXECUTE inserari.inserare_song(3, 12, 'Hate Me', 'Gold');
EXECUTE inserari.inserare_song(3, 3, 'Bad Karma', 'Multi-platinum');
EXECUTE inserari.inserare_song(3, 3, 'Never Be Me', 'Gold');
EXECUTE inserari.inserare_song(3, 3, 'Golden G String', 'Gold');

EXECUTE inserari.inserare_song(4, 13, '100 Letters', 'Gold');
EXECUTE inserari.inserare_song(4, 14, 'Eyes Closed', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Heaven in Hiding', 'Platinum');
EXECUTE inserari.inserare_song(4, 15, 'Alone', 'Multi-platinum');
EXECUTE inserari.inserare_song(4, 16, 'Now or Never', 'Multi-platinum');
EXECUTE inserari.inserare_song(4, 17, 'Sorry', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Lie', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Walls Could Talk', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Bad at Love', 'Diamond');
EXECUTE inserari.inserare_song(4, 13, 'Don''t Play', 'Gold');
EXECUTE inserari.inserare_song(4, 16, 'Strangers', 'Multi-platinum');
EXECUTE inserari.inserare_song(4, 13, 'Angel on Fire', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Devil in Me', 'Gold');
EXECUTE inserari.inserare_song(4, 14, 'Hopeless', 'Gold');

EXECUTE inserari.inserare_song(5, 3, 'I Was Just A Kid', 'Gold');
EXECUTE inserari.inserare_song(5, 1, 'Amsterdam', 'Multi-platinum');
EXECUTE inserari.inserare_song(5, 3, 'Sorry', 'Platinum');
EXECUTE inserari.inserare_song(5, 1, 'Broken Machine', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Live Like Animals', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Soda', 'Gold');
EXECUTE inserari.inserare_song(5, 4, 'I''m Not Made By Design', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Particles', 'Platinum');
EXECUTE inserari.inserare_song(5, 21, 'Get Better', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Hell, Yeah', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Afterlife', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Reset Me', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Number 13', 'Gold');

EXECUTE inserari.inserare_song(6, 3, 'Excuse Me', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Ban All The Music', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Wake Up Call', 'Gold');
EXECUTE inserari.inserare_song(6, 22, 'Itch', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'If I Get High', 'Platinum');
EXECUTE inserari.inserare_song(6, 3, 'Graveyard Whistling', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Hostage', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Trip Switch', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Lover, Please Stay', 'Platinum');
EXECUTE inserari.inserare_song(6, 1, 'Drawing Pins', 'Platinum');
EXECUTE inserari.inserare_song(6, 3, 'Painkiller', 'Gold');
EXECUTE inserari.inserare_song(6, 1, 'Tempt You (Evocatio)', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Honey Whiskey', 'Gold');
EXECUTE inserari.inserare_song(6, 1, 'Hanging', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Neon Brother', 'Gold');
EXECUTE inserari.inserare_song(6, 22, 'Six Billion', 'Gold');

EXECUTE inserari.inserare_song(7, 23, 'Back in Black', 'Diamond');

EXECUTE inserari.inserare_song(14, 6, 'High for This', 'Gold');
EXECUTE inserari.inserare_song(14, 6, 'What You Need', 'Gold');
EXECUTE inserari.inserare_song(14, 6, 'Wicked Games', 'Platinum');
EXECUTE inserari.inserare_song(14, 6, 'The Morning', 'Gold');
EXECUTE inserari.inserare_song(14, 6, 'Coming Down', 'Gold');

EXECUTE inserari.inserare_song(12, 7, 'Alone Again', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Too Late', 'Platinum');
EXECUTE inserari.inserare_song(12, 8, 'Hardest to Love', 'Platinum');
EXECUTE inserari.inserare_song(12, 7, 'Scared To Live', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Snowchild', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Escape From LA', 'Gold');
EXECUTE inserari.inserare_song(12, 9, 'Heartless', 'Diamond');
EXECUTE inserari.inserare_song(12, 8, 'Faith', 'Gold');
EXECUTE inserari.inserare_song(12, 8, 'Blinding Lights', 'Diamond');
EXECUTE inserari.inserare_song(12, 7, 'In Your Eyes', 'Multi-Platinum');
EXECUTE inserari.inserare_song(12, 8, 'Save Your Tears', 'Gold');
EXECUTE inserari.inserare_song(12, 10, 'Repeat After Me', 'Gold');
EXECUTE inserari.inserare_song(12, 9, 'After Hours', 'Gold');
EXECUTE inserari.inserare_song(12, 9, 'Until I Bleed Out', 'Gold');
EXECUTE inserari.inserare_song(12, 8, 'Nothing Compares', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Missed You', 'Gold');
EXECUTE inserari.inserare_song(12, 6, 'Final Lullaby', 'Gold');

EXECUTE inserari.inserare_song(17, 3, 'Unperson', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'Is Everybody Going Crazy', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'Moral Panic', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Real Love Song', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'Phobia', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'This Feels Like the End', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Free If We Want It', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Impossible', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'There Was Sun', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Can You Afford to Be an Individual', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Before We Drift Away', 'Gold');


EXECUTE inserari.inserare_song(18, 13, 'Ashley', 'Gold');
EXECUTE inserari.inserare_song(18, 18, 'clementine', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'Graveyard', 'Platinum');
EXECUTE inserari.inserare_song(18, 19, 'You should be sad', 'Multi-platinum');
EXECUTE inserari.inserare_song(18, 13, 'Forever... (is a long time)', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'Dominic''s Interlude', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'I HATE EVERYBODY', 'Gold');
EXECUTE inserari.inserare_song(18, 12, '3 am', 'Gold');
EXECUTE inserari.inserare_song(18, 16, 'Without Me', 'Diamond');
EXECUTE inserari.inserare_song(18, 17, 'Finally // beautiful stranger', 'Platinum');
EXECUTE inserari.inserare_song(18, 1, 'Alanis'' Interlude', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'killing boys', 'Gold');
EXECUTE inserari.inserare_song(18, 20, 'SUGA''s Interlude', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'More', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'Still Learning', 'Gold');
EXECUTE inserari.inserare_song(18, 13, '929', 'Gold');
SELECT * FROM song;


EXECUTE inserari.inserare_user('user1', 'user1@gmail.com', 'Free');
EXECUTE inserari.inserare_user('user2', 'user2@gmail.com', 'Premium');
EXECUTE inserari.inserare_user('user3', 'user3@gmail.com', 'Premium');
EXECUTE inserari.inserare_user('user4', 'user4@gmail.com', 'Free');
EXECUTE inserari.inserare_user('user5', 'user5@gmail.com', 'Free');
EXECUTE inserari.inserare_user('user6', 'user6@gmail.com', 'Free');
SELECT * FROM user_log;


EXECUTE inserari.inserare_playlist(1, 'edgy', 1);
EXECUTE inserari.inserare_playlist(1, 'love', 1);
EXECUTE inserari.inserare_playlist(1, 'BEST OF NBT', 1);
EXECUTE inserari.inserare_playlist(2, 'guitar', 0);
EXECUTE inserari.inserare_playlist(3, 'Girl Power', 0);
EXECUTE inserari.inserare_playlist(3, 'Dark', 1);
EXECUTE inserari.inserare_playlist(4, 'Cultural Reset', 0);
EXECUTE inserari.inserare_playlist(4, 'rockkkk', 1);
EXECUTE inserari.inserare_playlist(5, 'Chill', 0);
SELECT * FROM playlist;


EXECUTE inserari.inserare_song_playlist(1, 1, 1);
EXECUTE inserari.inserare_song_playlist(14, 1, 1);
EXECUTE inserari.inserare_song_playlist(40, 1, 1);
EXECUTE inserari.inserare_song_playlist(51, 1, 1);

EXECUTE inserari.inserare_song_playlist(66, 7, 0);
EXECUTE inserari.inserare_song_playlist(60, 7, 1);
EXECUTE inserari.inserare_song_playlist(114, 7, 0);
EXECUTE inserari.inserare_song_playlist(12, 7, 1);

EXECUTE inserari.inserare_song_playlist(100, 8, 1);
EXECUTE inserari.inserare_song_playlist(107, 8, 0);
EXECUTE inserari.inserare_song_playlist(108, 8, 0);
EXECUTE inserari.inserare_song_playlist(114, 8, 0);

EXECUTE inserari.inserare_song_playlist(2, 2, 1)
EXECUTE inserari.inserare_song_playlist(19, 2, 0);
EXECUTE inserari.inserare_song_playlist(14, 2, 1);
EXECUTE inserari.inserare_song_playlist(16, 2, 0);

EXECUTE inserari.inserare_song_playlist(20, 3, 1);
EXECUTE inserari.inserare_song_playlist(13, 3, 1);
EXECUTE inserari.inserare_song_playlist(14, 3, 1);
EXECUTE inserari.inserare_song_playlist(42, 3, 1);
EXECUTE inserari.inserare_song_playlist(23, 3, 1);

EXECUTE inserari.inserare_song_playlist(19, 4, 1);
EXECUTE inserari.inserare_song_playlist(47, 4, 1);
EXECUTE inserari.inserare_song_playlist(9, 4, 1);

EXECUTE inserari.inserare_song_playlist(79, 9, 0);
EXECUTE inserari.inserare_song_playlist(91, 9, 1);
EXECUTE inserari.inserare_song_playlist(118, 9, 0);
EXECUTE inserari.inserare_song_playlist(13, 9, 1);

EXECUTE inserari.inserare_song_playlist(14, 5, 1);
EXECUTE inserari.inserare_song_playlist(23, 5, 0);
EXECUTE inserari.inserare_song_playlist(30, 5, 0);
EXECUTE inserari.inserare_song_playlist(6, 5, 0);

EXECUTE inserari.inserare_song_playlist(16, 6, 1);
EXECUTE inserari.inserare_song_playlist(12, 6, 0);
EXECUTE inserari.inserare_song_playlist(31, 6, 0);
EXECUTE inserari.inserare_song_playlist(41, 6, 0);
SELECT * FROM song_playlist;