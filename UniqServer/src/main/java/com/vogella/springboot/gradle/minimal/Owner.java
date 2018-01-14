package com.vogella.springboot.gradle.minimal;

import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

public class Owner {
	String email;
	Coords coords;
	Date lastUpdate;
	Event event;
	final static int activity = 1000 * 5 * 60;
	Owner(String email){
		this.email = email;
		lastUpdate = new Date(0);
		event = null;
	}
	void update(Coords coords) {
		this.coords = coords;
		lastUpdate = new Date();
	}
	
	boolean isHost() {
		return this.event != null && this.event.owner == this;
	}
	void hostEvent(Event event) {
		if(isHost()) {
			this.event.abandon();
		} else if(this.event != null) {
			this.event.leave(this);
		}
		this.event = event;
	}
	void setEvent(Event event) {
		if(isHost()) {
			this.event.abandon();
		} else if(this.event != null){
			this.event.leave(this);
		}
		if(event != null) {
			event.voteYes(this);
		}
		this.event = event;
	}
	boolean active() {
		return new Date().getTime() - lastUpdate.getTime() <= activity;
	}
	@Override
    public boolean equals(Object arg0) {

        System.out.println("in equals");

        Owner obj=(Owner)arg0;

        if(this.email.equals(obj.email))
        {
                return true;
        }
        return false;
    }
	@Override
	public int hashCode() {
	    return this.email.hashCode();
	}
	public JSONObject toJSONObject() {
		JSONObject obj = new JSONObject();
		try {
			obj.put("user-id", email);
			obj.put("coords", coords.toJSONObject());
			if(event != null) {
				obj.put("event-id", event.id);
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return obj;
	}
}
