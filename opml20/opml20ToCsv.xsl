<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.opml20ToCsv.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../xml/xmlToCsv.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts OPML 2.0 format into CSV format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">OPML 2.0 形式で書かれたファイルを CSV 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-04</xsltdoc:version>
		<xsltdoc:since>2011-11-22</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.opml.org/spec2"/>
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

	<xsl:variable name="cxsltl:opml20ToCsv.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>OPML 2.0の要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:opml20ToCsv.config.default" select="$cxsltl:opml20ToCsv.self/cxsltl:config[@xml:id = 'cxsltl.opml20ToCsv.config.default']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToCsv.config" select="$cxsltl:opml20ToCsv.config.default"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToCsv.deny" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの区切り文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:opml20ToCsv.delimiter">,</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:opml20ToCsv.eol" select="'&#xD;&#xA;'"/>

	<xsltdoc:BooleanStringParam>
		<xsltdoc:short>デフォルトでのヘッダー</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:BooleanStringParam>

	<xsl:param name="cxsltl:opml20ToCsv.header" select="true()"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.opml20ToCsv.config.default">
		<xsltdoc:short>OPML 2.0の要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.opml20ToCsv.config.default">
		<cxsltl:id/>
		<cxsltl:id cxsltl:alias="parentId" cxsltl:xpath="parent::outline"/>
		<cxsltl:string cxsltl:alias="text" cxsltl:xpath="@text"/>
		<cxsltl:normalize cxsltl:alias="type" cxsltl:xpath="@type"/>
		<cxsltl:normalize cxsltl:alias="isComment" cxsltl:xpath="@isComment"/>
		<cxsltl:normalize cxsltl:alias="isBreakpoint" cxsltl:xpath="@isBreakpoint"/>
		<cxsltl:normalize cxsltl:alias="created" cxsltl:xpath="@created"/>
		<cxsltl:normalize cxsltl:alias="category" cxsltl:xpath="@category"/>
		<cxsltl:normalize cxsltl:alias="url" cxsltl:xpath="@url"/>
		<cxsltl:normalize cxsltl:alias="xmlUrl" cxsltl:xpath="@xmlUrl"/>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のoutline要素をCSVに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			CSVへの変換はxsl:call-templateを使用しcxsltl:opml20ToCsv.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:opml20ToCsv.convert">
			<xsl:with-param name="node" select="opml/body//outline"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>OPML 2.0をCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramBooleanString xsltdoc:name="header" xsltdoc:short="ヘッダーの出力を行うか"/>
		<xsltdoc:returnString xsltdoc:short="CSVを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opml20ToCsv.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="config" select="$cxsltl:opml20ToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:opml20ToCsv.deny"/>
		<xsl:param name="delimiter" select="$cxsltl:opml20ToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:opml20ToCsv.eol"/>
		<xsl:param name="header" select="$cxsltl:opml20ToCsv.header"/>

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