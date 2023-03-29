<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:enc="http://purl.oclc.org/net/rss_2.0/enc#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="ja">RSS 2.0 の{enclosure}要素を Enclosure Module に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-27</xsltdoc:version>
		<xsltdoc:since>2017-11-27</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://foz.home.xs4all.nl/mod_enclosure.html"/>
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

	<xsl:template match="node() | @*" mode="cxsltl:rss10.module.enclosure.mode.rssToModule"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enclosure}要素をEnclosure Moduleに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{enc:enclosure}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enclosure[@url][@length][@type]" mode="cxsltl:rss10.module.enclosure.mode.rssToModule">
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<enc:enclosure>
			<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.enclosure.mode.rssToModule">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</enc:enclosure>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enclosure/@url}属性をEnclosure Moduleに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@rdf:resource}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enclosure/@url" mode="cxsltl:rss10.module.enclosure.mode.rssToModule">
		<xsl:attribute name="rdf:resource">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enclosure/@length}属性、{enclosure/@type}属性をEnclosure Moduleに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{enc:*}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enclosure/@length | enclosure/@type" mode="cxsltl:rss10.module.enclosure.mode.rssToModule">
		<xsl:attribute name="enc:{name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>
	</xsl:template>

	<!-- ==============================
		## xsl:template for Enclosure Module element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードと属性のベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:rss10.module.enclosure.mode.moduleToRss"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enc:enclosure}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{enclosure}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enc:enclosure[@rdf:resource][@enc:length][@enc:type]" mode="cxsltl:rss10.module.enclosure.mode.moduleToRss">
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<enclosure>
			<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.enclosure.mode.moduleToRss">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</enclosure>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enc:enclosure/@rdf:resource}属性をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{url}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enc:enclosure/@rdf:resource" mode="cxsltl:rss10.module.enclosure.mode.moduleToRss">
		<xsl:attribute name="url">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enc:enclosure/@rdf:resource}属性をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enc:enclosure/@enc:length | enc:enclosure/@enc:type" mode="cxsltl:rss10.module.enclosure.mode.moduleToRss">
		<xsl:attribute name="{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSSをEnclosure Moduleに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{concat('enc:', local-name())}の要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10.module.enclosure.rssToModule">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.enclosure.mode.rssToModule">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Enclosure ModuleをRSSに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10.module.enclosure.moduleToRss">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10.module.enclosure.mode.moduleToRss">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>