
//REFERENCE: https://www.mediawiki.org/wiki/API:Images  
//REFERENCE: https://forum.processing.org/two/discussion/25957/how-to-get-links-of-api-images-of-wikipedia-in-processing#latest
//REFERENCE: https://stackoverflow.com/questions/8363531/accessing-main-picture-of-wikipedia-page-by-api
//REFERENCE: https://forum.processing.org/two/discussion/25686/http-header-with-api-key-to-access-json


import http.requests.*;

final String HTTPS="https://";
final String WIKI_PAGE="Albert%20Einstein";
final String WIKIPEDIA_IMAGES_QUERY_LIST=HTTPS+"en.wikipedia.org/w/api.php?action=query&prop=images&format=json&formatversion=2&titles="+WIKI_PAGE;
final String WIKIPEDIA_IMAGE_QUERY_URL=HTTPS+"en.wikipedia.org/w/api.php?action=query&prop=imageinfo&iiprop=url&format=json&formatversion=2&titles=Image:";

String imgURL="";

public void setup() 
{
  size(400, 400);
  smooth();
  GetRequest get;
  JSONObject values;

  get = new GetRequest(WIKIPEDIA_IMAGES_QUERY_LIST);
  get.send(); // program will wait untill the request is completed

  //println("response: " + get.getContent());


  values=parseJSONObject(get.getContent());  //SAMPLE at responseQuery1  @@@@@@@@@@@@@@@@@@
  //   OR
  //values = loadJSONObject("wiki.json");    //Available

  println("\n=================================");
  println("READ::: Size of response", values.size());
  println("READ::: Content of tag \"continue\":", values.getJSONObject("continue"));
  println("READ::: Value of ", "imcontinue: ", values.getJSONObject("continue").getString("imcontinue") );

  println("\n=================================");
  println(values.getJSONObject("query").getJSONArray("pages").size(), 
    values.getJSONObject("query").getJSONArray("pages").getJSONObject(0).getInt("pageid"), 
    values.getJSONObject("query").getJSONArray("pages").getJSONObject(0).getString("title"));

  println("\n=================================");
  int n=values.getJSONObject("query").getJSONArray("pages").getJSONObject(0).getJSONArray("images").size();
  JSONArray imgs=values.getJSONObject("query").getJSONArray("pages").getJSONObject(0).getJSONArray("images");
  println("READ::: Number of images= "+n);  
  println("READ::: Title of first image(from array)= "+imgs.getJSONObject(0).getString("title"));

  println("\n=================================");
  for (int i=0; i<n; i++) {
    println("Image "+i+"=> "+imgs.getJSONObject(i).getString("title"));
  }  

  String reqImg=imgs.getJSONObject(3).getString("title");  //Image 3=> File:Albert Einstein Head.jpg
  reqImg=getFileName(reqImg);           //Remove "File:"
  reqImg=htmlCustomFormatter(reqImg);   //Remove white spaces from URL   
  get = new GetRequest(WIKIPEDIA_IMAGE_QUERY_URL+reqImg);
  get.send(); // program will wait untill the request is completed
  //println("response: " + get.getContent());


  values=parseJSONObject(get.getContent()); //SAMPLE at responseQuery2  @@@@@@@@@@@@@@@@@@


  imgURL=values.getJSONObject("query").getJSONArray("pages").getJSONObject(0).getJSONArray("imageinfo").getJSONObject(0).getString("url");
  println("Image to load from external: ", imgURL);

  noLoop();
  imageMode(CENTER);
}

void draw() {
  background(200, 20, 220);
  PImage img=loadImage(imgURL);
  image(img, width/2, height/2, width, height);
}

void mouseClicked() {
  exit();
}

String getFileName(String in) {
  boolean goodValue=in.startsWith("File:");
  String ret=null;

  if (goodValue) ret=in.substring(in.indexOf(":")+1);

  println("Requisting image: "+ret);
  return  ret;
}
String htmlCustomFormatter(String in) {
  boolean goodValue=in!=null;
  String ret=null;

  if (goodValue) ret=in.replaceAll(" ", "%20");

  println("Requisting image(formatted): "+ret);
  return  ret;
}