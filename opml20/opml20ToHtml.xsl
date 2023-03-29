<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.opml20ToHtml.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:opml="http://opml.org/spec2"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/email.xsl"/>
	<xsl:import href="../library/basicMetaInformation.xsl"/>
	<xsl:import href="../library/opml20/basicMetaInformation.xsl"/>
	<xsl:import href="../library/opml20/get.xsl"/>
	<xsl:import href="../library/template/html.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts OPML 2.0 format into HTML format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">OPML 2.0 形式で書かれたファイルをHTMLに変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-22</xsltdoc:version>
		<xsltdoc:since>2011-10-05</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.opml.org/spec2"/>
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

	<xsl:variable name="cxsltl:opml20ToHtml.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToHtml.deny" select="/.."/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>OPML 2.0のデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToHtml.defaultValue" select="$cxsltl:opml20.basicMetaInformation.defaultValue"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのコールバックするテンプレート</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToHtml.callback" select="$cxsltl:template.html.layout"/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のOPML 2.0の要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			HTMLへの変換はxsl:call-templateを使用しcxsltl:opml20ToHtml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:opml20ToHtml.convert">
			<xsl:with-param name="node" select="opml"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for OPML 2.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:opml20ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opml20ToHtml.callback"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToHtml.converter">
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

	<xsl:template match="text() | @*" mode="cxsltl:opml20ToHtml.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opml}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opml | opml:opml" mode="cxsltl:opml20ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opml20ToHtml.callback"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:opml20ToHtml.self/xsl:template[@name = 'cxsltl:opml20ToHtml.get']"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{body}要素をHTMLに変換して{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="body | opml:body" mode="cxsltl:opml20ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="outline[count(. | $deny) != $denyCount]"/>
			<xsl:with-param name="string">
				<div class="cxsltl.opml20ToHtml.content">
					<ol>
						<xsl:apply-templates select="(outline | opml:outline)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToHtml.converter">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
						</xsl:apply-templates>
					</ol>
				</div>
			</xsl:with-param>
			<xsl:with-param name="type">content</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{outline}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{li}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline | opml:outline" mode="cxsltl:opml20ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:variable name="text">
			<xsl:apply-templates select="(@text | @opml:text)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToHtml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="include">
			<xsl:call-template name="cxsltl:opml20.get.link">
				<xsl:with-param name="node" select="@*[count(. | $deny) != $denyCount]"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="link">
			<xsl:call-template name="cxsltl:opml20.get.link">
				<xsl:with-param name="node" select="@*[count(. | $deny) != $denyCount]"/>
			</xsl:call-template>
		</xsl:variable>

		<li class="cxsltl.sitemapToHtml.opml.outline">
			<xsl:apply-templates select="(@created | @opml:created)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToHtml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:choose>
				<xsl:when test="string($link)">
					<a href="{$link}">
						<xsl:copy-of select="$text"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$text"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:variable name="children">
				<xsl:apply-templates select="(outline | opml:outline)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToHtml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<xsl:if test="string($include)">
					<xsl:apply-templates select="
						document($include)[count(. | $deny) != $denyCount]/opml[count(. | $deny) != $denyCount]/body[count(. | $deny) != $denyCount]/outline[count(. | $deny) != $denyCount] |
						document($include)[count(. | $deny) != $denyCount]/opml:opml[count(. | $deny) != $denyCount]/opml:body[count(. | $deny) != $denyCount]/opml:outline[count(. | $deny) != $denyCount]
					" mode="cxsltl:opml20ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:variable>

			<xsl:if test="string($children)">
				<ol>
					<xsl:copy-of select="$children"/>
				</ol>
			</xsl:if>
		</li>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@text}属性をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="エスケープを無効化した値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@text | @opml:text" mode="cxsltl:opml20ToHtml.converter">
		<xsl:value-of disable-output-escaping="yes" select="."/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@created}属性をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@title}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@created | @opml:created" mode="cxsltl:opml20ToHtml.converter">
		<xsl:attribute name="title">
			<xsl:text>created: </xsl:text>

			<xsl:call-template name="cxsltl:date.email.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>OPML 2.0をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opml20ToHtml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:opml20ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opml20ToHtml.callback"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToHtml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{$node}から{$type}の値を取得し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="{$node}から取得する値のタイプ"/>
		<xsltdoc:returnNodeSet xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opml20ToHtml.get']" mode="cxsltl:callback" name="cxsltl:opml20ToHtml.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:opml20ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">content</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="$type = 'content'">
				<xsl:apply-templates select="($node/body | $node/opml:body)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToHtml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
					<xsl:with-param name="callback" select="$callback"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:opml20.basicMetaInformation.get">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>