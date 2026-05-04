import { defineConfig } from 'vite';

export default defineConfig(({ mode }) => {
  return {
    define: {
      'process.env.VITE_GEONODE_URL': JSON.stringify(
        mode === 'production' 
          ? 'https://geoserver.dainst.org/'
          : 'https://geonode-dev.dainst.org/'
      ),
      'process.env.VITE_ENVIRONMENT': JSON.stringify(mode),
    },
    build: {
      sourcemap: true,
    },
  };
});
