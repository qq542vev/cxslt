<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="CSV" href="xmlToCsv.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToCsv.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/common.xsl"/>
	<xsl:import href="../library/csv/generate.xsl"/>
	<xsl:import href="../library/node/property.xsl"/>
	<xsl:import href="../library/node/test.xsl"/>
	<xsl:import href="../library/xpath/parse.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルをCSVに変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードをCSVに変換する。
			{xsl:import}, {xsl:include}を使用し外部のスタイルシートとして使用することも出来る。
		</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>aノード以下をCSVに変換する例</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:xmlToCsv.convert">
						<xsl:with-param name="node" select="/a/node()"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-05-11</xsltdoc:version>
		<xsltdoc:since>2011-11-23</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="https://www.ietf.org/rfc/rfc4180.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/csv"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToCsv.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>最小限のノード情報をCSVに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToCsv.config.conpact" select="$cxsltl:xmlToCsv.self/cxsltl:config[@xml:id = 'cxsltl.xmlToCsv.config.conpact']"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>ノード情報をCSVに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToCsv.config.full" select="$cxsltl:xmlToCsv.self/cxsltl:config[@xml:id = 'cxsltl.xmlToCsv.config.full']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCSVに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToCsv.config" select="$cxsltl:xmlToCsv.config.conpact"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToCsv.deny" select="/.."/>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでのノードの深さ</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToCsv.depth" select="1"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの区切り文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToCsv.delimiter">,</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのCSVの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToCsv.eol" select="'&#xD;&#xA;'"/>

	<xsltdoc:BooleanStringParam>
		<xsltdoc:short>デフォルトでのヘッダー</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:BooleanStringParam>

	<xsl:param name="cxsltl:xmlToCsv.header" select="true()"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.xmlToCsv.config.conpact">
		<xsltdoc:short>最小限のノード情報をCSVに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.xmlToCsv.config.conpact">
		<cxsltl:id cxsltl:wrap="literal"/>
		<cxsltl:id cxsltl:alias="parentId" cxsltl:typeIsNot="root" cxsltl:xpath=".." cxsltl:wrap="literal"/>
		<cxsltl:name cxsltl:typeIs="element processing-instruction" cxsltl:wrap="literal" />
		<cxsltl:type/>
		<cxsltl:string cxsltl:typeIsNot="root element"/>
	</cxsltl:config>

	<xsltdoc:Element rdf:about="#cxsltl.xmlToCsv.config.full">
		<xsltdoc:short>最大限のノード情報をCSVに変換する設定用のノード</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.xmlToCsv.config.full">
		<cxsltl:position cxsltl:wrap="literal"/>
		<cxsltl:id cxsltl:wrap="literal"/>
		<cxsltl:id cxsltl:alias="parentId" cxsltl:typeIsNot="root" cxsltl:xpath=".." cxsltl:wrap="literal"/>
		<cxsltl:id cxsltl:alias="child" cxsltl:typeIs="root element" cxsltl:xpath="node()"/>
		<cxsltl:name cxsltl:typeIs="element processing-instruction" cxsltl:wrap="literal"/>
		<cxsltl:type cxsltl:wrap="literal"/>
		<cxsltl:string cxsltl:typeIsNot="root element"/>
		<cxsltl:length cxsltl:wrap="literal"/>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードをCSVに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			CSVへの変換はxsl:call-templateを使用しcxsltl:xmlToCsv.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="CSVに変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:xmlToCsv.convert">
			<xsl:with-param name="node" select="//self::node() | //@* | //namespace::*"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for call Property
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>プロパティ呼び出し用のノードのテンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | text() | comment() | processing-instruction() | @*" mode="cxsltl:xmlToCsv.callProperty"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象とするノードにプロパティ要素を適用しCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="CSVに変換されたノード情報を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*" mode="cxsltl:xmlToCsv.callProperty">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToCsv.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToCsv.depth"/>
		<xsl:param name="delimiter" select="$cxsltl:xmlToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:xmlToCsv.eol"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:variable name="valid">
			<xsl:call-template name="cxsltl:node.test.check">
				<xsl:with-param name="binary">
					<xsl:apply-templates select="@*" mode="cxsltl:xmlToCsv.validation">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="depth" select="$depth"/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="delimiter" select="$delimiter"/>
						<xsl:with-param name="eol" select="$eol"/>
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
			<xsl:variable name="result">
				<xsl:choose>
					<xsl:when test="@cxsltl:xpath">
						<xsl:call-template name="cxsltl:xpath.parse.acsess">
							<xsl:with-param name="callback" select="$cxsltl:xmlToCsv.self/xsl:template[@name = 'cxsltl:xmlToCsv.callback.property']"/>
							<xsl:with-param name="node" select="$node"/>
							<xsl:with-param name="xpath" select="@cxsltl:xpath"/>
							<xsl:with-param name="param1" select="."/>
							<xsl:with-param name="param2" select="$deny"/>
							<xsl:with-param name="param3" select="$depth + 1"/>
							<xsl:with-param name="param4" select="$delimiter"/>
							<xsl:with-param name="param5" select="$eol"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="cxsltl:xmlToCsv.property">
							<xsl:with-param name="node" select="$node"/>
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="depth" select="$depth"/>
							<xsl:with-param name="delimiter" select="$delimiter"/>
							<xsl:with-param name="eol" select="$eol"/>
							<xsl:with-param name="position" select="$position"/>
							<xsl:with-param name="last" select="$last"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="
					@cxsltl:wrap = 'literal' or (
						@cxsltl:wrap = 'auto' and not(
							contains($result, $delimiter) or
							contains($result, '&#xA;') or
							contains($result, '&#xD;') or
							contains($result, '&quot;')
						)
					)
				">
					<xsl:value-of select="$result"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cxsltl:csv.generate.escape">
						<xsl:with-param name="string" select="$result"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<xsl:if test="position() != last()">
			<xsl:value-of select="$delimiter"/>
		</xsl:if>
	</xsl:template>

	<!-- ==============================
		## xsl:template for property element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>cxsltl:node.propertyに処理を渡す</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="cxsltl:node.propertyの処理結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToCsv.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="depth" select="$cxsltl:xmlToCsv.depth"/>
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
		<xsltdoc:short>プロパティ要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="@xlink:hrefのリンク先のプロパティ要素とcxsltl:groupの子要素のプロパティをCSVに変換して返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:group" mode="cxsltl:xmlToCsv.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToCsv.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToCsv.depth"/>
		<xsl:param name="delimiter" select="$cxsltl:xmlToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:xmlToCsv.eol"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:call-template name="cxsltl:xmlToCsv.propertyProcessing">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="delimiter"/>
			<xsl:with-param name="eol"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$last"/>
		</xsl:call-template>
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
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToCsv.validation">
		<xsl:param name="node" select="."/>
		<xsl:param name="depth" select="$cxsltl:xmlToCsv.depth"/>
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
		<xsltdoc:short>ノードをCSVに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用のノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramBooleanString xsltdoc:name="header" xsltdoc:short="ヘッダーの出力を行うか"/>
		<xsltdoc:returnString xsltdoc:short="CSVに変換されたノード情報を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToCsv.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="config" select="$cxsltl:xmlToCsv.config"/>
		<xsl:param name="deny" select="$cxsltl:xmlToCsv.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToCsv.depth"/>
		<xsl:param name="delimiter" select="$cxsltl:xmlToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:xmlToCsv.eol"/>
		<xsl:param name="header" select="$cxsltl:xmlToCsv.header"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="string($header) = 'true' and number($header) = 1">
				<xsl:for-each select="$config/*">
					<xsl:choose>
						<xsl:when test="@cxsltl:alias">
							<xsl:call-template name="cxsltl:csv.generate.escape">
								<xsl:with-param name="string" select="@cxsltl:alias"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="cxsltl:csv.generate.escape">
								<xsl:with-param name="string" select="local-name()"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:if test="position() != last()">
						<xsl:value-of select="$delimiter"/>
					</xsl:if>
				</xsl:for-each>

				<xsl:value-of select="$eol"/>
			</xsl:when>
			<xsl:when test="string($header) and not(string($header) = 'false' and number($header) = 0)">
				<xsl:value-of select="concat($header, $eol)"/>
			</xsl:when>
		</xsl:choose>

		<xsl:for-each select="$config[self::cxsltl:config]">
			<xsl:call-template name="cxsltl:xmlToCsv.propertyProcessing">
				<xsl:with-param name="node" select="$node[count(. | $deny) != $denyCount]"/>
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="depth" select="$depth"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
				<xsl:with-param name="eol" select="$eol"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$property/@xlink:hrefと$property/*を処理する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="property" xsltdoc:short="プロパティ要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="CSVに変換したノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToCsv.propertyProcessing">
		<xsl:param name="property" select="."/>
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToCsv.deny"/>
		<xsl:param name="depth" select="$cxsltl:xmlToCsv.depth"/>
		<xsl:param name="delimiter" select="$cxsltl:xmlToCsv.delimiter"/>
		<xsl:param name="eol" select="$cxsltl:xmlToCsv.eol"/>
		<xsl:param name="position" select="0"/>
		<xsl:param name="last" select="0"/>

		<xsl:for-each select="$node">
			<xsl:sort select="last() - position() * ($property/@cxsltl:order = 'desc')" data-type="number"/>

			<xsl:variable name="positionX" select="$position + (position() * not($position))"/>
			<xsl:variable name="lastX" select="$last + (last() * not($last))"/>

			<xsl:choose>
				<xsl:when test="substring-after($property/@xlink:href, '#')">
					<xsl:apply-templates select="document(substring-before($property/@xlink:href, '#'), $property)//self::*[@xml:id = substring-after($property/@xlink:href, '#')]/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToCsv.callProperty">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="delimiter" select="$delimiter"/>
						<xsl:with-param name="eol" select="$eol"/>
						<xsl:with-param name="depth" select="$depth"/>
						<xsl:with-param name="position" select="$positionX"/>
						<xsl:with-param name="last" select="$lastX"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$property/@xlink:href">
					<xsl:apply-templates select="document($property/@xlink:href, $property)/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToCsv.callProperty">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="delimiter" select="$delimiter"/>
						<xsl:with-param name="eol" select="$eol"/>
						<xsl:with-param name="depth" select="$depth"/>
						<xsl:with-param name="position" select="$positionX"/>
						<xsl:with-param name="last" select="$lastX"/>
					</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>

			<xsl:apply-templates select="$property/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToCsv.callProperty">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
				<xsl:with-param name="eol" select="$eol"/>
				<xsl:with-param name="depth" select="$depth"/>
				<xsl:with-param name="position" select="$positionX"/>
				<xsl:with-param name="last" select="$lastX"/>
			</xsl:apply-templates>

			<xsl:value-of select="$eol"/>
		</xsl:for-each>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>ノード情報をCSVに変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xpath.parse.acsessにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param1" xsltdoc:short="プロパティ要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param2" xsltdoc:short="除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="param3" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramString xsltdoc:name="param4" xsltdoc:short="CSVの区切り文字"/>
		<xsltdoc:paramString xsltdoc:name="param5" xsltdoc:short="CSVの改行文字"/>
		<xsltdoc:returnString xsltdoc:short="CSVに変換されたノード情報を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToCsv.callback.property']" mode="cxsltl:callback" name="cxsltl:xmlToCsv.callback.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:variable name="denyCount" select="count($param2)"/>

		<xsl:apply-templates select="$param1" mode="cxsltl:xmlToCsv.property">
			<xsl:with-param name="node" select="$node[count(. | $param2) != $denyCount]"/>
			<xsl:with-param name="deny" select="$param2"/>
			<xsl:with-param name="depth" select="$param3"/>
			<xsl:with-param name="delimiter" select="$param4"/>
			<xsl:with-param name="eol" select="$param5"/>
			<xsl:with-param name="position" select="0"/>
			<xsl:with-param name="last" select="0"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>