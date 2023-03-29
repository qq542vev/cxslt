<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.sitemapToText.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="sitemapToCsv.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts Sitemap 0.90 format into Plain Text format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Sitemap 0.90 形式で書かれたファイルを Plain Text 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-08-20</xsltdoc:version>
		<xsltdoc:since>2011-06-13</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.sitemaps.org/protocol.html"/>
		<xsltdoc:output rdf:resource="https://en.wikipedia.org/wiki/Text_file"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:sitemapToText.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>Sitemapの要素をテキストに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:sitemapToText.config.default" select="$cxsltl:sitemapToText.self/cxsltl:config[@xml:id = 'cxsltl.sitemapToText.config.default']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapToText.deny" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのテキストの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:sitemapToText.eol" select="'&#xA;'"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.sitemapToText.config.default">
		<xsltdoc:short>テキストに変換する設定用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.sitemapToText.config.default">
		<cxsltl:normalize cxsltl:alias="loc" cxsltl:xpath="sitemap:loc" cxsltl:wrap="literal"/>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下の全てのsitemap:loc要素をテキストに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			テキストへの変換はxsl:call-templateを使用しcxsltl:sitemapToText.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="テキストに変換したURLセットを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:sitemapToText.convert">
			<xsl:with-param name="node" select="sitemap:urlset/sitemap:url"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Sitemapをテキストに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="テキストの改行文字"/>
		<xsltdoc:returnString xsltdoc:short="テキストに変換したURLセットを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:sitemapToText.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:sitemapToText.deny"/>
		<xsl:param name="eol" select="$cxsltl:sitemapToText.eol"/>

		<xsl:call-template name="cxsltl:sitemapToCsv.convert">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="config" select="$cxsltl:sitemapToText.config.default"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="eol" select="$eol"/>
			<xsl:with-param name="header" select="false()"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>