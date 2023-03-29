<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss20ToSitemap.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/email.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 2.0 format into Sitemap 0.90 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 2.0 形式で書かれたファイルを Sitemap 0.90 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-18</xsltdoc:version>
		<xsltdoc:since>2011-10-01</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.rssboard.org/rss-specification"/>
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

	<xsl:param name="cxsltl:rss20ToSitemap.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 2.0の要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			Sitemapへの変換はxsl:call-templateを使用しcxsltl:rss20ToSitemap.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<urlset xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
			<xsl:call-template name="cxsltl:rss20ToSitemap.convert">
				<xsl:with-param name="node" select="rss/channel"/>
			</xsl:call-template>
		</urlset>
	</xsl:template>

	<!-- ==============================
		## xsl:template for RSS 2.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss20ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20ToSitemap.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{channel}要素、{item}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel | item" mode="cxsltl:rss20ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(self::pubDate)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{link}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="link" mode="cxsltl:rss20ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<url>
			<loc>
				<xsl:value-of select="normalize-space()"/>
			</loc>

			<xsl:apply-templates select="parent::item/pubDate[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToSitemap.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</url>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{comments}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="comments" mode="cxsltl:rss20ToSitemap.converter">
		<url>
			<loc>
				<xsl:value-of select="normalize-space()"/>
			</loc>
		</url>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enclosure}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enclosure/@url" mode="cxsltl:rss20ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<url>
			<loc>
				<xsl:value-of select="normalize-space()"/>
			</loc>
		</url>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{guid}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="guid[not(@isPermaLink) or @isPermaLink = 'true']" mode="cxsltl:rss20ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<url>
			<loc>
				<xsl:value-of select="normalize-space()"/>
			</loc>

			<xsl:apply-templates select="parent::item/pubDate[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToSitemap.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</url>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{pubDate}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{lastmod}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="pubDate" mode="cxsltl:rss20ToSitemap.converter">
		<lastmod>
			<xsl:call-template name="cxsltl:date.email.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
			</xsl:call-template>
		</lastmod>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 2.0をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss20ToSitemap.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss20ToSitemap.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>