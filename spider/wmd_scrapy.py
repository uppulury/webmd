# -*- coding: utf-8 -*-
import scrapy
from scrapy.selector import Selector
from WebMD.items import WebmdItem
import numpy as np
import requests
from scrapy.http import TextResponse

class WmdScrapySpider(scrapy.Spider):
    name = 'wmd_scrapy'
    allowed_domains = ['webmd.com']
    start_urls = ['https://www.webmd.com/vitamins/index']
 
    def parse(self, response):

        rows = response.xpath('//*[@id="ContentPane30"]/div[2]/ul/li').extract()

        Names = []
        NReviews = []
        item = WebmdItem()
        
        for row in range(0,len(rows)):
        # for row in range():
            Names = Selector(text=rows[row]).xpath('//a/text()').extract()[0]           
            Reason = []
            Effectiveness = []
            EaseOfUse = []
            Satisfaction = []
            Gender = []
            Age = []
            DatePosted = []
            Supplement = Names
            NReviews = Selector(text=rows[row]).xpath('//a/text()').extract()[1].split()[2].split('(')[1].split(')')[0]
            url = Selector(text=rows[row]).xpath('//a/@href').extract()[1]   
            
            for k in range(0,int(np.ceil(int(NReviews)/5.0))):
                url_supp = url+"&pageIndex="+str(k)+"&sortby=3&conditionFilter=-1"
                r = requests.get(url_supp)
                response = TextResponse(r.url,body=r.text,encoding='utf-8')
                nrows = response.xpath('//*[@id="ratings_fmt"]/div').extract()
                if k<=int(np.ceil(int(NReviews)/5.0))-2:
                    L = 5
                else:
                    L = int(NReviews)%5

                for m in range(0,L):
                    cnt = m+4
#                   Extract "Reason"
                    Reason.append(Selector(text=nrows[cnt]).xpath('//span/text()').extract()[0])
#                   Extract Effectiveness
                    Effectiveness.append(Selector(text=nrows[cnt]).xpath('//span/text()').extract()[1].split(" ")[2])
#                   Extract EaseOfUse
                    EaseOfUse.append(Selector(text=nrows[cnt]).xpath('//span/text()').extract()[2].split(" ")[2])
#                   Extract Satisfaction
                    Satisfaction.append(Selector(text=nrows[cnt]).xpath('//span/text()').extract()[3].split(" ")[2])
#                   Extract Gender
                    Gender_Text = Selector(text=nrows[cnt]).xpath('//p/text()').extract()[0]
                    Gender_Text = Gender_Text.split(" ")
                    Gender = [i for i in Gender_Text if i=="Female" or i=="Male"]
                    if len(Gender)==0:
                        item['Gender'] = 'NA'
                    else:
                        item['Gender'] = Gender
#                   Extract Age                    
                    Age_Text = Selector(text=nrows[cnt]).xpath('//p/text()').extract()[0]
                    Age_Text = Age_Text.split("-")
                    if len(Age_Text)>=2:
                        A0 = Age_Text[0].split(" ")
                        A1 = Age_Text[1].split(" ")
                        Age = A0[len(A0)-1]+"-"+A1[0]
                    else:
                        Age = 'NA'
#                   Extract DatePosted
                    DatePosted = Selector(text=nrows[cnt]).xpath('//div/text()').extract()[4].split(" ")[0]

#                   assign all "fields" to "item"
                    item['Supplement'] = Supplement
                    item['NReviews'] = NReviews
                    item['Reason'] = Reason[len(Reason)-1]
                    item['Effectiveness'] = Effectiveness[len(Effectiveness)-1]
                    item['EaseOfUse'] = EaseOfUse[len(EaseOfUse)-1]
                    item['Satisfaction'] = Satisfaction[len(Satisfaction)-1]
                    item['Age'] = Age
                    item['DatePosted'] = DatePosted
                    yield item
