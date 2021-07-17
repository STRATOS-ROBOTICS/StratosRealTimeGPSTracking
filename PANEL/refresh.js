//refresh.js

$(document).ready(function() {


    var current_position = new L.featureGroup();
    //Map attribution
    var map_attr = "";

    // OpenStreetMap tiles
    var osmURL = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    var osm = L.tileLayer(osmURL, {attribution: map_attr});


    //Google Maps (Hybrid) maptile

    var gmhURL = "https://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}";
    var gmHybrid = L.tileLayer(gmhURL, {
        maxZoom: 20,
        subdomains: ["mt0","mt1","mt2","mt3"]
    })

    var map = L.map('mymap',{
        center: [1.559864, 103.637799],
        zoom: 15,
        layers: [gmHybrid, current_position]
    });
    var baseLayers = {
        "OpenStreet Map": osm,
        "Google Map (Hybrid)": gmHybrid
    }; 

    var overlays = {"Current GPS":current_position};

    //Draw all layers
    L.control.layers(baseLayers, overlays, {collapsed:false}).addTo(map);
// Add marker
    reloadMarker()
    //FUNCTION TO ADD AND RELOAD MARKERS
    function reloadMarker(){
        //Get current position data from JSON (from data.php)
        $.getJSON("./data.php",function(mypos){
            //test 
            //console.log(mypos);
            for(var i=0; i<mypos.length; i++){
                var stnMarker = L.marker([mypos[i].lat,mypos[i].lng]).addTo(current_position);
             }

             //Get data extent
             var bounds = current_position.getBounds();
             map.fitBounds(bounds);
        });
    }




});