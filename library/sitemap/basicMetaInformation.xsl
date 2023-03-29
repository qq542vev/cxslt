<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../basicMetaInformation.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>Sitemap の基本メタ情報を扱う XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-22</xsltdoc:version>
		<xsltdoc:since>2017-10-22</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.opml.org/spec2"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:sitemap.basicMetaInformation.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>Sitemapのデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:sitemap.basicMetaInformation.defaultValue" select="$cxsltl:sitemap.basicMetaInformation.self/rdf:Description[@xml:id = 'cxsltl.sitemap.basicMetaInformation.defaultValue']"/>

	<!-- ==============================
		# rdf:Description Element
	 ============================== -->

	<rdf:Description rdf:about="#cxsltl.sitemap.basicMetaInformation.defaultValue" xml:id="cxsltl.sitemap.basicMetaInformation.defaultValue">
		<dcterms:title>Sitemap</dcterms:title>
		<dcterms:description>The Sitemap file. URL list on website.</dcterms:description>
		<dcterms:conformsTo rdf:resource="https://www.sitemaps.org/protocol.html"/>
		<dc:format>application/xml</dc:format>
	</rdf:Description>

	<!-- ==============================
		## xsl:template for Sitemap element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:sitemap.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="node() | @*" mode="cxsltl:sitemap.basicMetaInformation.geter">
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:sitemap.basicMetaInformation.geter"/>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$nodeから$typeの値を取得し$callbackにコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="$nodeから取得する値のタイプ"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:sitemap.basicMetaInformation.get']" mode="cxsltl:callback" name="cxsltl:sitemap.basicMetaInformation.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="defaultValue" select="$cxsltl:sitemap.basicMetaInformation.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type"/>

		<xsl:call-template name="cxsltl:basicMetaInformation.get">
			<xsl:with-param name="node" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
			<xsl:with-param name="type" select="$type"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>