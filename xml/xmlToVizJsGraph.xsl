<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="Graph" href="xmlToVizJsGraph.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToVizJsGraph.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/dot/generate.xsl"/>
	<xsl:import href="xmlToDot.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルを有効グラフに変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードを有効グラフに変換する。</xsltdoc:detail>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-08-16</xsltdoc:version>
		<xsltdoc:since>2015-01-29</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/html51/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output
		method="html"
		version="5.1"
		encoding="UTF-8"
		indent="no"
		media-type="text/html"
	/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToVizJsGraph.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのタイトル</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToVizJsGraph.name">XMLNodeGraph</xsl:param>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードをDOT言語に変換する</xsltdoc:short>
		<xsltdoc:detail>このXSLTでXMLを変換した場合、最初に呼び出される。</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLのグラフ"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>]]></xsl:text>

		<html>
			<head>
				<meta lang="en" xml:lang="en" name="description" content="This file is a XML Node Graph. Powered by viz.js."/>
				<meta name="generator" content="{system-property('xsl:vendor')}"/>

				<title>XML Node Graph</title>

				<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/viz.js/1.8.0/viz-lite.js"></script>
				<script type="text/javascript"><![CDATA[
				var dot;
				var list = {
					"dot": {
						"name": "DOT",
						"mime": "text/plain",
						"ext": "dot"
					},
					"svg": {
						"name": "SVG",
						"mime": "image/svg+xml",
						"ext": "svg"
					},
					"plain": {
						"name": "Plain Text",
						"mime": "text/plain",
						"ext": "txt"
					},
					"xdot": {
						"name": "xdot",
						"mime": "text/plain",
						"ext": "dot"
					},
					"ps": {
						"name": "Post Script",
						"mime": "application/postscript",
						"ext": "ps"
					},
					"json": {
						"name": "JSON",
						"mime": "apprication/json",
						"ext": "json"
					}
				};

				var filename = "]]><xsl:value-of select="$cxsltl:xmlToVizJsGraph.name"/><![CDATA[";

				function dataUriScheme(data, mime, charset) {
					return "data:" + mime + ";charset=" + charset + ";base64," + window.btoa(unescape(encodeURIComponent(data)));
				}

				function showGraph(format) {
					var main = document.getElementById("main");

					Array.prototype.forEach.call(main.childNodes, function(node) {
						node.parentNode.removeChild(node);
					});

					try {
						if(format === "dot") {
							var result = dot;
						} else {
							var result = Viz(dot, {"format": format});
						}

						var downloadLink = document.getElementById("downloadLink");
						downloadLink.href = dataUriScheme(result, list[format]["mime"], "UTF-8");
						downloadLink.download = filename + "." + list[format]["ext"];

						if(format === "svg") {
							main.innerHTML = result;
						} else {
							var pre = document.createElement("pre");
							var code = document.createElement("code");
							code.appendChild(document.createTextNode(result));
							pre.appendChild(code);

							main.appendChild(pre);
						}
					} catch(e) {
						var pre = document.createElement("pre");
						var samp = document.createElement("samp");
						samp.appendChild(document.createTextNode(e.toString()));
						pre.appendChild(samp);

						main.appendChild(pre);
					}
				}

				function hashGraphShow() {
					var hash = location.hash.slice(1);

					if(list.hasOwnProperty(hash)) {
						showGraph(hash);

						Array.prototype.forEach.call(document.getElementById("formatMenu").options, function(option) {
							if(option.value === hash) {
								option.selected = true;
							}
						});
					}
				}

				window.onhashchange = hashGraphShow;

				window.onload = function() {
					document.body.removeChild(document.getElementById("noscript"));

					dot = document.getElementById("main").textContent;

					var nav = document.createElement("nav");
					nav.appendChild(document.createTextNode("Format: "));

					var select = document.createElement("select");
					select.id = "formatMenu";
					select.onchange = function() {
						location.hash = "#" + this.value;
					}

					nav.appendChild(select);

					document.body.insertBefore(nav, document.getElementById("main"));

					Object.keys(list).forEach(function(key) {
						var option = document.createElement("option");
						option.value = key;
						option.text = this[key]["name"];

						document.getElementById("formatMenu").appendChild(option);
					}, list);

					nav.appendChild(document.createTextNode(" - "));

					var a = document.createElement("a");
					a.id = "downloadLink";
					a.href = dataUriScheme(dot, list["dot"]["mime"], "UTF-8");
					a.download = filename + "." + list["dot"]["ext"];
					a.appendChild(document.createTextNode("Download"));

					nav.appendChild(a);

					hashGraphShow();
				};
				]]></script>
			</head>
			<body>
				<p lang="en" xml:lang="en" id="noscript">Please enable Javascript To display a directed graph.</p>

				<main id="main">
					<pre><code>
						<xsl:call-template name="cxsltl:dot.generate.graph">
							<xsl:with-param name="name" select="$cxsltl:xmlToVizJsGraph.name"/>
							<xsl:with-param name="graph">digraph</xsl:with-param>
							<xsl:with-param name="content">
									<xsl:call-template name="cxsltl:dot.generate.node">
									<xsl:with-param name="node">graph</xsl:with-param>
									<xsl:with-param name="attribute">rankdir="LR"</xsl:with-param>
								</xsl:call-template>

								<xsl:call-template name="cxsltl:xmlToDot.convert">
									<xsl:with-param name="node" select="//self::node() | //@*"/>
								</xsl:call-template>

								<xsl:for-each select="//namespace::*[not(starts-with(translate(name(), 'XML', 'xml'), 'xml'))]">
									<xsl:if test="not(. = parent::*/parent::*/namespace::*[name() = name(current())])">
										<xsl:call-template name="cxsltl:xmlToDot.convert"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:with-param>
						</xsl:call-template>
					</code></pre>
				</main>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>