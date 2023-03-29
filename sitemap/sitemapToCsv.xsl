<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.sitemapToCsv.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../xml/xmlToCsv.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts Sitemap 0.90 format into CSV format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Sitemap 0.90 形式で書かれたファイルを CSV 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-08-27</xsltdoc:version>
		<xsltdoc:since>2011-03-03</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.sitemaps.org/protocol.html"/>
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

	<xsl:variable name="cxsltl:sitemapToCsv.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>Sitemapの要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:sitemapToCsv.config.default" select="$cxsltl:sitemapToCsv.self/cxsltl:config[@xml:id = 'cxsltl.sitemapToCsv.config.default']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapToCsv.config" select="$cxsltl:sitemapToCsv.config.default"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapToCsv.deny" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの区切り文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:sitemapToCsv.delimiter">,</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:sitemapToCsv.eol" select="'&#xD;&#xA;'"/>

	<xsltdoc:BooleanStringParam>
		<xsltdoc:short>デフォルトでのヘッダー</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:BooleanStringParam>

	<xsl:param name="cxsltl:sitemapToCsv.header" select="true()"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.sitemapToCsv.config.default">
		<xsltdoc:short>Sitemapの要素をCSVに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.sitemapToCsv.config.default">
		<cxsltl:normalize cxsltl:alias="loc" cxsltl:xpath="sitemap:loc" cxsltl:wrap="literal"/>
		<cxsltl:normalize cxsltl:alias="lastmod" cxsltl:xpath="sitemap:lastmod" cxsltl:wrap="literal"/>
		<cxsltl:normalize cxsltl:alias="changefreq" cxsltl:xpath="sitemap:changefreq" cxsltl:wrap="literal"/>
		<cxsltl:normalize cxsltl:alias="priority" cxsltl:xpath="sitemap:priority" cxsltl:wrap="literal"/>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のsitemap:url/sitemap:*要素をCSVに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			CSVへの変換はxsl:call-templateを使用しcxsltl:sitemapToCsv.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="CSVに変換したURLセットを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:sitemapToCsv.convert">
			<xsl:with-param name="node" select="sitemap:urlset/sitemap:url"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>SitemapをCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用の要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramBooleanString xsltdoc:name="header" xsltdoc:short="ヘッダーの出力を行うか"/>
		<xsltdoc:returnString xsltdoc:short="テキストに変換したURLセットを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:sitemapToCsv.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="config" select="$cxsltl:sitemapToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:sitemapToCsv.deny"/>
		<xsl:param name="delimiter" select="$cxsltl:sitemapToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:sitemapToCsv.eol"/>
		<xsl:param name="header" select="$cxsltl:sitemapToCsv.header"/>

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