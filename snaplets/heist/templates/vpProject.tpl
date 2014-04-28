<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>VP Dashboard</title>
<style>
.indent{padding-left:20px}
body {
	background-color: #CCC;
}
.mappedFeature {
	color: #0C0;
}
</style>
<script src="SpryAssets/SpryCollapsiblePanel.js" type="text/javascript"></script>
<link href="SpryAssets/SpryCollapsiblePanel.css" rel="stylesheet" type="text/css" />
</head>

<body>
<table width="100%" border="0">
  <tr>
    <td colspan="2" bgcolor="#33CCFF"><h1>Project &quot;ClaferMooVisualizer&quot;</h1>
    <p><a href="WholePlatform.html">Virtual Platform Dashboard</a></p></td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">
    <div id="CollapsiblePanel1" class="CollapsiblePanel">
      <div class="CollapsiblePanelTab" tabindex="0"><h2>Feature Model</h2></div>
      <div class="CollapsiblePanelContent"><span class="claferDecl" id="c0_ClaferMooVisualizer">ClaferMooVisualizer</span>
  <div class="indent">
  <span class="claferDecl" id="c0_server">server</span>
    <div class="indent">
    <span class="keyword">or</span> <span class="claferDecl" id="c0_backends">backends</span>
      <div class="indent">
      <span class="claferDecl" id="c0_ClaferMoo">ClaferMoo</span></div>
      <div class="indent">
      <span class="claferDecl" id="c0_ChocoSingle">ChocoSingle</span></div>
    </div>
    <div class="indent">
    <span class="claferDecl" id="c0_cache">cache</span></div>
    <div class="indent">
    <span class="claferDecl" id="c0_examples">examples</span></div>
    <div class="indent">
    <span class="claferDecl" id="c0_processManagement">processManagement</span>
      <div class="indent">
        <a href="polling.html"><span class="claferDecl" id="c0_polling"><span class="mappedFeature">polling</span></span></a></div>
      <div class="indent">
      <span class="claferDecl" id="c0_timeouts"><span class="mappedFeature">timeouts</span></span></div>
      <div class="indent">
        <span class="mappedFeature"><span class="claferDecl" id="c0_errorHandling">errorHandling</span></span></div>
      <div class="indent">
      <span class="claferDecl" id="c0_cancellation">cancellation</span></div>
    </div>
  </div>
  <div class="indent">
  <span class="claferDecl" id="c0_client">client</span>
    <div class="indent">
    <span class="claferDecl" id="c0_jquery">jquery</span>
      <div class="indent">
      <span class="claferDecl" id="c0_windowsEngine">windowsEngine</span></div>
      <div class="indent">
      <span class="claferDecl" id="c0_forms">forms</span></div>
    </div>
    <div class="indent">
    <span class="claferDecl" id="c0_hottracking">hottracking</span></div>
    <div class="indent">
    <span class="claferDecl" id="c0_help_pages">help_pages</span></div>
    <div class="indent">
    <span class="claferDecl" id="c0_automaticViewSizing">automaticViewSizing</span><span class="inlinecomment">(cloned from <a href="vpdevMain.html">ClaferIDE</a>)</span>
    </div>
    <div class="indent">
    <span class="claferDecl" id="c0_views">views</span>
      <div class="indent">
      <span class="claferDecl" id="c0_bubbleFrontGraph">bubbleFrontGraph</span></div>
      <div class="indent">
      <span class="claferDecl" id="c0_variantComparer">variantComparer</span>
        <div class="indent">
        <span class="claferDecl" id="c0_removeVariant">removeVariant</span></div>
      </div>
      <div class="indent">
      <span class="claferDecl" id="c0_featureAndQualityMatrix">featureAndQualityMatrix</span>
        <div class="indent">
        <span class="claferDecl" id="c0_expandCollapse">expandCollapse</span></div>
        <div class="indent">
        <span class="claferDecl" id="c0_sorting">sorting</span>
          <div class="indent">
          <span class="claferDecl" id="c0_byId">byId</span></div>
          <div class="indent">
          <span class="claferDecl" id="c0_byQuality">byQuality</span></div>
        </div>
        <div class="indent">
        <span class="claferDecl" id="c0_filtering">filtering</span></div>
      </div>
      <div class="indent">
      <span class="claferDecl" id="c0_objectives">objectives</span></div>
      <div class="indent">
      <span class="claferDecl" id="c0_claferSourceView">claferSourceView</span></div>
      <div class="indent">
      <span class="claferDecl" id="c0_input">input</span>
        <div class="indent">
        <span class="claferDecl" id="c1_examples">examples</span></div>
      </div>
    </div>
    <div class="indent">
    <span class="claferDecl" id="c0_icons">icons</span></div>
  </div>
</div>
    </div>
    
    


    </td>
    <td valign="top"><table width="100%" border="0">
      <tr>
        <td bgcolor="#FFFFFF"><div id="CollapsiblePanel3" class="CollapsiblePanel">
          <div class="CollapsiblePanelTab" tabindex="0"><h2>Project Statistics</h2></div>
          <div class="CollapsiblePanelContent">
            <p>Number of Declared Features:34 (3 features mapped)</p>
            <p>Number of Annotated Features: 5 (2 undeclared features)</p>
            <p>Total lines of code: 1000, in which 700 mapped to features(70%), 400 annotated by embedded annotation(40%), 121 lines of annotation(12.1%).</p>
            <p>200 lines of code shared by at least two features(20%).</p>
            <p>Number of Fragments in code: 70          </p>
          </div>
        </div>
          <p>&nbsp;</p></td>
      </tr>
      <tr>
        <td bgcolor="#FFFFFF">
            <div id="CollapsiblePanel2" class="CollapsiblePanel">
              <div class="CollapsiblePanelTab" tabindex="0"><h2>Validation</h2></div>
              <div class="CollapsiblePanelContent">
                <p>Unpaired annotation: </p>
                <p>/Server/server.js, L124 : unpaired end annotation.</p>
              </div>
            </div>
            <p>
          <p></td>
      </tr>
    </table>
     
    </td>
  </tr>
  <tr>
    <td colspan="2"><div id="CollapsiblePanel4" class="CollapsiblePanel">
      <div class="CollapsiblePanelTab" tabindex="0"><h2>Artifacts</h2></div>
      <div class="CollapsiblePanelContent">(Folders and Files tree)</div>
    </div></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
</table>
<script type="text/javascript">
var CollapsiblePanel2 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel2");
var CollapsiblePanel3 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel3");
var CollapsiblePanel1 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel1");
var CollapsiblePanel4 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel4");
</script>
</body>
</html>
