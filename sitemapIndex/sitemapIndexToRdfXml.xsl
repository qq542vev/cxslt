<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.sitemapIndexToRdfXml.stylesheet"
	exclude-result-prefixes="cxsltl sitemap xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:ont="http://www.w3.org/2006/gen/ont#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts Sitemap index 0.90 format into RDF/XML format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Sitemap index 0.90 形式で書かれたファイルを RDF/XML 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-08-31</xsltdoc:version>
		<xsltdoc:since>2011-09-30</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.sitemaps.org/protocol.html"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/rdf-syntax-grammar/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/rdf+xml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapIndexToRdfXml.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のSitemap index要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RDF/XMLへの変換はxsl:call-templateを使用しcxsltl:sitemapIndexToRdfXml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="テキストに変換したURLセットを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:call-template name="cxsltl:sitemapIndexToRdfXml.convert">
				<xsl:with-param name="node" select="sitemap:sitemapindex"/>
			</xsl:call-template>
		</rdf:RDF>
	</xsl:template>

	<!-- ==============================
		## xsl:template for sitemap index element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:sitemapIndexToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:sitemapIndexToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapIndexToRdfXml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:sitemapIndexToRdfXml.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:sitemap}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{ont:InformationResource}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:sitemap" mode="cxsltl:sitemapIndexToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:sitemapIndexToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<ont:InformationResource>
			<xsl:apply-templates select="sitemap:loc[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapIndexToRdfXml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="*[not(self::sitemap:loc)][count(. | $deny) != $denyCount]" mode="cxsltl:sitemapIndexToRdfXml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</ont:InformationResource>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:loc}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{rdf:about}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:loc" mode="cxsltl:sitemapIndexToRdfXml.converter">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:lastmod}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:modified}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:lastmod" mode="cxsltl:sitemapIndexToRdfXml.converter">
		<dcterms:modified rdf:datatype="http://purl.org/dc/terms/W3CDTF">
			<xsl:value-of select="normalize-space()"/>
		</dcterms:modified>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Sitemap indexをRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="RDF/XMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:sitemapIndexToRdfXml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:sitemapIndexToRdfXml.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapIndexToRdfXml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>