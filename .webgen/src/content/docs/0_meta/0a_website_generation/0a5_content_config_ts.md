+++
title = "Content Collections"
author = ["Nikita Tchayka"]
date = 2025-03-23T00:00:00+00:00
draft = false
+++

This file defines the content collections used by Astro’s content module.

We configure a single collection named `docs`, using Starlight’s built-in loader and schema. This enables automatic type-safe content handling and integration with Starlight’s documentation system.

We begin by importing the necessary helpers.

```typescript
import { defineCollection } from 'astro:content';
import { docsLoader } from '@astrojs/starlight/loaders';
import { docsSchema } from '@astrojs/starlight/schema';
```

Now we declare the collections map. The key `docs` corresponds to the content directory `src/content/docs`.

```typescript
export const collections = {
  docs: defineCollection({ loader: docsLoader(), schema: docsSchema() }),
};
```
