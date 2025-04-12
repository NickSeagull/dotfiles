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
description: Reality Augmentation Mind System - My dev environment + living knowledge base
template: splash
hero:
  tagline: Welcome. I’m a software engineer and creator of NeoHaskell, a programming language designed to explore new frontiers in expressiveness, type safety, and system design. This site is where I think out loud; a hybrid space of writing, code, and digital tools I use every day. You’ll find notes, blog posts, infrastructure, and experiments all woven together into one cohesive environment. Whether you're here for the tech, the ideas, or the craft behind it all — you're in the right place.
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

## >> aspects >>

<CardGrid>
	<Card title="// curiosity.">
		Every new idea starts with a sense of wonder. Here, I embrace the unknown and look at every problem like it’s waiting to be unraveled.
	</Card>
	<Card title="// creation.">
		Ideas are only the beginning. Creation is where concepts become concrete—through code, writing, or design—to shape something truly new.
	</Card>
	<Card title="// community.">
		People are at the heart of progress. Collaboration fuels bigger and better work, so I focus on open discussions, shared learning, and collective growth.
	</Card>
	<Card title="// craft.">
		Mastery is a journey. By refining the little things—from syntax to storytelling—I try to ensure everything I make reflects real care and attention.
	</Card>
</CardGrid>
```
