## URL Checker
Gem to check the status codes returned by a provided list of URLs.

###Usage
        UrlChecker.check_urls(urls)

The UrlChecker class exposes one public interface, the #check_urls method. This method takes a single argument that should be a JSON formatted string representing the URLs that are to be checked. UrlChecker will traverse the entire JSON object, pulling all key/value pairs with a key of "url" and then use the key's value as the URL to check. The UrlChecker will check urls in a background resque job and invoke a user defined callback upon completion. The Resque queue is named url_checker_queue so if you're starting your resque queues explicity, you must have a queue with that name.

###Examples
Example usage:<br/>
<code>
        UrlChecker.check_urls("{\"awards\":[{\"id\":1,\"url\":\"http://www.fastweb.com/\"},{\"id\":2,\"url\":\"https://www.google.com/\"},{\"id\":3,\"url\":\"invalid url\"},{\"id\":4,\"url\":\"www.cnn.com\"}]}")
</code>

Upon completion, UrlChecker will invoke a callback method that must be defined by the user's application. The application must have a class named UrlCheckerResultsProcessor and define a #process_results(results) method. The parameter to the #process_results method will be a JSON formatted string separating URLs with a successful status code, 2XX or 3XX, from those with a failed status code, 4XX or 5XX. Successful URLs are returned under the key "success" while failed URLs are returned under the key "failed". Deatils about the success/failed status can be access under the key "validity". All key/value pairs at the same nesting level as any found "url" keys will be returned as well so that you can provide metadata about the URLs being checked for identification purposes.

Example return value:<br/>
<code>
"{\"success\":[{\"id\":1,\"url\":\"http://www.fastweb.com/\",\"validity\":{\"status\":\"success\",\"http_resp_code\":200,\"message\":\"HTTP response code: 200\"}},{\"id\":2,\"url\":\"https://www.google.com/\",\"validity\":{\"status\":\"success\",\"http_resp_code\":200,\"message\":\"HTTP response code: 200\"}}],\"failed\":[{\"id\":3,\"url\":\"invalid url\",\"validity\":{\"status\":\"failed\",\"http_resp_code\":null,\"message\":\"bad URI(is not URI?): invalid url\"}},{\"id\":4,\"url\":\"www.cnn.com\",\"validity\":{\"status\":\"failed\",\"http_resp_code\":null,\"message\":\"No protocol specified for URL\"}}]}"
</code>

And converted to a JSON object:<br/>
<code>
{<br/>
  "success": [<br/>
    {<br/>
      "id": 1,<br/>
      "url": "http://www.fastweb.com/",<br/>
      "validity": {<br/>
        "status": "success",<br/>
        "http_resp_code": 200,<br/>
        "message": "HTTP response code: 200"<br/>
      }<br/>
    },<br/>
    {<br/>
      "id": 2,<br/>
      "url": "https://www.google.com/",<br/>
      "validity": {<br/>
        "status": "success",<br/>
        "http_resp_code": 200,<br/>
        "message": "HTTP response code: 200"<br/>
      }<br/>
    }<br/>
  ],<br/>
  "failed": [<br/>
    {<br/>
      "id": 3,<br/>
      "url": "invalid url",<br/>
      "validity": {<br/>
        "status": "failed",<br/>
        "http_resp_code": null,<br/>
        "message": "bad URI(is not URI?): invalid url"<br/>
      }<br/>
    },<br/>
    {<br/>
      "id": 4,<br/>
      "url": "www.cnn.com",<br/>
      "validity": {<br/>
        "status": "failed",<br/>
        "http_resp_code": null,<br/>
        "message": "No protocol specified for URL"<br/>
      }<br/>
    }<br/>
  ]<br/>
}<br/>
</code>
