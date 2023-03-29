<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss11ToRss10.stylesheet"
	exclude-result-prefixes="cxsltl payload rss xsl xsltdoc"
	xmlns="http://purl.org/rss/1.0/"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:payload="http://purl.org/net/rss1.1/payload#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/net/rss1.1#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../xhtml/xhtmlToHtmlText.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 1.0 format into RSS 1.1 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 1.0 形式で書かれたファイルを RSS 1.1 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-17</xsltdoc:version>
		<xsltdoc:since>2011-11-14</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://inamidst.com/rss1.1/"/>
		<xsltdoc:output rdf:resource="http://purl.org/rss/1.0/spec"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/rss+xml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss11ToRss10.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:call-template name="cxsltl:rss11ToRss10.convert">
				<xsl:with-param name="node" select="rss:Channel"/>
			</xsl:call-template>
		</rdf:RDF>
	</xsl:template>

	<!-- ==============================
		## xsl:template for RSS 1.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss11ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss11ToRss10.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:Channel}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{channel}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:Channel" mode="cxsltl:rss11ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<channel>
			<xsl:apply-templates select="(node() | @*)[not(self::rss:image | self::rss:items)][count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="(rss:image[@rdf:parseType = 'Resource'] | rss:items[@rdf:parseType = 'Collection'])[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.channel">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</channel>

		<xsl:apply-templates select="(rss:image[@rdf:parseType = 'Resource'] | rss:items[@rdf:parseType = 'Collection'])[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@rdf:about}属性をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="元の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:Channel/@rdf:about | rss:item/@rdf:about" mode="cxsltl:rss11ToRss10.converter">
		<xsl:copy/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{*[not(rss:*)]}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="元の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:Channel/*[not(self::rss:*)] | rss:image/*[not(self::rss:*)] | rss:item/*[not(self::rss:*)]" mode="cxsltl:rss11ToRss10.converter" priority="-0.5">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(preceding-sibling::*[namespace-uri() = namespace-uri(current())][local-name() = local-name(current())])">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:title | rss:link | rss:description | rss:url" mode="cxsltl:rss11ToRss10.converter">
		<xsl:element name="{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:image}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{image}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:image" mode="cxsltl:rss11ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<image rdf:about="normalize-space(rss:url)">
			<xsl:if test="not(rss:link[count(. | $deny) != $denyCount])">
				<xsl:apply-templates select="parent::rss:Channel[count(. | $deny) != $denyCount]/rss:link[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.channel">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:if>

			<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</image>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{item}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item" mode="cxsltl:rss11ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<item>
			<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</item>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item/payload:payload}要素を{content:content}要素に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{content:content}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/payload:payload[@rdf:parseType = 'Literal']" mode="cxsltl:rss11ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(
			preceding-sibling::payload:payload[@rdf:parseType = 'Literal'][count(. | $deny) != $denyCount] |
			parent::*/content:content[count(. | $deny) != $denyCount])
		">
			<content:content>
				<xsl:call-template name="cxsltl:xhtmlToHtmlText.convert">
					<xsl:with-param name="node" select="node()"/>
					<xsl:with-param name="deny" select="$deny"/>
				</xsl:call-template>
			</content:content>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss11ToRss10.channel">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.channel">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss11ToRss10.channel"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:image[@rdf:parseType = 'Resource']/rss:url}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{image}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:image[@rdf:parseType = 'Resource']/rss:url" mode="cxsltl:rss11ToRss10.channel">
		<image rdf:resource="normalize-space()"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:items[@rdf:parseType = 'Collection']}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{items}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:items[@rdf:parseType = 'Collection']" mode="cxsltl:rss11ToRss10.channel">
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<items>
			<rdf:Seq>
				<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.channel">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</rdf:Seq>
		</items>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item/@rdf:about}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{rdf:li}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/@rdf:about" mode="cxsltl:rss11ToRss10.channel">
		<rdf:li rdf:resource="{normalize-space()}"/>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 1.1をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="RSS 1.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss11ToRss10.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss11ToRss10.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss11ToRss10.converter">
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>