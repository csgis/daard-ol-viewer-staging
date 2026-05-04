// Feature layer json definitions
// Die URL wird zur Build-Zeit basierend auf der Umgebung gesetzt

const geonodeUrl = import.meta.env.VITE_GEONODE_URL || 'https://geonode-dev.dainst.org/';
const environment = import.meta.env.VITE_ENVIRONMENT || 'development';

console.log(`🗺️  Using GeoNode URL: ${geonodeUrl}`);
console.log(`⚙️  Environment: ${environment}`);

const customFeatureLayersJson = [
  {
    type: 'geonode',
    url: geonodeUrl,
    id: 6006,
    name: 'Daard Database',
    visible: true
  }
];

export { customFeatureLayersJson };
