<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss091="http://purl.org/rss/1.0/modules/rss091#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="ja">RSS 2.0 の要素を RSS091 Module に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-15</xsltdoc:version>
		<xsltdoc:since>2017-11-15</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://web.resource.org/rss/1.0/modules/rss091/"/>
		<xsltdoc:see rdf:resource="http://www.rssboard.org/rss-specification"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<!-- ==============================
		## xsl:template for RSS element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードと属性のベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:rss10.module.rss091.mode.rssToModule"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS091 Moduleに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{concat('rss091:', local-name())}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="
		copyright | managingEditor | webMaster | channel/pubDate |
		lastBuildDate | rating | hour | day | item/description
	" mode="cxsltl:rss10.module.rss091.mode.rssToModule">
		<xsl:element name="rss091:{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>language要素をRSS091 Moduleに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{concat('rss091:', local-name())}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="language" mode="cxsltl:rss10.module.rss091.mode.rssToModule">
		<rss091:language rdf:datatype="http://purl.org/dc/terms/RFC1766">
			<xsl:value-of select="normalize-space()"/>
		</rss091:language>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{width}要素、{height}要素をRSS091 Moduleに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{concat('rss091:', local-name())}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="width | height" mode="cxsltl:rss10.module.rss091.mode.rssToModule">
		<xsl:element name="rss091:{local-name()}">
			<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#positiveInteger</xsl:attribute>

			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{skipHours}要素、{skipDays}要素をRSS091 Moduleに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{concat('rss091:', local-name())}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="skipHours | skipDays" mode="cxsltl:rss10.module.rss091.mode.rssToModule">
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:element name="rss091:{local-name()}">
			<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>

			<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.rss091.mode.rssToModule">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!-- ==============================
		## xsl:template for RSS091 Module element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードと属性のベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:rss10.module.rss091.mode.moduleToRss"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS091 Moduleに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="
		rss091:language | rss091:copyright | rss091:managingEditor | rss091:webMaster |
		rss091:channel/pubDate | rss091:lastBuildDate | rss091:width | rss091:height |
		rss091:rating | rss091:hour | rss091:day | rss091:description
	" mode="cxsltl:rss10.module.rss091.mode.moduleToRss">
		<xsl:element name="{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss091:skipHours}要素、{rss091:skipDays}要素をRSSに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss091:skipHours | rss091:skipDays" mode="cxsltl:rss10.module.rss091.mode.moduleToRss">
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.rss091.mode.moduleToRss">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSSをRSS091 Moduleに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{concat('rss091:', local-name())}の要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10.module.rss091.rssToModule">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.rss091.mode.rssToModule">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS091 ModuleをRSSに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10.module.rss091.moduleToRss">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.rss091.mode.moduleToRss">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>