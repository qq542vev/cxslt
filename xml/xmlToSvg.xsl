<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="SVG" href="xmlToSvg.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToSvg.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns="http://www.w3.org/2000/svg"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/common.xsl"/>
	<xsl:import href="../library/line.xsl"/>
	<xsl:import href="../library/string.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>
	<xsl:import href="../library/xml/parse.xsl"/>
	<xsl:import href="../library/xpath/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルをSVGに変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードをSVGに変換する。
			{xsl:import}, {xsl:include}を使用し外部のスタイルシートとして使用することも出来る。
		</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>aノード以下をSVGに変換する例</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:xmlToSvg.convert">
						<xsl:with-param name="node" select="/a/node()"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-05-08</xsltdoc:version>
		<xsltdoc:since>2013-08-25</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/SVG11/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="no"
		media-type="image/svg+xml"
	/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToSvg.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToSvg.deny" select="/.."/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCDATAセクションとするテキストノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToSvg.cdata" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのid属性の接頭辞</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.idPrefix">xml-</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのXMLのバージョン</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.version">1.0</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのXMLの符号化情報</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.encoding">UTF-8</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのXMLのスタンドアローン文書宣言</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.standalone"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDTDの公開識別子</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.publicId"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDTDのシステム識別子</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.systemId"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDTDのマークアップ宣言</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.markupDeclaration"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでの行番号の形式</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSvg.format">rn</xsl:param>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでの行番号の初期値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToSvg.start" select="1"/>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでの行番号の加算値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToSvg.increment" select="1"/>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでの行の高さ</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToSvg.height" select="1.3"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>XPathをXML Nameに変換する要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToSvg.replace.xpath" select="$cxsltl:xmlToSvg.self/cxsltl:string.search[@xml:id = 'cxsltl.xmlToSvg.replace.xpath']/cxsltl:string.replace"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>entityをtspan要素のentityに変換する要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToSvg.replace.entity" select="$cxsltl:xmlToSvg.self/cxsltl:string.search[@xml:id = 'cxsltl.xmlToSvg.replace.entity']/cxsltl:string.replace"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>タブと改行をtspan要素のタブと改行に変換する要素</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToSvg.replace.space" select="$cxsltl:xmlToSvg.self/cxsltl:string.search[@xml:id = 'cxsltl.xmlToSvg.replace.whiteSpace']/cxsltl:string.replace"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.xmlToSvg.replace.xpath">
		<xsltdoc:short>XPathをXML Nameに変換する要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.xmlToSvg.replace.xpath">
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

	<xsltdoc:Element rdf:about="#cxsltl.xmlToSvg.replace.entity">
		<xsltdoc:short>entityをtspan要素のentityに変換する要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.xmlToSvg.replace.entity">
		<cxsltl:string.replace src="&amp;amp;" dst="&lt;tspan class=&quot;entity amp&quot;&gt;&amp;amp;amp;&lt;/tspan&gt;"/>
		<cxsltl:string.replace src="&amp;lt;" dst="&lt;tspan class=&quot;entity lt&quot;&gt;&amp;amp;lt;&lt;/tspan&gt;"/>
		<cxsltl:string.replace src="&amp;gt;" dst="&lt;tspan class=&quot;entity gt&quot;&gt;&amp;amp;gt;&lt;/tspan&gt;"/>
		<cxsltl:string.replace src="&amp;quot;" dst="&lt;tspan class=&quot;entity quot&quot;&gt;&amp;amp;quot;&lt;/tspan&gt;"/>
	</cxsltl:string.search>

	<xsltdoc:Element rdf:about="#cxsltl.xmlToSvg.replace.whiteSpace">
		<xsltdoc:short>タブと改行をtspan要素のタブと改行に変換する要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.xmlToSvg.replace.whiteSpace">
		<cxsltl:string.replace src="&#x9;" dst="&lt;tspan class=&quot;tab&quot;&gt;&#x9;&lt;/tspan&gt;"/>
		<cxsltl:string.replace src="&#xA;" dst="&lt;tspan class=&quot;eol&quot; x=&quot;0&quot; dy=&quot;1.3em&quot; &gt;&lt;tspan&gt;&#xA;&lt;/tspan&gt;&lt;/tspan&gt;"/>
	</cxsltl:string.search>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードをSVGに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			SVGへの変換はxsl:call-templateを使用しcxsltl:xmlToSvg.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="SVGに変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xmlToSvg.convert"/>
		</xsl:variable>

		<xsl:variable name="lineCount">
			<xsl:call-template name="cxsltl:line.count">
				<xsl:with-param name="string" select="$result"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="lineNumber">
			<xsl:call-template name="cxsltl:xmlToSvg.lineNumber">
				<xsl:with-param name="string" select="$result"/>
				<xsl:with-param name="count" select="$lineCount"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">]]></xsl:text>

		<svg version="1.1">
			<title xml:lang="en">XML Source Code</title>

			<desc xml:lang="en">Generate of <xsl:value-of select="system-property('xsl:vendor')"/> - <xsl:value-of select="system-property('xsl:vendor-url')"/></desc>

			<xsl:call-template name="cxsltl:xmlToSvg.style"/>

			<xsl:value-of disable-output-escaping="yes" select="$lineNumber"/>

			<svg version="1.1">
				<xsl:if test="0 &lt;= $cxsltl:xmlToSvg.start">
					<xsl:attribute name="x">
						<xsl:value-of select="concat(string-length($cxsltl:xmlToSvg.start - 1 + ($lineCount * $cxsltl:xmlToSvg.increment)) * 0.75, 'em')"/>
					</xsl:attribute>
				</xsl:if>

				<text class="xmlToSvg">
					<xsl:attribute name="y">
						<xsl:value-of select="concat($cxsltl:xmlToSvg.height, 'em')"/>
					</xsl:attribute>
					<xsl:attribute name="xml:space">preserve</xsl:attribute>

					<xsl:value-of disable-output-escaping="yes" select="$result"/>
				</text>
			</svg>
		</svg>
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
		<xsltdoc:returnString xsltdoc:short="SVGに変換したノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/" mode="cxsltl:xmlToSvg.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToSvg.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>
		<xsl:param name="version" select="$cxsltl:xmlToSvg.version"/>
		<xsl:param name="encoding" select="$cxsltl:xmlToSvg.encoding"/>
		<xsl:param name="standalone" select="$cxsltl:xmlToSvg.standalone"/>
		<xsl:param name="publicId" select="$cxsltl:xmlToSvg.publicId"/>
		<xsl:param name="systemId" select="$cxsltl:xmlToSvg.systemId"/>
		<xsl:param name="markupDeclaration" select="$cxsltl:xmlToSvg.markupDeclaration"/>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
			<xsl:with-param name="class">root</xsl:with-param>
			<xsl:with-param name="id">
				<xsl:if test="string($idPrefix)">
					<xsl:value-of select="concat($idPrefix, '.2F')"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="title">/</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:if test="string($version)">
					<xsl:call-template name="cxsltl:xmlToSvg.xmlDeclaration">
						<xsl:with-param name="version" select="$version"/>
						<xsl:with-param name="encoding" select="$encoding"/>
						<xsl:with-param name="standalone" select="$standalone"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:call-template>

					<xsl:text>&#xA;</xsl:text>
				</xsl:if>

				<xsl:for-each select="*/preceding-sibling::node()[count(. | $deny) != $denyCount]">
					<xsl:apply-templates select="self::node()" mode="cxsltl:xmlToSvg.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
						<xsl:with-param name="cdata" select="$cdata"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:apply-templates>

					<xsl:text>&#xA;</xsl:text>
				</xsl:for-each>

				<xsl:if test="string($systemId) or string($markupDeclaration)">
					<xsl:call-template name="cxsltl:xmlToSvg.dtd">
						<xsl:with-param name="publicId" select="$publicId"/>
						<xsl:with-param name="systemId" select="$systemId"/>
						<xsl:with-param name="markupDeclaration" select="$markupDeclaration"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:call-template>

					<xsl:text>&#xA;</xsl:text>
				</xsl:if>

				<xsl:for-each select="*[count(. | $deny) != $denyCount] | */following-sibling::node()[count(. | $deny) != $denyCount]">
					<xsl:apply-templates select="self::node()" mode="cxsltl:xmlToSvg.converter">
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
		<xsltdoc:short>要素ノードをSVGに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換した要素ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*" mode="cxsltl:xmlToSvg.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToSvg.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToSvg.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="elementName">
			<xsl:call-template name="cxsltl:xmlToSvg.element.fragmentlink">
				<xsl:with-param name="href" select="$xpathEncoded"/>
				<xsl:with-param name="class">elementName</xsl:with-param>
				<xsl:with-param name="content">
					<xsl:if test="namespace-uri()">
						<xsl:call-template name="cxsltl:xmlToSvg.element.title">
							<xsl:with-param name="content" select="concat('{', namespace-uri(), '}', local-name())"/>
						</xsl:call-template>
					</xsl:if>

					<xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
			<xsl:with-param name="class">
				<xsl:text>element</xsl:text>

				<xsl:if test="not(node()[count(. | $deny) != $denyCount])"> empty</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">elementStart</xsl:with-param>
					<xsl:with-param name="content">
						<xsl:text>&amp;lt;</xsl:text>

						<xsl:value-of select="$elementName"/>

						<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToSvg.converter">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
							<xsl:with-param name="cdata" select="$cdata"/>
							<xsl:with-param name="idPrefix" select="$idPrefix"/>
						</xsl:apply-templates>

						<xsl:call-template name="cxsltl:xmlToSvg.namespaceAttribute">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
							<xsl:with-param name="cdata" select="$cdata"/>
							<xsl:with-param name="idPrefix" select="$idPrefix"/>
						</xsl:call-template>

						<xsl:if test="not(node()[count(. | $deny) != $denyCount])">/</xsl:if>

						<xsl:text>&amp;gt;</xsl:text>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:if test="node()[count(. | $deny) != $denyCount]">
					<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
						<xsl:with-param name="class">elementValue</xsl:with-param>
						<xsl:with-param name="id">
							<xsl:if test="string($idPrefix)">
								<xsl:value-of select="concat($xpathEncoded, '.2Fnode.28.29')"/>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="title" select="concat($xpath, '/node()')"/>
						<xsl:with-param name="content">
							<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToSvg.converter">
								<xsl:with-param name="deny" select="$deny"/>
								<xsl:with-param name="denyCount" select="$denyCount"/>
								<xsl:with-param name="cdata" select="$cdata"/>
								<xsl:with-param name="idPrefix" select="$idPrefix"/>
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
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
		<xsltdoc:short>属性ノードをSVGに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換した属性ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@*" mode="cxsltl:xmlToSvg.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToSvg.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToSvg.attribute">
			<xsl:with-param name="nameHref">
				<xsl:if test="string($xpathEncoded)">
					<xsl:value-of select="concat('#', $xpathEncoded)"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="nameTitle">
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
			<xsl:with-param name="valueTitle">
				<xsl:if test="namespace-uri() = 'http://www.w3.org/XML/1998/namespace' and local-name() = 'lang'">IETF language tag</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="valueAttribute">
				<xsl:if test="namespace-uri() != 'http://www.w3.org/XML/1998/namespace' and ancestor::*/@xml:lang">
					<xsl:call-template name="cxsltl:xml.generate.attribute">
						<xsl:with-param name="name">xml:lang</xsl:with-param>
						<xsl:with-param name="value" select="ancestor::*/@xml:lang"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードをSVGに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換したテキストノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text()" mode="cxsltl:xmlToSvg.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToSvg.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:value-of select="$idPrefix"/>

			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToSvg.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="cdataCheck" select="$cdata[count(. | current()) = 1] and not(contains(., ']]&gt;'))"/>

		<xsl:variable name="lang">
			<xsl:if test="ancestor::*/@xml:lang">
				<xsl:call-template name="cxsltl:xml.generate.attribute">
					<xsl:with-param name="name">xml:lang</xsl:with-param>
					<xsl:with-param name="value" select="ancestor::*/@xml:lang"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
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
						<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
							<xsl:with-param name="class">cdataStart</xsl:with-param>
							<xsl:with-param name="content">
								<xsl:text>&amp;lt;![</xsl:text>

								<xsl:call-template name="cxsltl:xmlToSvg.element.a">
									<xsl:with-param name="href">http://www.w3.org/TR/xml/#sec-cdata-sect</xsl:with-param>
									<xsl:with-param name="title">CDATA Sections</xsl:with-param>
									<xsl:with-param name="content">CDATA</xsl:with-param>
								</xsl:call-template>

								<xsl:text>[</xsl:text>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
							<xsl:with-param name="class">cdataValue</xsl:with-param>
							<xsl:with-param name="attribute">
								<xsl:if test="$cdataCheck and string($lang)">
									<xsl:value-of select="$lang"/>
								</xsl:if>
							</xsl:with-param>
							<xsl:with-param name="escape" select="true()"/>
						</xsl:call-template>

						<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
							<xsl:with-param name="class">cdataEnd</xsl:with-param>
							<xsl:with-param name="content">]]&amp;gt;</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cxsltl:string.multipleReplace">
							<xsl:with-param name="node" select="$cxsltl:xmlToSvg.replace.entity[position() != last()]"/>
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
		<xsltdoc:short>コメントノードをSVGに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換したコメントノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="comment()" mode="cxsltl:xmlToSvg.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToSvg.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
			<xsl:with-param name="class">comment</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">commentStart</xsl:with-param>
					<xsl:with-param name="content">&amp;lt;!--</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">commentValue</xsl:with-param>
					<xsl:with-param name="escape" select="true()"/>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">commentEnd</xsl:with-param>
					<xsl:with-param name="content">--&amp;gt;</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>処理命令ノードをSVGに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換した処理命令ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="processing-instruction()" mode="cxsltl:xmlToSvg.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:variable name="xpath">
			<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
				<xsl:with-param name="deny" select="$deny"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="xpathEncoded">
			<xsl:call-template name="cxsltl:xmlToSvg.xpathToFragment">
				<xsl:with-param name="xpath" select="$xpath"/>
				<xsl:with-param name="idPrefix" select="$idPrefix"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
			<xsl:with-param name="class">pi</xsl:with-param>
			<xsl:with-param name="id" select="$xpathEncoded"/>
			<xsl:with-param name="title" select="$xpath"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">piStart</xsl:with-param>
					<xsl:with-param name="content">&amp;lt;?</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToSvg.element.fragmentlink">
					<xsl:with-param name="href" select="$xpathEncoded"/>
					<xsl:with-param name="class">piName</xsl:with-param>
					<xsl:with-param name="content" select="name()"/>
				</xsl:call-template>

				<xsl:if test="string()">
					<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
						<xsl:with-param name="class">piValue</xsl:with-param>
						<xsl:with-param name="content">
							<xsl:choose>
								<xsl:when test="name() = 'oasis-xml-catalog'">
									<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
										<xsl:with-param name="callback" select="$cxsltl:xmlToSvg.self/xsl:template[@name = 'cxsltl:xmlToSvg.callback.pseudoAttribute.oasisXmlCatalog']"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="name() = 'xml-model'">
									<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
										<xsl:with-param name="callback" select="$cxsltl:xmlToSvg.self/xsl:template[@name = 'cxsltl:xmlToSvg.callback.pseudoAttribute.xmlModel']"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="name() = 'xml-stylesheet'">
									<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
										<xsl:with-param name="callback" select="$cxsltl:xmlToSvg.self/xsl:template[@name = 'cxsltl:xmlToSvg.callback.pseudoAttribute.xmlStylesheet']"/>
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

				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
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
		<xsltdoc:returnString xsltdoc:short="SVGに変換した属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.attribute">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="nameHref"/>
		<xsl:param name="nameTitle"/>
		<xsl:param name="nameAttribute"/>
		<xsl:param name="value" select="."/>
		<xsl:param name="valueHref"/>
		<xsl:param name="valueTitle"/>
		<xsl:param name="valueAttribute"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>

		<xsl:variable name="escaped">
			<xsl:choose>
				<xsl:when test="string($valueHref)">
					<xsl:call-template name="cxsltl:xml.generate.escape">
						<xsl:with-param name="node" select="$cxsltl:xmlToSvg.replace.entity"/>
						<xsl:with-param name="string">
							<xsl:call-template name="cxsltl:xml.generate.escape">
								<xsl:with-param name="string" select="$value"/>
								<xsl:with-param name="quotEscape" select="true()"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cxsltl:string.multipleReplace">
						<xsl:with-param name="node" select="$cxsltl:xmlToSvg.replace.entity"/>
						<xsl:with-param name="string">
							<xsl:call-template name="cxsltl:xml.generate.escape">
								<xsl:with-param name="string" select="$value"/>
								<xsl:with-param name="quotEscape" select="true()"/>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:text> </xsl:text>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
			<xsl:with-param name="class">attribute</xsl:with-param>
			<xsl:with-param name="id" select="$id"/>
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="content">
				<xsl:choose>
					<xsl:when test="string($nameHref)">
						<xsl:call-template name="cxsltl:xmlToSvg.element.a">
							<xsl:with-param name="href" select="$nameHref"/>
							<xsl:with-param name="class">attributeName</xsl:with-param>
							<xsl:with-param name="title" select="$nameTitle"/>
							<xsl:with-param name="attribute" select="$nameAttribute"/>
							<xsl:with-param name="content" select="$name"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
							<xsl:with-param name="class">attributeName</xsl:with-param>
							<xsl:with-param name="title" select="$nameTitle"/>
							<xsl:with-param name="attribute" select="$nameAttribute"/>
							<xsl:with-param name="content" select="$name"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:text>="</xsl:text>

				<xsl:choose>
					<xsl:when test="string($valueHref)">
						<xsl:call-template name="cxsltl:xmlToSvg.element.a">
							<xsl:with-param name="href" select="$valueHref"/>
							<xsl:with-param name="class">attributeValue</xsl:with-param>
							<xsl:with-param name="title" select="$valueTitle"/>
							<xsl:with-param name="attribute" select="$valueAttribute"/>
							<xsl:with-param name="content" select="$escaped"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
							<xsl:with-param name="class">attributeValue</xsl:with-param>
							<xsl:with-param name="title" select="$valueTitle"/>
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
		<xsltdoc:short>任意のノードセットをSVGに変換する</xsltdoc:short>
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
		<xsltdoc:returnString xsltdoc:short="SVGに変換したノード"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToSvg.cdata"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>
		<xsl:param name="version" select="$cxsltl:xmlToSvg.version"/>
		<xsl:param name="encoding" select="$cxsltl:xmlToSvg.encoding"/>
		<xsl:param name="standalone" select="$cxsltl:xmlToSvg.standalone"/>
		<xsl:param name="publicId" select="$cxsltl:xmlToSvg.publicId"/>
		<xsl:param name="systemId" select="$cxsltl:xmlToSvg.systemId"/>
		<xsl:param name="markupDeclaration" select="$cxsltl:xmlToSvg.markupDeclaration"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:string.multipleReplace">
			<xsl:with-param name="node" select="$cxsltl:xmlToSvg.replace.space"/>
			<xsl:with-param name="string">
				<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToSvg.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
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
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>DTDを生成する</xsltdoc:short>
		<xsltdoc:paramBooleanString xsltdoc:name="publicId" xsltdoc:short="公開識別子"/>
		<xsltdoc:paramBooleanString xsltdoc:name="systemId" xsltdoc:short="システム識別子"/>
		<xsltdoc:paramBooleanString xsltdoc:name="markupDeclaration" xsltdoc:short="マークアップ宣言"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換したDTD"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.dtd">
		<xsl:param name="publicId" select="$cxsltl:xmlToSvg.publicId"/>
		<xsl:param name="systemId" select="$cxsltl:xmlToSvg.systemId"/>
		<xsl:param name="markupDeclaration" select="$cxsltl:xmlToSvg.markupDeclaration"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:variable name="fragment.dtd">
			<xsl:if test="string($idPrefix)">
				<xsl:value-of select="concat($idPrefix, 'dtd')"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
			<xsl:with-param name="class">dtd</xsl:with-param>
			<xsl:with-param name="title">Document Type Definition</xsl:with-param>
			<xsl:with-param name="id" select="$fragment.dtd"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">dtdStart</xsl:with-param>
					<xsl:with-param name="content">
						<xsl:text>&amp;lt;!</xsl:text>

						<xsl:call-template name="cxsltl:xmlToSvg.element.fragmentlink">
							<xsl:with-param name="href" select="$fragment.dtd"/>
							<xsl:with-param name="content">DOCTYPE</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:text> </xsl:text>

				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">elementName</xsl:with-param>
					<xsl:with-param name="content" select="name(*)"/>
				</xsl:call-template>

				<xsl:if test="string($systemId)">
					<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
						<xsl:with-param name="class">externalId</xsl:with-param>
						<xsl:with-param name="content">
							<xsl:choose>
								<xsl:when test="string($publicId)">
									<xsl:text> PUBLIC "</xsl:text>

									<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
										<xsl:with-param name="class">publicId</xsl:with-param>
										<xsl:with-param name="title">Public Identifier</xsl:with-param>
										<xsl:with-param name="content" select="$publicId"/>
									</xsl:call-template>

									<xsl:text>" "</xsl:text>
								</xsl:when>
								<xsl:otherwise> SYSTEM "</xsl:otherwise>
							</xsl:choose>

							<xsl:call-template name="cxsltl:xmlToSvg.element.a">
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

					<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
						<xsl:with-param name="class">markupDeclaration</xsl:with-param>
						<xsl:with-param name="title">Markup Declaration</xsl:with-param>
						<xsl:with-param name="content" select="$markupDeclaration"/>
						<xsl:with-param name="escape" select="true()"/>
					</xsl:call-template>

					<xsl:text>&#xA;]</xsl:text>
				</xsl:if>

				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">dtdEnd</xsl:with-param>
					<xsl:with-param name="content">&amp;gt;</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>a要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="href" xsltdoc:short="href属性"/>
		<xsltdoc:paramString xsltdoc:name="class" xsltdoc:short="class属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="id属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="title属性"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:returnString xsltdoc:short="a要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.element.a">
		<xsl:param name="href"/>
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
						<xsl:with-param name="name">xlink:href</xsl:with-param>
						<xsl:with-param name="value" select="$href"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:call-template name="cxsltl:xmlToSvg.globalAttribute">
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="attribute" select="$attribute"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:if test="string($title)">
					<xsl:call-template name="cxsltl:xmlToSvg.element.title">
						<xsl:with-param name="content" select="$title"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$escape">
						<xsl:call-template name="cxsltl:xml.generate.escape">
							<xsl:with-param name="string" select="$content"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$content"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>a要素(内部リンク)またはtspan要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="href" xsltdoc:short="href属性"/>
		<xsltdoc:paramString xsltdoc:name="class" xsltdoc:short="class属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="id属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="title属性"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:returnString xsltdoc:short="a要素またはtspan要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.element.fragmentlink">
		<xsl:param name="href"/>
		<xsl:param name="class"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>
		<xsl:param name="attribute"/>
		<xsl:param name="content" select="."/>
		<xsl:param name="escape" select="false()"/>

		<xsl:choose>
			<xsl:when test="string($href)">
				<xsl:call-template name="cxsltl:xmlToSvg.element.a">
					<xsl:with-param name="href" select="concat('#', $href)"/>
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="attribute" select="$attribute"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="escape" select="$escape"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
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
		<xsltdoc:short>title要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:returnString xsltdoc:short="title要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.element.title">
		<xsl:param name="attribute"/>
		<xsl:param name="content" select="."/>

		<xsl:call-template name="cxsltl:xml.generate.element">
			<xsl:with-param name="name">title</xsl:with-param>
			<xsl:with-param name="attribute" select="$attribute"/>
			<xsl:with-param name="content" select="$content"/>
			<xsl:with-param name="escape" select="true()"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>tspan要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="class" xsltdoc:short="class属性"/>
		<xsltdoc:paramString xsltdoc:name="id" xsltdoc:short="id属性"/>
		<xsltdoc:paramString xsltdoc:name="title" xsltdoc:short="title要素"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:returnString xsltdoc:short="tspan要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.element.tspan">
		<xsl:param name="class"/>
		<xsl:param name="id"/>
		<xsl:param name="title"/>
		<xsl:param name="attribute"/>
		<xsl:param name="content" select="."/>
		<xsl:param name="escape" select="false()"/>

		<xsl:call-template name="cxsltl:xml.generate.element">
			<xsl:with-param name="name">tspan</xsl:with-param>
			<xsl:with-param name="attribute">
				<xsl:call-template name="cxsltl:xmlToSvg.globalAttribute">
					<xsl:with-param name="class" select="$class"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="attribute" select="$attribute"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:if test="string($title)">
					<xsl:call-template name="cxsltl:xmlToSvg.element.title">
						<xsl:with-param name="content" select="$title"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$escape">
						<xsl:call-template name="cxsltl:xml.generate.escape">
							<xsl:with-param name="string" select="$content"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$content"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
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

	<xsl:template name="cxsltl:xmlToSvg.globalAttribute">
		<xsl:param name="class"/>
		<xsl:param name="id"/>
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

		<xsl:if test="string($attribute)">
			<xsl:text> </xsl:text>

			<xsl:call-template name="cxsltl:string.leftTrim">
				<xsl:with-param name="string" select="$attribute"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>名前空間ノードをSVGに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="element" xsltdoc:short="対象とする要素ノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="名前空間属性"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.namespaceAttribute">
		<xsl:param name="element" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToSvg.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:for-each select="$element/namespace::*[count(. | $deny) != $denyCount][not(starts-with(translate(name(), 'XML', 'xml'), 'xml'))]">
			<xsl:if test="not(. = parent::*/parent::*/namespace::*[count(. | $deny) != $denyCount][name() = name(current())])">
				<xsl:variable name="xpath">
					<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
						<xsl:with-param name="deny" select="$deny"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="xpathEncoded">
					<xsl:call-template name="cxsltl:xmlToSvg.xpathToFragment">
						<xsl:with-param name="xpath" select="$xpath"/>
						<xsl:with-param name="idPrefix" select="$idPrefix"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:call-template name="cxsltl:xmlToSvg.attribute">
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
				<xsl:call-template name="cxsltl:xmlToSvg.attribute">
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
		<xsltdoc:short>行番号を生成する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="start" xsltdoc:short="行番号の初期値"/>
		<xsltdoc:paramNumber xsltdoc:name="count" xsltdoc:short="行番号の回数"/>
		<xsltdoc:paramString xsltdoc:name="format" xsltdoc:short="行番号の形式"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:paramNumber xsltdoc:name="increment" xsltdoc:short="行番号の加算値"/>
		<xsltdoc:paramNumber xsltdoc:name="height" xsltdoc:short="1行の高さ"/>
		<xsltdoc:returnString xsltdoc:short="名前空間属性"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.lineNumber">
		<xsl:param name="start" select="$cxsltl:xmlToSvg.start"/>
		<xsl:param name="count" select="0"/>
		<xsl:param name="format" select="$cxsltl:xmlToSvg.format"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>
		<xsl:param name="increment" select="$cxsltl:xmlToSvg.increment"/>
		<xsl:param name="height" select="$cxsltl:xmlToSvg.height"/>

		<xsl:if test="0 &lt;= $start">
			<xsl:call-template name="cxsltl:common.forLoop">
				<xsl:with-param name="callback" select="$cxsltl:xmlToSvg.self/xsl:template[@name = 'cxsltl:xmlToSvg.callback.lineNumber']"/>
				<xsl:with-param name="start" select="$start"/>
				<xsl:with-param name="step" select="$increment"/>
				<xsl:with-param name="end" select="$start - 1 + ($count * $increment)"/>
				<xsl:with-param name="param1" select="$format"/>
				<xsl:with-param name="param2" select="$idPrefix"/>
				<xsl:with-param name="param3" select="$height"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>シンタックスハイライトのスタイル</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="style要素"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.style">
		<style type="text/css">
			.xmlToSvg {
				fill: #000000;
				font: 16px monospace;
			}

			.xmlToSvg a {
				fill: inherit;
				text-decoration: none;
			}

			.xmlToSvg .xmlDeclaration {
				fill: #FF0000;
			}

			.xmlToSvg .dtd {
				fill: #FF33FF;
				font-style: italic;
			}

			.xmlToSvg .root {
			}

			.xmlToSvg .element {
			}

			.xmlToSvg .element .elementName {
				fill: #000080;
				font-weight: bold;
			}

			.xmlToSvg .attribute {
			}

			.xmlToSvg .attributeName {
				fill: #0000FF;
			}

			.xmlToSvg .attributeValue {
				fill: #008000;
			}

			.xmlToSvg .text {
			}

			.xmlToSvg .comment {
				fill: #808080;
			}

			.xmlToSvg .commentValue {
				font-style: italic;
			}

			.xmlToSvg .pi {
				fill: #FF0000;
			}

			.xmlToSvg .piName {
				font-weight: bold;
			}

			.xmlToSvg .piValue {
			}

			.xmlToSvg .cdata {
				fill: #800080;
			}

			.xmlToSvg .entity {
				font-style: italic;
			}

			.xmlToSvg *:target {
				text-decoration: underline;
			}

			.xmlToSvg .tab {
				letter-spacing: 2em;
			}

			.xmlToSvg .eol tspan {
				font-size: 0;
			}

			.lineNumber {
				font: 16px monospace;
			}

			.lineNumber rect {
				fill: #FFFFFF;
			}

			.lineNumber:nth-of-type(even) rect {
				fill: #FAFAFA;
			}

			.lineNumber:target rect {
				fill: #FFFF00;
			}
		</style>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XML宣言を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="version" xsltdoc:short="XMLのバージョン情報"/>
		<xsltdoc:paramString xsltdoc:name="encoding" xsltdoc:short="符号化宣言"/>
		<xsltdoc:paramString xsltdoc:name="standalone" xsltdoc:short="スタンドアローン宣言"/>
		<xsltdoc:paramString xsltdoc:name="idPrefix" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換したXML宣言"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSvg.xmlDeclaration">
		<xsl:param name="version" select="$cxsltl:xmlToSvg.version"/>
		<xsl:param name="encoding" select="$cxsltl:xmlToSvg.encoding"/>
		<xsl:param name="standalone" select="$cxsltl:xmlToSvg.standalone"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:variable name="fragment">
			<xsl:if test="string($idPrefix)">
				<xsl:value-of select="concat($idPrefix, 'xmlDeclaration')"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
			<xsl:with-param name="class">pi xmlDeclaration</xsl:with-param>
			<xsl:with-param name="title">XML Declaration</xsl:with-param>
			<xsl:with-param name="id" select="$fragment"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
					<xsl:with-param name="class">piStart</xsl:with-param>
					<xsl:with-param name="content">&amp;lt;?</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToSvg.element.fragmentlink">
					<xsl:with-param name="href" select="$fragment"/>
					<xsl:with-param name="class">piName</xsl:with-param>
					<xsl:with-param name="content">xml</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToSvg.attribute">
					<xsl:with-param name="name">version</xsl:with-param>
					<xsl:with-param name="nameHref">http://www.w3.org/TR/xml/#sec-prolog-dtd</xsl:with-param>
					<xsl:with-param name="nameTitle">version pseudo-attribute</xsl:with-param>
					<xsl:with-param name="value" select="$version"/>
				</xsl:call-template>

				<xsl:if test="string($encoding)">
					<xsl:call-template name="cxsltl:xmlToSvg.attribute">
						<xsl:with-param name="name">encoding</xsl:with-param>
						<xsl:with-param name="nameHref">http://www.w3.org/TR/xml/#charencoding</xsl:with-param>
						<xsl:with-param name="nameTitle">encoding pseudo-attribute</xsl:with-param>
						<xsl:with-param name="value" select="$encoding"/>
						<xsl:with-param name="valueHref">https://www.iana.org/assignments/character-sets/character-sets.xhtml</xsl:with-param>
						<xsl:with-param name="valueTitle">Character Sets</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="string($standalone)">
					<xsl:call-template name="cxsltl:xmlToSvg.attribute">
						<xsl:with-param name="name">standalone</xsl:with-param>
						<xsl:with-param name="nameTitle">standalone pseudo-attribute</xsl:with-param>
						<xsl:with-param name="nameHref">http://www.w3.org/TR/xml/#sec-rmd</xsl:with-param>
						<xsl:with-param name="value" select="$standalone"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:call-template name="cxsltl:xmlToSvg.element.tspan">
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

	<xsl:template name="cxsltl:xmlToSvg.xpathToFragment">
		<xsl:param name="xpath"/>
		<xsl:param name="idPrefix" select="$cxsltl:xmlToSvg.idPrefix"/>

		<xsl:if test="string($idPrefix)">
			<xsl:value-of select="$idPrefix"/>

			<xsl:call-template name="cxsltl:string.multipleReplace">
				<xsl:with-param name="node" select="$cxsltl:xmlToSvg.replace.xpath"/>
				<xsl:with-param name="string" select="$xpath"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- ==============================
		# Callback Template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>行番号を生成する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:common.forLoopにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramNumber xsltdoc:name="start" xsltdoc:short="ループの最初の番号"/>
		<xsltdoc:paramNumber xsltdoc:name="end" xsltdoc:short="ループの番号の最大値"/>
		<xsltdoc:paramNumber xsltdoc:name="step" xsltdoc:short="ループの番号の増加数"/>
		<xsltdoc:paramNumber xsltdoc:name="counter" xsltdoc:short="ループの回数"/>
		<xsltdoc:paramString xsltdoc:name="param1" xsltdoc:short="行番号の形式"/>
		<xsltdoc:paramString xsltdoc:name="param2" xsltdoc:short="id属性の接頭辞"/>
		<xsltdoc:paramString xsltdoc:name="param3" xsltdoc:short="行の高さ"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToSvg.callback.lineNumber']" mode="cxsltl:callback" name="cxsltl:xmlToSvg.callback.lineNumber">
		<xsl:param name="position" select="1"/>
		<xsl:param name="start" select="1"/>
		<xsl:param name="end" select="1"/>
		<xsl:param name="step" select="1"/>
		<xsl:param name="counter" select="1"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>

		<xsl:variable name="fragment.line">
			<xsl:if test="string($param2)">
				<xsl:value-of select="concat($param2, 'line', $position)"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xml.generate.element">
			<xsl:with-param name="name">g</xsl:with-param>
			<xsl:with-param name="attribute">
				<xsl:text>class="lineNumber"</xsl:text>

				<xsl:if test="string($fragment.line)">
					<xsl:call-template name="cxsltl:xml.generate.attribute">
						<xsl:with-param name="name">id</xsl:with-param>
						<xsl:with-param name="value" select="concat($param2, 'line', $position)"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:xmlToSvg.element.title">
					<xsl:with-param name="attribute">xml:lang="en"</xsl:with-param>
					<xsl:with-param name="content" select="concat('Line ', $position)"/>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xml.generate.element">
					<xsl:with-param name="name">rect</xsl:with-param>
					<xsl:with-param name="attribute">
						<xsl:text>width="100%"</xsl:text>

						<xsl:call-template name="cxsltl:xml.generate.attribute">
							<xsl:with-param name="name">height</xsl:with-param>
							<xsl:with-param name="value" select="concat($param3, 'em')"/>
						</xsl:call-template>

						<xsl:call-template name="cxsltl:xml.generate.attribute">
							<xsl:with-param name="name">y</xsl:with-param>
							<xsl:with-param name="value" select="concat(($counter - 1) * $param3, 'em')"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xml.generate.element">
					<xsl:with-param name="name">text</xsl:with-param>
					<xsl:with-param name="attribute">
						<xsl:text>xml:space="preserve"</xsl:text>

						<xsl:call-template name="cxsltl:xml.generate.attribute">
							<xsl:with-param name="name">y</xsl:with-param>
							<xsl:with-param name="value" select="concat($counter * $param3, 'em')"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="content">
						<xsl:call-template name="cxsltl:xmlToSvg.element.fragmentlink">
							<xsl:with-param name="href" select="$fragment.line"/>
							<xsl:with-param name="content">
								<xsl:call-template name="cxsltl:line.numberFormat">
									<xsl:with-param name="number" select="$position"/>
									<xsl:with-param name="format" select="$param1"/>
									<xsl:with-param name="width" select="string-length($end)"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>oasis-xml-catalogの擬似属性を受け取りSVGに変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xml.generate.pseudoAttributeにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="擬似属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="擬似属性値"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToSvg.callback.pseudoAttribute.oasisXmlCatalog']" mode="cxsltl:callback" name="cxsltl:xmlToSvg.callback.pseudoAttribute.oasisXmlCatalog">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:call-template name="cxsltl:xmlToSvg.attribute">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="nameHref">
				<xsl:if test="$name = 'catalog'">https://www.oasis-open.org/committees/download.php/14809/xml-catalogs.html#oasis-er-tc-abc</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="nameTitle">
				<xsl:if test="$name = 'catalog'">XML Catalogs</xsl:if>
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
		<xsltdoc:short>xml-modelの疑似属性を受け取りSVGに変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xml.generate.pseudoAttributeにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="擬似属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="擬似属性値"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToSvg.callback.pseudoAttribute.xmlModel']" mode="cxsltl:callback" name="cxsltl:xmlToSvg.callback.pseudoAttribute.xmlModel">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:call-template name="cxsltl:xmlToSvg.attribute">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="nameHref" select="concat('http://www.w3.org/TR/xml-model/#PA-', $name)"/>
			<xsl:with-param name="nameTitle" select="concat($name, ' pseudo-attribute')"/>
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
			<xsl:with-param name="valueTitle">
				<xsl:choose>
					<xsl:when test="$name = 'charset'">Character Sets</xsl:when>
					<xsl:when test="$name = 'type'">Media Types</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>xml-stylesheetの疑似属性を受け取りSVGに変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xml.generate.pseudoAttributeにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="擬似属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="擬似属性値"/>
		<xsltdoc:returnString xsltdoc:short="SVGに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToSvg.callback.pseudoAttribute.xmlStylesheet']" mode="cxsltl:callback" name="cxsltl:xmlToSvg.callback.pseudoAttribute.xmlStylesheet">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:call-template name="cxsltl:xmlToSvg.attribute">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="nameHref" select="concat('http://www.w3.org/TR/xml-stylesheet/#PA-', $name)"/>
			<xsl:with-param name="nameTitle" select="concat($name, ' pseudo-attribute')"/>
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
			<xsl:with-param name="valueTitle">
				<xsl:choose>
					<xsl:when test="$name = 'charset'">Character Sets</xsl:when>
					<xsl:when test="$name = 'media'">Media Queries</xsl:when>
					<xsl:when test="$name = 'type'">Media Types</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>