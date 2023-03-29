<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss10ToRss30.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/rss/1.0/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/rss30/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 1.0 format into RSS 3.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 1.0 形式で書かれたファイルを RSS 3.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-05</xsltdoc:version>
		<xsltdoc:since>2011-10-16</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://web.resource.org/rss/1.0/spec"/>
		<xsltdoc:output rdf:resource="http://www.aaronsw.com/2002/rss30"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss10ToRss30.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 1.0の要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RSS 3.0への変換はxsl:call-templateを使用しcxsltl:rss10ToRss30.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss10ToRss30.convert">
			<xsl:with-param name="node" select="rdf:RDF/rss:channel"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for RSS 1.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss10ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss10ToRss30.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel" mode="cxsltl:rss10ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(self::rss:items)][count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="rss:items" mode="cxsltl:rss10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@rdf:resource}属性から{rss:item}要素を呼び出す</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のitemを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:items/rdf:Seq/rdf:li/@rdf:resource" mode="cxsltl:rss10ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="
			parent::rdf:li/parent::rdf:Seq/parent::rss:items/parent::rss:channel/parent::rdf:RDF/
			rss:item[normalize-space(@rdf:about) = normalize-space(current())][count(. | $deny) != $denyCount]
		" mode="cxsltl:rss10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のitemを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item" mode="cxsltl:rss10ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:text>&#xA;</xsl:text>

		<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:*}要素、{dc:*}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0の行を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:title | rss:link | rss:description | dc:language | dc:rights | dc:subject" mode="cxsltl:rss10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:creator}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のgenerateを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="dc:creator" mode="cxsltl:rss10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">generator</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:date}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のlast-modifiedを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="dc:date" mode="cxsltl:rss10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">last-modified</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 1.0をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10ToRss30.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss10ToRss30.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>