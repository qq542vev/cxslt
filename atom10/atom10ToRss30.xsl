<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.atom10ToRss30.stylesheet"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/rss30/generate.xsl"/>
	<xsl:import href="../library/uri.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts Atom 1.0 format into RSS 3.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Atom 1.0 形式で書かれたファイルを RSS 3.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-05</xsltdoc:version>
		<xsltdoc:since>2011-10-16</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.ietf.org/rfc/rfc4287.txt"/>
		<xsltdoc:output rdf:resource="http://www.aaronsw.com/2002/rss30"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:atom10ToRss30.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のAtom 1.0の要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RSS 3.0への変換はxsl:call-templateを使用しcxsltl:atom10ToRss30.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:atom10ToRss30.convert">
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

	<xsl:template match="/ | *" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:atom10ToRss30.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:feed}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:feed" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(self::atom:entry)][count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="atom:entry[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:entry}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のitemを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:entry" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:text>&#xA;</xsl:text>

		<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:author}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のcreatorを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:author/atom:email" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:rss30.generate.agent">
			<xsl:with-param name="tokenName">creator</xsl:with-param>
			<xsl:with-param name="name">
				<xsl:apply-templates select="parent::atom:author/atom:name[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToRss30.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:name}要素を出力する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="{atom:name}の値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:author/atom:name" mode="cxsltl:atom10ToRss30.converter">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:category}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のsubjectを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:category/@term" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">subject</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:generator}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のgenerateを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:generator" mode="cxsltl:atom10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:id}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のuriを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:id" mode="cxsltl:atom10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">uri</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:link}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のlinkを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:link[
		not(@rel) or (normalize-space(@rel) = 'alternate') or
		(normalize-space(@rel) = 'http://www.iana.org/assignments/relation/alternate')
	]/@href" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">link</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="cxsltl:uri.relativeResolution">
					<xsl:with-param name="base">
						<xsl:call-template name="cxsltl:uri.baseResolution">
							<xsl:with-param name="base" select="ancestor-or-self::*[count(@xml:base | $deny) != $denyCount][count(. | $deny) != $denyCount]"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:link[@rel = 'license']}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のlicenseを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:link[
		normalize-space(@rel) = 'license' or
		(normalize-space(@rel) = 'http://www.iana.org/assignments/relation/license')
	]/@href" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">license</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="cxsltl:uri.relativeResolution">
					<xsl:with-param name="base">
						<xsl:call-template name="cxsltl:uri.baseResolution">
							<xsl:with-param name="base" select="ancestor-or-self::*[count(@xml:base | $deny) != $denyCount][count(. | $deny) != $denyCount]"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:published}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のcreatedを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:published" mode="cxsltl:atom10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">created</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:rights}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のrightsを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:rights" mode="cxsltl:atom10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:rights[@type = 'html']}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のrightsを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:rights[@type = 'html']" mode="cxsltl:atom10ToRss30.converter">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xml.generate.removeTags"/>
		</xsl:variable>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="value" select="normalize-space($result)"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:source[not(parent::*/atom:author)]}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のcreatorを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:source[not(parent::*/atom:author)]" mode="cxsltl:atom10ToRss30.converter">
		<xsl:param name="deny" select="cxsltl:atom10ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="atom:author[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:subtitle}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のdescriptionを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:subtitle" mode="cxsltl:atom10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">description</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:subtitle[@type = 'html']}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のdescriptionを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:subtitle[@type = 'html']" mode="cxsltl:atom10ToRss30.converter">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xml.generate.removeTags"/>
		</xsl:variable>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">description</xsl:with-param>
			<xsl:with-param name="value" select="normalize-space($result)"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:title}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のtitleを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:title" mode="cxsltl:atom10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:title[@type = 'html']}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のtitleを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:title[@type = 'html']" mode="cxsltl:atom10ToRss30.converter">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xml.generate.removeTags"/>
		</xsl:variable>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="value" select="normalize-space($result)"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{atom:updated}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のlast-modifiedを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="atom:updated" mode="cxsltl:atom10ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">last-modified</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>AtomをRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:atom10ToRss30.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:atom10ToRss30.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:atom10ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>