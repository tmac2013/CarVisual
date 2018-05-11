package CarVisual.bean;

import java.io.Serializable;

public class CarLocation implements Serializable {
	private String longitude;
	private String latitude;
	private String time;

	public CarLocation(){

	}

	public CarLocation(String longitude,String latitude,String time){
		this.longitude = longitude;
		this.latitude = latitude;
		this.time = time;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}
}
