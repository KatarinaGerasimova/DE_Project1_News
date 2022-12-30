--insert data from file
INSERT INTO filesdata (filename,xmldata)
VALUES ('******filename******', '******datafromxmlfile******')   --insert file name and data from xml file

--insert categories
WITH n AS 
	(SELECT DISTINCT text(UNNEST(xpath('//item/category/text()', xmldata))) AS category
	FROM filesdata 
	 WHERE filename LIKE 'vedomosti%')
INSERT INTO categories (categoryname)
SELECT category FROM n
LEFT JOIN categories on n.category=categories.categoryname
WHERE category_id is NULL;

--insert news
WITH q AS 
	(WITH w AS 
		(WITH n AS 
			(SELECT text(UNNEST(xpath('//item/title/text()', xmldata))) AS title,
			text(UNNEST(xpath('//item/link/text()', xmldata))) AS link,
			text(UNNEST(xpath('//item/guid/text()', xmldata))) AS guid,
			text(UNNEST(xpath('//item/pdalink/text()', xmldata))) AS pdalink,
			text(UNNEST(xpath('//item/author/text()', xmldata))) AS author,
			text(UNNEST(xpath('//item/category/text()', xmldata))) AS category,
			text(UNNEST(xpath('//item/enclosure/@url', xmldata))) AS enclosure,
			CAST(text(UNNEST(xpath('//item/pubDate/text()', xmldata))) AS timestamp) AS pubDate
			FROM filesdata
			WHERE filename='******filename******')       --insert file name
		SELECT n.*, c.category_id FROM n
		JOIN categories c on n.category = c.categoryname)
	SELECT w.* FROM w 
	LEFT JOIN news nn on w.guid = nn.guid
	WHERE nn.guid is NULL)
INSERT INTO news ( title, link, guid, pubdate, description, author, enclosure, pdalink, source_id, file_id)
SELECT  q.title, q.link, q.guid, q.pubdate, NULL, q.author, q.enclosure, q.pdalink, '1',
(SELECT file_id from filesdata WHERE filename = '******filename******')   --insert file name
FROM q


--insert newscategories
INSERT INTO newscategories (news_id, category_id)
WITH a AS 
	(WITH o AS 
		(WITH l AS 
			(SELECT text(UNNEST(xpath('//item/guid/text()', xmldata))) AS guid,
			text(UNNEST(xpath('//item/category/text()', xmldata))) AS category
			FROM filesdata
			WHERE filename='******filename******') --insert file name
		SELECT n.news_id, n.guid, l.category
		FROM news n
		JOIN l on n.guid = l.guid)
	SELECT o.*, c.category_id FROM o
	FROM categories c on o.category = c.categoryname)
SELECT a.news_id, a.category_id FROM a --include unique rows
LEFT JOIN newscategories nc on a.news_id = nc.news_id
WHERE nc.news_id is NULL

