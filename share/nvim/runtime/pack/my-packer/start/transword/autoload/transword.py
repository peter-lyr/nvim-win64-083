import re
import sys

try:
  import requests
  from lxml import etree
except:
  import os
  os.system(f"pip install -r {os.path.join(os.path.dirname(__file__), 'transcword-requirements.txt')}")
  import requests
  from lxml import etree

text = requests.get(f'https://dict.youdao.com/search?q={sys.argv[1]}').text
content = etree.tostring(etree.HTML(text).xpath('//div[@id="phrsListTab"]')[0], encoding='utf-8').decode()
content = re.subn(re.compile(r'<[^>]+?>'), '', content)[0]
content = re.subn(re.compile(r'\s+'), ' ', content)[0]
content = re.subn(re.compile(r'&[^;]+;'), r'', content)[0]
content = re.subn(re.compile(r'\s+'), ' ', content)[0]
print(content)
