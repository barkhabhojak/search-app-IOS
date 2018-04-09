const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const http = require('http');
const app = express();
const request = require('request');
var router = express.Router();
const yelp = require('yelp-fusion');
var debug = false;
var keyword_global, category_global, distance_global, loc_global, radioBtnChecked_global;
var local = true;
const placesKey = "AIzaSyAU5hyg6Ky-pOHejxe2u8trKteehGkSNrk";
const geoKey = "AIzaSyBi3mS77HSSIOTdlIgpnsjzdUVJIindH8w";
const yelpKey = "HPOJ_wtKt3pM6NziniTmqO4ulVh2OWMZnii_NxW4NbvEMzZIe-FWcg6vTL53NmUJHMQ4KnjK4JQG0omkn0IymrRQKiQhoI69HkOEdwCx0L7v8QLW0UjTy-rSyEu0WnYx";
const client = yelp.client(yelpKey);
// Parsers
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false}));


app.get('/', (req, res) => {
    res.send("Hello Server Running");
});

app.get('/parameters', (req,res) => {
	res.send({'keyword' : keyword_global, 'category' : category_global, 'distance' : distance_global, 'location' : loc_global, 'radioChecked' : radioBtnChecked_global})
})

// app.get('/ilike', function (req, res) {
// 	if (debug) {
// 		console.log(req);
// 		console.log("name = ",req.query.name);
// 		console.log("lname = ", req.query.lname);
// 	}
// 	var responseObj = {message: 'OK'};
// 	res.send(responseObj);
// })

app.get('/yelp', (req, res) => {
	if (debug) {
		console.log("yelp");
		console.log(req.query);		
	}
	client.businessMatch('lookup', {
		name: req.query.name,
		address: req.query.address,
		city: req.query.city,
		state: req.query.state.toUpperCase(),
		country: "US",
		postal_code: req.query.postalCode,
		latitude: req.query.lat,
		longitude: req.query.lng
		}).then(response => {
			if (debug)
				console.log("yelp response");
			if (response.jsonBody.businesses.length > 0) {
				if (debug) {
					console.log(response.jsonBody.businesses);
					console.log("matched id = ", response.jsonBody.businesses[0].id);
				}
				client.reviews(response.jsonBody.businesses[0].id).then(responseFin => {
					res.send(responseFin.body);
					}).catch(e => {
						if (debug)
							console.log(e);
				});
			}
			else {
				res.send({status:"No match found"});
			}
		}).catch(e => {
			if (debug)
				console.log(e);
		});
})

app.get('/ip', (req, res) => {
	var url = "https://ipapi.co/json";
	request.get(url,function(error, response, body) {
			if (error === null) {
				var ob = JSON.parse(body);
				if(debug) {console.log(ob);}
				res.send(ob);
			}
	});
})
//http://iosappserver-env.us-east-2.elasticbeanstalk.com/googlepath?origin=2626+S+Figueroa+St+Los+Angeles+CA+90007+USA&destination=34.0221597,-118.2610431&mode=driving

app.get('/googlepath', (req, res) => {
	var origin = req.query.origin.replaceAll(" ","+")
	var destination = req.query.destination
	var mode = req.query.mode
	var url = "https://maps.googleapis.com/maps/api/directions/json?origin=" + origin + "&destination=" + destination + "&mode=" + mode + "&key=" + geoKey;
	request.get(url,function(error, response, body) {
				if (error === null) {
					var ob = JSON.parse(body);
					res.send(ob);
				}
	});
});

