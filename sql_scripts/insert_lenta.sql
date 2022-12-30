--insert data from file
INSERT INTO filesdata (filename,xmldata)
VALUES ('******filename******', '******datafromxmlfile******')   --insert file name and data from xml file

--insert categories
WITH n AS (SELECT distinct text(UNNEST(xpath('//item/category/text()', xmldata))) AS category
			FROM filesdata 
		   WHERE filename LIKE 'lenta%')
INSERT INTO categories (categoryname)
SELECT category FROM n
LEFT JOIN categories ON n.category=categories.categoryname
where category_id is NULL;

--insert news
WITH q AS (WITH w AS (WITH n AS (SELECT text(UNNEST(xpath('//item/guid/text()', xmldata))) AS guid,
	   								text(UNNEST(xpath('//item/author/text()', xmldata))) AS author,
	   								text(UNNEST(xpath('//item/title/text()', xmldata))) AS title,
	   								text(UNNEST(xpath('//item/link/text()', xmldata))) AS link,
	   								RTRIM(LTRIM(text(UNNEST(xpath('//item/description[1]', xmldata))), '"<description>
    									<![CDATA['), ']]>
  										</description>') AS description,
	   								cast(text(UNNEST(xpath('//item/pubDate/text()', xmldata))) AS timestamp) AS pubDate,
	   								text(UNNEST(xpath('//item/enclosure/@url', xmldata))) AS enclosure,
	   								text(UNNEST(xpath('//item/category/text()', xmldata))) AS category
									FROM filesdata
									WHERE filename='******filename******')  --insert file name
					SELECT n.*, c.category_id FROM n
					JOIN categories c ON n.category = c.categoryname)
		SELECT w.* FROM w 
		LEFT JOIN news nn ON w.guid = nn.guid
		WHERE nn.guid is NULL)
INSERT INTO news ( title, link, guid, pubdate, description, author, enclosure, pdalink, source_id, file_id)
SELECT  q.title, q.link, q.guid, q.pubdate, q.description, q.author, q.enclosure, NULL, '2',
(SELECT file_id FROM filesdata WHERE filename = '******filename******')   --insert file name
FROM q


--insert newscategories
INSERT INTO newscategories (news_id, category_id)
WITH a AS (WITH o AS (WITH l AS (SELECT text(UNNEST(xpath('//item/guid/text()', xmldata))) AS guid,
	   								text(UNNEST(xpath('//item/category/text()', xmldata))) AS category
									FROM filesdata
									WHERE filename='******filename******')   --insert file name
						SELECT n.news_id, n.guid, l.category
						FROM news n
						JOIN l ON n.guid = l.guid)
		SELECT o.*, c.category_id FROM o
		JOIN categories c ON o.category = c.categoryname)
SELECT a.news_id, a.category_id FROM a 
LEFT JOIN newscategories nc ON a.news_id = nc.news_id
where nc.news_id is NULL
