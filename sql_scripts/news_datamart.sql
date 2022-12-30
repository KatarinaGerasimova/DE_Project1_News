with overall as (select c.categoryname, count(nc.news_id) as overall--,
					from categories c
					 left join newscategories nc on c.category_id = nc.category_id
					 left join news n on nc.news_id = n.news_id
					group by c.categoryname),
	 ved_overall as (select c.categoryname, count(nc.news_id) as vedomosti_overall
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where s.sourcename = '"Ведомости". Ежедневная деловая газета'
					 group by c.categoryname),
	lenta_overall as (select c.categoryname, count(nc.news_id) as lenta_overall
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where s.sourcename = 'Lenta.ru : Новости'
					 group by c.categoryname
					),
	tass_overall as (select c.categoryname, count(nc.news_id) as tass_overall
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where s.sourcename = 'ИНФОРМАЦИОННОЕ АГЕНТСТВО РОССИИ ТАСС'
					 group by c.categoryname
					),
	overall_last_day as (select  c.categoryname, count(nc.news_id) as overall_last_day
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where date_trunc('day', n.pubdate) >= (current_date - 1)
					 group by c.categoryname),
	vedomosti_last_day as (select  c.categoryname, count(nc.news_id) as vedomosti_last_day
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where date_trunc('day', n.pubdate) >= (current_date - 1) and s.sourcename = '"Ведомости". Ежедневная деловая газета'
					 group by c.categoryname),
	lenta_last_day as (select  c.categoryname, count(nc.news_id) as lenta_last_day
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where date_trunc('day', n.pubdate) >= (current_date - 1) and s.sourcename = 'Lenta.ru : Новости'
					 group by c.categoryname),
	tass_last_day as (select  c.categoryname, count(nc.news_id) as tass_last_day
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where date_trunc('day', n.pubdate) >= (current_date - 1) and s.sourcename = 'ИНФОРМАЦИОННОЕ АГЕНТСТВО РОССИИ ТАСС'
					 group by c.categoryname),
	monday as (select c.categoryname, count(nc.news_id) as monday
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where extract(isodow from pubdate) = 1
					 group by c.categoryname
					),
	tuesday as (select c.categoryname, count(nc.news_id) as tuesday
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where extract(isodow from pubdate) = 2
					 group by c.categoryname
					),
	wednesday as (select c.categoryname, count(nc.news_id) as wednesday
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where extract(isodow from pubdate) = 3
					 group by c.categoryname
					),
	thursday as (select c.categoryname, count(nc.news_id) as thursday
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where extract(isodow from pubdate) = 4
					 group by c.categoryname
					),
	friday as (select c.categoryname, count(nc.news_id) as friday
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where extract(isodow from pubdate) = 5
					 group by c.categoryname
					),
	saturday as (select c.categoryname, count(nc.news_id) as saturday
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where extract(isodow from pubdate) = 6
					 group by c.categoryname
					),
	sunday as (select c.categoryname, count(nc.news_id) as sunday
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 where extract(isodow from pubdate) = 7
					 group by c.categoryname
					),
	avg_per_day as (select  c.categoryname, sum(nc.news_id)/count(date_trunc('day', n.pubdate)) as avg_per_day
					from categories c
					 join newscategories nc on c.category_id = nc.category_id
					 join news n on nc.news_id = n.news_id
					 join sources s on n.source_id = s.source_id
					 group by c.categoryname)
	
						
					select ca.category_id, o.*, vo.vedomosti_overall, lo.lenta_overall, 
					tao.tass_overall, old.overall_last_day, vld.vedomosti_last_day,  lld.lenta_last_day,
					tld.tass_last_day,
					apd.avg_per_day, mo.monday, tu.tuesday, we.wednesday, th.thursday, fr.friday,
					sa.saturday, su.sunday
					from overall o
					join categories ca on o.categoryname = ca.categoryname 
					left join ved_overall vo on o.categoryname = vo.categoryname
					left join lenta_overall lo on o.categoryname = lo.categoryname
					left join tass_overall tao on o.categoryname = tao.categoryname
					left join overall_last_day old on o.categoryname = old.categoryname
					left join vedomosti_last_day vld on o.categoryname = vld.categoryname
					left join lenta_last_day lld on o.categoryname = lld.categoryname
					left join tass_last_day tld on o.categoryname = tld.categoryname
					left join avg_per_day apd on o.categoryname = apd.categoryname
					left join monday mo on o.categoryname = mo.categoryname
					left join tuesday tu on o.categoryname = tu.categoryname
					left join wednesday we on o.categoryname = we.categoryname
					left join thursday th on o.categoryname = th.categoryname
					left join friday fr on o.categoryname = fr.categoryname
					left join saturday sa on o.categoryname = sa.categoryname
					left join sunday su on o.categoryname = su.categoryname
					order by ca.category_id

