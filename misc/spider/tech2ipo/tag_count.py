#!/usr/bin/env python
# -*- coding:utf-8 -*-

import json
import os
import io
import HTMLParser
import codecs

from upload import *


def get_all_files_list(root_dir):
    list_all = os.walk(unicode(root_dir, 'utf-8'))
    files_list = []
    for root, dirs, files in list_all:
        for each_file in files:
            if '.txt' in each_file:
                files_list.append(os.path.join(root, each_file))
    return files_list


def escape_brief(each_file):
        print 'processing...', each_file
        f = open(each_file, 'r')
        try:
            article = json.load(f)
        except:
            f.close()
            return
        html_text = article['content']
        get_tag_and_removed_tag(html_text)


        f.close()
        """
        with io.open(each_file, 'w+', encoding='utf-8') as outfile:
            data = json.dumps(article, ensure_ascii=False, encoding='utf-8', indent=4)
            outfile.write(unicode(data))
        """


def get_all_tag(file_list):
    """Get all tag-count dict."""
    all_tag_dict = {}
    for each_file in file_list:
        #raw_input('input')
        #print each_file
        with open(each_file, 'r') as f:
            article = json.load(f)
            html_text = article['content']
            tag_list = get_tag_list(html_text)
            tag_list.append(tag_dict[article['tag']])
            #print tag_list
            for each_tag in tag_list:
                if each_tag not in all_tag_dict:
                    all_tag_dict[each_tag.strip()] = 1
                else:
                    all_tag_dict[each_tag.strip()] += 1
        #print all_tag_dict
    return all_tag_dict


def write_tag_than_num_to_file(all_tag_dict, num):
    """Write to file tag.txt"""
    tag_list_than_three = set()
    for k, v in all_tag_dict.items():
        if int(v) >= num:
            tag_list_than_three.add((k, v))
    with codecs.open('tag.txt', 'a+', 'utf-8') as f:    # use utf-8 codes.open
        for each in tag_list_than_three:
            f.write(each[0] + u' ' + unicode(each[1]) + '\n')


def tag_test():
    """Test tag"""
    file_list = get_all_files_list('./article')
    all_tag_dict = get_all_tag(file_list)
    print len(all_tag_dict)
    print 'ready to write tags to tag.txt'
    write_tag_than_num_to_file(all_tag_dict, 3)


def main():
    files_list = get_all_files_list('./article')
    print len(files_list)
    for each_file in files_list:
       # raw_input()
        if '61520' in each_file:
            escape_brief(each_file)
            break
    print 'finish'


if __name__ == '__main__':
    tag_test()
    print 'finish.'
