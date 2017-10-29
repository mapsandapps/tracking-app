var map = L.map('map', {
  zoomControl: false
}).setView([33.8, -84.4], 13);

L.tileLayer('https://api.mapbox.com/styles/v1/mapsandapps/cj9bj48ts4cza2rn2avra7xjt/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwc2FuZGFwcHMiLCJhIjoiY2o4YWpvYzJ5MGdpbDJxcDd0bzI5MDIwNiJ9.LimJsR1bhO-BQW80SlCiAQ', {
  maxZoom: 18
}).addTo(map);

// TODO: have tracks load one at a time; pause after each to take screenshot
// TODO: have button that takes the screenshot for you

var layersLoaded = 0;
var totalLayers;
var mapBounds = L.latLngBounds([]);

function handleFileSelect(e) {
  const files = e.target.files;
  Object.keys(files).forEach(i => {
    totalLayers = files.length;
    const file = files[i];
    const reader = new FileReader();
    reader.readAsText(file);
    reader.onload = () => {
      layersLoaded += 1;
      var fileContents = reader.result;
      addFileToMap(fileContents);
    }
  });
}

document.getElementById('files').addEventListener('change', handleFileSelect, false);

function getColorByMode(mode) {
  switch(mode) {
    case 'Cycling':
      return '#00aa00';
    case 'Walking':
    case 'Hiking':
      return '#0000aa';
    case 'Nordic Walking':
      return '#aaaa00';
    default:
      return '#aa0000';
  }
}

function addFileToMap(fileContents) {
  console.log('addFileToMap');
  var currentLayer = omnivore.gpx.parse(fileContents);
  currentLayer.setStyle({
    opacity: 0.5,
    weight: 8,
    color: getColorByMode(currentLayer.toGeoJSON().features[0].properties.name.split(/( \d)/)[0])
  });
  currentLayer.addTo(map);
  mapBounds.extend(currentLayer.getBounds());

  // if this is the last one, do other stuff
  if (layersLoaded === totalLayers) {
    console.log('done!');
    map.fitBounds(mapBounds);
  }
}
