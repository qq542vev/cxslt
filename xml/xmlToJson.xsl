<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="JSON" href="xmlToJson.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToJson.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/common.xsl"/>
	<xsl:import href="../library/json/generate.xsl"/>
	<xsl:import href="../library/node/property.xsl"/>
	<xsl:import href="../library/node/test.xsl"/>
	<xsl:import href="../library/xml/parse.xsl"/>
	<xsl:import href="../library/xpath/parse.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルをJSONに変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードをJSONに変換する。
			{xsl:import}, {xsl:include}を使用し外部のスタイルシートとして使用することも出来る。
		</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>aノード以下をJSONに変換する例</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:xmlToJson.convert">
						<xsl:with-param name="node" select="/a/node()"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-05-11</xsltdoc:version>
		<xsltdoc:since>2010-09-24T14:22:36+09:00</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="https://www.ietf.org/rfc/rfc7159.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="application/json"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToJson.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>最小限のノード情報をJSONに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToJson.config.conpact" select="$cxsltl:xmlToJson.self/cxsltl:config[@xml:id = 'cxsltl.xmlToJson.config.conpact']"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>最大限のノード情報をJSONに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToJson.config.full" select="$cxsltl:xmlToJson.self/cxsltl:config[@xml:id = 'cxsltl.xmlToJson.config.full']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのJSONに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToJson.config" select="$cxsltl:xmlToJson.config.conpact"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToJson.deny" select="/.."/>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでのノードの深さ</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToJson.depth" select="1"/>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでのJSONの深さ</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToJson.json.depth" select="0"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのJSONのインデント文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToJson.json.indent" select="'&#x9;'"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのJSONの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToJson.json.eol" select="'&#xA;'"/>

	<xsltdoc:BooleanParam>
		<xsltdoc:short>デフォルトでのJSONの末尾にカンマを生成するか</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:BooleanParam>

	<xsl:param name="cxsltl:xmlToJson.json.last" select="true()"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのJSONPのコールパック関数名</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToJson.json.callback"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.xmlToJson.config.conpact">
		<xsltdoc:short>最小限のノード情報をJSONに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config cxsltl:wrap="array" xml:id="cxsltl.xmlToJson.config.conpact">
		<!-- Root Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="none" cxsltl:typeIs="root" cxsltl:xpath="node()" xlink:href="#cxsltl.xmlToJson.config.conpact"/>
		<!-- Element Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:typeIs="element">
			<cxsltl:group cxsltl:alias="attribute" cxsltl:wrap="object">
				<!-- Attribute Node Processing -->
				<cxsltl:group cxsltl:alias="" cxsltl:wrap="none" cxsltl:xpath="@*">
					<!-- xml:base, xml:id, xml:lang, xml:space Attribute Processing -->
					<cxsltl:normalize cxsltl:nameIs="xml:base xml:id xml:lang xml:space">
						<cxsltl:name cxsltl:wrap="none" cxsltl:processing="alias"/>
					</cxsltl:normalize>
					<!-- Not xml:base, xml:id, xml:lang, xml:space Attribute Processing -->
					<cxsltl:string cxsltl:nameIsNot="xml:base xml:id xml:lang xml:space">
						<cxsltl:name cxsltl:wrap="none" cxsltl:processing="alias"/>
					</cxsltl:string>
				</cxsltl:group>
				<!-- Namespace(Attribute) Node Processing -->
				<cxsltl:attributeXmlns cxsltl:alias="xmlns" cxsltl:wrap="none">
					<cxsltl:normalize>
						<cxsltl:static cxsltl:wrap="none" cxsltl:processing="alias" cxsltl:nameIsNot="{#null#}">:</cxsltl:static>
						<cxsltl:name cxsltl:wrap="none" cxsltl:processing="alias"/>
					</cxsltl:normalize>
				</cxsltl:attributeXmlns>
				<!-- Empty Namespace(xmlns="" xmlns:ex="") Node Processing -->
				<cxsltl:attributeXmlnsEmpty cxsltl:alias="xmlns" cxsltl:wrap="none">
					<cxsltl:static>
						<cxsltl:static cxsltl:wrap="none" cxsltl:processing="alias" cxsltl:nameIsNot="{#null#}">:</cxsltl:static>
						<cxsltl:name cxsltl:wrap="none" cxsltl:processing="alias"/>
					</cxsltl:static>
				</cxsltl:attributeXmlnsEmpty>
			</cxsltl:group>
			<cxsltl:group cxsltl:alias="child" cxsltl:wrap="array" cxsltl:xpath="node()" xlink:href="#cxsltl.xmlToJson.config.conpact"/>
			<cxsltl:name/>
			<cxsltl:type/>
		</cxsltl:group>
		<!-- Text Node Processing -->
		<cxsltl:string cxsltl:typeIs="text"/>
		<!-- Comment Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:typeIs="comment">
			<cxsltl:string/>
			<cxsltl:type/>
		</cxsltl:group>
		<!-- Processing Instruction Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:typeIs="processing-instruction">
			<cxsltl:name/>
			<cxsltl:pseudoAttribute cxsltl:wrap="object" cxsltl:nameIs="oasis-xml-catalog xml-model xml-stylesheet"/>
			<cxsltl:static cxsltl:alias="pseudoAttribute" cxsltl:wrap="object" cxsltl:nameIsNot="oasis-xml-catalog xml-model xml-stylesheet"/>
			<cxsltl:string/>
			<cxsltl:type/>
		</cxsltl:group>
	</cxsltl:config>

	<xsltdoc:Element rdf:about="#cxsltl.xmlToJson.config.full">
		<xsltdoc:short>最大限のノード情報をJSONに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config cxsltl:wrap="array" xml:id="cxsltl.xmlToJson.config.full">
		<!-- Root Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="none" cxsltl:typeIs="root" cxsltl:xpath="node()" xlink:href="#cxsltl.xmlToJson.config.full"/>
		<!-- Element Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:typeIs="element">
			<cxsltl:group cxsltl:alias="attribute" cxsltl:wrap="object">
				<!-- Attribute Node Processing -->
				<cxsltl:group cxsltl:alias="" cxsltl:wrap="none" cxsltl:xpath="@*">
					<cxsltl:group cxsltl:wrap="object">
						<cxsltl:name cxsltl:wrap="none" cxsltl:processing="alias"/>
						<cxsltl:depth cxsltl:wrap="literal"/>
						<cxsltl:expanded/>
						<cxsltl:id/>
						<cxsltl:jsonDepth cxsltl:wrap="literal"/>
						<cxsltl:normalizeLength cxsltl:alias="length" cxsltl:wrap="literal" cxsltl:nameIs="xml:base xml:id xml:lang xml:space"/>
						<cxsltl:length cxsltl:wrap="literal" cxsltl:nameIsNot="xml:base xml:id xml:lang xml:space"/>
						<cxsltl:local/>
						<cxsltl:name/>
						<cxsltl:namespaceUri/>
						<cxsltl:prefix/>
						<cxsltl:normalize cxsltl:alias="string" cxsltl:nameIs="xml:base xml:id xml:lang xml:space"/>
						<cxsltl:string cxsltl:nameIsNot="xml:base xml:id xml:lang xml:space"/>
						<cxsltl:type/>
					</cxsltl:group>
				</cxsltl:group>
				<!-- Namespace(Attribute) Node Processing -->
				<cxsltl:attributeXmlns cxsltl:alias="xmlns" cxsltl:wrap="none">
					<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:nameIs="{#null#}">
						<cxsltl:depth cxsltl:wrap="literal"/>
						<cxsltl:static cxsltl:alias="expanded"/>
						<cxsltl:id/>
						<cxsltl:jsonDepth cxsltl:wrap="literal"/>
						<cxsltl:normalizeLength cxsltl:alias="length" cxsltl:wrap="literal"/>
						<cxsltl:static cxsltl:alias="local">xmlns</cxsltl:static>
						<cxsltl:static cxsltl:alias="name">xmlns</cxsltl:static>
						<cxsltl:static cxsltl:alias="namespaceUri">http://www.w3.org/2000/xmlns/</cxsltl:static>
						<cxsltl:static cxsltl:alias="prefix"/>
						<cxsltl:normalize cxsltl:alias="string"/>
						<cxsltl:static cxsltl:alias="type">attribute</cxsltl:static>
					</cxsltl:group>
					<cxsltl:group cxsltl:alias=":" cxsltl:wrap="object" cxsltl:nameIsNot="{#null#}">
						<cxsltl:name cxsltl:wrap="none" cxsltl:processing="alias"/>
						<cxsltl:depth cxsltl:wrap="literal"/>
						<cxsltl:group cxsltl:alias="expanded">
							<cxsltl:static cxsltl:wrap="none">http://www.w3.org/2000/xmlns/</cxsltl:static>
							<cxsltl:name cxsltl:wrap="none"/>
						</cxsltl:group>
						<cxsltl:id/>
						<cxsltl:jsonDepth cxsltl:wrap="literal"/>
						<cxsltl:normalizeLength cxsltl:alias="length" cxsltl:wrap="literal"/>
						<cxsltl:local/>
						<cxsltl:group cxsltl:alias="name">
							<cxsltl:static cxsltl:wrap="none">xmlns:</cxsltl:static>
							<cxsltl:name cxsltl:wrap="none"/>
						</cxsltl:group>
						<cxsltl:static cxsltl:alias="namespaceUri">http://www.w3.org/2000/xmlns/</cxsltl:static>
						<cxsltl:static cxsltl:alias="prefix">xmlns</cxsltl:static>
						<cxsltl:normalize cxsltl:alias="string"/>
						<cxsltl:static cxsltl:alias="type">attribute</cxsltl:static>
					</cxsltl:group>
				</cxsltl:attributeXmlns>
				<!-- xmlns="" xmlns:ex="" Node Processing -->
				<cxsltl:attributeXmlnsEmpty cxsltl:alias="xmlns" cxsltl:wrap="none">
					<!-- xmlns="" Node Processing -->
					<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:nameIs="{#null#}">
						<cxsltl:depth cxsltl:wrap="literal"/>
						<cxsltl:static cxsltl:alias="expanded"/>
						<cxsltl:id/>
						<cxsltl:jsonDepth cxsltl:wrap="literal"/>
						<cxsltl:static cxsltl:alias="length" cxsltl:wrap="literal">0</cxsltl:static>
						<cxsltl:static cxsltl:alias="local">xmlns</cxsltl:static>
						<cxsltl:static cxsltl:alias="name">xmlns</cxsltl:static>
						<cxsltl:static cxsltl:alias="namespaceUri">http://www.w3.org/2000/xmlns/</cxsltl:static>
						<cxsltl:static cxsltl:alias="prefix"/>
						<cxsltl:static cxsltl:alias="string"/>
						<cxsltl:static cxsltl:alias="type">attribute</cxsltl:static>
					</cxsltl:group>
					<!-- xmlns:ex="" Node Processing -->
					<cxsltl:group cxsltl:alias=":" cxsltl:wrap="object" cxsltl:nameIsNot="{#null#}">
						<cxsltl:name cxsltl:wrap="none" cxsltl:processing="alias"/>
						<cxsltl:depth cxsltl:wrap="literal"/>
						<cxsltl:group cxsltl:alias="expanded">
							<cxsltl:static cxsltl:wrap="none">http://www.w3.org/2000/xmlns/</cxsltl:static>
							<cxsltl:name cxsltl:wrap="none"/>
						</cxsltl:group>
						<cxsltl:id/>
						<cxsltl:jsonDepth cxsltl:wrap="literal"/>
						<cxsltl:static cxsltl:alias="length" cxsltl:wrap="literal">0</cxsltl:static>
						<cxsltl:local/>
						<cxsltl:group cxsltl:alias="name">
							<cxsltl:static cxsltl:wrap="none">xmlns:</cxsltl:static>
							<cxsltl:name cxsltl:wrap="none"/>
						</cxsltl:group>
						<cxsltl:static cxsltl:alias="namespaceUri">http://www.w3.org/2000/xmlns/</cxsltl:static>
						<cxsltl:static cxsltl:alias="prefix">xmlns</cxsltl:static>
						<cxsltl:static cxsltl:alias="string"/>
						<cxsltl:static cxsltl:alias="type">attribute</cxsltl:static>
					</cxsltl:group>
				</cxsltl:attributeXmlnsEmpty>
			</cxsltl:group>
			<cxsltl:group cxsltl:alias="child" cxsltl:wrap="array" cxsltl:xpath="node()" xlink:href="#cxsltl.xmlToJson.config.full"/>
			<cxsltl:count cxsltl:wrap="literal" cxsltl:xpath="node()"/>
			<cxsltl:depth cxsltl:wrap="literal"/>
			<cxsltl:expanded/>
			<cxsltl:id/>
			<cxsltl:jsonDepth cxsltl:wrap="literal"/>
			<cxsltl:last cxsltl:wrap="literal"/>
			<cxsltl:length cxsltl:wrap="literal"/>
			<cxsltl:local/>
			<cxsltl:name/>
			<!-- Namespace Node Processing -->
			<cxsltl:group cxsltl:alias="namespace" cxsltl:wrap="object" cxsltl:xpath="namespace::*">
				<cxsltl:group cxsltl:wrap="object">
					<cxsltl:name cxsltl:wrap="literal" cxsltl:processing="alias"/>
					<cxsltl:depth cxsltl:wrap="literal"/>
					<cxsltl:id/>
					<cxsltl:jsonDepth cxsltl:wrap="literal"/>
					<cxsltl:last cxsltl:wrap="literal"/>
					<cxsltl:normalizeLength cxsltl:alias="length" cxsltl:wrap="literal"/>
					<cxsltl:name/>
					<cxsltl:position cxsltl:wrap="literal"/>
					<cxsltl:normalize cxsltl:alias="string"/>
					<cxsltl:type/>
				</cxsltl:group>
			</cxsltl:group>
			<cxsltl:namespaceUri/>
			<cxsltl:prefix/>
			<cxsltl:position cxsltl:wrap="literal"/>
			<cxsltl:string/>
			<cxsltl:type/>
		</cxsltl:group>
		<!-- Text Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:typeIs="text">
			<cxsltl:depth cxsltl:wrap="literal"/>
			<cxsltl:id/>
			<cxsltl:jsonDepth cxsltl:wrap="literal"/>
			<cxsltl:last cxsltl:wrap="literal"/>
			<cxsltl:length cxsltl:wrap="literal"/>
			<cxsltl:position cxsltl:wrap="literal"/>
			<cxsltl:string/>
			<cxsltl:type/>
		</cxsltl:group>
		<!-- Comment Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:typeIs="comment">
			<cxsltl:depth cxsltl:wrap="literal"/>
			<cxsltl:id/>
			<cxsltl:jsonDepth cxsltl:wrap="literal"/>
			<cxsltl:last cxsltl:wrap="literal"/>
			<cxsltl:length cxsltl:wrap="literal"/>
			<cxsltl:position cxsltl:wrap="literal"/>
			<cxsltl:string/>
			<cxsltl:type/>
		</cxsltl:group>
		<!-- Processing Instruction Node Processing -->
		<cxsltl:group cxsltl:alias="" cxsltl:wrap="object" cxsltl:typeIs="processing-instruction">
			<cxsltl:depth cxsltl:wrap="literal"/>
			<cxsltl:id/>
			<cxsltl:jsonDepth cxsltl:wrap="literal"/>
			<cxsltl:last cxsltl:wrap="literal"/>
			<cxsltl:length cxsltl:wrap="literal"/>
			<cxsltl:name/>
			<cxsltl:position cxsltl:wrap="literal"/>
			<cxsltl:pseudoAttribute cxsltl:wrap="object" cxsltl:nameIs="oasis-xml-catalog xml-model xml-stylesheet"/>
			<cxsltl:static cxsltl:alias="pseudoAttribute" cxsltl:wrap="object" cxsltl:nameIsNot="oasis-xml-catalog xml-model xml-stylesheet"/>
			<cxsltl:string/>
			<cxsltl:type/>
		</cxsltl:group>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードをJSONに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、{xsl:apply-templates}からこのテンプレートを適用すべきではない。
			JSONへの変換はxsl:call-templateを使用しcxsltl:xmlToJson.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="JSONに変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:xmlToJson.convert"/>
	</xsl:template>

	<!-- ==============================
		## xsl:template for call Property
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>プロパティ呼び出し用のノードのテンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | text() | comment() | processing-instruction() | @*" mode="cxsltl:xmlToJson.callProperty"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象とするノードにプロパティ要素を適用しJSONに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換されたノード情報を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*" mode="cxsltl:xmlToJson.callProperty">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToJson.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="ancestorWrap">string:</xsl:param>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:variable name="valid">
			<xsl:call-template name="cxsltl:node.test.check">
				<xsl:with-param name="binary">
					<xsl:apply-templates select="@*" mode="cxsltl:xmlToJson.validation">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="depth" select="$depth"/>
						<xsl:with-param name="jsonDepth" select="$jsonDepth"/>
						<xsl:with-param name="indent" select="$indent"/>
						<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
						<xsl:with-param name="position" select="$position"/>
						<xsl:with-param name="last" select="$last"/>
					</xsl:apply-templates>
				</xsl:with-param>
				<xsl:with-param name="operation">
					<xsl:call-template name="cxsltl:common.chooseAndPrint">
						<xsl:with-param name="test0" select="string(@cxsltl:operation)"/>
						<xsl:with-param name="test1">and</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="number($valid)">
			<xsl:variable name="ancestorWrapType" select="substring-before($ancestorWrap, ':')"/>

			<xsl:variable name="key">
				<xsl:value-of select="substring-after($ancestorWrap, ':')"/>

				<xsl:call-template name="cxsltl:xmlToJson.callAlias">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="depth" select="$depth"/>
					<xsl:with-param name="jsonDepth" select="$jsonDepth"/>
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="position" select="$position"/>
					<xsl:with-param name="last" select="$last"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="keyNone" select="$ancestorWrapType != 'object' or @cxsltl:wrap = 'none'"/>

			<xsl:variable name="wrap">
				<xsl:choose>
					<xsl:when test="@cxsltl:wrap = 'none'">
						<xsl:value-of select="$ancestorWrapType"/>
					</xsl:when>
					<xsl:when test="@cxsltl:wrap">
						<xsl:value-of select="@cxsltl:wrap"/>
					</xsl:when>
					<xsl:otherwise>string</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="nextAncestorWrap">
				<xsl:value-of select="concat($wrap, ':')"/>

				<xsl:if test="$keyNone">
					<xsl:value-of select="$key"/>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="@cxsltl:xpath">
						<xsl:call-template name="cxsltl:xpath.parse.acsess">
							<xsl:with-param name="callback" select="$cxsltl:xmlToJson.self/xsl:template[@name = 'cxsltl:xmlToJson.callback.property']"/>
							<xsl:with-param name="node" select="$node"/>
							<xsl:with-param name="xpath" select="@cxsltl:xpath"/>
							<xsl:with-param name="param1" select="."/>
							<xsl:with-param name="param2" select="$deny"/>
							<xsl:with-param name="param3" select="$depth + 1"/>
							<xsl:with-param name="param4" select="concat($jsonDepth * not($ancestorWrapType = 'string'), ':', $indent)"/>
							<xsl:with-param name="param5" select="$nextAncestorWrap"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="cxsltl:xmlToJson.property">
							<xsl:with-param name="node" select="$node"/>
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="depth" select="$depth"/>
							<xsl:with-param name="jsonDepth" select="$jsonDepth * not($ancestorWrapType = 'string')"/>
							<xsl:with-param name="indent" select="$indent"/>
							<xsl:with-param name="ancestorWrap" select="$nextAncestorWrap"/>
							<xsl:with-param name="position" select="$position"/>
							<xsl:with-param name="last" select="$last"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="@cxsltl:wrap = 'none' or ($wrap = 'literal' and ($ancestorWrapType = 'literal' or $ancestorWrapType = 'string'))">
					<xsl:value-of select="$value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cxsltl:json.generate.contener">
						<xsl:with-param name="value" select="$value"/>
						<xsl:with-param name="type" select="$wrap"/>
						<xsl:with-param name="indent" select="$indent"/>
						<xsl:with-param name="eol" select="$cxsltl:xmlToJson.json.eol"/>
						<xsl:with-param name="depth" select="$jsonDepth * not($ancestorWrapType = 'string')"/>
						<xsl:with-param name="prefix">
							<xsl:call-template name="cxsltl:json.generate.indentRepeat">
								<xsl:with-param name="indent" select="$indent"/>
								<xsl:with-param name="depth" select="$jsonDepth * not($ancestorWrapType = 'string')"/>
							</xsl:call-template>

							<xsl:if test="not($keyNone)">
								<xsl:call-template name="cxsltl:json.generate.key">
									<xsl:with-param name="key" select="$key"/>
									<xsl:with-param name="depth" select="0"/>
									<xsl:with-param name="indent" select="$indent"/>
								</xsl:call-template>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="last" select="$ancestorWrapType != 'array' and $ancestorWrapType != 'object'"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- ==============================
		## xsl:template for property element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{cxsltl:node.property}に処理を渡す</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="{cxsltl:node.property}の処理結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToJson.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:apply-templates select="." mode="cxsltl:node.property">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$last"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>属性となる名前空間ノードを取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換した名前空間ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:attributeXmlns" mode="cxsltl:xmlToJson.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToJson.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="ancestorWrap">string:</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:variable name="nodeNames">
			<xsl:text> </xsl:text>

			<xsl:for-each select="$node/namespace::*[count(. | $deny) != $denyCount][not(starts-with(translate(name(), 'XML', 'xml'), 'xml'))]">
				<xsl:if test="not(. = parent::*/parent::*/namespace::*[name() = name(current())])">
					<xsl:value-of select="concat(name(), ' ')"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToJson.propertyProcessing">
			<xsl:with-param name="node" select="$node/namespace::*[contains($nodeNames, concat(' ', name(), ' '))]"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="depth" select="$depth + 1"/>
			<xsl:with-param name="jsonDepth" select="$jsonDepth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>値が空となる名前空間ノードを取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換した名前空間ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:attributeXmlnsEmpty" mode="cxsltl:xmlToJson.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToJson.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="ancestorWrap">string:</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:variable name="nodeNames">
			<xsl:text> </xsl:text>

			<xsl:for-each select="$node[self::*]/parent::*/namespace::*[count(. | $deny) != $denyCount]">
				<xsl:if test="not($node/namespace::*[name() = name(current())])">
					<xsl:value-of select="concat(name(), ' ')"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:call-template name="cxsltl:xmlToJson.propertyProcessing">
			<xsl:with-param name="node" select="$node/parent::*/namespace::*[contains($nodeNames, concat(' ', name(), ' '))]"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="depth" select="$depth + 1"/>
			<xsl:with-param name="jsonDepth" select="$jsonDepth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>プロパティ要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="@xlink:hrefのリンク先のプロパティ要素とcxsltl:groupの子要素のプロパティをJSONに変換して返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:group" mode="cxsltl:xmlToJson.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToJson.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="ancestorWrap">string:</xsl:param>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:call-template name="cxsltl:xmlToJson.propertyProcessing">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="jsonDepth" select="$jsonDepth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$last"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>JSONの深度を取得する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:returnNumber xsltdoc:short="JSONの深度を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:jsonDepth" mode="cxsltl:xmlToJson.property">
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>

		<xsl:value-of select="$jsonDepth"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの擬似属性を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換した擬似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:pseudoAttribute" mode="cxsltl:xmlToJson.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="ancestorWrap">string:</xsl:param>

		<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
			<xsl:with-param name="callback" select="$cxsltl:xmlToJson.self/xsl:template[@name = 'cxsltl:xmlToJson.callback.pseudoAttribute']"/>
			<xsl:with-param name="attribute" select="$node"/>
			<xsl:with-param name="param1" select="$jsonDepth + (@cxsltl:wrap = 'array' or @cxsltl:wrap = 'object')"/>
			<xsl:with-param name="param2" select="$indent"/>
			<xsl:with-param name="param3" select="$ancestorWrap"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for alias
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>エイリアス用のノードのテンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToJson.alias"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>プロパティ要素のエイリアス名を取得する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="エイリアス名を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:alias" mode="cxsltl:xmlToJson.alias">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- ==============================
		## xsl:template for validation
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>検査用のノードのテンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnBoolean xsltdoc:short="{$node}の検査結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToJson.validation">
		<xsl:param name="node" select="."/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:apply-templates select="." mode="cxsltl:node.test">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$last"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Named xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>プロパティ要素のエイリアスを取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="property" xsltdoc:short="プロパティ要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="エイリアスを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToJson.callAlias">
		<xsl:param name="property" select="."/>
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToJson.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:choose>
			<xsl:when test="$property/@cxsltl:alias or $property/*[@cxsltl:processing = 'alias']">
				<xsl:apply-templates select="$property/@cxsltl:alias" mode="cxsltl:xmlToJson.alias"/>

				<xsl:apply-templates select="$property/*[@cxsltl:processing = 'alias']" mode="cxsltl:xmlToJson.callProperty">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="depth" select="$depth"/>
					<xsl:with-param name="jsonDepth" select="$jsonDepth"/>
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="ancestorWrap">string:</xsl:with-param>
					<xsl:with-param name="position" select="$position"/>
					<xsl:with-param name="last" select="$last"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="local-name($property)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>ノードをJSONに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用のノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="カンマを生成するか"/>
		<xsltdoc:paramString xsltdoc:name="callback" xsltdoc:short="JSONPのコールパック関数名"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換されたノード情報を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToJson.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="config" select="$cxsltl:xmlToJson.config"/>
		<xsl:param name="deny" select="$cxsltl:xmlToJson.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="last" select="$cxsltl:xmlToJson.json.last"/>
		<xsl:param name="callback" select="$cxsltl:xmlToJson.json.callback"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:if test="string($callback)">
			<xsl:value-of select="concat($callback, '(')"/>
		</xsl:if>

		<xsl:for-each select="$config[self::cxsltl:config]">
			<xsl:call-template name="cxsltl:json.generate.contener">
				<xsl:with-param name="value">
					<xsl:call-template name="cxsltl:xmlToJson.propertyProcessing">
						<xsl:with-param name="node" select="$node[count(. | $deny) != $denyCount]"/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="depth" select="$cxsltl:xmlToJson.depth"/>
						<xsl:with-param name="jsonDepth" select="$jsonDepth"/>
						<xsl:with-param name="indent" select="$indent"/>
						<xsl:with-param name="ancestorWrap">
							<xsl:choose>
								<xsl:when test="@cxsltl:wrap = 'none'">
									<xsl:choose>
										<xsl:when test="@cxsltl:alias">object</xsl:when>
										<xsl:otherwise>array</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="@cxsltl:wrap">
									<xsl:value-of select="@cxsltl:wrap"/>
								</xsl:when>
								<xsl:otherwise>string</xsl:otherwise>
							</xsl:choose>

							<xsl:value-of select="concat(':', @cxsltl:alias)"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="type">
					<xsl:choose>
						<xsl:when test="@cxsltl:wrap = 'none'">literal</xsl:when>
						<xsl:when test="@cxsltl:wrap">
							<xsl:value-of select="@cxsltl:wrap"/>
						</xsl:when>
						<xsl:otherwise>string</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="eol" select="$cxsltl:xmlToJson.json.eol"/>
				<xsl:with-param name="depth" select="$jsonDepth"/>
				<xsl:with-param name="last" select="position() = last() and $last"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:if test="string($callback)">);</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$property/@xlink:hrefと$property/*を処理する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="property" xsltdoc:short="プロパティ要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="jsonDepth" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換したノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToJson.propertyProcessing">
		<xsl:param name="property" select="."/>
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToJson.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToJson.depth"/>
		<xsl:param name="jsonDepth" select="$cxsltl:xmlToJson.json.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToJson.json.indent"/>
		<xsl:param name="ancestorWrap">string:</xsl:param>
		<xsl:param name="position" select="0"/>
		<xsl:param name="last" select="0"/>

		<xsl:variable name="jsonDepthPlus" select="$jsonDepth + ($property/@cxsltl:wrap = 'array' or $property/@cxsltl:wrap = 'object')"/>

		<xsl:for-each select="$node">
			<xsl:sort select="last() - position() * ($property/@cxsltl:order = 'desc')" data-type="number"/>

			<xsl:variable name="positionX" select="$position + (position() * not($position))"/>
			<xsl:variable name="lastX" select="$last + (last() * not($last))"/>

			<xsl:choose>
				<xsl:when test="substring-after($property/@xlink:href, '#')">
					<xsl:apply-templates select="document(substring-before($property/@xlink:href, '#'), $property)//self::*[@xml:id = substring-after($property/@xlink:href, '#')]/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToJson.callProperty">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="depth" select="$depth"/>
						<xsl:with-param name="jsonDepth" select="$jsonDepthPlus"/>
						<xsl:with-param name="indent" select="$indent"/>
						<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
						<xsl:with-param name="position" select="$positionX"/>
						<xsl:with-param name="last" select="$lastX"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$property/@xlink:href">
					<xsl:apply-templates select="document($property/@xlink:href, $property)/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToJson.callProperty">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="depth" select="$depth"/>
						<xsl:with-param name="jsonDepth" select="$jsonDepthPlus"/>
						<xsl:with-param name="indent" select="$indent"/>
						<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
						<xsl:with-param name="position" select="$positionX"/>
						<xsl:with-param name="last" select="$lastX"/>
					</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>

			<xsl:apply-templates select="$property/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToJson.callProperty">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="depth" select="$depth"/>
				<xsl:with-param name="jsonDepth" select="$jsonDepthPlus"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
				<xsl:with-param name="position" select="$positionX"/>
				<xsl:with-param name="last" select="$lastX"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>ノード情報をJSONに変換する</xsltdoc:short>
		<xsltdoc:detail>{cxsltl:xpath.parse.acsess}にて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param1" xsltdoc:short="プロパティ要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param2" xsltdoc:short="除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="param3" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramString xsltdoc:name="param4" xsltdoc:short="JSONの深さ:JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="param5" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換されたノード情報を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToJson.callback.property']" mode="cxsltl:callback" name="cxsltl:xmlToJson.callback.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:variable name="denyCount" select="count($param2)"/>

		<xsl:apply-templates select="$param1" mode="cxsltl:xmlToJson.property">
			<xsl:with-param name="node" select="$node[count(. | $param2) != $denyCount]"/>
			<xsl:with-param name="deny" select="$param2"/>
			<xsl:with-param name="depth" select="$param3"/>
			<xsl:with-param name="jsonDepth" select="substring-before($param4, ':')"/>
			<xsl:with-param name="indent" select="substring-after($param4, ':')"/>
			<xsl:with-param name="ancestorWrap" select="$param5"/>
			<xsl:with-param name="position" select="0"/>
			<xsl:with-param name="last" select="0"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>疑似属性をJSONに変換する</xsltdoc:short>
		<xsltdoc:detail>{cxsltl:xml.parse.attributeSplit}にて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="疑似属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="疑似属性値"/>
		<xsltdoc:paramNumber xsltdoc:name="param1" xsltdoc:short="JSONの深さ"/>
		<xsltdoc:paramString xsltdoc:name="param2" xsltdoc:short="JSONのインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="param3" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:returnString xsltdoc:short="JSONに変換した疑似属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToJson.callback.pseudoAttribute']" mode="cxsltl:callback" name="cxsltl:xmlToJson.callback.pseudoAttribute">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>

		<xsl:call-template name="cxsltl:json.generate.contener">
			<xsl:with-param name="key">
				<xsl:if test="not(starts-with($param3, 'array:'))">
					<xsl:value-of select="concat(substring-after($param3, ':'), $name)"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="depth" select="$param1"/>
			<xsl:with-param name="indent" select="$param2"/>
			<xsl:with-param name="eol" select="$cxsltl:xmlToJson.json.eol"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>