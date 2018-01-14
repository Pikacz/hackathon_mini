package com.vogella.springboot.gradle.minimal;

import java.util.HashSet;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Event {
	static int lastId = 0;
	int id;
	String name;
	String desc;
	String icon;
	String roomId;
	Owner owner;
	Coords coords;
	boolean following;
	HashSet<Owner> yes = new HashSet<>(), no = new HashSet<>();
	Event(String data, String name, String desc, String icon, String roomId){
		this.roomId = roomId;
		this.name = name;
		this.desc = desc;
		this.icon = icon;
		following = true;
		this.id = lastId++;
	}
	
	void setOwner(Owner owner) {
		this.owner = owner;
	}
	void abandon() {
		this.owner = null;
		for(Owner ow: yes) {
			if(ow.event == this) {
				ow.event = null;
			}
		}
		for(Owner ow: no) {
			if(ow.event == this) {
				ow.event = null;
			}
		}
	}
	void leave(Owner ow) {
		yes.remove(ow);
		no.remove(ow);
	}
	void settle() {
		following = false;
		coords = owner.coords;
	}
	
	void pickup() {
		following = true;
	}
	
	Coords getCoords() {
		if(following) {
			return owner.coords;
		} else {
			return coords;
		}
	}
	
	boolean active() {
		return owner != null && owner.active();
	}
	
	JSONObject toJSONObject() {
		JSONObject obj = new JSONObject();
 		try {
 			obj.put("id", id);
 			obj.put("name", name);
 			obj.put("desc", desc);
 			obj.put("icon", icon);
 			obj.put("room-id", roomId);
 			obj.put("yes", yes.size());
 			obj.put("no", no.size());
 			if(owner != null)
 				obj.put("owner-id", owner.email);
 			if(getCoords() != null)
 				obj.put("coords", getCoords().toJSONObject());
 			JSONArray arr = new JSONArray();
 			for(Owner ow: yes) {
 				arr.put(ow.email);
 			}
 			for(Owner ow: no) {
 				arr.put(ow.email);
 			}
 			obj.put("guests-id", arr);
 			obj.put("following-owner", following);
 		} catch (JSONException e) {
			e.printStackTrace();
		}
 		return obj;
	}
	void voteYes(Owner owner) {
		yes.add(owner);
		no.remove(owner);
	}
	void voteNo(Owner owner) {
		yes.remove(owner);
		no.add(owner);
	}
	void vote(Owner owner, Integer i){
		if(i == 0){
			voteNo(owner);
		} else if(i == 1){
			voteYes(owner);
		}
	}
}