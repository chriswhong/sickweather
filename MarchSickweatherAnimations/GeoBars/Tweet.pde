// Tweet.pde
// (c) 2012 David Troy (@davetroy)
//
// A simple class for each tweet. For the purposes of trails we are only storing
// a unix timestamp, a screenName, and a latitude and longitude. An optional lifespan
// is specified here but is not used. It could be used for aging out and removing a tweet
// from a trail. Each tweet acts as a waypoint on a gps trail. Trails with a length of
// one tweet (waypoint) just act as single markers and are plotted accordingly.

public class Tweet {
  int timestamp;
  float lat, lon;
  float lifespan;
  String ailment;

  Tweet(String rowString) {
    String[] row = split(rowString, ',');
    ailment = row[0];
    lat = parseFloat(row[1]);
    lon = parseFloat(row[2]);
    timestamp = parseInt(row[3]);
    lifespan=255.0;
   
   
  }

  PVector screenLocation() {
    return mercatorMap.getScreenLocation(new PVector(lat, lon));
  }

  boolean isDead() {
    if (lifespan <= 1) {
      return true;
    } 
    else {
      return false;
    }
  }
}

