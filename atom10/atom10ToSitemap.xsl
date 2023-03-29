<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.atom10ToSitemap.stylesheet"
	exclude-result-prefixes="atom cxsltl rdf xsl xsltdoc"
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/uri.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts Atom 1.0 format into Sitemap 0.90 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Atom 1.0 形式で書かれたファイルを Sitemap 0.90 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-15</xsltdoc:version>
		<xsltdoc:since>2011-10-23</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.ietf.org/rfc/rfc4287.txt"/>
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

	<xsl:param name="cxsltl:atom10ToSitemap.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のAtom 1.0の要素をSitemap変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			Sitemapへの変換はxsl:call-templateを使用しcxsltl:atom10ToSitemap.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<urlset xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
			<xsl:call-template name="cxsltl:atom10ToSitemap.convert">
				<xsl:with-param name="node" select="atom:feed"/>
			</xsl:call-template>
		</urlset>
	</xsl:template>

	<!-- ==============================
		## xsl:template for Atom element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:atom10ToSitemap.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:atom10ToSitemap.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:feed}要素、{atom:entry}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:feed | atom:entry" mode="cxsltl:atom10ToSitemap.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(self::atom:updated)][count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:content/@src}属性をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:content/@src" mode="cxsltl:atom10ToSitemap.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<url>
			<xsl:call-template name="cxsltl:atom10ToSitemap.toLoc">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:call-template>
		</url>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:link/@href}属性をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:link/@href" mode="cxsltl:atom10ToSitemap.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<url>
			<xsl:call-template name="cxsltl:atom10ToSitemap.toLoc">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:call-template>

			<xsl:apply-templates select="
				parent::atom:link[(normalize-space(@rel) = 'self') or (normalize-space(@rel) = 'http://www.iana.org/assignments/relation/self')]/
				parent::*/atom:updated[count(. | $deny) != $denyCount]
			" mode="cxsltl:atom10ToSitemap.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</url>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:updated}要素をSitemapに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{lastmod}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:updated" mode="cxsltl:atom10ToSitemap.converter">
		<lastmod>
			<xsl:value-of select="normalize-space()"/>
		</lastmod>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Atom 1.0をSitemapに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="Sitemapを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:atom10ToSitemap.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:atom10ToSitemap.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToSitemap.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードを{loc}要素に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{loc}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template name="cxsltl:atom10ToSitemap.toLoc">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="cxsltl:atom10ToSitemap.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<loc>
			<xsl:call-template name="cxsltl:uri.relativeResolution">
				<xsl:with-param name="reference" select="normalize-space($node)"/>
				<xsl:with-param name="base">
					<xsl:call-template name="cxsltl:uri.baseResolution">
						<xsl:with-param name="base" select="$node/ancestor-or-self::*[count(@xml:base | $deny) != $denyCount][count(. | $deny) != $denyCount]"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</loc>
	</xsl:template>
</xsl:stylesheet>