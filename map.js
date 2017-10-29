var map = L.map('map', {
  zoomControl: false
}).setView([33.8, -84.4], 13);

L.tileLayer('https://api.mapbox.com/styles/v1/mapsandapps/cj9bj48ts4cza2rn2avra7xjt/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwc2FuZGFwcHMiLCJhIjoiY2o4YWpvYzJ5MGdpbDJxcDd0bzI5MDIwNiJ9.LimJsR1bhO-BQW80SlCiAQ', {
  maxZoom: 18
}).addTo(map);

// TODO: allow user to insert some text about each route segment
// TODO: add legend
// TODO: display the date

var totalLayers;
var mapBounds = L.latLngBounds([]);
var mappedFiles = 0;
var mapLayers = [];
var lastLayer;
var settings = {
  fitMapTo: 'fit-to-all'
};

function handleFileSelect(e) {
  const files = e.target.files;
  _.forEach(files, file => {
    totalLayers = files.length;
    const reader = new FileReader();
    reader.readAsText(file);
    reader.onload = () => {
      var fileContents = reader.result;
      addFileContentsToList(fileContents);
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

function lightenLastLayer(layer) {
  layer.setStyle({
    opacity: 0.3
  });
}

function addLayerToMap(layer) {
  if (lastLayer) {
    lightenLastLayer(lastLayer);
  }
  if (layer) { // for the last click, there's no new layer; just lowering opacity of last layer and zooming out
    layer.setStyle({
      opacity: 1,
      weight: 8,
      color: getColorByMode(layer.mode)
    });
    lastLayer = layer;
    layer.addTo(map);
    mapBounds.extend(layer.getBounds());
    if (settings.fitMapTo === 'fit-to-each') {
      map.fitBounds(layer.getBounds());
    } else {
      map.fitBounds(mapBounds);
    }
  } else {
    map.fitBounds(mapBounds);
  }
}

function createMapLayer(path) {
  var currentLayer = omnivore.gpx.parse(path);
  mapLayers.push(currentLayer);
}

function addFileContentsToList(fileContents) {
  createMapLayer(fileContents);

  // when the last file is processed, do other stuff
  if (mapLayers.length === totalLayers) {

    _.forEach(mapLayers, layer => {
      layer.time = layer.toGeoJSON().features[0].properties.time;
      layer.mode = layer.toGeoJSON().features[0].properties.name.split(/( \d)/)[0]
    });

    mapLayers = _.sortBy(mapLayers, ['time']);

    document.getElementById('track-interactions').classList.remove('hidden');
    document.getElementById('total-tracks').innerHTML = totalLayers;
    advanceTrack(); // show first track
  }
}

function createImage() {
  var mapElement = document.getElementById('map');
  html2canvas(mapElement, {
    useCORS: true,
    allowTaint: false,
    onrendered: function(canvas) {
      var tempCanvas = document.createElement('canvas');
      tempCanvas.width = 800;
      tempCanvas.height = 800;
      var context = tempCanvas.getContext('2d');
      context.drawImage(canvas, 0, 0, 800, 800);
      document.body.appendChild(tempCanvas);

      var svgPaths = document.getElementsByTagName('g');
      _.forEach(svgPaths, path => {
        context.drawSvg(path.innerHTML, 0, 0, 0, 0);
      });

      var link = document.createElement("a");
      link.href = tempCanvas.toDataURL('image/png');
      link.download = 'screenshot.png';
      link.click();
    }
  });
}

function advanceTrack() {
  addLayerToMap(mapLayers[mappedFiles]);
  mappedFiles += 1;
  document.getElementById('completed-tracks').innerHTML = mappedFiles > totalLayers ? 'All' : mappedFiles;

  if (mappedFiles === totalLayers + 1) {
    document.getElementById('advance-button').disabled = true;
  }
}

var form = document.getElementById('fit-map');
form.addEventListener('change', event => {
  settings.fitMapTo = event.target.id;
});
