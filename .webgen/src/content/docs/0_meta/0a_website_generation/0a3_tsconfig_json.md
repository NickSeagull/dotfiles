+++
title = "TypeScript Config"
author = ["Nikita Tchayka"]
date = 2025-03-23T00:00:00+00:00
draft = false
+++

This file defines the TypeScript configuration for the Astro project.

We extend Astro’s strict default settings for type checking.

```json
{
  "extends": "astro/tsconfigs/strict",
```

We include all source files and Astro’s generated types.

```json
  "include": [".astro/types.d.ts", "**/*"],
```

The build output directory is excluded from type checking.

```json
  "exclude": ["dist"]
}
```
