+++
title = "Package.Json"
author = ["Nikita Tchayka"]
date = 2025-03-23T00:00:00+00:00
draft = false
+++

This file defines the Node.js project configuration used by Astro to manage dependencies, scripts, and project metadata.

Astro uses a \`package.json\` file to declare metadata, specify package versions, and define commands for development and production workflows.

The project is named arbitrarily but consistently across systems.

```json
{
  "name": "website",
```

We declare this package as an ECMAScript Module project.

```json
  "type": "module",
```

The version is not yet stable and is in early development.

```json
  "version": "0.0.1",
```

We define common scripts for local development and deployment.

```json
  "scripts": {
    "dev": "astro dev",
    "start": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "astro": "astro"
  },
```

Here we declare the main runtime dependencies used in the project.

```json
  "dependencies": {
```

We use the Starlight theme for documentation websites.

```json
    "@astrojs/starlight": "^0.32.5",
```

Astro is the core web framework driving the project.

```json
    "astro": "^5.5.3",
```

For the main font, we use Monaspace Krypton:

```json
    "@fontsource/monaspace-krypton": "*",
```

For cool effects, like the image noise, use open-props (for `openprops/duration`)

```json
    "open-props": "*",
```

We use \`sharp\` for efficient image processing.

```json
    "sharp": "^0.32.5"
  }
}
```
