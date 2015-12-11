#!/bin/bash

cd web/elm/livechat
elm make LiveChat.elm --output LiveChat.js
cd ../../..
cp web/elm/livechat/LiveChat.js priv/static/js

