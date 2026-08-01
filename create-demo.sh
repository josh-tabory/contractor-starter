#!/bin/bash

# Usage: ./create-demo.sh "Business Name" "Phone Number" "City, State" "slug"
# Example: ./create-demo.sh "Austin Pro Plumbing" "512-555-0199" "Austin, TX" "austin-plumbing"

NAME=$1
PHONE=$2
CITY=$3
SLUG=$4

if [ -z "$NAME" ] || [ -z "$PHONE" ] || [ -z "$CITY" ] || [ -z "$SLUG" ]; then
  echo "Error: Missing arguments!"
  echo "Usage: ./create-demo.sh \"Business Name\" \"Phone Number\" \"City, State\" \"branch-slug\""
  exit 1
fi

echo "🚀 Creating demo branch for: $NAME..."

# 1. Checkout main and pull latest changes
git checkout main
git pull origin main

# 2. Create and switch to new prospect branch
git checkout -b "client-$SLUG"

# 3. Update site-config.json (using node inline script)
node -e "
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('src/site-config.json'));
config.businessName = '$NAME';
config.phone = '$PHONE';
config.city = '$CITY';
config.description = 'Professional contractor services in $CITY. Quality work and free estimates.';
fs.writeFileSync('src/site-config.json', JSON.stringify(config, null, 2));
"

# 4. Commit and Push branch to GitHub
git add src/site-config.json
git commit -m "Configure demo site for $NAME"
git push -u origin "client-$SLUG"

echo "✅ Success! Demo branch pushed."
echo "🔗 Your Cloudflare preview link will be live in ~30 seconds at:"
echo "👉 https://client-$SLUG.contractor-starter.pages.dev"