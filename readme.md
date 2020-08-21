# tenka1-tmpl

HTTPS経由でbotを作る必要があるようなので  
C++ → stdio → Ruby → https → server  
仲介スクリプトとソルバーのテンプレート

https://tenka1.klab.jp/2019-obt/problem_re31z0.html
https://practice.gbc-2020.tenka1.klab.jp/portal/index.html#top

## build

```
mkdir -p out && cd out
cmake .. -GNinja
ninja
```
