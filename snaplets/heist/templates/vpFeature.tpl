<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Feature "Polling"</title>
<style type="text/css">
body {
	background-color: #CCC;
}
</style>
</head>

<body>
<table width="100%" border="0">
  <tr>
    <td bgcolor="#33CCFF">
    <h1>Feature &quot;Polling&quot;</h1>
    </td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">
    <h2>Statistics</h2>
    <table>
    <tr><td>Project</td><td><a href="vpProject.tpl">ClaferMooVisualizer</a></td></tr>
    <tr><td>Fully qualified name</td><td>ClaferMooVisualizer::server::<span class="claferDecl">processManagement</span>::polling</td></tr>
    <tr><td>LPQ name</td><td>polling</td></tr>
    <tr><td>Provenance Info</td><td>Originally created here</td></tr>
    <tr><td>Number of folders &amp; files</td><td>0</td></tr>
    <tr><td>Total lines of code</td><td>400</td></tr>
    <tr><td>Total lines of code annotated by embedded annotations</td><td>400</td></tr>
    <tr><td>Number of code fragments</td><td>6</td></tr>
    <tr><td>Number of annotation lines</td><td>12</td></tr>
    </table>
    </td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF"><h2>Assets</h2>
    <p>In /Server/server.js: Line 435-664</p>
    <p>//&amp;begin [polling]<br />
      /* =============================================== */<br />
      // POLLING Requests<br />
      /* ------------------------------------------*/</p>
    <p>/*<br />
      * Handle Polling<br />
      * The client will poll the server to get the latest updates or the final result<br />
      * Polling is implemented to solve the browser timeout problem.<br />
      * Moreover, this helps to control the execution of a tool: to stop, or to get intermediate results.<br />
      * An alternative way might be to create a web socket<br />
      */</p>
    <p>server.post('/poll', /*pollingMiddleware,*/ function(req, res, next)<br />
      {<br />
      var process = core.getProcess(req.body.windowKey);<br />
      if (process == null)<br />
      {<br />
      res.writeHead(404, { &quot;Content-Type&quot;: &quot;application/json&quot;});<br />
      res.end('{&quot;message&quot;: &quot;Error: the requested process is not found.&quot;}'); <br />
      // clearing part<br />
      core.cleanProcesses();<br />
      core.logSpecific(&quot;Client polled&quot;, req.body.windowKey);<br />
      return;<br />
      }</p>
    <p> if (req.body.command == &quot;ping&quot;) // normal ping<br />
      { <br />
      core.timeoutProcessClearPing(process);</p>
    <p> if (process.mode_completed) // the execution of the current mode is completed<br />
      {<br />
      if (process.mode == &quot;compiler&quot;) // if the mode completed is compilation<br />
      { <br />
      // finished compilation. Start optimization right a way.<br />
      //                console.log(&quot;COMPLETED COMPILER&quot;);</p>
    <p> core.timeoutProcessSetPing(process);</p>
    <p> var jsonObj = new Object();<br />
      jsonObj.message = &quot;Working&quot;;<br />
      jsonObj.compiled_formats = process.compiled_formats;<br />
      jsonObj.args = process.compiler_args;<br />
      jsonObj.compiler_message = process.compiler_message;</p>
    <p> process.compiler_args = &quot;&quot;;<br />
      res.writeHead(200, { &quot;Content-Type&quot;: &quot;application/json&quot;});<br />
      res.end(JSON.stringify(jsonObj));</p>
    <p> process.mode = &quot;ig&quot;;<br />
      process.mode_completed = false;<br />
      runOptimization(process);<br />
      }<br />
      else<br />
      {<br />
      //                console.log(&quot;COMPLETED MOO&quot;);<br />
      var jsonObj = new Object();</p>
    <p> if (process.instancesOnly)<br />
      {<br />
      console.log(&quot;returning instances...&quot;);<br />
      res.writeHead(200, { &quot;Content-Type&quot;: &quot;application/json&quot;});<br />
      jsonObj.optimizer_message = &quot;Instances successfully returned&quot;;<br />
      jsonObj.optimizer_instances = process.instances;<br />
      jsonObj.optimizer_instances_only = true;<br />
      res.end(JSON.stringify(jsonObj));<br />
      }<br />
      else<br />
      {</p>
    <p> var data_result = process.freshData;<br />
      process.freshData = &quot;&quot;;</p>
    <p> var error_result = process.freshError;<br />
      process.freshError = &quot;&quot;;</p>
    <p> console.log(&quot;Preparing to send the result...&quot;);<br />
      <br />
      var code = process.code;</p>
    <p> if (error_result.indexOf('Exception in thread &quot;main&quot;') &gt; -1)<br />
      {<br />
      code = 1;<br />
      }</p>
    <p> if (code === 0) <br />
      { <br />
      var parts = data_result.split(&quot;=====&quot;);<br />
  <br />
      if (parts.length != 2)<br />
      {<br />
      jsonObj.optimizer_message = 'Error, instances and normal text must be separated by &quot;=====&quot;';<br />
      console.log(data_result);<br />
      }<br />
      else<br />
      {<br />
  <br />
      var message = parts[0]; //<br />
      console.log(message);<br />
      var instances = parts[1]; // <br />
      // todo : error handling<br />
  <br />
      console.log(process.file + '.xml');<br />
      var xml = fs.readFileSync(process.file + '.xml');<br />
      // this code assumes the backend should produce an XML,<br />
      // which is not the correct way<br />
  <br />
      jsonObj.optimizer_message = message;<br />
      jsonObj.optimizer_instances_only = false;<br />
      jsonObj.optimizer_instances = instances;<br />
      jsonObj.optimizer_claferXML = xml.toString();<br />
      jsonObj.optimizer_from_cache = process.loadedFromCache;<br />
      //&amp;begin [cache]<br />
      if (process.cacheEnabled &amp;&amp; !process.loadedFromCache) // caching the results<br />
      {<br />
      fs.writeFile(process.cache_file_name, data_result, function(err)<br />
      {<br />
      if (err)<br />
      {<br />
      core.logSpecific(&quot;Could not write cache: &quot; + process.cache_file_name, process.windowKey); <br />
      }<br />
      else<br />
      {<br />
      core.logSpecific(&quot;The cache file successfully saved: &quot; + process.cache_file_name, process.windowKey);<br />
      }<br />
      });<br />
      }<br />
      }<br />
      //&amp;end [cache]<br />
      }<br />
      else <br />
      {<br />
      jsonObj.optimizer_message = 'Error, return code: ' + code + '\n' + error_result;<br />
      console.log(data_result);<br />
      }</p>
    <p> jsonObj.model = process.model;</p>
    <p> if (code == 0)<br />
      {<br />
      res.writeHead(200, { &quot;Content-Type&quot;: &quot;application/json&quot;});<br />
      }<br />
      else<br />
      {<br />
      res.writeHead(400, { &quot;Content-Type&quot;: &quot;application/json&quot;});<br />
      } </p>
    <p> jsonObj.message = jsonObj.optimizer_message;</p>
    <p> jsonObj.ig_args = process.ig_args;<br />
      process.ig_args = &quot;&quot;; </p>
    <p> res.end(JSON.stringify(jsonObj));</p>
    <p> // if mode is completed, then the tool is not busy anymore, so now it's time to <br />
      // set inactivity timeout<br />
      }</p>
    <p> core.timeoutProcessClearInactivity(process);<br />
      core.timeoutProcessSetInactivity(process);<br />
      }</p>
    <p> } <br />
      else // still working<br />
      {<br />
      //            console.log(&quot;WORKING&quot;);<br />
      core.timeoutProcessSetPing(process);</p>
    <p> res.writeHead(200, { &quot;Content-Type&quot;: &quot;application/json&quot;});<br />
      var jsonObj = new Object();<br />
      jsonObj.message = &quot;Working&quot;;<br />
      jsonObj.args = process.compiler_args;<br />
      process.compiler_args = &quot;&quot;;</p>
    <p> jsonObj.ig_args = process.ig_args;<br />
      process.ig_args = &quot;&quot;; </p>
    <p> res.end(JSON.stringify(jsonObj));</p>
    <p> console.log(jsonObj.message);<br />
      }<br />
      }<br />
      //&amp;begin cancellation<br />
      else // if it is cancel<br />
      {<br />
      process.toKill = true;<br />
      core.timeoutProcessClearPing(process);</p>
    <p> // starting inactivity timer<br />
      core.timeoutProcessClearInactivity(process);<br />
      core.timeoutProcessSetInactivity(process);</p>
    <p> res.writeHead(200, { &quot;Content-Type&quot;: &quot;application/json&quot;});</p>
    <p> var jsonObj = new Object();<br />
      jsonObj.message = &quot;Cancelled&quot;;<br />
      jsonObj.scopes = &quot;&quot;;<br />
      jsonObj.compiler_message = &quot;Cancelled compilation&quot;;<br />
      jsonObj.completed = true;<br />
      res.end(JSON.stringify(jsonObj));</p>
    <p> core.logSpecific(&quot;Cancelled: &quot; + process.toKill, req.body.windowKey);<br />
      }<br />
      //&amp;end cancellation<br />
      // clearing part<br />
      core.cleanProcesses();<br />
      core.logSpecific(&quot;Client polled&quot;, req.body.windowKey);<br />
  <br />
      });<br />
      //&amp;end [polling]</p>
<p>In /Server/Client/md_input.js: Line 222</p>
    <p>...</p>
    <p>...</p>
  </td>
  </tr>
</table>
</body>
</html>
