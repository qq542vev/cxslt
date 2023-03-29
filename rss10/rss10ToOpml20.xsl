<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss10ToOpml20.stylesheet"
	exclude-result-prefixes="cxsltl dc rdf rss xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rss="http://purl.org/rss/1.0/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/iso8601/datetime.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 1.0 format into OPML 2.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 1.0 形式で書かれたファイルを OPML 2.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-10</xsltdoc:version>
		<xsltdoc:since>2011-10-02</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://web.resource.org/rss/1.0/spec"/>
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

	<xsl:param name="cxsltl:rss10ToOpml20.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 1.0の要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			OPML 2.0への変換はxsl:call-templateを使用しcxsltl:rss10ToOpml20.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="OPML 2.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss10ToOpml20.convert">
			<xsl:with-param name="node" select="rdf:RDF/rss:channel"/>
		</xsl:call-template>
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

	<xsl:template match="/ | *" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToOpml20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss10ToOpml20.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:Channel}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{opml}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<opml version="2.0">
			<head>
				<xsl:apply-templates select="*[not(self::rss:items)][count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<docs>http://www.opml.org/spec2</docs>
			</head>

			<body>
				<xsl:apply-templates select="rss:items" mode="cxsltl:rss10ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</body>
		</opml>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:title}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{title}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/rss:title" mode="cxsltl:rss10ToOpml20.converter">
		<title>
			<xsl:value-of select="normalize-space()"/>
		</title>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:creator}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{ownerName}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/dc:creator" mode="cxsltl:rss10ToOpml20.converter">
		<ownerName>
			<xsl:value-of select="normalize-space()"/>
		</ownerName>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:date}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dateModified}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:channel/dc:date" mode="cxsltl:rss10ToOpml20.converter">
		<dateModified>
			<xsl:call-template name="cxsltl:date.iso8601.datetime.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toEmailDateTime']"/>
			</xsl:call-template>
		</dateModified>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@rdf:resource}属性から{rss:item}要素を呼び出す</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{outline}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:items/rdf:Seq/rdf:li/@rdf:resource" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="
			parent::rdf:li/parent::rdf:Seq/parent::rss:items/parent::rss:channel/parent::rdf:RDF/
			rss:item[normalize-space(@rdf:about) = normalize-space(current())][count(. | $deny) != $denyCount]
		" mode="cxsltl:rss10ToOpml20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:item}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{outline}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:rss10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<outline>
			<xsl:variable name="subject">
				<xsl:apply-templates select="dc:subject[not(contains(., ','))][count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:if test="string($subject)">
				<xsl:attribute name="category">
					<xsl:value-of select="$subject"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="*[not(self::dc:subject)][count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToOpml20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</outline>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:title}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@text}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/rss:title" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:attribute name="text">
			<xsl:call-template name="cxsltl:xml.generate.escape">
				<xsl:with-param name="string" select="normalize-space()"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{rss:link}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@url}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/rss:link" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:attribute name="url">
			<xsl:value-of select="normalize-space()"/>
		</xsl:attribute>

		<xsl:attribute name="type">link</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:date}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@created}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/dc:date" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:attribute name="created">
			<xsl:call-template name="cxsltl:date.iso8601.datetime.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toEmailDateTime']"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dc:subject}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="{dc:subject}要素の値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="rss:item/dc:subject[not(contains(., ','))]" mode="cxsltl:rss10ToOpml20.converter">
		<xsl:variable name="normalized" select="normalize-space()"/>

		<xsl:if test="not(starts-with($normalized, '/'))">/</xsl:if>

		<xsl:value-of select="$normalized"/>

		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 1.0をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="OPML 2.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss10ToOpml20.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss10ToOpml20.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss10ToOpml20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>