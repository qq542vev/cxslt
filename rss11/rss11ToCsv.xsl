<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss11ToCsv.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/net/rss1.1#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/uri.xsl"/>
	<xsl:import href="../xml/xmlToCsv.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 1.1 format into CSV format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 1.1 形式で書かれたファイルを CSV 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-17</xsltdoc:version>
		<xsltdoc:since>2011-10-15</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://inamidst.com/rss1.1/"/>
		<xsltdoc:output rdf:resource="https://www.ietf.org/rfc/rfc4180.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" indent="no" media-type="text/csv"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:rss11ToCsv.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>RSS 1.1の要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:rss11ToCsv.config.default" select="$cxsltl:rss11ToCsv.self/cxsltl:config[@xml:id = 'cxsltl.rss11ToCsv.config.default']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss11ToCsv.config" select="$cxsltl:rss11ToCsv.config.default"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss11ToCsv.deny" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの区切り文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:rss11ToCsv.delimiter">,</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:rss11ToCsv.eol" select="'&#xD;&#xA;'"/>

	<xsltdoc:BooleanStringParam>
		<xsltdoc:short>デフォルトでのヘッダー</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:BooleanStringParam>

	<xsl:param name="cxsltl:rss11ToCsv.header" select="true()"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.rss11ToCsv.config.default">
		<xsltdoc:short>RSS 1.1の要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.rss11ToCsv.config.default">
		<cxsltl:normalize cxsltl:alias="title" cxsltl:xpath="rss:title"/>
		<cxsltl:rss11ToCsv.element.link cxsltl:alias="link" cxsltl:xpath="rss:link"/>
		<cxsltl:normalize cxsltl:alias="description" cxsltl:xpath="rss:description"/>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のrss:item/rss:*要素をCSVに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			CSVへの変換はxsl:call-templateを使用しcxsltl:rss11ToCsv.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss11ToCsv.convert">
			<xsl:with-param name="node" select="rss:Channel/rss:items[@rdf:parseType = 'Collection']/rss:item"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for property element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの値からURIを参照解決する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnString xsltdoc:short="参照解決したURIを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:rss11ToCsv.element.link" mode="cxsltl:xmlToCsv.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss11ToCsv.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:uri.relativeResolution">
			<xsl:with-param name="reference" select="$node"/>
			<xsl:with-param name="base">
				<xsl:call-template name="cxsltl:uri.baseResolution">
					<xsl:with-param name="base" select="$node/ancestor-or-self::*[count(@xml:base | $deny) != $denyCount][count(. | $deny) != $denyCount]"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 1.1をCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramBooleanString xsltdoc:name="header" xsltdoc:short="ヘッダーの出力を行うか"/>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss11ToCsv.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="config" select="$cxsltl:rss11ToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:rss11ToCsv.deny"/>
		<xsl:param name="delimiter" select="$cxsltl:rss11ToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:rss11ToCsv.eol"/>
		<xsl:param name="header" select="$cxsltl:rss11ToCsv.header"/>

		<xsl:call-template name="cxsltl:xmlToCsv.convert">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="config" select="$config"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="eol" select="$eol"/>
			<xsl:with-param name="header" select="$header"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>