app.get('/result', (req, res) => {
    if (req.query.next_page_token !== undefined) {
    	if (debug)
    		console.log('next page token');
    	var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=" + req.query.next_page_token + "&key=" + placesKey;
			request.get(url,function(error, response, body) {
				if (error === null) {
					var ob = JSON.parse(body);
					res.send(ob);
				}
		});
    }

    else {
    	if (debug) {
	    	console.log(req.query.keyw);
		    console.log(req.query.category);
		    console.log(req.query.distance);
		    console.log(req.query.locOpt);
		}
	    var keyword = req.query.keyw;
	    keyword_global = req.query.keyw;
	    var category = req.query.category.toLowerCase();
	    category_global = req.query.category.toLowerCase();
	    if (category.indexOf(' ') >= 0) {
	    	category = category.replaceAll(' ','+');
	    }
	    if (keyword.indexOf(' ') >= 0) {
	    	keyword = keyword.replaceAll(' ','+');
	    }
	    var distance = 10;
	    lat = 0;
	    long = 0;
	    if (req.query.distance !== '') {
	    	distance = req.query.distance;
	    	distance_global = req.query.distance;
	    }
	    if (req.query.locOpt === 'other-loc') {
	    	var address = req.query.loc;
	    	radioBtnChecked_global = "other-loc";
	    	loc_global = address;
			if (address.indexOf(' ') >= 0 || address.indexOf(',') >= 0) {
				address = address.replaceAll(' ','+');
				address = address.replaceAll(',','');
			}
			var url = "https://maps.googleapis.com/maps/api/geocode/json?address="+address+"&key="+geoKey;
			if (debug){console.log("url = ", url);};
			request.get(url,function(error, response, body) {
				if (error === null) {
					var obj = JSON.parse(body);
					if (obj.status === 'OK') {
						var a = obj.results[0].geometry.location;
						lat = a.lat;
						long = a.lng;

						distance = distance*1609.34;
						url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+lat+","+long+"&radius="+distance+"&type="+category+"&keyword="+keyword+"&key="+placesKey;	
						if (debug)
							console.log("url list = ", url);
						if (url.indexOf(' ') >= 0) {
							url = url.replaceAll(' ','+');
						}
						request.get(url,function(error, response, body) {
							if (error === null) {
								var obj = JSON.parse(body);
								obj.keyword = keyword;
								obj.category = category;
								obj.distance = distance/1609.34;
								obj.loc = address;
								obj.loc_opt = req.query.locOpt;
								res.send(obj);
							}
						});
					}
					else {
						alert('error in getting location from google maps');
						return;
					}
				}
			});
	    }
	    else {
	    	var a = req.query.locOpt.split('curr-loc-')[1];
	    	radioBtnChecked_global = "curr-loc";
	    	lat = a.split(',')[0];
	    	long = a.split(',')[1];
			distance = distance*1609.34;
			var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+lat+","+long+"&radius="+distance+"&type="+category+"&keyword="+keyword+"&key="+placesKey;	
			if (debug)
				console.log("url list = ", url);
			if (url.indexOf(' ') >= 0) {
				url = url.replaceAll(' ','+');
			}
			request.get(url,function(error, response, body) {
				if (error === null) {
					var obj = JSON.parse(body);
					obj.keyword = keyword;
					obj.category = category;
					obj.distance = distance/1609.34;
					obj.loc_opt = 'curr-loc';
					res.send(obj);
				}
			});
	    }
	}
});

	

var server = app.listen(process.env.port || 8081, function () {
	var port = server.address().port;
});



function getList(keyword,category,distance,lat,long) {
	distance = distance*1609.34;
	var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+lat+","+long+"&radius="+distance+"&type="+category+"&keyword="+keyword+"&key="+placesKey;	
	if (debug)
		console.log("url list = ", url);
	if (url.indexOf(' ') >= 0) {
		url = url.replaceAll(' ','+');
	}
	request.get(url,function(error, response, body) {
		if (error === null) {
			var obj = JSON.parse(body);
			if (obj.status === 'OK') {
				return obj;
			}
			else {
				// alert('error in getting location from google maps');
				return null;
			}
		}
	});
}



String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};

https://maps.googleapis.com/maps/api/directions/json?origin=2626+S+Figueroa+St+Los+Angeles+CA+90007+USA&destination=34.0221597,-118.2610431&mode=driving&key=AIzaSyBi3mS77HSSIOTdlIgpnsjzdUVJIindH8w

module.exports = app;
//module.exports = router;