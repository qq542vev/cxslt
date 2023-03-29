<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss11ToSitemap.stylesheet"
	exclude-result-prefixes="cxsltl dc rdf rss xsl xsltdoc"
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/net/rss1.1#"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/uri.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 1.1 format into Sitemap 0.90 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 1.1 形式で書かれたファイルを Sitemap 0.90 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-18</xsltdoc:version>
		<xsltdoc:since>2011-10-15</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://inamidst.com/rss1.1/"/>
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

	<xsl:param name="cxsltl:rss11ToSitemap.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 1.1の要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			Sitemapへの変換はxsl:call-templateを使用しcxsltl:rss11ToSitemap.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<urlset xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
			<xsl:call-template name="cxsltl:rss11ToSitemap.convert">
				<xsl:with-param name="node" select="rss:Channel"/>
			</xsl:call-template>
		</urlset>
	</xsl:template>

	<!-- ==============================
		## xsl:template for RSS 1.1 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss11ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss11ToSitemap.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:Channel}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="$denyの個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:Channel" mode="cxsltl:rss11ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(self::dc:date)][count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="$denyの個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item[rss:link]" mode="cxsltl:rss11ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(self::dc:date)][count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:link}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{loc}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:link" mode="cxsltl:rss11ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<url>
			<loc>
				<xsl:call-template name="cxsltl:uri.relativeResolution">
					<xsl:with-param name="base">
						<xsl:call-template name="cxsltl:uri.baseResolution">
							<xsl:with-param name="base" select="ancestor-or-self::*[count(@xml:base | $deny) != $denyCount][count(. | $deny) != $denyCount]"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:apply-templates select="parent::*/dc:date[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToSitemap.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</loc>
		</url>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:date}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{lastmod}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="dc:date" mode="cxsltl:rss11ToSitemap.converter">
		<lastmod>
			<xsl:value-of select="normalize-space()"/>
		</lastmod>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 1.1をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss11ToSitemap.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss11ToSitemap.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>