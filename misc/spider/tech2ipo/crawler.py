#!/usr/bin/env python
# -*- coding:utf-8 -*-

"""tech2ipo crawler
"""
from os.path import exists
from bs4 import BeautifulSoup
import io
import json
import os
import Queue
import requests
import threading
import time


BASE_URL = 'http://tech2ipo.com/'


def get_articleurl_from_allpage(all_url):
    """Get article url from http://tech2ipo/all/"""
    html_origin = requests.get(all_url, timeout=30).text
    soup = BeautifulSoup(html_origin)
    all_tag = soup.find_all(lambda tag: tag.get('class') == ['post-img'])
    url_set = set()
    for each in all_tag:
        #print each.find_next('p').text
        url_num = str(each['href'][1:])    # skip '/9999'
        url = BASE_URL + url_num
        url_set.add(url)
    return url_set


def write_article_brief(fresh_artcile_url_set):
    """Write article brief information."""
    fresh_article_id_set = [int(each_url.split('/')[3])
                            for each_url in fresh_artcile_url_set]    # to int
    min_fresh_article_id = min(fresh_article_id_set)

    for i in range(1, 937):
        all_url = BASE_URL + 'all/' + str(i)
        print all_url
        html_origin = requests.get(all_url, timeout=30).text
        soup = BeautifulSoup(html_origin)
        all_tag = soup.find_all(lambda tag: tag.get('class') == ['post-img'])
        all_tag = sorted(all_tag, key=lambda each: int(each['href'][1:]), reverse=True)
        for each in all_tag:
            #print each.find_next('p').text
            url_id = each['href'][1:]    # skip '/9999'

            if int(url_id) < min_fresh_article_id:    # skip already downloaded
                return

            filename = './article/' + url_id + '.txt'
            print 'write brief info', filename
            try:
                f = open(filename, 'r')
            except:
                continue
            else:
                try:
                    article = json.load(f)
                except:
                    f.close()
                    continue

                f.close()
                article['brief'] = each.find_next('p').text
                with io.open(filename, 'w+', encoding='utf8') as outfile:
                    data = json.dumps(article, ensure_ascii=False, encoding='utf8', indent=4)
                    outfile.write(unicode(data))


#def get_max_article_id():
#    """Get max article id from http://tech2ipo.com/all/1"""
#    url = BASE_URL + 'all/1'
#    url_set = get_articleurl_from_allpage(url)
#    id_list = [int(each_url.split('/')[3]) for each_url in url_set]
#    return max(id_list) if id_list else 0


def get_downloaded_max_article_id(article_dir):
    """Get the max downloaded article id."""
    list_all = os.walk(unicode(article_dir, 'utf-8'))
    article_id_set = set()
    for root, dirs, files in list_all:
        for each_file in files:
            if '.txt' in each_file:
                article_id_set.add(int(each_file.split('.')[0]))    # to int
    return max(article_id_set) if article_id_set else 0


#def get_fresh_article_url_set():
#    """Get article that need to download."""
#    max_id = get_max_article_id()
#    max_downloaded_article_id = get_downloaded_max_article_id('./article')
#    fresh_id_set = [i for i in range(max_downloaded_article_id, max_id+1)]
#    fresh_article_url_set = [BASE_URL+str(each_id) for each_id in fresh_id_set]
#    print '%d articles need to download' % len(fresh_article_url_set)
#    print fresh_article_url_set
#    return fresh_article_url_set


def parse_page(page_url):
    print "---", page_url
    """Parse article page and write article_id.txt file to ./article."""
    try:
        html_origin = requests.get(page_url, timeout=30).text
    except:
        return

    soup = BeautifulSoup(html_origin, 'lxml')
    article = {}

    try:
        article_tag = soup.find('article')
        article['tag'] = unicode(article_tag.find_next('a').string)   # tag
        article['title'] = article_tag.find_next('h1').string    # title
        print article['title']
        article['id'] = article_tag.find_next('h1').get('id').split('_')[2]    # id
        try:
            author = article_tag.find_next('a', class_='author').string    # author
        except AttributeError:
            author = article_tag.find_next('span', class_='author').find_next('em').string
        article['author'] = author
        data_text = article_tag.find_next('div', class_='title-act').get_text().split()
        length = len(data_text)
        pub_time = unicode(data_text[length-2])[3:] + ' ' + unicode(data_text[length-1])
        article['time'] = time.mktime(time.strptime(pub_time, '%Y-%m-%d %H:%M:%S'))    # pub_time
        article['content'] = unicode(article_tag.find_next('section', id='article-content'))    # content
    except:
        return
    print page_url
    filename = './article/' + unicode(article['id']) + '.txt'
    print filename
    with io.open(filename, 'w+', encoding='utf8') as outfile:
        data = json.dumps(article, ensure_ascii=False, encoding='utf8', indent=4)
        outfile.write(unicode(data))


class ThreadingParse(threading.Thread):
    """Thread parse class"""
    def __init__(self, queue):
        threading.Thread.__init__(self)
        self.queue = queue

    def run(self):
        while True:
            url = self.queue.get()
            parse_page(url)

            # After work is down, send a signal to queue job is done
            self.queue.task_done()

def get_three_page_url_set():
    """Get three pages articles url set."""
    all_url_set = set()
    for i in range(1, 2): 
        url = BASE_URL +"all/"+ str(i)
        url_set = get_articleurl_from_allpage(url)
        all_url_set |= url_set
    return all_url_set

def write_three_article_brief(fresh_artcile_url_set):
    """Write article brief information."""
    fresh_article_id_set = [int(each_url.split('/')[3])
                            for each_url in fresh_artcile_url_set]    # to int

    for i in range(1, 2):
        all_url = BASE_URL + 'all/' + str(i)
        print all_url
        html_origin = requests.get(all_url,timeout=30).text
        soup = BeautifulSoup(html_origin)
        all_tag = soup.find_all(lambda tag: tag.get('class') == ['post-img'])
        all_tag = sorted(all_tag, key=lambda each: int(each['href'][1:]), reverse=True)
        for each in all_tag:
            #print each.find_next('p').text
            url_id = each['href'][1:]    # skip '/9999'

            filename = './article/' + url_id + '.txt'
            print 'write brief info', filename
            try:
                f = open(filename, 'r')
            except:
                continue
            else:
                try:
                    article = json.load(f)
                except:
                    f.close()
                    continue

                f.close()
                article['brief'] = each.find_next('p').text
                with io.open(filename, 'w+', encoding='utf8') as outfile:
                    data = json.dumps(article, ensure_ascii=False, encoding='utf8', indent=4)
                    outfile.write(unicode(data))


from single_process import  single_process
@single_process
def main():
    q = Queue.Queue()
    thread_num = 10    # number of threads

    for i in range(thread_num):
        t = ThreadingParse(q)
        # setDaemon allow main thread to exit if only daemonic threads are alive
        t.setDaemon(True)
        t.start()

    fresh_article_url_set = get_three_page_url_set()
    for url in fresh_article_url_set:
        q.put(url)

    # wait on the queue until everything has been processed, q is emtpy
    # blocks until all items in the queue have been gotten and processed
    q.join()
    write_three_article_brief(fresh_article_url_set)

if __name__ == '__main__':
    main()
    print 'finish'
