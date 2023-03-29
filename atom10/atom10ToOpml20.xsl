<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.atom10ToOpml20.stylesheet"
	exclude-result-prefixes="atom cxsltl rdf xhtml xsl xsltdoc"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/iso8601/datetime.xsl"/>
	<xsl:import href="../library/uri.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>
	<xsl:import href="../xhtml/xhtmlToHtmlText.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts Atom 1.0 format into OPML 2.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Atom 1.0 形式で書かれたファイルを OPML 2.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-20</xsltdoc:version>
		<xsltdoc:since>2011-10-17</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.ietf.org/rfc/rfc4287.txt"/>
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

	<xsl:param name="cxsltl:atom10ToOpml20.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のAtom 1.0の要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			OPML 2.0への変換はxsl:call-templateを使用しcxsltl:atom10ToOpml20.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="OPMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:atom10ToOpml20.convert">
			<xsl:with-param name="node" select="atom:feed"/>
		</xsl:call-template>
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

	<xsl:template match="/ | *" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:atom10ToOpml20.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:feed}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{opml}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:feed" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<opml version="2.0">
			<head>
				<xsl:apply-templates select="*[not(self::atom:entry)][count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<docs>http://www.opml.org/spec2</docs>
			</head>

			<body>
				<xsl:apply-templates select="atom:entry[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</body>
		</opml>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:title}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{title}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:feed/atom:title" mode="cxsltl:atom10ToOpml20.converter">
		<title>
			<xsl:value-of select="normalize-space()"/>
		</title>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:title[@type = 'html']}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{title}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:feed/atom:title[@type = 'html']" mode="cxsltl:atom10ToOpml20.converter" priority="0.75">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xml.generate.removeTags"/>
		</xsl:variable>

		<title>
			<xsl:value-of select="normalize-space($result)"/>
		</title>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:updated}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dateModified}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:feed/atom:updated" mode="cxsltl:atom10ToOpml20.converter">
		<dateModified>
			<xsl:call-template name="cxsltl:date.iso8601.datetime.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toEmailDateTime']"/>
			</xsl:call-template>
		</dateModified>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:author}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{owner*}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:feed/atom:author" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(preceding-sibling::atom:author[count(. | $deny) != $denyCount])">
			<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:name}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{ownerName}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:author/atom:name" mode="cxsltl:atom10ToOpml20.converter">
		<ownerName>
			<xsl:value-of select="normalize-space()"/>
		</ownerName>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:email}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{ownerEmail}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:author/atom:email" mode="cxsltl:atom10ToOpml20.converter">
		<ownerEmail>
			<xsl:value-of select="normalize-space()"/>
		</ownerEmail>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:uri}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{ownerId}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:author/atom:uri" mode="cxsltl:atom10ToOpml20.converter">
		<ownerId>
			<xsl:value-of select="normalize-space()"/>
		</ownerId>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:entry}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{outline}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<outline>
			<xsl:variable name="category">
				<xsl:apply-templates select="atom:category[count(@term | $deny) != $denyCount][not(contains(@term, ','))][count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:if test="string($category)">
				<xsl:attribute name="category">
					<xsl:value-of select="$category"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="(atom:title | atom:link[not(@rel) or (normalize-space(@rel) = 'alternate') or (normalize-space(@rel) = 'http://www.iana.org/assignments/relation/alternate')] | atom:published)[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:apply-templates select="atom:link[
				(normalize-space(@rel) = 'related') or (normalize-space(@rel) = 'http://www.iana.org/assignments/relation/related') or
				(normalize-space(@rel) = 'enclosure') or (normalize-space(@rel) = 'http://www.iana.org/assignments/relation/enclosure')
			][count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</outline>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:title[not(@type) or @type = 'text']}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@text}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry/atom:title[not(@type) or @type = 'text']" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:attribute name="text">
			<xsl:call-template name="cxsltl:xml.generate.escape">
				<xsl:with-param name="string" select="normalize-space()"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:title[@type = 'html']}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@text}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry/atom:title[@type = 'html']" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:attribute name="text">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:title[@type = 'xhtml']}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{@text}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry/atom:title[@type = 'xhtml']" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:attribute name="text">
			<xsl:call-template name="cxsltl:xhtmlToHtmlText.convert">
				<xsl:with-param name="node" select="xhtml:div[count(. | $deny) != $denyCount]/node()"/>
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:link}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{@url}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry/atom:link[
		not(@rel) or (normalize-space(@rel) = 'alternate') or
		(normalize-space(@rel) = 'http://www.iana.org/assignments/relation/alternate')
	]/@href" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:if test="not(parent::atom:link/preceding-sibling::atom:link[
			not(@rel) or (normalize-space(@rel) = 'alternate') or
			(normalize-space(@rel) = 'http://www.iana.org/assignments/relation/alternate')
		][count(. | $deny) != $denyCount])">
			<xsl:attribute name="url">
				<xsl:call-template name="cxsltl:uri.relativeResolution">
					<xsl:with-param name="base">
						<xsl:call-template name="cxsltl:uri.baseResolution">
							<xsl:with-param name="base" select="ancestor-or-self::*[count(@xml:base | $deny) != $denyCount][count(. | $deny) != $denyCount]"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>

			<xsl:attribute name="type">link</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:link[@rel = 'related' or @rel = 'enclosure']}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{outline}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry/atom:link[
		(normalize-space(@rel) = 'related') or (normalize-space(@rel) = 'http://www.iana.org/assignments/relation/related') or
		(normalize-space(@rel) = 'enclosure') or (normalize-space(@rel) = 'http://www.iana.org/assignments/relation/enclosure')
	]/@href" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:variable name="uri">
			<xsl:call-template name="cxsltl:uri.relativeResolution">
				<xsl:with-param name="base">
					<xsl:call-template name="cxsltl:uri.baseResolution">
						<xsl:with-param name="base" select="ancestor-or-self::*[count(@xml:base | $deny) != $denyCount][count(. | $deny) != $denyCount]"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<outline type="link" url="{$uri}">
			<xsl:attribute name="text">
				<xsl:call-template name="cxsltl:xml.generate.escape">
					<xsl:with-param name="string">
						<xsl:choose>
							<xsl:when test="count(parent::*/@title | $deny)">
								<xsl:value-of select="normalize-space(parent::*/@title)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$uri"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</outline>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:published}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{@created}属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry/atom:published" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:attribute name="created">
			<xsl:call-template name="cxsltl:date.iso8601.datetime.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toEmailDateTime']"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:category}要素をOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="{@term}属性の値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry/atom:category[@term][not(contains(@term, ','))]" mode="cxsltl:atom10ToOpml20.converter">
		<xsl:variable name="normalized" select="normalize-space(@term)"/>

		<xsl:if test="not(starts-with($normalized, '/'))">/</xsl:if>

		<xsl:value-of select="$normalized"/>

		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>AtomをOPML 2.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="OPMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:atom10ToOpml20.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:atom10ToOpml20.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToOpml20.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>