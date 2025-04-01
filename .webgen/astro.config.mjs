// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import starlightObsidian, { obsidianSidebarGroup } from "starlight-obsidian";
import starlightThemeObsidian from "starlight-theme-obsidian";
import mdx from "@astrojs/mdx";
import embeds from "astro-embed/integration";
// @ts-ignore
import remarkOembed from "remark-oembed";
import AutoImport from 'astro-auto-import';


import react from "@astrojs/react";

// https://astro.build/config
export default defineConfig({
  markdown: {
    remarkPlugins: [remarkOembed],
  },
  site: "https://nickseagull.dev",
  integrations: [
    starlight({
      title: "nulspace",
      components: {
        Sidebar: "./src/overrides/Sidebar.astro",
        Header: "./src/overrides/Header.astro",
      },
      social: {
        github: "https://github.com/nickseagull/",
        linkedin: "https://www.linkedin.com/in/nickseagull/",
        twitter: "https://x.com/NickSeagull",
        twitch: "https://www.twitch.tv/codeseagull",
        youtube: "https://www.youtube.com/@CodeSeagull",
        mastodon: "https://mastodon.social/@NickSeagull",
      },
      sidebar: [obsidianSidebarGroup],
      customCss: ["@fontsource/xanh-mono/400.css", "./src/style/custom.css"],
      plugins: [
        // Generate the Obsidian vault pages.
        starlightObsidian({
          vault: "./content",
          sidebar: {
            label: "nulspace",
          },
        }),
        starlightThemeObsidian({
          backlinksConfig: {
            visibilityRules: ["**/*"],
          },
          // @ts-ignore
          graphConfig: {
            depth: 2,
            linkDistance: 100,
            prefetchPages: true,
            renderArrows: true,
            renderExternal: true,
            renderUnresolved: true,
            tagRenderMode: "node",
            tagStyles: {
              Tag: {
                shape: "square",
                strokeWidth: 8,
                cornerType: "round",
                strokeCornerRadius: "80%",
              },
            },
          },
        }),
      ],
    }),
    AutoImport({
      imports: [
        // import A from './src/components/A.astro';
        // './src/components/A.astro',

        {
          // Explicitly alias a default export
          // generates:
          // import { default as B } from './src/components/B.astro';
          // './src/components/B.astro': [['default', 'B']],

          // Import a module’s named exports
          // generates:
          // import { Tweet, YouTube } from 'astro-embed';
          'astro-embed': ['Tweet', 'YouTube'],

          // Import all named exports from a module as a namespace
          // generates:
          // import * as Components from './src/components';
          // './src/components': 'Components',
        },
      ],
    }),
    react(),
    embeds(),
    mdx(),
  ],
});
