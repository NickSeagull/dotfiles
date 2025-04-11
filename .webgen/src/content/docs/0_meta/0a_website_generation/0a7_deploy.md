+++
title = "Deploy"
author = ["Nikita Tchayka"]
date = 2025-04-11T00:00:00+01:00
draft = false
+++

I deploy this site to GitHub pages. Astro has some [great docs](https://docs.astro.build/en/guides/deploy/github/) on how to do this, so I just replicate.

```javascript
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
    paths:
      - '**.org'

  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout your repository using git
        uses: actions/checkout@v4
      - name: Install, build, and upload your site
        uses: withastro/action@v3
        with:
          path: ./.webgen

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```
