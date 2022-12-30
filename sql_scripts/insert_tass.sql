--insert data from file
INSERT INTO filesdata (filename,xmldata)
VALUES ('******filename******', '******datafromxmlfile******')   --insert file name and data from xml file

--insert categories
WITH n AS (SELECT distinct text(UNNEST(xpath('//item/category/text()', xmldata))) AS category
			FROM filesdata 
		   WHERE filename like 'tass%')
INSERT INTO categories (categoryname)
SELECT category FROM n
LEFT JOIN categories ON n.category=categories.categoryname
WHERE category_id is NULL;


--insert news
WITH q AS (WITH w AS (WITH n AS (SELECT RTRIM(LTRIM(text(UNNEST(xpath('//item/title/text()', xmldata))), '<![CDATA['), ']]>') AS title,
	   							RTRIM(LTRIM(text(UNNEST(xpath('//item/link/text()', xmldata))), '<![CDATA['), ']]>') AS link,
	   							RTRIM(LTRIM(text(UNNEST(xpath('//item/guid/text()', xmldata))), '<![CDATA['), ']]>') AS guid,
	   							cast(text(UNNEST(xpath('//item/pubDate/text()', xmldata))) AS timestamp) AS pubDate,
	   							text(UNNEST(xpath('//item/description/text()', xmldata))) AS description,
	   							text(UNNEST(xpath('//item/enclosure/@url', xmldata))) AS enclosure,
	   							RTRIM(LTRIM(text(UNNEST(xpath('//item/category[1]', xmldata))), '<category>'), '</category>') AS category1	   						  
								FROM filesdata
								WHERE filename='******filename******')    --insert file name
					SELECT n.*, c.category_id FROM n
					JOIN categories c ON n.category1 = c.categoryname)
			SELECT w.* FROM w 
			LEFT JOIN news nn ON w.guid = nn.guid
			WHERE nn.guid IS NULL)
INSERT INTO news ( title, link, guid, pubdate, description, author, enclosure, pdalink, source_id, file_id)
SELECT  q.title, q.link, q.guid, q.pubdate, q.description, NULL, q.enclosure, NULL, '3',
(SELECT file_id FROM filesdata WHERE filename = '******filename******')   --insert file name
FROM q;


--insert newscategories
INSERT INTO newscategories (news_id, category_id)
WITH a AS (WITH o AS (WITH l AS (SELECT RTRIM(LTRIM(text(UNNEST(xpath('//item/guid/text()', xmldata))), '<![CDATA['), ']]>') AS guid,
	   							RTRIM(LTRIM(text(UNNEST(xpath('//item/category[1]', xmldata))), '<category>'), '</category>') AS category
								FROM filesdata
								WHERE filename='******filename******')   --insert file name
					SELECT n.news_id, n.guid, l.category
					FROM news n
					JOIN l ON n.guid = l.guid)
		SELECT o.*, c.category_id FROM o
		JOIN categories c ON o.category = c.categoryname)
SELECT a.news_id, a.category_id FROM a 
LEFT JOIN newscategories nc ON a.news_id = nc.news_id
WHERE nc.news_id IS NULL;









