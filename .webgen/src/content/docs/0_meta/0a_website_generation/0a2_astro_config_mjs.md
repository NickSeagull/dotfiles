+++
title = "Astro Config"
author = ["Nikita Tchayka"]
date = 2025-03-23T00:00:00+00:00
draft = false
+++

This file defines the Astro configuration for the documentation website.

We use the Starlight theme integration, which provides a default layout, sidebar navigation, and social links for GitHub. This configuration is used by Astro at build and development time.

We begin by enabling TypeScript type checking via JSDoc comments.

```javascript
// @ts-check
```

We import Astro’s configuration utilities and the Starlight theme integration.

```javascript
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
```

Reference to Astro’s official configuration documentation.

```javascript
// https://astro.build/config
```

Now we export the full configuration. Starlight is passed as an integration, with title, GitHub link, and a multi-section sidebar.

```javascript
export default defineConfig({
  site: 'https://nickseagull.dev',
  integrations: [
    starlight({
        title: 'RAMSYS',
        customCss: [
            './src/custom.css',
            '@fontsource/monaspace-krypton/400.css',
            '@fontsource/monaspace-krypton/600.css',
        ],
        social: {
            github: 'https://github.com/nickseagull/nickseagull',
        },
        sidebar: [
            {
                label: '0 - Foundations & Meta',
                autogenerate: { directory: '0_meta' },
            },
        ],
    }),
  ],
});
```
