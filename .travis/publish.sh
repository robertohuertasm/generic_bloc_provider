#!/usr/bin/env bash
mkdir -p .pub-cache

cat <<EOF > ~/.pub-cache/credentials.json
{
  "accessToken":"$accesstoken",
  "refreshToken":"$refreshtoken",
  "tokenEndpoint":"$tokenendpoint",
  "scopes":["https://www.googleapis.com/auth/plus.me","https://www.googleapis.com/auth/userinfo.email"],
  "expiration":$expiration
}
EOF

pub publish -f
