<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.opensearch11ToHtml.stylesheet"
	exclude-result-prefixes="cxsltl moz opensearch rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:moz="http://www.mozilla.org/2006/browser/search/"
	xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/basicMetaInformation.xsl"/>
	<xsl:import href="../library/json/generate.xsl"/>
	<xsl:import href="../library/opensearch11/basicMetaInformation.xsl"/>
	<xsl:import href="../library/opensearch11/get.xsl"/>
	<xsl:import href="../library/template/html.xsl"/>
	<xsl:import href="../library/string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT which converts OpenSearch description document 1.1 into HTML.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">OpenSearch description document 1.1 形式で書かれたファイルを XHTML 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-20</xsltdoc:version>
		<xsltdoc:since>2009-12-18</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.opensearch.org/Specifications/OpenSearch/1.1"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/html51/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:opensearch11ToHtml.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opensearch11ToHtml.deny" select="/.."/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>Open Searchのデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opensearch11ToHtml.defaultValue" select="$cxsltl:opensearch11.basicMetaInformation.defaultValue"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのコールバックするテンプレート</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opensearch11ToHtml.callback" select="$cxsltl:template.html.layout"/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のOpen Searchの要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			HTMLへの変換はxsl:call-templateを使用しcxsltl:opensearch11ToHtml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:opensearch11ToHtml.convert">
			<xsl:with-param name="node" select="opensearch:OpenSearchDescription"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for Open Search element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Open Searchのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:opensearch11ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaultValue" select="$cxsltl:opensearch11ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opensearch11ToHtml.callback"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:opensearch11ToHtml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:opensearch11ToHtml.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:OpenSearchDescription}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Open Searchのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:OpenSearchDescription" mode="cxsltl:opensearch11ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opensearch11ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opensearch11ToHtml.callback"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:opensearch11ToHtml.self/xsl:template[@name = 'cxsltl:opensearch11ToHtml.get']"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{tr}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')]" mode="cxsltl:opensearch11ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<tr>
			<xsl:apply-templates select="@type[count(. | $deny) != $denyCount]" mode="cxsltl:opensearch11ToHtml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="@template[count(. | $deny) != $denyCount]" mode="cxsltl:opensearch11ToHtml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url/@type}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{th}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')]/@type" mode="cxsltl:opensearch11ToHtml.converter">
		<th>
			<xsl:text>Template of </xsl:text>

			<code>
				<xsl:value-of select="normalize-space()"/>
			</code>
		</th>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url/@template}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{td}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')]/@template" mode="cxsltl:opensearch11ToHtml.converter">
		<td>
			<code>
				<xsl:call-template name="cxsltl:opensearch11ToHtml.templateParameterToHtml"/>
			</code>
		</td>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url[contains(concat(' ', @rel, ' '), ' self ')]/@template}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{a}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[contains(concat(' ', @rel, ' '), ' self ')][@type = 'application/opensearchdescription+xml']/@template" mode="cxsltl:opensearch11ToHtml.converter">
		<a href="{normalize-space()}" onclick="cxsltl.opensearch11ToHtml.addSearchPlugin(this.href); return false;">Add search plugin</a>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url[contains(concat(' ', @rel, ' '), ' suggestions ')]/@template}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{input}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[contains(concat(' ', @rel, ' '), ' suggestions ')][(@type = 'application/x-suggestions+json') or (@type = 'application/json')]/@template" mode="cxsltl:opensearch11ToHtml.converter">
		<input type="hidden" name="suggestions">
			<xsl:attribute name="value">
				<xsl:call-template name="cxsltl:opensearch11.get.expandTemplateParameter"/>
			</xsl:attribute>
		</input>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Image[@width = @height]}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{img}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Image[normalize-space(@width) = normalize-space(@height)]" mode="cxsltl:opensearch11ToHtml.converter">
		<img width="16" height="16" alt="" src="{normalize-space()}"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:SyndicationRight}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{tr}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:SyndicationRight" mode="cxsltl:opensearch11ToHtml.converter" name="cxsltl:opensearch11ToHtml.getSyndicationRight">
		<xsl:param name="node" select="."/>

		<tr>
			<th>Syndication Right</th>
			<td>
				<code class="cxsltl:opensearch11ToHtml.opensearch.SyndicationRight">
					<xsl:call-template name="cxsltl:opensearch11.get.syndicationRight">
						<xsl:with-param name="node" select="$node"/>
					</xsl:call-template>
				</code>
			</td>
		</tr>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:AdultContent}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{tr}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:AdultContent" mode="cxsltl:opensearch11ToHtml.converter" name="cxsltl:opensearch11ToHtml.getAdultContent">
		<xsl:param name="node" select="."/>

		<tr>
			<th>Adult Content</th>
			<td>
				<code class="cxsltl.opensearch11ToHtml.opensearch.AdultContent">
					<xsl:call-template name="cxsltl:opensearch11.get.adultContent">
						<xsl:with-param name="node" select="$node"/>
					</xsl:call-template>
				</code>
			</td>
		</tr>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{moz:SearchForm}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{input}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="moz:SearchForm" mode="cxsltl:opensearch11ToHtml.converter">
		<input type="hidden" name="moz:SearchForm" value="{normalize-space()}"/>
	</xsl:template>

	<!-- ==============================
		## xsl:template for Search Content
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:opensearch11ToHtml.searchContent">
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:opensearch11ToHtml.searchContent">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:opensearch11ToHtml.searchContent"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:OpenSearchDescription}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{div}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:OpenSearchDescription" mode="cxsltl:opensearch11ToHtml.searchContent">
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<div class="cxsltl.opensearch11ToHtml.content">
			<xsl:call-template name="cxsltl:opensearch11ToHtml.script"/>

			<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>

			<xsl:if test="opensearch:Url[contains(concat(' ', @rel, ' '), ' self ')][@type = 'application/opensearchdescription+xml'][count(. | $deny) != $denyCount]">
				<p class="cxsltl.opensearch11ToHtml.addSearchPlugin">
					<xsl:apply-templates select="opensearch:Image[normalize-space(@width) = normalize-space(@height)][count(. | $deny) != $denyCount][1]" mode="cxsltl:opensearch11ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="opensearch:Url[contains(concat(' ', @rel, ' '), ' self ')][@type = 'application/opensearchdescription+xml'][count(. | $deny) != $denyCount][1]" mode="cxsltl:opensearch11ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>
				</p>
			</xsl:if>

			<xsl:variable name="inputEncoding">
				<xsl:call-template name="cxsltl:opensearch11.get.inputEncoding">
					<xsl:with-param name="node" select="opensearch:InputEncoding[count(. | $deny) != $denyCount]"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:if test="
				opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')][count(. | $deny) != $denyCount] and
				contains(concat(' ', $inputEncoding, ' '), ' UTF-8 ')
			">
				<form class="cxsltl.opensearch11ToHtml.searchForm" action="#" method="get" onsubmit="cxsltl.opensearch11ToHtml.onsubmit.call(this); return false;">
					<p>
						<xsl:apply-templates select="
							(
								opensearch:Url[contains(concat(' ', @rel, ' '), ' suggestions ')][(@type = 'application/x-suggestions+json') or (@type = 'application/json')] |
								moz:SearchForm
							)[count(. | $deny) != $denyCount]
						" mode="cxsltl:opensearch11ToHtml.converter">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
						</xsl:apply-templates>

						<input type="text" name="http://a9.com/-/spec/opensearch/1.1/:searchTerms" size="50"/>
						<input type="submit" value="Search"/>
						<br/>

						<xsl:text>Response type: </xsl:text>

						<select name="url" onchange="cxsltl.opensearch11ToHtml.onchange.call(this); return false;">
							<xsl:apply-templates select="opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')]" mode="cxsltl:opensearch11ToHtml.searchContent">
								<xsl:with-param name="deny" select="$deny"/>
								<xsl:with-param name="denyCount" select="$denyCount"/>
							</xsl:apply-templates>
						</select>
					</p>

					<div class="cxsltl.opensearch11ToHtml.otherParameter">
						<table>
							<tbody>
							</tbody>
						</table>
					</div>
				</form>
			</xsl:if>

			<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>

			<div class="cxsltl.opensearch11ToHtml.detail">
				<h2>Search Engine details</h2>

				<table>
					<tbody>
						<xsl:apply-templates select="opensearch:Url[not(@rel) or contains(concat(' ', @rel, ' '), ' results ')]" mode="cxsltl:opensearch11ToHtml.converter">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
						</xsl:apply-templates>

						<xsl:call-template name="cxsltl:opensearch11ToHtml.getSyndicationRight">
							<xsl:with-param name="node" select="opensearch:SyndicationRight[count(. | $deny) != $denyCount]"/>
						</xsl:call-template>

						<xsl:call-template name="cxsltl:opensearch11ToHtml.getAdultContent">
							<xsl:with-param name="node" select="opensearch:AdultContent[count(. | $deny) != $denyCount]"/>
						</xsl:call-template>

						<tr>
							<th>Support languages</th>
							<td>
								<xsl:call-template name="cxsltl:string.split">
									<xsl:with-param name="string">
										<xsl:call-template name="cxsltl:opensearch11.get.language">
											<xsl:with-param name="node" select="opensearch:Language[count(. | $deny) != $denyCount]"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="callback" select="$cxsltl:opensearch11ToHtml.self/xsl:template[@name = 'cxsltl:opensearch11ToHtml.callback.language']"/>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<th>Support input encodings</th>
							<td>
								<xsl:call-template name="cxsltl:string.split">
									<xsl:with-param name="string">
										<xsl:call-template name="cxsltl:opensearch11.get.inputEncoding">
											<xsl:with-param name="node" select="opensearch:InputEncoding[count(. | $deny) != $denyCount]"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="callback" select="$cxsltl:opensearch11ToHtml.self/xsl:template[@name = 'cxsltl:opensearch11ToHtml.callback.encoding']"/>
									<xsl:with-param name="param1">InputEncoding</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<th>Support output encodings</th>
							<td>
								<xsl:call-template name="cxsltl:string.split">
									<xsl:with-param name="string">
										<xsl:call-template name="cxsltl:opensearch11.get.outputEncoding">
											<xsl:with-param name="node" select="opensearch:OutputEncoding[count(. | $deny) != $denyCount]"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="callback" select="$cxsltl:opensearch11ToHtml.self/xsl:template[@name = 'cxsltl:opensearch11ToHtml.callback.encoding']"/>
									<xsl:with-param name="param1">OutputEncoding</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<xsl:call-template name="cxsltl:opensearch11ToHtml.script"/>
		</div>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{option}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')]" mode="cxsltl:opensearch11ToHtml.searchContent">
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<option>
			<xsl:attribute name="value">
				<xsl:call-template name="cxsltl:json.generate.object">
					<xsl:with-param name="value">
						<xsl:apply-templates select="@template" mode="cxsltl:opensearch11ToHtml.searchContent">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
						</xsl:apply-templates>

						<xsl:call-template name="cxsltl:json.generate.contener">
							<xsl:with-param name="key">startIndex</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:call-template name="cxsltl:opensearch11.get.indexOffset">
									<xsl:with-param name="node" select="@indexOffset[count(. | $deny) != $denyCount]"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="type">literal</xsl:with-param>
							<xsl:with-param name="key1">startPage</xsl:with-param>
							<xsl:with-param name="value1">
								<xsl:call-template name="cxsltl:opensearch11.get.pageOffset">
									<xsl:with-param name="node" select="@pageOffset[count(. | $deny) != $denyCount]"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="type1">literal</xsl:with-param>
							<xsl:with-param name="wrap">parameter</xsl:with-param>
							<xsl:with-param name="indent"/>
							<xsl:with-param name="eol"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="indent"/>
					<xsl:with-param name="eol"/>
					<xsl:with-param name="last" select="true()"/>
				</xsl:call-template>
			</xsl:attribute>

			<xsl:apply-templates select="@type" mode="cxsltl:opensearch11ToHtml.searchContent">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</option>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url/@template}属性をJSONに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="key:valueを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')]/@template" mode="cxsltl:opensearch11ToHtml.searchContent">
		<xsl:call-template name="cxsltl:json.generate.string">
			<xsl:with-param name="key">template</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="cxsltl:opensearch11.get.expandTemplateParameter"/>
			</xsl:with-param>
			<xsl:with-param name="indent"/>
			<xsl:with-param name="eol"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Url/@type}属性をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Url[not(normalize-space(@rel)) or contains(concat(' ', @rel, ' '), ' results ')]/@type" mode="cxsltl:opensearch11ToHtml.searchContent">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Open SearchをHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Open Searchのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11ToHtml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opensearch11ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opensearch11ToHtml.callback"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:opensearch11ToHtml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>JavaSceip無効時のメッセージを取得する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{div}要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11ToHtml.noscript">
		<div class="cxsltl.opensearch11ToHtml.noscript">
			<p>JavaScript is turned off. Please turn on JavaScript to enable all functions.</p>
		</div>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>JavaSceipのコードを取得する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{script}要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11ToHtml.script">
		<script type="text/javascript"><![CDATA[
			var cxsltl = cxsltl || {};
			cxsltl.opensearch11ToHtml = cxsltl.opensearch11ToHtml || {};

			/**
			 * サーチプラグインを追加する
			 *
			 * @param {string} url OpenSearch description documentのURL
			 * @return {boolean} window.external.AddSearchProviderを呼び出せばtrueを、それ以外はfalseを返す
			 */
			cxsltl.opensearch11ToHtml.addSearchPlugin = cxsltl.opensearch11ToHtml.addSearchPlugin || function(url) {
				if(("external" in window) && ("AddSearchProvider" in window.external)) {
					try {
						window.external.AddSearchProvider(url);

						return true;
					} catch(e) {
						alert(e.name + ": " + e.message);

						return false;
					}
				} else {
					alert("Your browser does not support OpenSearch description document.");

					return false;
				}
			};

			/**
			 * Webブラウザーの希望する言語を取得する
			 *
			 * @return {string} 言語タグ
			 */
			cxsltl.opensearch11ToHtml.getLanguage = cxsltl.opensearch11ToHtml.getLanguage || function() {
				return (
					(window.navigator.languages && window.navigator.languages[0]) ||
					window.navigator.language || window.navigator.userLanguage ||
					window.navigator.browserLanguage || document.documentElement.lang || "*"
				);
			};

			/**
			 * ドキュメントがHTML5かチェックする
			 *
			 * @return {boolean} HTML5ならばtrueを、それ以外はfalseを返す
			 */
			cxsltl.opensearch11ToHtml.isHtml5 = cxsltl.opensearch11ToHtml.isHtml5 || function() {
				return (
					(document.doctype.name === "html") && (document.doctype.publicId === "") &&
					((document.doctype.systemId === "") || (document.doctype.systemId === "about:legacy-compat"))
				);
			};

			/**
			 * onchange時に呼び出される関数
			 *
			 * @return {boolean} falseを返す
			 */
			cxsltl.opensearch11ToHtml.onchange = cxsltl.opensearch11ToHtml.onchange || function() {
				var item = JSON.parse(this.value);
				var otherParameter = this.form.getElementsByClassName("cxsltl.opensearch11ToHtml.otherParameter")[0];
				var tbody = otherParameter.getElementsByTagName("tbody")[0];

				tbody.textContent = "";

				Array.prototype.forEach.call(otherParameter.querySelectorAll("input[type = 'hidden']"), function(element) {
					element.parentNode.removeChild(element);
				});

				Object.keys(cxsltl.opensearch11ToHtml.parameter).forEach(function(key) {
					if(~item.template.indexOf("{" + key + "}") || ~item.template.indexOf("{" + key + "?}")) {
						if(1 < this[key].value.length) {
							var tr = document.createElement("tr");
							var th = document.createElement("th");
							var td = document.createElement("td");
							var select = document.createElement("select");

							select.name = key;

							this[key].value.forEach(function(value) {
								var option = document.createElement("option");

								option.value = value;
								option.text = value;
								option.selected = (item.parameter[key] === value);

								this.appendChild(option);
							}, select);

							th.textContent = this[key].description;
							td.appendChild(select);

							tr.appendChild(th);
							tr.appendChild(td);

							tbody.appendChild(tr);
						} else if(this[key].value.length) {
							var input = document.createElement("input");

							input.name = key;
							input.value = this[key].value[0];
							input.type = "hidden";

							otherParameter.appendChild(input);
						}
					}
				}, cxsltl.opensearch11ToHtml.parameter);

				return false;
			};

			/**
			 * oninput時に呼び出される関数
			 *
			 * @return {boolean} falseを返す
			 */
			cxsltl.opensearch11ToHtml.oninput = cxsltl.opensearch11ToHtml.oninput || function() {
				var self = this;
				var suggestion = this.form.querySelector("input[name = 'suggestions']");

				if(this.list && suggestion) {
					var url = cxsltl.opensearch11ToHtml.templateParamReplace(
						Object.keys(cxsltl.opensearch11ToHtml.parameter).reduce(function(template, key) {
							if(cxsltl.opensearch11ToHtml.parameter[key]["value"][0]) {
								return cxsltl.opensearch11ToHtml.templateParamReplace(template, key, cxsltl.opensearch11ToHtml.parameter[key]["value"][0]);
							}

							return template;
						}, suggestion.value),
						"http://a9.com/-/spec/opensearch/1.1/:searchTerms",
						this.value
					).replace(/\{.*?\??\}/g, "");
					var xhr = new XMLHttpRequest();

					xhr.open("GET", url, true);
					xhr.setRequestHeader("Accept", "application/x-suggestions+json, application/json;q=0.9");
					xhr.responseType = "text";
					xhr.timeout = 5000;

					xhr.onreadystatechange = function() {
						if((xhr.readyState === 4) && ((xhr.status === 200) || (xhr.status === 304))) {
							try {
								var data = JSON.parse(xhr.responseText);

								if(Array.isArray(data) && (self.value === data[0]) && Array.isArray(data[1])) {
									self.list.textContent = "";

									data[1].forEach(function(value, index) {
										var option = document.createElement("option");
										option.value = value;

										if(data[2][index]) {
											option.title = data[2][index];
										}

										self.list.appendChild(option);
									});
								}
							} catch(e) {
								console.log(e.name + ": " + e.message);
							}
						}
					};

					try {
						xhr.send();
					} catch(e) {
						console.log(e.name + ": " + e.message);
					}
				}

				return false;
			};

			/**
			 * onsubmit時に呼び出される関数
			 *
			 * @return {boolean} falseを返す
			 */
			cxsltl.opensearch11ToHtml.onsubmit = cxsltl.opensearch11ToHtml.onsubmit || function() {
				var item = JSON.parse(this.querySelector("select[name = 'url']").value);
				var searchForm = this.querySelector("input[name = 'moz:SearchForm']");

				if(
					(item.template.indexOf("{http://a9.com/-/spec/opensearch/1.1/:searchTerms}") === -1) ||
					(this.querySelector("input[name = 'http://a9.com/-/spec/opensearch/1.1/:searchTerms']").value !== "")
				) {
					location.href = Array.prototype.reduce.call(this.elements, function(template, element) {
						return cxsltl.opensearch11ToHtml.templateParamReplace(template, element.name, element.value);
					}, item.template).replace(/\{.*?\??\}/g, "");
				} else if(searchForm) {
					location.href = searchForm.value;
				}

				return false;
			};

			/**
			 * OpenSearch URL templateで使用されるパラメーター
			 */
			cxsltl.opensearch11ToHtml.parameter = cxsltl.opensearch11ToHtml.parameter || {
				"http://a9.com/-/spec/opensearch/1.1/:searchTerms": {
					"description": "Search keywords.",
					"value": []
				},
				"http://a9.com/-/spec/opensearch/1.1/:count": {
					"description": "Search results per page.",
					"value": [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
				},
				"http://a9.com/-/spec/opensearch/1.1/:startIndex": {
					"description": "First index of search results.",
					"value": [1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
				},
				"http://a9.com/-/spec/opensearch/1.1/:startPage": {
					"description": "Page number of search results.",
					"value": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
				},
				"http://a9.com/-/spec/opensearch/1.1/:language": {
					"description": "Language of search results.",
					"value": []
				},
				"http://a9.com/-/spec/opensearch/1.1/:inputEncoding": {
					"description": "Search request character encoded",
					"value": ["UTF-8"]
				},
				"http://a9.com/-/spec/opensearch/1.1/:outputEncoding": {
					"description": "Character encoding of search results.",
					"value": []
				},
				"http://a9.com/-/opensearch/extensions/referrer/1.0/:source": {
					"description": "String identifying the search client.",
					"value": ["cxsltl.opensearch11ToHtml"]
				}
			};

			/**
			 * OpenSearch URL template内のパラメーターを置換する
			 *
			 * @param {string} template OpenSearch URL template
			 * @param {string} name パラメーター名
			 * @param {string} value パラメータを置換する値
			 * @return {string} 置換されたOpenSearch URL templateを返す
			 */
			cxsltl.opensearch11ToHtml.templateParamReplace = cxsltl.opensearch11ToHtml.templateParamReplace || function(template, name, value) {
				return template.replace("{" + name + "}", encodeURIComponent(value)).replace("{" + name + "?}", encodeURIComponent(value));
			};

			(function() {
				var content = Array.prototype.slice.call(document.getElementsByClassName("cxsltl.opensearch11ToHtml.content")).pop();

				Array.prototype.forEach.call(content.getElementsByClassName("cxsltl.opensearch11ToHtml.noscript"), function(element) {
					element.parentNode.removeChild(element);
				});

				var language = content.getElementsByClassName("cxsltl.opensearch11ToHtml.opensearch.Language")

				if(Array.prototype.some.call(language, function(element) {
					return element.textContent === "*";
				})) {
					cxsltl.opensearch11ToHtml.parameter["http://a9.com/-/spec/opensearch/1.1/:language"].value.push(cxsltl.opensearch11ToHtml.getLanguage());
				} else {
					Array.prototype.forEach.call(language, function(element) {
						cxsltl.opensearch11ToHtml.parameter["http://a9.com/-/spec/opensearch/1.1/:language"].value.push(element.textContent);
					});
				}

				Array.prototype.forEach.call(content.getElementsByClassName("cxsltl.opensearch11ToHtml.opensearch.OutputEncoding"), function(element) {
					cxsltl.opensearch11ToHtml.parameter["http://a9.com/-/spec/opensearch/1.1/:outputEncoding"].value.push(element.textContent);
				});

				Array.prototype.forEach.call(content.childNodes, function(node) {
					if(node.nodeType === 8) {
						var div = document.createElement("div");
						div.className = "cxsltl.opensearch11ToHtml.onscript";
						div.innerHTML = node.textContent;

						node.parentNode.insertBefore(div, node);
						node.parentNode.removeChild(node);

						cxsltl.opensearch11ToHtml.onchange.call(div.querySelector("select[name = 'url']"));
					}
				});

				var form = content.getElementsByClassName("cxsltl.opensearch11ToHtml.searchForm")[0];

				if(form && cxsltl.opensearch11ToHtml.isHtml5()) {
					var datalist = document.createElement("datalist");
					datalist.id = "cxsltl.opensearch11ToHtml.datalist";

					var input = form.querySelector("input[name = 'http://a9.com/-/spec/opensearch/1.1/:searchTerms']");
					input.setAttribute("list", "cxsltl.opensearch11ToHtml.datalist");
					input.addEventListener("input", cxsltl.opensearch11ToHtml.oninput, false);

					form.appendChild(datalist);
				}
			})();
		]]></script>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>OpenSearch URL template内のパラメーターを{$namespace}から展開する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="OpenSearch URL template"/>
		<xsltdoc:paramNodeSet xsltdoc:name="namespace" xsltdoc:short="名前空間"/>
		<xsltdoc:returnString xsltdoc:short="パラメーターが展開されたOpenSearch URL templateを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11ToHtml.templateParameterToHtml">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="namespace" select="ancestor-or-self::*[1]/namespace::*"/>

		<xsl:choose>
			<xsl:when test="contains(substring-after($string, '{'), '}')">
				<xsl:variable name="parameter" select="substring-before(substring-after($string, '{'), '}')"/>
				<xsl:variable name="qname">
					<xsl:call-template name="cxsltl:string.substringBefore">
						<xsl:with-param name="string" select="$parameter"/>
						<xsl:with-param name="substring">?</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="expanded">
					<xsl:call-template name="cxsltl:opensearch11.get.expandParameter">
						<xsl:with-param name="string" select="$qname"/>
						<xsl:with-param name="namespace" select="$namespace"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="concat(substring-before($string, '{'), '{')"/>

				<var class="cxsltl.opensearch11ToHtml.templateParameter">
					<xsl:attribute name="title">
						<xsl:value-of select="concat('{', substring-before($expanded, ' '), '}', substring-after($expanded, ' '))"/>
					</xsl:attribute>

					<xsl:value-of select="$qname"/>
				</var>

				<xsl:value-of select="substring('?}', string-length($parameter) - string-length($qname) + 1)"/>

				<xsl:call-template name="cxsltl:opensearch11ToHtml.templateParameterToHtml">
					<xsl:with-param name="string" select="substring-after($string, '}')"/>
					<xsl:with-param name="namespace" select="$namespace"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>{$node}から{$type}の値を取得し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Open Searchのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="{$node}から取得する値のタイプ"/>
		<xsltdoc:returnNodeSet xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opensearch11ToHtml.get']" mode="cxsltl:callback" name="cxsltl:opensearch11ToHtml.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:opensearch11ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opensearch11ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">content</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="$type = 'content'">
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node/*[count(. | $deny) != $denyCount]"/>
					<xsl:with-param name="string">
						<xsl:apply-templates select="$node" mode="cxsltl:opensearch11ToHtml.searchContent">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
						</xsl:apply-templates>
					</xsl:with-param>
					<xsl:with-param name="type">content</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:opensearch11.basicMetaInformation.get">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>{Encoding}要素のコールバックテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:paramString xsltdoc:name="param1" xsltdoc:short="元の要素名"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="count" xsltdoc:short="文脈数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{code}要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opensearch11ToHtml.callback.encoding']" mode="cxsltl:callback" name="cxsltl:opensearch11ToHtml.callback.encoding">
		<xsl:param name="string"/>
		<xsl:param name="param1"/>
		<xsl:param name="position"/>
		<xsl:param name="count"/>

		<code class="cxsltl.opensearch11ToHtml.opensearch.{$param1}">
			<xsl:value-of select="$string"/>
		</code>

		<xsl:if test="$position != $count">, </xsl:if>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>{Language}要素のコールバックテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="count" xsltdoc:short="文脈数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{code}要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opensearch11ToHtml.callback.language']" mode="cxsltl:callback" name="cxsltl:opensearch11ToHtml.callback.language">
		<xsl:param name="string"/>
		<xsl:param name="position"/>
		<xsl:param name="count"/>

		<code class="cxsltl.opensearch11ToHtml.opensearch.Language">
			<xsl:if test="$string = '*'">
				<xsl:attribute name="title">any languages</xsl:attribute>
			</xsl:if>

			<xsl:value-of select="$string"/>
		</code>

		<xsl:if test="$position != $count">, </xsl:if>
	</xsl:template>
</xsl:stylesheet>