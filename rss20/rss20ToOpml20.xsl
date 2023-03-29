<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss20ToOpml20.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/common.xsl"/>
	<xsl:import href="../library/rss20/get.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 2.0 format into OPML 2.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 2.0 形式で書かれたファイルを OPML 2.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-20</xsltdoc:version>
		<xsltdoc:since>2011-10-02</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.rssboard.org/rss-specification"/>
		<xsltdoc:output rdf:resource="http://www.opml.org/spec2"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/xml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss20ToOpml20.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 2.0の要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			OPML 2.0への変換はxsl:call-templateを使用しcxsltl:rss20ToOpml20.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="OPML 2.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss20ToOpml20.convert">
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

	<xsl:template match="/ | *" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20ToOpml20.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{channel}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{opml}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<opml version="2.0">
			<head>
				<xsl:apply-templates select="*[not(self::item)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<docs>http://www.opml.org/spec2</docs>
			</head>

			<body>
				<xsl:apply-templates select="item[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</body>
		</opml>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{lastBuildDate}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dateModified}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel/lastBuildDate" mode="cxsltl:rss20ToOpml20.converter">
		<dateModified>
			<xsl:value-of select="normalize-space()"/>
		</dateModified>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{managingEditor}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{ownerEmail}要素と{ownerName}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel/managingEditor" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:rss20.get.email"/>
		</xsl:variable>
		<xsl:variable name="email" select="substring-before($result, ' ')"/>
		<xsl:variable name="name" select="substring-after($result, ' ')"/>

		<xsl:if test="$email">
			<ownerEmail>
				<xsl:value-of select="$email"/>
			</ownerEmail>
		</xsl:if>

		<xsl:if test="$name">
			<ownerName>
				<xsl:value-of select="$name"/>
			</ownerName>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{pubDate}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dateCreated}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel/pubDate" mode="cxsltl:rss20ToOpml20.converter">
		<dateCreated>
			<xsl:value-of select="normalize-space()"/>
		</dateCreated>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>title要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="title要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel/title" mode="cxsltl:rss20ToOpml20.converter">
		<title>
			<xsl:value-of select="normalize-space()"/>
		</title>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{outline}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<outline>
			<xsl:variable name="category" select="category[not(contains(., ','))][count(. | $deny) != $denyCount]"/>

			<xsl:if test="$category">
				<xsl:attribute name="category">
					<xsl:apply-templates select="$category" mode="cxsltl:rss20ToOpml20.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="*[not(self::category | self::comments | self::enclosure)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="*[self::comments | self::enclosure][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</outline>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{category}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="カンマ区切りの{category}要素の値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/category[not(contains(., ','))]" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:variable name="normalized" select="normalize-space()"/>

		<xsl:if test="not(starts-with($normalized, '/'))">/</xsl:if>

		<xsl:value-of select="$normalized"/>

		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{comments}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{outline}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/comments" mode="cxsltl:rss20ToOpml20.converter">
		<outline type="link" url="{normalize-space()}" text="Comment"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enclosure}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{outline}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/enclosure[@url]" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<outline type="link">
			<xsl:apply-templates select="@url" mode="cxsltl:rss20ToOpml20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:attribute name="text">
				<xsl:text>Enclosure</xsl:text>

				<xsl:apply-templates select="@type[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<xsl:apply-templates select="@length[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:attribute>
		</outline>
	</xsl:template>

	<xsl:template match="item/enclosure/@url" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:attribute name="url">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="item/enclosure/@type" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:value-of select="concat(' [', normalize-space(), ']')"/>
	</xsl:template>

	<xsl:template match="item/enclosure/@length" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:value-of select="concat(' ', format-number(normalize-space(), '###,###,###,###,###,###', 'cxsltl:common.numberFormat'), ' Bytes')"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{description}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{@text}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/description" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::item/title[count(. | $deny) != $denyCount])">
			<xsl:attribute name="text">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{link}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@url}属性と{@type}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/link" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:attribute name="url">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>

		<xsl:attribute name="type">link</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{pubDate}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@created}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/pubDate" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:attribute name="created">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{title}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@text}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/title" mode="cxsltl:rss20ToOpml20.converter">
		<xsl:attribute name="text">
			<xsl:call-template name="cxsltl:xml.generate.escape">
				<xsl:with-param name="string" select="normalize-space()"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 2.0をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="OPML 2.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss20ToOpml20.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="cxsltl:rss20ToOpml20.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToOpml20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>