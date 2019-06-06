# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class WebmdItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()

    Supplement = scrapy.Field()
    NReviews = scrapy.Field()
    Reason = scrapy.Field()
    Effectiveness = scrapy.Field()
    EaseOfUse = scrapy.Field()
    Satisfaction = scrapy.Field()
    Gender = scrapy.Field()
    Age = scrapy.Field()
    DatePosted = scrapy.Field()

    pass
