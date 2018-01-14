package com.vogella.springboot.gradle.minimal;

import java.util.HashMap;
import java.util.HashSet;
import java.util.concurrent.atomic.AtomicLong;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javassist.bytecode.Descriptor.Iterator;

@RestController
public class ReqController {
	HashMap<String, Owner> owners = new HashMap<>();
	HashMap<Integer, Event> events = new HashMap<>();
 	@RequestMapping("/api2/user/create")
    public String createUser(@RequestParam(value="user-id") String name) {
    	System.out.println("CREATE REQUEST:" + name);
        if(owners.containsKey(name)) {
        	System.out.println("Already got.");
        } else {
        	owners.put(name, new Owner(name));
        }
        
        JSONObject object = new JSONObject();
    	try {
			object.put("user-id", name);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		putOk(object);
    	return object.toString();
    }
	
 	
 	@RequestMapping("/api2/user/update-location")
	public String updateLocation(
			@RequestParam(value="lat") String lat, 
			@RequestParam(value="lon") String lon,
			@RequestParam(value="floor-id") String floorId,
			@RequestParam(value="user-id") String name) {
		System.out.println("UPDATE REQUEST:" + lat +
 		", " + lon+ ", " + name);
		if(!owners.containsKey(name)) {
			owners.put(name, new Owner(name));
			System.out.println("no such name");
		} else {
			Coords coords = new Coords(Double.parseDouble(lat), Double.parseDouble(lon), floorId);
			owners.get(name).update(coords);
		}
		
		JSONObject object = new JSONObject();
		try {
			object.put("user-id", name);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		putOk(object);
 		return object.toString();
	}
 	
 	@RequestMapping("/api2/user/host-event")
 	public String hostEvent(
 			@RequestParam(value="owner-id") String userid,
 			@RequestParam(value="name") String name,
 			@RequestParam(value="description") String desc,
 			@RequestParam(value="room-id") String roomId,
 			@RequestParam(value="icon") String icon
 			) {
 		System.out.println("HOST REQUEST:" + userid +
 		", " + name + ", " + desc + "," + roomId + "," + icon);
 		Event ev = new Event(userid, name, desc, icon, roomId);
 		ev.setOwner(owners.get(userid));
 		if(owners.get(userid) != null) {
 			owners.get(userid).hostEvent(ev);
 		}
 		events.put(ev.id, ev);
 		JSONObject object = new JSONObject();
 		try {
			object.put("user-id", name);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		putOk(object);
 		return object.toString();
 	}
 	
 	public void updateAll() {
 		for(Owner owner: owners.values()) {
 			if(!owner.active() || owner.isHost()) {
 				continue;
 			}
			Event closest = null;
			for(Event ev : events.values()) {
				if(!ev.active()) {
					continue;
				}
				if(closest == null || dist(owner.coords, ev.coords)
						< dist(owner.coords, closest.coords)) {
					closest = ev;
				}
			}
			owner.event = closest;
 		}
 	}
 	
 	public double dist(Coords c1, Coords c2) {
 		return getDistanceFromLatLonInKm(c1.lat, c1.lon, c2.lat, c2.lon);
 	}
 	
 	public double getDistanceFromLatLonInKm(double lat1,double lon1, double lat2, double lon2) {
	  double R = 6371; // Radius of the earth in km
	  double dLat = deg2rad(lat2-lat1);  // deg2rad below
	  double dLon = deg2rad(lon2-lon1); 
	  double a = 
	    Math.sin(dLat/2) * Math.sin(dLat/2) +
	    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
	    Math.sin(dLon/2) * Math.sin(dLon/2)
	    ; 
	  double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
	  double d = R * c; // Distance in km
	  return d;
	}
	double deg2rad(double deg) {
	  return deg * (3.14/180);
	}
 	@RequestMapping("/api2/user/data")
 	public String getData(
 			@RequestParam(value="user-id") String userid
 			) {
 		System.out.println("DATA REQUEST:" + userid);
 		//updateAll();
 		JSONObject object = new JSONObject();
 		try {
 			JSONArray arr = new JSONArray();
 			for(Owner owner : owners.values()) {
 				if(owner.active())
 					arr.put(owner.toJSONObject());
 			}
 			object.put("ppl", arr);
 			JSONArray evArr = new JSONArray();
 			for(Event e: events.values()) {
 				if(e.active())
 					evArr.put(e.toJSONObject());
 			}
 			object.put("events", evArr);
 		} catch(JSONException e) {
 			e.printStackTrace();
 		}
 		putOk(object);
 		return object.toString();
 	}
 	
 	@RequestMapping("/api2/user/vote")
 	public String vote(
 			@RequestParam(value="user-id") String userid,
 			@RequestParam(value="value") String val,
 			@RequestParam(value="event-id") String eid
 			) {
 		System.out.println("VOTE REQUEST:" + userid +"," + val + "," + eid);
 		Integer id = Integer.parseInt(eid);
 		JSONObject obj = new JSONObject();
 		if(!events.containsKey(id) || !owners.containsKey(userid)){
 			return obj.toString();
 		}
 		events.get(id).vote(owners.get(userid), Integer.parseInt(val));
 		putOk(obj);
 		return obj.toString();
 	}
 	public void putOk(JSONObject obj){
 		try {
			obj.put("OK", "OK");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
 	}
 	@RequestMapping("/api2/user/join")
 	public String join(
 			@RequestParam(value="user-id") String userid,
 			@RequestParam(value="event-id") String eid
 			) {
 		System.out.println("JOIN REQUEST:" + userid +"," + eid);
 		Integer id = Integer.parseInt(eid);
 		JSONObject obj = new JSONObject();
 		if(!owners.containsKey(userid) || !events.containsKey(id)){
 			return obj.toString();
 		}
 		owners.get(userid).setEvent(events.get(id));
 		putOk(obj);
 		return obj.toString();
 	}
 	@RequestMapping("/api2/user/abandon")
 	public String abandon(
 			@RequestParam(value="user-id") String userid
 			) {
 		owners.get(userid).setEvent(null);
 		JSONObject obj = new JSONObject();
 		putOk(obj);
 		return obj.toString();
 	}
}
