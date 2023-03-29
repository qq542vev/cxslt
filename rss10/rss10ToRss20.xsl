<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss10ToRss20.stylesheet"
	exclude-result-prefixes="admin ag cxsltl rdf rss rss091 sy xsl xsltdoc"
	xmlns:admin="http://webns.net/mvcb/"
	xmlns:ag="http://purl.org/rss/1.0/modules/aggregation/"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/rss/1.0/"
	xmlns:rss091="http://purl.org/rss/1.0/modules/rss091#"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/iso8601/datetime.xsl"/>
	<xsl:import href="../library/rss10/module/enclosure.xsl"/>
	<xsl:import href="../library/rss10/module/rss091.xsl"/>
	<xsl:import href="../library/rss10/module/syndication.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 1.0 format into RSS 2.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 1.0 形式で書かれたファイルを RSS 2.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-10</xsltdoc:version>
		<xsltdoc:since>2011-11-16</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://purl.org/rss/1.0/spec"/>
		<xsltdoc:output rdf:resource="http://www.rssboard.org/rss-specification"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/rss+xml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss10ToRss20.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 1.0の要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RSS 2.0への変換はxsl:call-templateを使用しcxsltl:rss10ToRss20.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="RSS 2.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<rss version="2.0">
			<channel>
				<docs>http://www.rssboard.org/rss-specification</docs>

				<xsl:call-template name="cxsltl:rss10ToRss20.convert">
					<xsl:with-param name="node" select="rdf:RDF"/>
				</xsl:call-template>
			</channel>
		</rss>
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

	<xsl:template match="/ | *" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss10ToRss20.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss091:*}要素のベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss091:*" mode="cxsltl:rss10ToRss20.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rdf:RDF}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{channel/*}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rdf:RDF" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="rss:channel[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{channel/*}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="ancestor-or-self::*[count(@xml:lang | $deny) != $denyCount][count(. | $deny) != $denyCount]">
			<language>
				<xsl:value-of select="ancestor-or-self::*[count(@xml:lang | $deny) != $denyCount][count(. | $deny) != $denyCount][1]/@xml:lang"/>
			</language>
		</xsl:if>

		<xsl:if test="sy:*[count(. | $deny) != $denyCount]">
			<xsl:variable name="second">
				<xsl:call-template name="cxsltl:rss10.module.syndication.elementToSecond">
					<xsl:with-param name="period" select="sy:updatePeriod[count(. | $deny) != $denyCount]"/>
					<xsl:with-param name="frequency" select="sy:updateFrequency[count(. | $deny) != $denyCount]"/>
				</xsl:call-template>
			</xsl:variable>

			<ttl>
				<xsl:value-of select="round($second * 60)"/>
			</ttl>
		</xsl:if>

		<xsl:apply-templates select="*[not(self::rss:items)][count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>

		<xsl:call-template name="cxsltl:rss10.module.rss091.moduleToRss">
			<xsl:with-param name="node" select="*"/>
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:call-template>

		<xsl:apply-templates select="rss:items[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/*}要素、{rss:image/*}要素、{rss:textinput/*}要素、{rss:item/*}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="元の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="
		rss:channel/*[not(self::rss:*) and @rdf:parseType = 'Literal'] |
		rss:image/*[not(self::rss:*) and @rdf:parseType = 'Literal'] |
		rss:textinput/*[not(self::rss:*) and @rdf:parseType = 'Literal'] |
		rss:item/*[not(self::rss:*) and @rdf:parseType = 'Literal']
	" mode="cxsltl:rss10ToRss20.converter" priority="-0.375">
		<xsl:copy>
			<xsl:copy-of select="node()"/>
		</xsl:copy>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/*}要素、{rss:image/*}要素、{rss:textinput/*}要素、{rss:item/*}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="元の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="
		rss:channel/*[not(self::rss:*) and @rdf:resource] |
		rss:image/*[not(self::rss:*) and @rdf:resource] |
		rss:textinput/*[not(self::rss:*) and @rdf:resource] |
		rss:item/*[not(self::rss:*) and @rdf:resource]
	" mode="cxsltl:rss10ToRss20.converter" priority="-0.375">
		<xsl:copy>
			<xsl:attribute name="xsi:type">http://purl.org/dc/terms/URI</xsl:attribute>

			<xsl:value-of select="@rdf:resource"/>
		</xsl:copy>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/*}要素、{rss:image/*}要素、{rss:textinput/*}要素、{rss:item/*}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="元の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="
		rss:channel/*[not(self::rss:*) and (@rdf:datatype or not(@rdf:* or *))] |
		rss:image/*[not(self::rss:*) and (@rdf:datatype or not(@rdf:* or *))] |
		rss:textinput/*[not(self::rss:*) and (@rdf:datatype or not(@rdf:* or *))] |
		rss:item/*[not(self::rss:*) and (@rdf:datatype or not(@rdf:* or *))]
	" mode="cxsltl:rss10ToRss20.converter" priority="-0.375">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:copy>
			<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:value-of select="."/>
		</xsl:copy>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@rdf:datatype}属性をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@xsi:type}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@rdf:datatype[starts-with(., 'http://purl.org/dc/terms/')][substring-after(., 'http://purl.org/dc/terms/')]" mode="cxsltl:rss10ToRss20.converter">
		<xsl:attribute name="xsi:type">
			<xsl:value-of select="concat('dcterms:', substring-after(., 'http://purl.org/dc/terms/'))"/>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@rdf:datatype}属性をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@xsi:type}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@rdf:datatype[starts-with(., 'http://www.w3.org/2001/XMLSchema#')][substring-after(., 'http://www.w3.org/2001/XMLSchema#')]" mode="cxsltl:rss10ToRss20.converter">
		<xsl:attribute name="xsi:type">
			<xsl:value-of select="concat('xs:', substring-after(., 'http://www.w3.org/2001/XMLSchema#'))"/>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{local-name()}の要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:title | rss:link | rss:description | rss:url | rss:name" mode="cxsltl:rss10ToRss20.converter">
		<xsl:element name="{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{admin:errorReportsTo}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{webMaster}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/admin:errorReportsTo[starts-with(@rdf:resource, 'mailto:')]" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(
			(
				preceding-sibling::admin:errorReportsTo[starts-with(@rdf:resource, 'mailto:')] |
				parent::*/rss091:webmaster
			)[count(. | $deny) != $denyCount]
		)">
			<webMaster>
				<xsl:value-of select="normalize-space(@rdf:resource)"/>
			</webMaster>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/dc:date}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{lastBuildDate}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/dc:date" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(
			(
				preceding-sibling::dc:date |
				parent::*/rss091:lastBuildDate
			)[count(. | $deny) != $denyCount]
		)">
			<lastBuildDate>
				<xsl:call-template name="cxsltl:date.iso8601.datetime.parse">
					<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toEmailDateTime']"/>
				</xsl:call-template>
			</lastBuildDate>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/dc:language}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{language}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/dc:language" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="
				not(
					(
						ancestor::*[count(@xml:lang | $deny) != $denyCount] |
						parent::*/rss091:language
					)[count(. | $deny) != $denyCount]
				) and
				(count(@rdf:datatype | $deny) != $denyCount) and
				(
					(@rdf:datatype != 'http://purl.org/dc/terms/RFC1766') or
					(@rdf:datatype != 'http://purl.org/dc/terms/RFC3066') or
					(@rdf:datatype != 'http://purl.org/dc/terms/RFC4646') or
					(@rdf:datatype != 'http://purl.org/dc/terms/RFC5646')
				)
			">
				<language>
					<xsl:value-of select="normalize-space()"/>
				</language>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:value-of select="normalize-space()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/dc:rights}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{copyright}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/dc:rights" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not((preceding-sibling::dc:rights | parent::*/rss091:copyright)[count(. | $deny) != $denyCount])">
			<copyright>
				<xsl:value-of select="normalize-space()"/>
			</copyright>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:subject}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{category}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/dc:subject | rss:item/dc:subject" mode="cxsltl:rss10ToRss20.converter">
		<category>
			<xsl:value-of select="normalize-space()"/>
		</category>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/rss:image/@rdf:resource}属性をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{image}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/rss:image/@rdf:resource" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="
			parent::rss:image/parent::rss:channel/parent::rdf:RDF/
			rss:image[normalize-space(@rdf:about) = normalize-space(current())][count(. | $deny) != $denyCount]
		" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:channel/rss:textinput/@rdf:resource}属性をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{textInput}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/rss:textinput/@rdf:resource" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="
			parent::rss:textinput/parent::rss:channel/parent::rdf:RDF/
			rss:textinput[normalize-space(@rdf:about) = normalize-space(current())][count(. | $deny) != $denyCount]
		" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:items/rdf:Seq/rdf:li/@rdf:resource}属性をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{item}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:items/rdf:Seq/rdf:li/@rdf:resource" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="
			parent::rdf:li/parent::rdf:Seq/parent::rss:items/parent::rss:channel/parent::rdf:RDF/
			rss:item[normalize-space(@rdf:about) = normalize-space(current())][count(. | $deny) != $denyCount]
		" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rdf:RDF/rss:image}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{image}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rdf:RDF/rss:image" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<image>
			<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:call-template name="cxsltl:rss10.module.rss091.moduleToRss">
				<xsl:with-param name="node" select="*"/>
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</image>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rdf:RDF/rss:textinput}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{textInput}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rdf:RDF/rss:textinput" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<textInput>
			<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</textInput>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{item}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<item>
			<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:if test="ag:source[count(. | $deny) != $denyCount] and ag:sourceURL[count(. | $deny) != $denyCount]">
				<source url="{normalize-space(ag:sourceURL)}">
					<xsl:value-of select="normalize-space(ag:source)"/>
				</source>
			</xsl:if>

			<xsl:call-template name="cxsltl:rss10.module.enclosure.moduleToRss">
				<xsl:with-param name="node" select="*"/>
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</item>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item/rss:description}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{description}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/rss:description" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<description>
			<xsl:call-template name="cxsltl:xml.generate.escape"/>
		</description>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item/dc:date}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{pubDate}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/dc:date" mode="cxsltl:rss10ToRss20.converter">
		<pubDate>
			<xsl:call-template name="cxsltl:date.iso8601.datetime.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toEmailDateTime']"/>
			</xsl:call-template>
		</pubDate>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item/rss:dc:identifier}要素をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{guid}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/dc:identifier" mode="cxsltl:rss10ToRss20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<guid>
			<xsl:if test="
				(count(@rdf:datatype | $deny) = $denyCount) or
				(@rdf:datatype != 'http://purl.org/dc/terms/URI') or
				(@rdf:datatype != 'http://www.w3.org/2001/XMLSchema#anyURI')
			">
				<xsl:attribute name="isPermaLink">false</xsl:attribute>
			</xsl:if>

			<xsl:value-of select="normalize-space()"/>
		</guid>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 1.0をRSS 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="RSS 2.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10ToRss20.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss10ToRss20.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToRss20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>