+++
title = "Index Page"
author = ["Nikita Tchayka"]
date = 2025-03-23T00:00:00+00:00
draft = false
+++

This is the main splash page for the documentation site, using the Starlight theme.

We begin with frontmatter metadata, which defines the page’s title, description, template type, and hero section.

```yaml
---
title: nickseagull.dev
description: Get started building your docs site with Starlight.
template: splash
hero:
  tagline: Congrats on setting up a new Starlight project!
  image:
    file: ../../assets/portrait.png
  actions:
    - text: Enter RAMSYS
      link: /0_meta/readme
      icon: right-arrow
---
```

We import some components from Starlight to display a grid of cards.

```mdx
import { Card, CardGrid } from '@astrojs/starlight/components';
```

Below we define a section titled “Next steps” with four cards offering suggestions to the user.

```mdx

## Next steps

<CardGrid>
	<Card title="Update content" icon="pencil">
		Edit `src/content/docs/index.mdx` to see this page change.
	</Card>
	<Card title="Add new content" icon="add-document">
		Add Markdown or MDX files to `src/content/docs` to create new pages.
	</Card>
	<Card title="Configure your site" icon="setting">
		Edit your `sidebar` and other config in `astro.config.mjs`.
	</Card>
	<Card title="Read the docs" icon="open-book">
		Learn more in [the Starlight Docs](https://starlight.astro.build/).
	</Card>
</CardGrid>
```
