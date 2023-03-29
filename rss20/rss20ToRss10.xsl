<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss20ToRss10.stylesheet"
	exclude-result-prefixes="cxsltl xsi xsl xsltdoc"
	xmlns="http://purl.org/rss/1.0/"
	xmlns:ag="http://purl.org/rss/1.0/modules/aggregation/"
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

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 2.0 format into RSS 1.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 2.0 形式で書かれたファイルを RSS 1.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-09</xsltdoc:version>
		<xsltdoc:since>2011-11-15</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.rssboard.org/rss-specification"/>
		<xsltdoc:output rdf:resource="http://web.resource.org/rss/1.0/spec"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/rss+xml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss20ToRss10.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 2.0の要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RSS 1.0への変換はxsl:call-templateを使用しcxsltl:rss20ToRss10.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="RSS 1.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:call-template name="cxsltl:rss20ToRss10.convert">
				<xsl:with-param name="node" select="rss/channel"/>
			</xsl:call-template>
		</rdf:RDF>
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

	<xsl:template match="/ | *" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20ToRss10.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{channel}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<channel rdf:about="">
			<xsl:apply-templates select="*[not(self::item | self::image | self::textInput)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="(image | textInput)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.channel">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:call-template name="cxsltl:rss10.module.rss091.rssToModule">
				<xsl:with-param name="node" select="*"/>
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>

			<items>
				<rdf:Seq>
					<xsl:apply-templates select="item[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.channel">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>
				</rdf:Seq>
			</items>
		</channel>

		<xsl:apply-templates select="(item | image | textInput)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="title | link | channel/description | url | textInput/description | name" mode="cxsltl:rss20ToRss10.converter">
		<xsl:element name="{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{language}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:language}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="language" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:language[not(*)][count(. | $deny) != $denyCount])">
			<dc:language rdf:datatype="http://purl.org/dc/terms/RFC1766">
				<xsl:value-of select="normalize-space()"/>
			</dc:language>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{copyright}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:rights}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="copyright" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:rights[not(*)][count(. | $deny) != $denyCount])">
			<dc:rights>
				<xsl:value-of select="normalize-space()"/>
			</dc:rights>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{managingEditor}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:creator}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="managingEditor" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:creator[not(*)][count(. | $deny) != $denyCount])">
			<dc:creator>
				<xsl:value-of select="normalize-space()"/>
			</dc:creator>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{webMaster}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:publisher}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="webMaster" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:publisher[not(*)][count(. | $deny) != $denyCount])">
			<dc:publisher>
				<xsl:value-of select="normalize-space()"/>
			</dc:publisher>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{lastBuildDate}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:date}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="lastBuildDate" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:date[not(*)][count(. | $deny) != $denyCount])">
			<dc:date rdf:datatype="http://purl.org/dc/terms/W3CDTF">
				<xsl:call-template name="cxsltl:date.email.parse">
					<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
				</xsl:call-template>
			</dc:date>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{category}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:subject}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="category" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(
			parent::*/dc:subject[not(*)][count(. | $deny) != $denyCount] |
			preceding-sibling::category[count(. | $deny) != $denyCount]
		)">
			<dc:subject>
				<xsl:value-of select="normalize-space()"/>
			</dc:subject>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{generator}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:contributor}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="generator" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:contributor[not(*)][count(. | $deny) != $denyCount])">
			<dc:contributor>
				<xsl:value-of select="normalize-space()"/>
			</dc:contributor>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{ttl}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{sy:updatePeriod}要素、{sy:updatePeriod}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="ttl" mode="cxsltl:rss20ToRss10.converter">
		<xsl:call-template name="cxsltl:rss10.module.syndication.secondToElement">
			<xsl:with-param name="second" select=". * 60"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{image}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{image}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="image" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<image>
			<xsl:if test="url[count(. | $deny) != $denyCount]">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="url"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
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
		<xsltdoc:short>{textInput}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{textinput}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="textInput" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<textinput rdf:about="{normalize-space(link)}">
			<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</textinput>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{item}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<item>
			<xsl:choose>
				<xsl:when test="link[count(. | $deny) != $denyCount]">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="normalize-space(link)"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="guid[not(@isPermaLink) or @isPermaLink = 'true'][count(. | $deny) != $denyCount]">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="normalize-space(guid)"/>
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

			<xsl:if test="not(title[count(. | $deny) != $denyCount])">
				<title>No Title</title>
			</xsl:if>

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

			<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
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
		<xsltdoc:short>{item/description}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{description}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/description" mode="cxsltl:rss20ToRss10.converter">
		<description>
			<xsl:call-template name="cxsltl:xml.generate.removeTags">
				<xsl:with-param name="string" select="normalize-space()"/>
			</xsl:call-template>
		</description>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{author}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:creator}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="author" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:creator[not(*)][count(. | $deny) != $denyCount])">
			<dc:creator>
				<xsl:value-of select="normalize-space()"/>
			</dc:creator>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{guid}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:identifier}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="guid" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:identifier[not(*)][count(. | $deny) != $denyCount])">
			<dc:identifier>
				<xsl:if test="(count(@isPermaLink | $deny) = $denyCount) or (@isPermaLink = 'true')">
					<xsl:attribute name="rdf:datatype">http://purl.org/dc/terms/URI</xsl:attribute>
				</xsl:if>

				<xsl:value-of select="normalize-space()"/>
			</dc:identifier>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item/pubDate}をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:date}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/pubDate" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::*/dc:date[not(*)][count(. | $deny) != $denyCount])">
			<dc:date rdf:datatype="http://purl.org/dc/terms/W3CDTF">
				<xsl:call-template name="cxsltl:date.email.parse">
					<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
				</xsl:call-template>
			</dc:date>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{source[@url]}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{ag:source}要素、{ag:sourceURL}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="source[@url]" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<ag:source>
			<xsl:value-of select="normalize-space()"/>
		</ag:source>

		<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{source/@url}属性をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{ag:sourceURL}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="source/@url" mode="cxsltl:rss20ToRss10.converter">
		<ag:sourceURL rdf:datatype="http://purl.org/dc/terms/URI">
			<xsl:value-of select="normalize-space()"/>
		</ag:sourceURL>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{content:encoded}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="元の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/content:encoded" mode="cxsltl:rss20ToRss10.converter">
		<xsl:copy>
			<xsl:value-of select="."/>
		</xsl:copy>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:*[not(*)]}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="元の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel/dc:*[not(*)] | image/dc:*[not(*)] | textInput/dc:*[not(*)] | item/dc:*[not(*)]" mode="cxsltl:rss20ToRss10.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(preceding-sibling::dc:*[not(*)][local-name() = local-name(current())][count(. | $deny) != $denyCount])">
			<xsl:copy>
				<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<xsl:copy-of select="node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:*[not(*)]/@xsi:type}属性をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@rdf:datatype}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="
		channel/dc:*[not(*)]/@xsi:type | image/dc:*[not(*)]/@xsi:type |
		textInput/dc:*[not(*)]/@xsi:type | item/dc:*[not(*)]/@xsi:type
	" mode="cxsltl:rss20ToRss10.converter">
		<xsl:if test="parent::*/namespace::*[name() = substring-before(current(), ':')] = 'http://purl.org/dc/terms/'">
			<xsl:attribute name="rdf:datatype">
				<xsl:value-of select="concat('http://purl.org/dc/terms/', substring-after(., ':'))"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss20ToRss10.channel">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.channel">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20ToRss10.channel"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{rdf:li}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item" mode="cxsltl:rss20ToRss10.channel">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<rdf:li>
			<xsl:attribute name="rdf:resource">
				<xsl:choose>
					<xsl:when test="link[count(. | $deny) != $denyCount]">
						<xsl:value-of select="link"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('#item-', generate-id())"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</rdf:li>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{image}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{image}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="image/url" mode="cxsltl:rss20ToRss10.channel">
		<image rdf:resource="{normalize-space()}"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{textInput}要素をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{textinput}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="textInput/link" mode="cxsltl:rss20ToRss10.channel">
		<textinput rdf:resource="{normalize-space()}"/>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 2.0をRSS 1.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="RSS 1.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss20ToRss10.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss20ToRss10.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss10.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>