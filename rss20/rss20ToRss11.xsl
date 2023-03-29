<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss20ToRss11.stylesheet"
	exclude-result-prefixes="cxsltl xsi xsl xsltdoc"
	xmlns="http://purl.org/net/rss1.1#"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/email.xsl"/>
	<xsl:import href="../library/rss10/module/enclosure.xsl"/>
	<xsl:import href="../library/rss10/module/rss091.xsl"/>
	<xsl:import href="../library/rss10/module/syndication.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>
	<xsl:import href="rss20ToRss10.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 2.0 format into RSS 1.1 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 2.0 形式で書かれたファイルを RSS 1.1 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-09</xsltdoc:version>
		<xsltdoc:since>2011-11-14</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.rssboard.org/rss-specification"/>
		<xsltdoc:output rdf:resource="http://inamidst.com/rss1.1/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/rss+xml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss20ToRss11.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 2.0の要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RSS 1.1への変換はxsl:call-templateを使用しcxsltl:rss20ToRss11.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="RSS 1.1を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss20ToRss11.convert">
			<xsl:with-param name="node" select="rss/channel"/>
		</xsl:call-template>
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

	<xsl:template match="/ | *" mode="cxsltl:rss20ToRss11.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss11.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20ToRss11.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{channel}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{Channel}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel" mode="cxsltl:rss20ToRss11.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss11.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<Channel rdf:about="">
			<xsl:if test="language[count(. | $deny) != $denyCount]">
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="language"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="title[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="link[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="description[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="image[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="*[not(self::title | self::link | self::description | self::image | self::item)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:call-template name="cxsltl:rss10.module.rss091.rssToModule">
				<xsl:with-param name="node" select="*"/>
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>

			<items rdf:parseType="Collection">
				<xsl:apply-templates select="item[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</items>
		</Channel>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel/title | channel/link | channel/description | image/url | image/title | image/link | item/title | item/link" mode="cxsltl:rss20ToRss11.converter">
		<xsl:element name="{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{language}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:rights}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="language" mode="cxsltl:rss20ToRss11.converter">
		<dc:language rdf:datatype="http://purl.org/dc/terms/RFC1766">
			<xsl:value-of select="normalize-space()"/>
		</dc:language>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{copyright}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:rights}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="copyright" mode="cxsltl:rss20ToRss11.converter">
		<dc:rights>
			<xsl:value-of select="normalize-space()"/>
		</dc:rights>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{managingEditor}要素、{author}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:creator}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="managingEditor | author" mode="cxsltl:rss20ToRss11.converter">
		<dc:creator>
			<xsl:value-of select="normalize-space()"/>
		</dc:creator>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{webMaster}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:publisher}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="webMaster" mode="cxsltl:rss20ToRss11.converter">
		<dc:publisher>
			<xsl:value-of select="normalize-space()"/>
		</dc:publisher>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{lastBuildDate}要素、{item/pubDate}をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:date}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="lastBuildDate | item/pubDate" mode="cxsltl:rss20ToRss11.converter">
		<dc:date rdf:datatype="http://purl.org/dc/terms/W3CDTF">
			<xsl:call-template name="cxsltl:date.email.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
			</xsl:call-template>
		</dc:date>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{category}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:subject}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="category" mode="cxsltl:rss20ToRss11.converter">
		<dc:subject>
			<xsl:value-of select="normalize-space()"/>
		</dc:subject>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{generator}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:contributor}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="generator" mode="cxsltl:rss20ToRss11.converter">
		<dc:contributor>
			<xsl:value-of select="normalize-space()"/>
		</dc:contributor>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{image}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{image}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="image" mode="cxsltl:rss20ToRss11.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss11.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<image rdf:parseType="Resource">
			<xsl:apply-templates select="title[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="link[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="url[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="*[not(self::title | self::link | self::url)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:call-template name="cxsltl:rss10.module.rss091.rssToModule">
				<xsl:with-param name="node" select="*"/>
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</image>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{ttl}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{sy:updatePeriod}要素、{sy:updatePeriod}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="ttl" mode="cxsltl:rss20ToRss11.converter">
		<xsl:call-template name="cxsltl:rss10.module.syndication.secondToElement">
			<xsl:with-param name="second" select=". * 60"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{item}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item" mode="cxsltl:rss20ToRss11.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss11.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<item>
			<xsl:choose>
				<xsl:when test="link[count(. | $deny) != $denyCount]">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="link"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="guid[not(@isPermaLink) or @isPermaLink = 'true'][count(. | $deny) != $denyCount]">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="guid"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="concat('#item-', generate-id())"/>
					</xsl:attribute>

					<xsl:attribute name="xml:id">
						<xsl:value-of select="concat('item-', generate-id())"/>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="title[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:if test="not(title[count(. | $deny) != $denyCount])">
				<title>No Title</title>
			</xsl:if>

			<xsl:apply-templates select="link[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:if test="not(link[count(. | $deny) != $denyCount])">
				<link>
					<xsl:choose>
						<xsl:when test="guid[not(@isPermaLink) or @isPermaLink = 'true'][count(. | $deny) != $denyCount]">
							<xsl:value-of select="guid[not(@isPermaLink) or @isPermaLink = 'true'][count(. | $deny) != $denyCount]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('#item-', generate-id())"/>
						</xsl:otherwise>
					</xsl:choose>
				</link>
			</xsl:if>

			<xsl:apply-templates select="description[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="*[not(self::title | self::link | self::description)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:call-template name="cxsltl:rss10.module.enclosure.rssToModule">
				<xsl:with-param name="node" select="*"/>
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</item>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item/description}要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{description}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/description" mode="cxsltl:rss20ToRss11.converter">
		<description>
			<xsl:call-template name="cxsltl:xml.generate.removeTags">
				<xsl:with-param name="string" select="normalize-space()"/>
			</xsl:call-template>
		</description>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="guid | source[@url] | dc:*[not(*)] | content:encoded" mode="cxsltl:rss20ToRss11.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss11.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:rss20ToRss10.convert">
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 2.0をRSS 1.1に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="RSS 1.1を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss20ToRss11.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss20ToRss11.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss11.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>