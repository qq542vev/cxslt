<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss10ToCsv.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/rss/1.0/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../xml/xmlToCsv.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 1.0 format into CSV format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 1.0 形式で書かれたファイルを CSV 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-04</xsltdoc:version>
		<xsltdoc:since>2011-03-03</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://web.resource.org/rss/1.0/spec"/>
		<xsltdoc:output rdf:resource="https://www.ietf.org/rfc/rfc4180.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/csv"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:rss10ToCsv.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>RSS 1.0の要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:rss10ToCsv.config.default" select="$cxsltl:rss10ToCsv.self/cxsltl:config[@xml:id = 'cxsltl.rss10ToCsv.config.default']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss10ToCsv.config" select="$cxsltl:rss10ToCsv.config.default"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss10ToCsv.deny" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの区切り文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:rss10ToCsv.delimiter">,</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:rss10ToCsv.eol" select="'&#xD;&#xA;'"/>

	<xsltdoc:BooleanStringParam>
		<xsltdoc:short>デフォルトでのヘッダー</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:BooleanStringParam>

	<xsl:param name="cxsltl:rss10ToCsv.header" select="true()"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.rss10ToCsv.config.default">
		<xsltdoc:short>RSS 1.0の要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.rss10ToCsv.config.default">
		<cxsltl:normalize cxsltl:alias="title" cxsltl:xpath="rss:title"/>
		<cxsltl:normalize cxsltl:alias="link" cxsltl:xpath="rss:link"/>
		<cxsltl:normalize cxsltl:alias="description" cxsltl:xpath="rss:description"/>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 1.0の要素をCSVに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			CSVへの変換はxsl:call-templateを使用しcxsltl:rss10ToCsv.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss10ToCsv.convert">
			<xsl:with-param name="node" select="rdf:RDF/rss:channel"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for RSS 1.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss10ToCsv.converter">
		<xsl:param name="config" select="$cxsltl:rss10ToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:rss10ToCsv.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="delimiter" select="$cxsltl:rss10ToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:rss10ToCsv.eol"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToCsv.converter">
			<xsl:with-param name="config" select="$config"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss10ToCsv.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>RSS 1.0をCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rdf:RDF" mode="cxsltl:rss10ToCsv.converter">
		<xsl:param name="config" select="$cxsltl:rss10ToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:rss10ToCsv.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="delimiter" select="$cxsltl:rss10ToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:rss10ToCsv.eol"/>

		<xsl:apply-templates select="rss:channel[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToCsv.converter">
			<xsl:with-param name="config" select="$config"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@rdf:resource}属性をCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:items/rdf:Seq/rdf:li/@rdf:resource" mode="cxsltl:rss10ToCsv.converter">
		<xsl:param name="config" select="$cxsltl:rss10ToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:rss10ToCsv.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="delimiter" select="$cxsltl:rss10ToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:rss10ToCsv.eol"/>

		<xsl:apply-templates select="
			parent::rdf:li/parent::rdf:Seq/parent::rss:items/parent::rss:channel/parent::rdf:RDF/
			rss:item[normalize-space(@rdf:about) = normalize-space(current())][count(. | $deny) != $denyCount]
		" mode="cxsltl:rss10ToCsv.converter">
			<xsl:with-param name="config" select="$config"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item}要素をCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item" mode="cxsltl:rss10ToCsv.converter">
		<xsl:param name="config" select="$cxsltl:rss10ToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:rss10ToCsv.deny"/>
		<xsl:param name="delimiter" select="$cxsltl:rss10ToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:rss10ToCsv.eol"/>

		<xsl:call-template name="cxsltl:xmlToCsv.convert">
			<xsl:with-param name="config" select="$config"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="eol" select="$eol"/>
			<xsl:with-param name="header" select="false()"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 1.0をCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramBooleanString xsltdoc:name="header" xsltdoc:short="ヘッダーの出力を行うか"/>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10ToCsv.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="config" select="$cxsltl:rss10ToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:rss10ToCsv.deny"/>
		<xsl:param name="delimiter" select="$cxsltl:rss10ToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:rss10ToCsv.eol"/>
		<xsl:param name="header" select="$cxsltl:rss10ToCsv.header"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:xmlToCsv.convert">
			<xsl:with-param name="node" select="/.."/>
			<xsl:with-param name="config" select="$config"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="eol" select="$eol"/>
			<xsl:with-param name="header" select="$header"/>
		</xsl:call-template>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToCsv.converter">
			<xsl:with-param name="config" select="$config"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>