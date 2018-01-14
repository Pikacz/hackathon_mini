package com.vogella.springboot.gradle.minimal;

import org.json.JSONException;
import org.json.JSONObject;

public class Coords {
	double lat;
	double lon;
	String floorId;
	Coords(double lat, double lon, String floorId){
		this.lat = lat;
		this.lon = lon;
		this.floorId = floorId;
	}
	JSONObject toJSONObject() {
		JSONObject obj = new JSONObject();
		try {
			obj.put("lat", lat);
			obj.put("lon", lon);
			obj.put("floor-id", floorId);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj;
	}
}
