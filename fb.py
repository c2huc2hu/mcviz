# Assuming a maximum of 1000 likes and max 200 comments. 
# Works with python 2. 

import urllib
import json

# Methods: 
#   get_members(group_id)
#   get_posts(group_id, limit=50)
#   get_post_likes(post_id)
#   get_comments(post_id, limit=200)
#   get_comment_likes(comment_id)
# 579010795509386_787572237986573

def _clean_response(response):
    """Clean up the data returned from fb"""
    return json.loads(response.read().decode("utf-8"))

def get_members(group_id, access_token):
    url = "https://graph.facebook.com/{}/members?fields=name,id&access_token={}".format(group_id, access_token)
    #print(url)
    return urllib.urlopen(url)

def get_posts(group_id, access_token, limit=200):
    url = "https://graph.facebook.com/{}?fields=feed.limit({}){{id,from,message}}&access_token={}".format(group_id, limit, access_token)
    #print(url)
    return urllib.urlopen(url)
    
def get_post_likes(post_id, access_token, limit=1000):
    url = "https://graph.facebook.com/{}/likes?limit={}&access_token={}".format(post_id, limit, access_token)
    #print(url)
    return urllib.urlopen(url)
    
def get_comments(post_id, access_token, limit=200):
    url = "https://graph.facebook.com/{}/comments?fields=id,from,message&limit={}&access_token={}".format(post_id, limit, access_token)
    #print(url)
    return urllib.urlopen(url)
    
def get_comment_likes(comment_id, access_token):
    url = "https://graph.facebook.com/{}/likes?limit=1000&access_token={}".format(comment_id, access_token)
    #print(url)
    return urllib.urlopen(url)
    
def get_post_tree(post_id, access_token):
    """
    Get the complete tree from a post. Format it as shown in example.txt
    """

    if "_" not in post_id or access_token == "":
        return None
    
    # get poster and message
    url = "https://graph.facebook.com/{}?fields=from,message&access_token={}".format(post_id, access_token)
    post_info = _clean_response(urllib.urlopen(url))
    
    likes_info = transpose_name_id(_clean_response(get_post_likes(post_id, access_token)) ['data'])
    result = _clean_response(get_comments(post_id, access_token))['data']
    
    for c in result:
        comment_num = c['id']
        del c['id']
        c['likes'] = transpose_name_id(_clean_response(get_comment_likes(post_id + '_' + comment_num, access_token)) ['data'])

    result.append({'message':post_info['message'], 'from':post_info['from'], 'likes':likes_info})
        
    return result

def transpose_name_id(table):
    """
    Given a table that looks like
    [{'id':195258, 'name':'person B'}, {'id':356864, 'name':'person D']},
    return:
    {id:[195258, 356864], name:['person B', 'person D']}
    """
    id_result = []
    name_result = []
    for i in table:
        id_result.append(i['id'])
        name_result.append(i['name'])

    return {'id':id_result, 'name':name_result}

      
"""if __name__ == "__main__":
    access_token = "CAACEdEose0cBAGsu73qXLRwqoZB6Pg1UHnrvTYZB0cbvv0MtWof7VHQv68uiHR7ezkSGKbjsC6dTG4KjmTYCWgyyeJOMutETfeSsxcP37sgOiYvucZAi6ZBQZC2c0avkUqu87e3O9IKl6Q7ZCWc3rS1WKkbWqusYGNqZCcHgoLWwJfZBNconqJyltNx08jLbyFK4tbhvEmaZB0ZCewelmlc0V07vvMKjzyvxkZD"

    # Testing on: 579010795509386_787572237986573_787584784651985/
    group = "579010795509386"
    post = "579010795509386_787572237986573"
    comment = "579010795509386_787572237986573_787584784651985"
    
    #test1 = get_members(group)
    #print("Get members executed successfully")

    #test2 = get_posts(group)
    #print("Get posts successful")
    
    #test3 = get_post_likes(post)
    #print("get post likes successful")
    
    #test4 = get_comments(post)
    #print("get comments successful")
    
    #test5 = get_comment_likes(post)
    #print("getting comment likes successful")
    
    tree = get_post_tree(post, access_token)
    
        
    print("============")
    import pprint
    pprint.pprint(tree)
"""
