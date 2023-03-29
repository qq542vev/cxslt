<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.sitemapIndexToSitemap.stylesheet"
	exclude-result-prefixes="atom cxsltl rdf rss rss11 sitemap xsl xsltdoc"
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/rss/1.0/"
	xmlns:rss11="http://purl.org/net/rss1.1#"
	xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../atom10/atom10ToSitemap.xsl"/>
	<xsl:import href="../rss10/rss10ToSitemap.xsl"/>
	<xsl:import href="../rss11/rss11ToSitemap.xsl"/>
	<xsl:import href="../rss20/rss20ToSitemap.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts Sitemap index 0.90 format into Sitemap 0.90 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Sitemap index 0.90 形式で書かれたファイルを Sitemap 0.90 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-08-31</xsltdoc:version>
		<xsltdoc:since>2011-10-04</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.sitemaps.org/protocol.html"/>
		<xsltdoc:output rdf:resource="https://www.sitemaps.org/protocol.html"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/xml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapIndexToSitemap.deny" select="/sitemap:sitemapindex/sitemap:sitemap/sitemap:loc[
		substring(., string-length() - 3) != '.xml' and
		substring(., string-length() - 3) != '.rdf' and
		substring(., string-length() - 3) != '.rss' and
		substring(., string-length() - 4) != '.atom'
	]"/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のsitemap:loc要素からSitemapに結合する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			Sitemapへの変換はxsl:call-templateを使用しcxsltl:sitemapIndexToSitemap.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<urlset>
			<xsl:call-template name="cxsltl:sitemapIndexToSitemap.convert">
				<xsl:with-param name="node" select="sitemap:sitemapindex"/>
			</xsl:call-template>
		</urlset>
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

	<xsl:template match="/ | *" mode="cxsltl:sitemapIndexToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:sitemapIndexToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapIndexToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:sitemapIndexToSitemap.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:loc}要素を処理する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{sitemap:uri}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:sitemap/sitemap:loc" mode="cxsltl:sitemapIndexToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:sitemapIndexToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:variable name="document" select="document(.)"/>

		<xsl:choose>
			<xsl:when test="$document/rdf:RDF/rss:channel">
				<xsl:call-template name="cxsltl:rss10ToSitemap.convert">
					<xsl:with-param name="node" select="$document"/>
					<xsl:with-param name="deny" select="$deny"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$document/rss11:channel">
				<xsl:call-template name="cxsltl:rss11ToSitemap.convert">
					<xsl:with-param name="node" select="$document"/>
					<xsl:with-param name="deny" select="$deny"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$document/rss/channel">
				<xsl:call-template name="cxsltl:rss20ToSitemap.convert">
					<xsl:with-param name="node" select="$document"/>
					<xsl:with-param name="deny" select="$deny"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$document/atom:feed">
				<xsl:call-template name="cxsltl:atom10ToSitemap.convert">
					<xsl:with-param name="node" select="$document"/>
					<xsl:with-param name="deny" select="$deny"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$document/sitemap:urlset">
				<xsl:apply-templates select="$document" mode="cxsltl:sitemapIndexToSitemap.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:url}要素を処理する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{sitemap:uri}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:url" mode="cxsltl:sitemapIndexToSitemap.converter">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- ==============================
		# Named xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Sitemap indexをSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:sitemapIndexToSitemap.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:sitemapIndexToSitemap.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapIndexToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>