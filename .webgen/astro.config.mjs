// @ts-check

import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config

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
