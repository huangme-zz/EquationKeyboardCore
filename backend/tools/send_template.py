import fileinput
import re
from datetime import datetime
from elasticsearch import Elasticsearch

for line in fileinput.input():

    keywords = re.split(r'\t', line.rstrip())

    template = keywords[0]
    tag = keywords[1]
    favourite = keywords[2]

    es = Elasticsearch(["http://ec2-54-146-55-27.compute-1.amazonaws.com:8080"])

    doc = {
        'template': str(template),
        'favourite': str(favourite),
        'tag': str(tag),
    }

    res = es.index(index="course", doc_type='template', id=str(datetime.now()), body=doc)
    print(str([template, favourite, tag]) + " created is " + str(res['created']))
