#!/usr/bin/bash
google_rss_apnews=$(curl -sf "https://news.google.com/rss/search?q=when:24h+allinurl:apnews.com&hl=en-US&gl=US&ceid=US:en")
news_json=$(xq -r ".rss.channel.item" <(echo "$google_rss_apnews"))
echo "$news_json"
