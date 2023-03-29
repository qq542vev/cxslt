<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="XHTML" href="xmlToXhtml.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToXhtml.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/line.xsl"/>
	<xsl:import href="../library/string.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>
	<xsl:import href="../library/xml/parse.xsl"/>
	<xsl:import href="../library/xpath/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルをXHTMLに変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードをXHTMLに変換する。
			{xsl:import}, {xsl:include}を使用し外部のスタイルシートとして使用することも出来る。
		</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>aノード以下をXHTMLに変換する例</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:xmlToXhtml.convert">
						<xsl:with-param name="node" select="/a/node()"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-04-08</xsltdoc:version>
		<xsltdoc:since>2013-08-27</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/html51/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="no"
		media-type="application/xhtml+xml"
	/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToXhtml.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToXhtml.deny" select="/.."/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCDATAセクションとするテキストノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToXhtml.cdata" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのid属性の接頭辞</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToXhtml.idPrefix">xml-</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのXMLのバージョン</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToXhtml.version">1.0</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのXMLの符号化情報</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToXhtml.encoding">UTF-8</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのXMLのスタンドアローン文書宣言</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToXhtml.standalone"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDTDの公開識別子</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToXhtml.publicId"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDTDのシステム識別子</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToXhtml.systemId"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDTDのマークアップ宣言</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToXhtml.markupDeclaration"/>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでの行番号の最初の値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToXhtml.start" select="1"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>XPathをXML Nameに変換する要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToXhtml.replace.xpath" select="$cxsltl:xmlToXhtml.self/cxsltl:string.search[@xml:id = 'cxsltl.xmlToXhtml.replace.xpath']/cxsltl:string.replace"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>entityをvar要素のentityに変換する要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToXhtml.replace.entity" select="$cxsltl:xmlToXhtml.self/cxsltl:string.search[@xml:id = 'cxsltl.xmlToXhtml.replace.entity']/cxsltl:string.replace"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.xmlToXhtml.replace.xpath">
		<xsltdoc:short>XPathをXML Nameに変換する要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.xmlToXhtml.replace.xpath">
		<cxsltl:string.replace src="&quot;" dst=".22"/>
		<cxsltl:string.replace src="(" dst=".28"/>
		<cxsltl:string.replace src=")" dst=".29"/>
		<cxsltl:string.replace src="*" dst=".2A"/>
		<cxsltl:string.replace src="." dst=".2E"/>
		<cxsltl:string.replace src="/" dst=".2F"/>
		<cxsltl:string.replace src="=" dst=".3D"/>
		<cxsltl:string.replace src="[" dst=".5B"/>
		<cxsltl:string.replace src="]" dst=".5D"/>
		<cxsltl:string.replace src="@" dst="attribute::"/>
	</cxsltl:string.search>

	<xsltdoc:Element rdf:about="#cxsltl.xmlToXhtml.replace.entity">
		<xsltdoc:short>entityをvar要素のentityに変換する要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.xmlToXhtml.replace.entity">
		<cxsltl:string.replace src="&amp;amp;" dst="&lt;var class=&quot;entity amp&quot;&gt;&amp;amp;amp;&lt;/var&gt;"/>
		<cxsltl:string.replace src="&amp;lt;" dst="&lt;var class=&quot;entity lt&quot;&gt;&amp;amp;lt;&lt;/var&gt;"/>
		<cxsltl:string.replace src="&amp;gt;" dst="&lt;var class=&quot;entity gt&quot;&gt;&amp;amp;gt;&lt;/var&gt;"/>
		<cxsltl:string.replace src="&amp;quot;" dst="&lt;var class=&quot;entity quot&quot;&gt;&amp;amp;quot;&lt;/var&gt;"/>
	</cxsltl:string.search>

	<!-- ==============================
		# Ruled Template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			XHTMLへの変換はxsl:call-templateを使用しcxsltl:xmlToXhtml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="XHTMLに変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xmlToXhtml.convert"/>
		</xsl:variable>

		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>]]></xsl:text>

		<html>
			<head>
				<meta charset="{$cxsltl:xmlToXhtml.self/xsl:output/@encoding}"/>

				<meta lang="en" xml:lang="en" name="description" content="This file is a source code of the XML that performed coloring."/>
				<meta name="generator" content="{system-property('xsl:vendor')}"/>

				<title lang="en" xml:lang="en">XML Source Code</title>

				<xsl:call-template name="cxsltl:xmlToXhtml.style"/>
			</head>
			<body>
				<pre class="xmlToXhtml">
					<code>
						<xsl:value-of disable-output-escaping="yes" select="$result"/>
					</code>
				</pre>
			</body>
		</html>
	</xsl:template>

	<!-- ==============================
		## xsl:template for XML node
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>XML宣言を行い、ルートノードの子ノードにパターンマッチングしたxsl:templateを適用する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:paramString xsltdoc:name="version" xsltdoc:short="XMLのバージョン情報"/>
		<xsltdoc:paramString xsltdoc:name="encoding" xsltdoc:short="符号化宣言"/>
		<xsltdoc:paramString xsltdoc:name="standalone" xsltdoc:short="スタンドアローン宣言"/>
		<xsltdoc:paramString xsltdoc:name="publicId" xsltdoc:short="DTDの公開識別子"/>
		<xsltdoc:paramString xsltdoc:name="systemId" xsltdoc:short="DTDのシステム識別子"/>
		<xsltdoc:paramString xsltdoc:name="markupDeclaration" xsltdoc:short="DTDのマークアップ宣言"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換したノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/" mode="cxsltl:xmlToXhtml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToXhtml.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>
		<xsl:param name="version" select="$cxsltl:xmlToXhtml.version"/>
		<xsl:param name="encoding" select="$cxsltl:xmlToXhtml.encoding"/>
		<xsl:param name="standalone" select="$cxsltl:xmlToXhtml.standalone"/>
		<xsl:param name="publicId" select="$cxsltl:xmlToXhtml.publicId"/>
		<xsl:param name="systemId" select="$cxsltl:xmlToXhtml.systemId"/>
		<xsl:param name="markupDeclaration" select="$cxsltl:xmlToXhtml.markupDeclaration"/>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">root</xsl:with-param>
			<xsl:with-param name="id">
				<xsl:if test="string($idPrefix)">
					<xsl:value-of select="concat($idPrefix, '.2F')"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="title">/</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:if test="string($version)">
					<xsl:call-template name="cxsltl:xmlToXhtml.xmlDeclaration">
						<xsl:with-param name="version" select="$version"/>
						<xsl:with-param name="encoding" select="$encoding"/>
						<xsl:with-param name="standalone" select="$standalone"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:call-template>

					<xsl:text>&#xA;</xsl:text>
				</xsl:if>

				<xsl:for-each select="*/preceding-sibling::node()[count(. | $deny) != $denyCount]">
					<xsl:apply-templates select="self::node()" mode="cxsltl:xmlToXhtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
						<xsl:with-param name="cdata" select="$cdata"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:apply-templates>

					<xsl:text>&#xA;</xsl:text>
				</xsl:for-each>

				<xsl:if test="string($systemId) or string($markupDeclaration)">
					<xsl:call-template name="cxsltl:xmlToXhtml.dtd">
						<xsl:with-param name="publicId" select="$publicId"/>
						<xsl:with-param name="systemId" select="$systemId"/>
						<xsl:with-param name="markupDeclaration" select="$markupDeclaration"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:call-template>

					<xsl:text>&#xA;</xsl:text>
				</xsl:if>

				<xsl:for-each select="*[count(. | $deny) != $denyCount] | */following-sibling::node()[count(. | $deny) != $denyCount]">
					<xsl:apply-templates select="self::node()" mode="cxsltl:xmlToXhtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
						<xsl:with-param name="cdata" select="$cdata"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:apply-templates>

					<xsl:if test="position() != last()">
						<xsl:text>&#xA;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素ノードをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換した要素ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*" mode="cxsltl:xmlToXhtml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToXhtml.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToXhtml.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="elementName">
			<xsl:call-template name="cxsltl:xmlToXhtml.element.fragmentlink">
				<xsl:with-param name="href" select="$xpathEncoded"/>
				<xsl:with-param name="class">elementName</xsl:with-param>
				<xsl:with-param name="title">
					<xsl:if test="namespace-uri()">
						<xsl:value-of select="concat('{', namespace-uri(), '}', local-name())"/>
					</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="content" select="name()"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">
				<xsl:text>element</xsl:text>

				<xsl:if test="not(node()[count(. | $deny) != $denyCount])"> empty</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">elementStart</xsl:with-param>
					<xsl:with-param name="content">
						<xsl:text>&amp;lt;</xsl:text>

						<xsl:value-of select="$elementName"/>

						<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToXhtml.converter">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
							<xsl:with-param name="cdata" select="$cdata"/>
							<xsl:with-param name="idPrefix" select="$idPrefix"/>
						</xsl:apply-templates>

						<xsl:call-template name="cxsltl:xmlToXhtml.namespaceAttribute">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
							<xsl:with-param name="idPrefix" select="$idPrefix"/>
						</xsl:call-template>

						<xsl:if test="not(node()[count(. | $deny) != $denyCount])">/</xsl:if>

						<xsl:text>&amp;gt;</xsl:text>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:if test="node()[count(. | $deny) != $denyCount]">
					<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
						<xsl:with-param name="class">elementValue</xsl:with-param>
						<xsl:with-param name="id">
							<xsl:if test="string($idPrefix)">
								<xsl:value-of select="concat($xpathEncoded, '.2Fnode.28.29')"/>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="title" select="concat($xpath, '/node()')"/>
						<xsl:with-param name="content">
							<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToXhtml.converter">
								<xsl:with-param name="deny" select="$deny"/>
								<xsl:with-param name="denyCount" select="$denyCount"/>
								<xsl:with-param name="cdata" select="$cdata"/>
								<xsl:with-param name="idPrefix" select="$idPrefix"/>
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
						<xsl:with-param name="class">elementEnd</xsl:with-param>
						<xsl:with-param name="content">
							<xsl:text>&amp;lt;/</xsl:text>

							<xsl:value-of select="$elementName"/>

							<xsl:text>&amp;gt;</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>属性ノードをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換した属性ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@*" mode="cxsltl:xmlToXhtml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToXhtml.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
			<xsl:with-param name="nameHref">
				<xsl:if test="string($xpathEncoded)">
					<xsl:value-of select="concat('#', $xpathEncoded)"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="nameAttribute">
				<xsl:call-template name="cxsltl:xml.generate.attribute">
					<xsl:with-param name="name">title</xsl:with-param>
					<xsl:with-param name="value">
						<xsl:choose>
							<xsl:when test="namespace-uri()">
								<xsl:value-of select="concat('{', namespace-uri(), '}', local-name())"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="namespace-uri(..)">
									<xsl:value-of select="concat('{', namespace-uri(..), '}')"/>
								</xsl:if>

								<xsl:value-of select="concat(local-name(..), '/@', local-name())"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="valueHref">
				<xsl:if test="namespace-uri() = 'http://www.w3.org/XML/1998/namespace'">
					<xsl:choose>
						<xsl:when test="local-name() = 'base'">
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:when test="local-name() = 'lang'">https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="valueAttribute">
				<xsl:if test="namespace-uri() = 'http://www.w3.org/XML/1998/namespace' and local-name() = 'lang'">
					<xsl:call-template name="cxsltl:xml.generate.attribute">
						<xsl:with-param name="name">title</xsl:with-param>
						<xsl:with-param name="value">IETF language tag</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="namespace-uri() != 'http://www.w3.org/XML/1998/namespace' and ancestor::*/@xml:lang">
					<xsl:call-template name="cxsltl:xml.generate.attribute">
						<xsl:with-param name="name">lang</xsl:with-param>
						<xsl:with-param name="value" select="ancestor::*/@xml:lang"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換したテキストノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text()" mode="cxsltl:xmlToXhtml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToXhtml.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:value-of select="$idPrefix"/>

			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToXhtml.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="cdataCheck" select="$cdata[count(. | current()) = 1] and not(contains(., ']]&gt;'))"/>

		<xsl:variable name="lang">
			<xsl:if test="ancestor::*/@xml:lang">
				<xsl:call-template name="cxsltl:xml.generate.attribute">
					<xsl:with-param name="name">lang</xsl:with-param>
					<xsl:with-param name="value" select="ancestor::*/@xml:lang"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">
				<xsl:text>text</xsl:text>

				<xsl:if test="$cdataCheck"> cdata</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
			<xsl:with-param name="attribute">
				<xsl:if test="not($cdataCheck) and string($lang)">
					<xsl:value-of select="$lang"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:choose>
					<xsl:when test="$cdataCheck">
						<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
							<xsl:with-param name="class">cdataStart</xsl:with-param>
							<xsl:with-param name="content">
								<xsl:text>&amp;lt;![</xsl:text>

								<xsl:call-template name="cxsltl:xmlToXhtml.element.a">
									<xsl:with-param name="href">http://www.w3.org/TR/xml/#sec-cdata-sect</xsl:with-param>
									<xsl:with-param name="hreflang">en</xsl:with-param>
									<xsl:with-param name="title">CDATA Sections</xsl:with-param>
									<xsl:with-param name="content">CDATA</xsl:with-param>
								</xsl:call-template>

								<xsl:text>[</xsl:text>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
							<xsl:with-param name="class">cdataValue</xsl:with-param>
							<xsl:with-param name="attribute">
								<xsl:if test="$cdataCheck and string($lang)">
									<xsl:value-of select="$lang"/>
								</xsl:if>
							</xsl:with-param>
							<xsl:with-param name="escape" select="true()"/>
						</xsl:call-template>

						<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
							<xsl:with-param name="class">cdataEnd</xsl:with-param>
							<xsl:with-param name="content">]]&amp;gt;</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cxsltl:string.multipleReplace">
							<xsl:with-param name="node" select="$cxsltl:xmlToXhtml.replace.entity[position() != last()]"/>
							<xsl:with-param name="string">
								<xsl:call-template name="cxsltl:xml.generate.escape"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>コメントノードをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換したコメントノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="comment()" mode="cxsltl:xmlToXhtml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToXhtml.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">comment</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">commentStart</xsl:with-param>
					<xsl:with-param name="content">&amp;lt;!--</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.fragmentlink">
					<xsl:with-param name="href" select="$xpathEncoded"/>
					<xsl:with-param name="class">commentValue</xsl:with-param>
					<xsl:with-param name="escape" select="true()"/>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">commentEnd</xsl:with-param>
					<xsl:with-param name="content">--&amp;gt;</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>処理命令ノードをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換した処理命令ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="processing-instruction()" mode="cxsltl:xmlToXhtml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToXhtml.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">pi</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">piStart</xsl:with-param>
					<xsl:with-param name="content">&amp;lt;?</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.fragmentlink">
					<xsl:with-param name="href" select="$xpathEncoded"/>
					<xsl:with-param name="class">piName</xsl:with-param>
					<xsl:with-param name="content" select="name()"/>
				</xsl:call-template>

				<xsl:if test="string()">
					<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
						<xsl:with-param name="class">piValue</xsl:with-param>
						<xsl:with-param name="content">
							<xsl:choose>
								<xsl:when test="name() = 'oasis-xml-catalog'">
									<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
										<xsl:with-param name="callback" select="$cxsltl:xmlToXhtml.self/xsl:template[@name = 'cxsltl:xmlToXhtml.callback.pseudoAttribute.oasisXmlCatalog']"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="name() = 'xml-model'">
									<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
										<xsl:with-param name="callback" select="$cxsltl:xmlToXhtml.self/xsl:template[@name = 'cxsltl:xmlToXhtml.callback.pseudoAttribute.xmlModel']"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="name() = 'xml-stylesheet'">
									<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
										<xsl:with-param name="callback" select="$cxsltl:xmlToXhtml.self/xsl:template[@name = 'cxsltl:xmlToXhtml.callback.pseudoAttribute.xmlStylesheet']"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text> </xsl:text>

									<xsl:call-template name="cxsltl:xml.generate.escape"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">piEnd</xsl:with-param>
					<xsl:with-param name="content">?&amp;gt;</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>属性の文字列を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="属性名"/>
		<xsltdoc:paramString xsltdoc:name="nameHref" xsltdoc:short="属性名のリンクURI"/>
		<xsltdoc:paramString xsltdoc:name="nameAttribute" xsltdoc:short="属性名の属性"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="属性値"/>
		<xsltdoc:paramString xsltdoc:name="valueHref" xsltdoc:short="属性値のリンクURI"/>
		<xsltdoc:paramString xsltdoc:name="valueAttribute" xsltdoc:short="属性値の属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="属性のid属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="属性のtitle属性"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換した属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.attribute">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="nameHref"/>
		<xsl:param name="nameAttribute"/>
		<xsl:param name="value" select="."/>
		<xsl:param name="valueHref"/>
		<xsl:param name="valueAttribute"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>

		<xsl:variable name="escaped">
			<xsl:call-template name="cxsltl:string.multipleReplace">
				<xsl:with-param name="node" select="$cxsltl:xmlToXhtml.replace.entity"/>
				<xsl:with-param name="string">
					<xsl:call-template name="cxsltl:xml.generate.escape">
						<xsl:with-param name="string" select="$value"/>
						<xsl:with-param name="quotEscape" select="true()"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:text> </xsl:text>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">attribute</xsl:with-param>
			<xsl:with-param name="id" select="$id"/>
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="content">
				<xsl:choose>
					<xsl:when test="string($nameHref)">
						<xsl:call-template name="cxsltl:xmlToXhtml.element.a">
							<xsl:with-param name="href" select="$nameHref"/>
							<xsl:with-param name="class">attributeName</xsl:with-param>
							<xsl:with-param name="attribute" select="$nameAttribute"/>
							<xsl:with-param name="content" select="$name"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
							<xsl:with-param name="class">attributeName</xsl:with-param>
							<xsl:with-param name="attribute" select="$nameAttribute"/>
							<xsl:with-param name="content" select="$name"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:text>="</xsl:text>

				<xsl:choose>
					<xsl:when test="string($valueHref)">
						<xsl:call-template name="cxsltl:xmlToXhtml.element.a">
							<xsl:with-param name="href" select="$valueHref"/>
							<xsl:with-param name="class">attributeValue</xsl:with-param>
							<xsl:with-param name="attribute" select="$valueAttribute"/>
							<xsl:with-param name="content" select="$escaped"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
							<xsl:with-param name="class">attributeValue</xsl:with-param>
							<xsl:with-param name="attribute" select="$valueAttribute"/>
							<xsl:with-param name="content" select="$escaped"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:text>"</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>DTDを生成する</xsltdoc:short>
		<xsltdoc:paramBooleanString xsltdoc:name="publicId" xsltdoc:short="公開識別子"/>
		<xsltdoc:paramBooleanString xsltdoc:name="systemId" xsltdoc:short="システム識別子"/>
		<xsltdoc:paramBooleanString xsltdoc:name="markupDeclaration" xsltdoc:short="マークアップ宣言"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換したDTD"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.dtd">
		<xsl:param name="publicId" select="$cxsltl:xmlToXhtml.publicId"/>
		<xsl:param name="systemId" select="$cxsltl:xmlToXhtml.systemId"/>
		<xsl:param name="markupDeclaration" select="$cxsltl:xmlToXhtml.markupDeclaration"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:variable name="fragment.dtd">
			<xsl:if test="string($idPrefix)">
				<xsl:value-of select="concat($idPrefix, 'dtd')"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">dtd</xsl:with-param>
			<xsl:with-param name="title">Document Type Definition</xsl:with-param>
			<xsl:with-param name="id" select="$fragment.dtd"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">dtdStart</xsl:with-param>
					<xsl:with-param name="content">
						<xsl:text>&amp;lt;!</xsl:text>

						<xsl:call-template name="cxsltl:xmlToXhtml.element.fragmentlink">
							<xsl:with-param name="href" select="$fragment.dtd"/>
							<xsl:with-param name="content">DOCTYPE</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:text> </xsl:text>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">elementName</xsl:with-param>
					<xsl:with-param name="content" select="name(*)"/>
				</xsl:call-template>

				<xsl:if test="string($systemId)">
					<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
						<xsl:with-param name="class">externalId</xsl:with-param>
						<xsl:with-param name="content">
							<xsl:choose>
								<xsl:when test="string($publicId)">
									<xsl:text> PUBLIC "</xsl:text>

									<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
										<xsl:with-param name="class">publicId</xsl:with-param>
										<xsl:with-param name="title">Public Identifier</xsl:with-param>
										<xsl:with-param name="content" select="$publicId"/>
									</xsl:call-template>

									<xsl:text>" "</xsl:text>
								</xsl:when>
								<xsl:otherwise> SYSTEM "</xsl:otherwise>
							</xsl:choose>

							<xsl:call-template name="cxsltl:xmlToXhtml.element.a">
								<xsl:with-param name="href" select="$systemId"/>
								<xsl:with-param name="class">systemId</xsl:with-param>
								<xsl:with-param name="title">System Identifier</xsl:with-param>
								<xsl:with-param name="content" select="$systemId"/>
							</xsl:call-template>

							<xsl:text>"</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="string($markupDeclaration)">
					<xsl:text> [&#xA;</xsl:text>

					<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
						<xsl:with-param name="class">markupDeclaration</xsl:with-param>
						<xsl:with-param name="title">Markup Declaration</xsl:with-param>
						<xsl:with-param name="content" select="$markupDeclaration"/>
						<xsl:with-param name="escape" select="true()"/>
					</xsl:call-template>

					<xsl:text>&#xA;]</xsl:text>
				</xsl:if>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">dtdEnd</xsl:with-param>
					<xsl:with-param name="content">&amp;gt;</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>a要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="href" xsltdoc:short="href属性"/>
		<xsltdoc:paramString xsltdoc:name="hreflang" xsltdoc:short="hreflang属性"/>
		<xsltdoc:paramString xsltdoc:name="class" xsltdoc:short="class属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="id属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="title属性"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:returnString xsltdoc:short="a要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.element.a">
		<xsl:param name="href"/>
		<xsl:param name="hreflang"/>
		<xsl:param name="class"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>
		<xsl:param name="attribute"/>
		<xsl:param name="content" select="."/>
		<xsl:param name="escape" select="false()"/>

		<xsl:call-template name="cxsltl:xml.generate.element">
			<xsl:with-param name="name">a</xsl:with-param>
			<xsl:with-param name="attribute">
				<xsl:if test="string($href)">
					<xsl:call-template name="cxsltl:xml.generate.attribute">
						<xsl:with-param name="name">href</xsl:with-param>
						<xsl:with-param name="value" select="$href"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="string($hreflang)">
					<xsl:call-template name="cxsltl:xml.generate.attribute">
						<xsl:with-param name="name">hreflang</xsl:with-param>
						<xsl:with-param name="value" select="$hreflang"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:call-template name="cxsltl:xmlToXhtml.globalAttribute">
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="attribute" select="$attribute"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="escape" select="$escape"/>
			<xsl:with-param name="endTag" select="true()"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>a要素(内部リンク)またはspan要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="href" xsltdoc:short="href属性"/>
		<xsltdoc:paramString xsltdoc:name="hreflang" xsltdoc:short="hreflang属性"/>
		<xsltdoc:paramString xsltdoc:name="class" xsltdoc:short="class属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="id属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="title属性"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:returnString xsltdoc:short="a要素またはspan要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.element.fragmentlink">
		<xsl:param name="href"/>
		<xsl:param name="hreflang"/>
		<xsl:param name="class"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>
		<xsl:param name="attribute"/>
		<xsl:param name="content" select="."/>
		<xsl:param name="escape" select="false()"/>

		<xsl:choose>
			<xsl:when test="string($href)">
				<xsl:call-template name="cxsltl:xmlToXhtml.element.a">
					<xsl:with-param name="href" select="concat('#', $href)"/>
					<xsl:with-param name="hreflang" select="$hreflang"/>
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="attribute" select="$attribute"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="escape" select="$escape"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="attribute" select="$attribute"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="escape" select="$escape"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>span要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="class" xsltdoc:short="class属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="id属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="title属性"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:returnString xsltdoc:short="span要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.element.span">
		<xsl:param name="class"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>
		<xsl:param name="attribute"/>
		<xsl:param name="content" select="."/>
		<xsl:param name="escape" select="false()"/>

		<xsl:call-template name="cxsltl:xml.generate.element">
			<xsl:with-param name="name">span</xsl:with-param>
			<xsl:with-param name="attribute">
				<xsl:call-template name="cxsltl:xmlToXhtml.globalAttribute">
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="attribute" select="$attribute"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="escape" select="$escape"/>
			<xsl:with-param name="endTag" select="true()"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>任意のノードセットをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="変換対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:paramString xsltdoc:name="version" xsltdoc:short="XMLのバージョン情報"/>
		<xsltdoc:paramString xsltdoc:name="encoding" xsltdoc:short="符号化宣言"/>
		<xsltdoc:paramString xsltdoc:name="standalone" xsltdoc:short="スタンドアローン宣言"/>
		<xsltdoc:paramString xsltdoc:name="publicId" xsltdoc:short="DTDの公開識別子"/>
		<xsltdoc:paramString xsltdoc:name="systemId" xsltdoc:short="DTDのシステム識別子"/>
		<xsltdoc:paramString xsltdoc:name="markupDeclaration" xsltdoc:short="マークアップ宣言"/>
		<xsltdoc:paramBooleanNumber xsltdoc:name="start" xsltdoc:short="行番号の最初の値"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換したノード"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToXhtml.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>
		<xsl:param name="version" select="$cxsltl:xmlToXhtml.version"/>
		<xsl:param name="encoding" select="$cxsltl:xmlToXhtml.encoding"/>
		<xsl:param name="standalone" select="$cxsltl:xmlToXhtml.standalone"/>
		<xsl:param name="publicId" select="$cxsltl:xmlToXhtml.publicId"/>
		<xsl:param name="systemId" select="$cxsltl:xmlToXhtml.systemId"/>
		<xsl:param name="markupDeclaration" select="$cxsltl:xmlToXhtml.markupDeclaration"/>
		<xsl:param name="start" select="$cxsltl:xmlToXhtml.start"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:string.replace">
				<xsl:with-param name="string">
					<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToXhtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="cdata" select="$cdata"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
						<xsl:with-param name="version" select="$version"/>
						<xsl:with-param name="encoding" select="$encoding"/>
						<xsl:with-param name="standalone" select="$standalone"/>
						<xsl:with-param name="publicId" select="$publicId"/>
						<xsl:with-param name="systemId" select="$systemId"/>
						<xsl:with-param name="markupDeclaration" select="$markupDeclaration"/>
					</xsl:apply-templates>
				</xsl:with-param>
				<xsl:with-param name="src" select="'&#x9;'"/>
				<xsl:with-param name="dst">
					<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
						<xsl:with-param name="class">tab</xsl:with-param>
						<xsl:with-param name="content" select="'&#x9;'"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$start &lt; 0">
				<xsl:value-of select="$result"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:line.split">
					<xsl:with-param name="callback" select="$cxsltl:xmlToXhtml.self/xsl:template[@name = 'cxsltl:xmlToXhtml.callback.line.split']"/>
					<xsl:with-param name="string" select="$result"/>
					<xsl:with-param name="param1" select="$start - 1"/>
					<xsl:with-param name="param2" select="$idPrefix"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>グローバル属性を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="class" xsltdoc:short="class属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="id属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="title属性"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="属性"/>
		<xsltdoc:returnString xsltdoc:short="グローバル属性"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.globalAttribute">
		<xsl:param name="class"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>
		<xsl:param name="attribute"/>

		<xsl:if test="string($class)">
			<xsl:call-template name="cxsltl:xml.generate.attribute">
				<xsl:with-param name="name">class</xsl:with-param>
				<xsl:with-param name="value" select="$class"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="string($id)">
			<xsl:call-template name="cxsltl:xml.generate.attribute">
				<xsl:with-param name="name">id</xsl:with-param>
				<xsl:with-param name="value" select="$id"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="string($title)">
			<xsl:call-template name="cxsltl:xml.generate.attribute">
				<xsl:with-param name="name">title</xsl:with-param>
				<xsl:with-param name="value" select="$title"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="string($attribute)">
			<xsl:text> </xsl:text>

			<xsl:call-template name="cxsltl:string.leftTrim">
				<xsl:with-param name="string" select="$attribute"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>名前空間ノードをXHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="element" xsltdoc:short="対象とする要素ノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="名前空間属性"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.namespaceAttribute">
		<xsl:param name="element" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToXhtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:for-each select="$element/namespace::*[count(. | $deny) != $denyCount][not(starts-with(translate(name(), 'XML', 'xml'), 'xml'))]">
			<xsl:if test="not(. = parent::*/parent::*/namespace::*[count(. | $deny) != $denyCount][name() = name(current())])">
				<xsl:variable name="xpath">
					<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
						<xsl:with-param name="deny" select="$deny"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="xpathEncoded">
					<xsl:call-template name="cxsltl:xmlToXhtml.xpathToFragment">
						<xsl:with-param name="xpath" select="$xpath"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
					<xsl:with-param name="name">
						<xsl:text>xmlns</xsl:text>

						<xsl:if test="name()">
							<xsl:value-of select="concat(':', name())"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="value" select="normalize-space()"/>
					<xsl:with-param name="nameHref">
						<xsl:if test="string($xpathEncoded)">
							<xsl:value-of select="concat('#', $xpathEncoded)"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="valueHref" select="normalize-space()"/>
					<xsl:with-param name="id" select="$xpathEncoded"/>
					<xsl:with-param name="title" select="$xpath"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="$element/parent::*/namespace::*[count(. | $deny) != $denyCount]">
			<xsl:if test="not($element/namespace::*[name() = name(current())])">
				<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
					<xsl:with-param name="name">
						<xsl:text>xmlns</xsl:text>

						<xsl:if test="name()">
							<xsl:value-of select="concat(':', name())"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="value"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>シンタックスハイライトのスタイル</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="スタイル要素"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.style">
		<style type="text/css">
			.xmlToXhtml {
				background: #FFFFFF;
				color: #000000;
				font-family: monospace;
				counter-reset: xmlToXhtml-line 0;
			}

			.xmlToXhtml * {
				font-family: monospace;
			}

			.xmlToXhtml a {
				color: inherit;
				text-decoration: none;
			}

			.xmlToXhtml .xmlDeclaration {
				color: #FF0000;
			}

			.xmlToXhtml .dtd {
				color: #FF33FF;
				font-style: italic;
			}

			.xmlToXhtml .root {
			}

			.xmlToXhtml .element {
			}

			.xmlToXhtml .element .elementName {
				color: #000080;
				font-weight: bold;
			}

			.xmlToXhtml .attribute {
			}

			.xmlToXhtml .attributeName {
				color: #0000FF;
			}

			.xmlToXhtml .attributeValue {
				color: #008000;
			}

			.xmlToXhtml .text {
			}

			.xmlToXhtml .comment {
				color: #808080;
			}

			.xmlToXhtml .commentValue {
				font-style: italic;
			}

			.xmlToXhtml .pi {
				color: #FF0000;
			}

			.xmlToXhtml .piName {
				font-weight: bold;
			}

			.xmlToXhtml .piValue {
			}

			.xmlToXhtml .cdata {
				color: #800080;
			}

			.xmlToXhtml *:target {
				background: #FFFF00;
			}

			.xmlToXhtml .line {
				margin-right: 0.5em;
				color: #000000;
				counter-increment: xmlToXhtml-line;
			}

			.xmlToXhtml .line:after {
				display: inline-block;
				width: 2em;
				text-align: right;
				content: counter(xmlToXhtml-line);
			}

			.xmlToXhtml *:target .line {
				background: #FFFFFF;
			}

			.xmlToXhtml .eol:before {
				content: "⏎";
				color: #F0F0F0;
			}

			@media print {
				.xmlToXhtml {
					white-space: pre-wrap;
				}
			}
		</style>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XML宣言を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="version" xsltdoc:short="XMLのバージョン情報"/>
		<xsltdoc:paramString xsltdoc:name="encoding" xsltdoc:short="符号化宣言"/>
		<xsltdoc:paramString xsltdoc:name="standalone" xsltdoc:short="スタンドアローン宣言"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換したXML宣言"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.xmlDeclaration">
		<xsl:param name="version" select="$cxsltl:xmlToXhtml.version"/>
		<xsl:param name="encoding" select="$cxsltl:xmlToXhtml.encoding"/>
		<xsl:param name="standalone" select="$cxsltl:xmlToXhtml.standalone"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:variable name="fragment">
			<xsl:if test="string($idPrefix)">
				<xsl:value-of select="concat($idPrefix, 'xmlDeclaration')"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
			<xsl:with-param name="class">pi xmlDeclaration</xsl:with-param>
			<xsl:with-param name="title">XML Declaration</xsl:with-param>
			<xsl:with-param name="id" select="$fragment"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">piStart</xsl:with-param>
					<xsl:with-param name="content">&amp;lt;?</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.fragmentlink">
					<xsl:with-param name="href" select="$fragment"/>
					<xsl:with-param name="class">piName</xsl:with-param>
					<xsl:with-param name="content">xml</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
					<xsl:with-param name="name">version</xsl:with-param>
					<xsl:with-param name="nameHref">http://www.w3.org/TR/xml/#sec-prolog-dtd</xsl:with-param>
					<xsl:with-param name="nameAttribute">title="version pseudo-attribute"</xsl:with-param>
					<xsl:with-param name="value" select="$version"/>
				</xsl:call-template>

				<xsl:if test="string($encoding)">
					<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
						<xsl:with-param name="name">encoding</xsl:with-param>
						<xsl:with-param name="nameHref">http://www.w3.org/TR/xml/#charencoding</xsl:with-param>
						<xsl:with-param name="nameAttribute">title="encoding pseudo-attribute"</xsl:with-param>
						<xsl:with-param name="value" select="$encoding"/>
						<xsl:with-param name="valueHref">https://www.iana.org/assignments/character-sets/character-sets.xhtml</xsl:with-param>
						<xsl:with-param name="valueAttribute">hreflang="en" title="Character Sets"</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="string($standalone)">
					<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
						<xsl:with-param name="name">standalone</xsl:with-param>
						<xsl:with-param name="nameAttribute">title="standalone pseudo-attribute"</xsl:with-param>
						<xsl:with-param name="nameHref">http://www.w3.org/TR/xml/#sec-rmd</xsl:with-param>
						<xsl:with-param name="value" select="$standalone"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:call-template name="cxsltl:xmlToXhtml.element.span">
					<xsl:with-param name="class">piEnd</xsl:with-param>
					<xsl:with-param name="content">?&amp;gt;</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XPathをXML-Nameに変換する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="xpath" xsltdoc:short="XPath"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="XML-Nameを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToXhtml.xpathToFragment">
		<xsl:param name="xpath"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToXhtml.idPrefix"/>

		<xsl:if test="string($idPrefix)">
			<xsl:value-of select="$idPrefix"/>

			<xsl:call-template name="cxsltl:string.multipleReplace">
				<xsl:with-param name="node" select="$cxsltl:xmlToXhtml.replace.xpath"/>
				<xsl:with-param name="string" select="$xpath"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- ==============================
		# Callback Template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>oasis-xml-catalogの擬似属性を受け取りXHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xml.generate.pseudoAttributeにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="擬似属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="擬似属性値"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToXhtml.callback.pseudoAttribute.oasisXmlCatalog']" mode="cxsltl:callback" name="cxsltl:xmlToXhtml.callback.pseudoAttribute.oasisXmlCatalog">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="nameHref">
				<xsl:if test="$name = 'catalog'">https://www.oasis-open.org/committees/download.php/14809/xml-catalogs.html#oasis-er-tc-abc</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="nameAttribute">
				<xsl:if test="$name = 'catalog'">hreflang="en" title="XML Catalogs"</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="valueHref">
				<xsl:if test="$name = 'catalog'">
					<xsl:value-of select="$value"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>xml-modelの疑似属性を受け取りXHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xml.generate.pseudoAttributeにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="擬似属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="擬似属性値"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToXhtml.callback.pseudoAttribute.xmlModel']" mode="cxsltl:callback" name="cxsltl:xmlToXhtml.callback.pseudoAttribute.xmlModel">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="nameHref" select="concat('http://www.w3.org/TR/xml-model/#PA-', $name)"/>
			<xsl:with-param name="nameAttribute">
				<xsl:text>hreflang="en"</xsl:text>

				<xsl:call-template name="cxsltl:xml.generate.attribute">
					<xsl:with-param name="name">title</xsl:with-param>
					<xsl:with-param name="value" select="concat($name, ' pseudo-attribute')"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="valueHref">
				<xsl:choose>
					<xsl:when test="$name = 'charset'">https://www.iana.org/assignments/character-sets/character-sets.xhtml</xsl:when>
					<xsl:when test="$name = 'href' or $name = 'schematypens'">
						<xsl:value-of select="$value"/>
					</xsl:when>
					<xsl:when test="$name = 'type'">https://www.iana.org/assignments/media-types/media-types.xhtml</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="valueAttribute">
				<xsl:choose>
					<xsl:when test="$name = 'charset'">hreflang="en" title="Character Sets"</xsl:when>
					<xsl:when test="$name = 'type'">hreflang="en" title="Media Types"</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>xml-stylesheetの疑似属性を受け取りXHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xml.generate.pseudoAttributeにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="擬似属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="擬似属性値"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToXhtml.callback.pseudoAttribute.xmlStylesheet']" mode="cxsltl:callback" name="cxsltl:xmlToXhtml.callback.pseudoAttribute.xmlStylesheet">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:call-template name="cxsltl:xmlToXhtml.attribute">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="nameHref" select="concat('http://www.w3.org/TR/xml-stylesheet/#PA-', $name)"/>
			<xsl:with-param name="nameAttribute">
				<xsl:text>hreflang="en"</xsl:text>

				<xsl:call-template name="cxsltl:xml.generate.attribute">
					<xsl:with-param name="name">title</xsl:with-param>
					<xsl:with-param name="value" select="concat($name, ' pseudo-attribute')"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="valueHref">
				<xsl:choose>
					<xsl:when test="$name = 'charset'">https://www.iana.org/assignments/character-sets/character-sets.xhtml</xsl:when>
					<xsl:when test="$name = 'href'">
						<xsl:value-of select="$value"/>
					</xsl:when>
					<xsl:when test="$name = 'media'">http://www.w3.org/TR/css3-mediaqueries/</xsl:when>
					<xsl:when test="$name = 'type'">https://www.iana.org/assignments/media-types/media-types.xhtml</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="valueAttribute">
				<xsl:choose>
					<xsl:when test="$name = 'charset'">hreflang="en" title="Character Sets"</xsl:when>
					<xsl:when test="$name = 'media'">hreflang="en" title="Media Queries"</xsl:when>
					<xsl:when test="$name = 'type'">hreflang="en" title="Media Types"</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>分割した行の文字列を受け取り、行番号付き文字列を出力する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="分割した文字列"/>
		<xsltdoc:detail>cxsltl:line.splitにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="分割した文字列の位置"/>
		<xsltdoc:paramNumber xsltdoc:name="count" xsltdoc:short="分割した文字列の総数"/>
		<xsltdoc:paramNumber xsltdoc:name="param1" xsltdoc:short="行番号の最初の値の-1"/>
		<xsltdoc:paramString xsltdoc:name="param2" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="行番号加えたXHTML文字列"/>
		<xsltdoc:private/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToXhtml.callback.line.split']" mode="cxsltl:callback" name="cxsltl:xmlToXhtml.callback.line.split">
		<xsl:param name="string"/>
		<xsl:param name="position"/>
		<xsl:param name="count"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>

		<xsl:variable name="fragment.line">
			<xsl:if test="string($param2)">
				<xsl:value-of select="concat($param2, 'line', $position + $param1)"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToXhtml.element.fragmentlink">
			<xsl:with-param name="href" select="$fragment.line"/>
			<xsl:with-param name="class">line</xsl:with-param>
			<xsl:with-param name="id" select="$fragment.line"/>
			<xsl:with-param name="attribute">lang=""</xsl:with-param>
			<xsl:with-param name="content"/>
		</xsl:call-template>

		<xsl:value-of select="$string"/>

		<xsl:if test="$position != $count">
			<xsl:variable name="fragment.eol">
				<xsl:if test="string($param2)">
					<xsl:value-of select="concat($param2, 'eol', $position + $param1)"/>
				</xsl:if>
			</xsl:variable>

			<xsl:call-template name="cxsltl:xmlToXhtml.element.fragmentlink">
				<xsl:with-param name="href" select="$fragment.eol"/>
				<xsl:with-param name="class">eol</xsl:with-param>
				<xsl:with-param name="id" select="$fragment.eol"/>
				<xsl:with-param name="content" select="'&#xA;'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>