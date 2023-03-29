<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="DOT" href="xmlToDot.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToDot.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/common.xsl"/>
	<xsl:import href="../library/dot/generate.xsl"/>
	<xsl:import href="../library/node/property.xsl"/>
	<xsl:import href="../library/node/test.xsl"/>
	<xsl:import href="../library/xpath/generate.xsl"/>
	<xsl:import href="../library/xpath/parse.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルをDOT言語に変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードをDOT言語に変換する。
			{xsl:import}, {xsl:include}を使用し外部のスタイルシートとして使用することも出来る。
		</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>a要素以下の全てのノードをDOT言語に変換するコードである</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:xmlToDot.convert">
						<xsl:with-param name="node" select="/a/node()"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-08-05</xsltdoc:version>
		<xsltdoc:since>2013-08-30</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="http://www.graphviz.org/Documentation.php"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" indent="no" media-type="text/plain"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToDot.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>ノードのスタイル付けノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToDot.config.style" select="$cxsltl:xmlToDot.self/cxsltl:config[@xml:id = 'cxsltl.xmlToDot.config.style']"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>ノード間のスタイル付けノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xmlToDot.config.path" select="$cxsltl:xmlToDot.self/cxsltl:config[@xml:id = 'cxsltl.xmlToDot.config.path']"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのDOT言語に変換する設定用のノード</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToDot.config" select="$cxsltl:xmlToDot.config.style | $cxsltl:xmlToDot.config.path"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToDot.deny" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのグラフのタイプ</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToDot.graph">digraph</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのグラフ名</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToDot.name">XMLNodeGraph</xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDOT言語のインデント文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToDot.dot.indent" select="'&#x9;'"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのDOT言語の改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToDot.dot.eol" select="'&#xA;'"/>

	<!-- ==============================
		# Configuration Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.xmlToDot.config.style">
		<xsltdoc:short>ノードのスタイル付けノード</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.xmlToDot.config.style">
		<cxsltl:id cxsltl:processing="alias"/>
		<cxsltl:id/>
		<cxsltl:group cxsltl:alias="URL">
			<cxsltl:static cxsltl:wrap="none">#</cxsltl:static>
			<cxsltl:id cxsltl:wrap="none"/>
		</cxsltl:group>
		<cxsltl:group cxsltl:typeIs="root" cxsltl:wrap="none">
			<cxsltl:static cxsltl:alias="label">/</cxsltl:static>
			<cxsltl:static cxsltl:alias="tooltip">Root Node</cxsltl:static>
			<cxsltl:static cxsltl:alias="shape">septagon</cxsltl:static>
			<cxsltl:static cxsltl:alias="style">filled</cxsltl:static>
			<cxsltl:static cxsltl:alias="fillcolor">#00FFFF</cxsltl:static>
			<cxsltl:static cxsltl:alias="peripheries">2</cxsltl:static>
		</cxsltl:group>
		<cxsltl:group cxsltl:typeIs="element" cxsltl:wrap="none">
			<cxsltl:group cxsltl:alias="label">
				<cxsltl:static cxsltl:wrap="none">&lt;</cxsltl:static>
				<cxsltl:name cxsltl:wrap="none"/>
				<cxsltl:static cxsltl:wrap="none">&gt;</cxsltl:static>
			</cxsltl:group>
			<cxsltl:group cxsltl:alias="tooltip">
				<cxsltl:static cxsltl:wrap="none">&lt;</cxsltl:static>
				<cxsltl:group cxsltl:wrap="none" cxsltl:namespaceUriIsNot="{#null#}">
					<cxsltl:static cxsltl:wrap="none">{</cxsltl:static>
					<cxsltl:namespaceUri cxsltl:wrap="none"/>
					<cxsltl:static cxsltl:wrap="none">}</cxsltl:static>
				</cxsltl:group>
				<cxsltl:local cxsltl:wrap="none"/>
				<cxsltl:static cxsltl:wrap="none">&gt;</cxsltl:static>
			</cxsltl:group>
			<cxsltl:static cxsltl:alias="shape">ellipse</cxsltl:static>
			<cxsltl:static cxsltl:alias="style">filled</cxsltl:static>
			<cxsltl:static cxsltl:alias="fillcolor">#00FFFF</cxsltl:static>
		</cxsltl:group>
		<cxsltl:group cxsltl:typeIs="text" cxsltl:wrap="none">
			<cxsltl:group cxsltl:alias="label">
				<cxsltl:substring length="30" cxsltl:wrap="none">
					<cxsltl:string cxsltl:wrap="none"/>
				</cxsltl:substring>
				<cxsltl:static cxsltl:wrap="none" cxsltl:lengthIs="31-">…</cxsltl:static>
			</cxsltl:group>
			<cxsltl:string cxsltl:alias="tooltip"/>
			<cxsltl:static cxsltl:alias="shape">box</cxsltl:static>
			<cxsltl:static cxsltl:alias="style">filled</cxsltl:static>
			<cxsltl:static cxsltl:alias="fillcolor">#FFFF66</cxsltl:static>
		</cxsltl:group>
		<cxsltl:group cxsltl:typeIs="comment" cxsltl:wrap="none">
			<cxsltl:group cxsltl:alias="label">
				<cxsltl:static cxsltl:wrap="none">&lt;!--</cxsltl:static>
				<cxsltl:substring length="25" cxsltl:wrap="none">
					<cxsltl:string cxsltl:wrap="none"/>
				</cxsltl:substring>
				<cxsltl:static cxsltl:wrap="none" cxsltl:lengthIs="26-">…</cxsltl:static>
				<cxsltl:static cxsltl:wrap="none">--&gt;</cxsltl:static>
			</cxsltl:group>
			<cxsltl:group cxsltl:alias="tooltip">
				<cxsltl:static cxsltl:wrap="none">&lt;!--</cxsltl:static>
				<cxsltl:string cxsltl:wrap="none"/>
				<cxsltl:static cxsltl:wrap="none">--&gt;</cxsltl:static>
			</cxsltl:group>
			<cxsltl:group cxsltl:alias="tooltip">
				<cxsltl:static cxsltl:wrap="none">&lt;!--</cxsltl:static>
				<cxsltl:string cxsltl:wrap="none"/>
				<cxsltl:static cxsltl:wrap="none">--&gt;</cxsltl:static>
			</cxsltl:group>
			<cxsltl:static cxsltl:alias="shape">parallelogram</cxsltl:static>
			<cxsltl:static cxsltl:alias="style">filled</cxsltl:static>
			<cxsltl:static cxsltl:alias="fillcolor">#DDDDDD</cxsltl:static>
		</cxsltl:group>
		<cxsltl:group cxsltl:typeIs="processing-instruction" cxsltl:wrap="none">
			<cxsltl:group cxsltl:alias="label">
				<cxsltl:static cxsltl:wrap="none">&lt;?</cxsltl:static>
				<cxsltl:name cxsltl:wrap="none"/>
				<cxsltl:static cxsltl:wrap="none">?&gt;</cxsltl:static>
			</cxsltl:group>
			<cxsltl:group cxsltl:alias="tooltip">
				<cxsltl:static cxsltl:wrap="none">&lt;?</cxsltl:static>
				<cxsltl:name cxsltl:wrap="none"/>
				<cxsltl:static cxsltl:wrap="none" xml:space="preserve" cxsltl:lengthIsNot="0"> </cxsltl:static>
				<cxsltl:string cxsltl:wrap="none"/>
				<cxsltl:static cxsltl:wrap="none">?&gt;</cxsltl:static>
			</cxsltl:group>
			<cxsltl:static cxsltl:alias="shape">octagon</cxsltl:static>
			<cxsltl:static cxsltl:alias="style">filled</cxsltl:static>
			<cxsltl:static cxsltl:alias="fillcolor">#FFCCFF</cxsltl:static>
			<cxsltl:static cxsltl:alias="peripheries">2</cxsltl:static>
		</cxsltl:group>
		<cxsltl:group cxsltl:typeIs="attribute" cxsltl:wrap="none">
			<cxsltl:group cxsltl:alias="label">
				<cxsltl:substring length="30" cxsltl:wrap="none">
					<cxsltl:string cxsltl:wrap="none"/>
				</cxsltl:substring>
				<cxsltl:static cxsltl:wrap="none" cxsltl:lengthIs="31-">…</cxsltl:static>
			</cxsltl:group>
			<cxsltl:string cxsltl:alias="tooltip"/>
			<cxsltl:static cxsltl:alias="shape">box</cxsltl:static>
			<cxsltl:static cxsltl:alias="style">filled</cxsltl:static>
			<cxsltl:static cxsltl:alias="fillcolor">#FFCC66</cxsltl:static>
		</cxsltl:group>
		<cxsltl:group cxsltl:typeIs="namespace" cxsltl:wrap="none">
			<cxsltl:group cxsltl:alias="label">
				<cxsltl:substring length="30" cxsltl:wrap="none">
					<cxsltl:string cxsltl:wrap="none"/>
				</cxsltl:substring>
				<cxsltl:static cxsltl:wrap="none" cxsltl:lengthIs="31-">…</cxsltl:static>
			</cxsltl:group>
			<cxsltl:string cxsltl:alias="tooltip"/>
			<cxsltl:static cxsltl:alias="shape">box</cxsltl:static>
			<cxsltl:static cxsltl:alias="style">filled</cxsltl:static>
			<cxsltl:static cxsltl:alias="fillcolor">#FFCCFF</cxsltl:static>
		</cxsltl:group>
	</cxsltl:config>

	<xsltdoc:Element rdf:about="#cxsltl.xmlToDot.config.path">
		<xsltdoc:short>ノード間のスタイル付けノード</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:config xml:id="cxsltl.xmlToDot.config.path">
		<cxsltl:group cxsltl:wrap="none" cxsltl:processing="alias" cxsltl:typeIsNot="root">
			<cxsltl:id cxsltl:xpath=".."/>
			<cxsltl:static cxsltl:wrap="none" xml:space="preserve"> -&gt; </cxsltl:static>
			<cxsltl:id/>
		</cxsltl:group>
		<cxsltl:currentXpath cxsltl:alias="label"/>
		<cxsltl:absoluteXpath cxsltl:alias="labeltooltip"/>
		<cxsltl:group cxsltl:alias="URL">
			<cxsltl:static cxsltl:wrap="none">#</cxsltl:static>
			<cxsltl:id cxsltl:wrap="none"/>
		</cxsltl:group>
		<cxsltl:static cxsltl:alias="arrowhead" cxsltl:typeIs="attribute namespace" cxsltl:typeIsNot="root">crow</cxsltl:static>
	</cxsltl:config>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードをDOT言語に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			DOT言語への変換はxsl:call-templateを使用しcxsltl:xmlToDot.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="JSONに変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:dot.generate.graph">
			<xsl:with-param name="name" select="$cxsltl:xmlToDot.name"/>
			<xsl:with-param name="graph" select="$cxsltl:xmlToDot.graph"/>
			<xsl:with-param name="content">
				<xsl:call-template name="cxsltl:dot.generate.node">
					<xsl:with-param name="node">graph</xsl:with-param>
					<xsl:with-param name="attribute">rankdir="LR"</xsl:with-param>
					<xsl:with-param name="indent" select="$cxsltl:xmlToDot.dot.indent"/>
				</xsl:call-template>

				<xsl:call-template name="cxsltl:xmlToDot.convert">
					<xsl:with-param name="node" select="//self::node() | //@*"/>
				</xsl:call-template>

				<xsl:for-each select="//namespace::*[not(starts-with(translate(name(), 'XML', 'xml'), 'xml'))]">
					<xsl:if test="not(. = parent::*/parent::*/namespace::*[name() = name(current())])">
						<xsl:call-template name="cxsltl:xmlToDot.convert"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for callProperty
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>プロパティ呼び出し用のノードのテンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | text() | comment() | processing-instruction() | @*" mode="cxsltl:xmlToDot.callProperty"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象とするノードにプロパティ要素を適用しDOT言語に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="DOT言語に変換されたノード情報を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*" mode="cxsltl:xmlToDot.callProperty">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>
		<xsl:param name="ancestorWrap">string</xsl:param>
		<xsl:param name="position" select="0"/>
		<xsl:param name="last" select="0"/>

		<xsl:variable name="valid">
			<xsl:call-template name="cxsltl:node.test.check">
				<xsl:with-param name="binary">
					<xsl:apply-templates select="@*" mode="cxsltl:xmlToDot.validation">
						<xsl:with-param name="node" select="$node"/>
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
			<xsl:variable name="nextAncestorWrap">
				<xsl:choose>
					<xsl:when test="@cxsltl:wrap = 'none'">
						<xsl:value-of select="$ancestorWrap"/>
					</xsl:when>
					<xsl:when test="@cxsltl:wrap">
						<xsl:value-of select="@cxsltl:wrap"/>
					</xsl:when>
					<xsl:otherwise>string</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="result">
				<xsl:choose>
					<xsl:when test="@cxsltl:xpath">
						<xsl:call-template name="cxsltl:xpath.parse.acsess">
							<xsl:with-param name="callback" select="$cxsltl:xmlToDot.self/xsl:template[@name = 'cxsltl:xmlToDot.callback.property']"/>
							<xsl:with-param name="node" select="$node"/>
							<xsl:with-param name="xpath" select="@cxsltl:xpath"/>
							<xsl:with-param name="param1" select="."/>
							<xsl:with-param name="param2" select="$deny"/>
							<xsl:with-param name="param3" select="$nextAncestorWrap"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="cxsltl:xmlToDot.property">
							<xsl:with-param name="node" select="$node"/>
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="ancestorWrap" select="$nextAncestorWrap"/>
							<xsl:with-param name="position" select="$position"/>
							<xsl:with-param name="last" select="$last"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="@cxsltl:wrap = 'none'">
					<xsl:value-of select="$result"/>
				</xsl:when>
				<xsl:when test="$ancestorWrap = 'object'">
					<xsl:call-template name="cxsltl:dot.generate.attribute">
						<xsl:with-param name="name">
							<xsl:call-template name="cxsltl:xmlToDot.callAlias">
								<xsl:with-param name="node" select="$node"/>
								<xsl:with-param name="deny" select="$deny"/>
								<xsl:with-param name="position" select="$position"/>
								<xsl:with-param name="last" select="$last"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="value" select="$result"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cxsltl:dot.generate.escape">
						<xsl:with-param name="string" select="$result"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- ==============================
		## xsl:template for property
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>cxsltl:node.propertyに処理を渡す</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="cxsltl:node.propertyの処理結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToDot.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:apply-templates select="." mode="cxsltl:node.property">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$last"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>$nodeから絶対XPathを作成する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnString xsltdoc:short="XPath"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:absoluteXpath" mode="cxsltl:xmlToDot.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>

		<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
			<xsl:with-param name="node" select="$node/ancestor-or-self::node()"/>
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>$nodeから現在のXPathを作成する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnString xsltdoc:short="XPath"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:currentXpath" mode="cxsltl:xmlToDot.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>

		<xsl:call-template name="cxsltl:xpath.generate.nodeXPath">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>プロパティ要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="@xlink:hrefのリンク先のプロパティ要素とcxsltl:groupの子要素のプロパティをDOT言語に変換して返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:group" mode="cxsltl:xmlToDot.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>
		<xsl:param name="ancestorWrap">string</xsl:param>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:call-template name="cxsltl:xmlToDot.propertyProcessing">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="ancestorWrap" select="$ancestorWrap"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$last"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>部分文字列を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="プロパティの結果を部分文字列として返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:substring" mode="cxsltl:xmlToDot.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xmlToDot.propertyProcessing">
				<xsl:with-param name="node" select="$node"/>
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="ancestorWrap">string</xsl:with-param>
				<xsl:with-param name="position" select="$position"/>
				<xsl:with-param name="last" select="$last"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="start">
			<xsl:call-template name="cxsltl:common.chooseAndPrint">
				<xsl:with-param name="test0" select="string(@start)"/>
				<xsl:with-param name="test1">1</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="length">
			<xsl:call-template name="cxsltl:common.chooseAndPrint">
				<xsl:with-param name="test0" select="string(@length)"/>
				<xsl:with-param name="test1" select="string-length($result)"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="substring($result, $start, $length)"/>
	</xsl:template>

	<!-- ==============================
		## xsl:template for alias
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>エイリアス用のノードのテンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToDot.alias"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>プロパティ要素のエイリアス名を取得する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="エイリアス名を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:alias" mode="cxsltl:xmlToDot.alias">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- ==============================
		## xsl:template for validation
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>検査用のノードのテンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="node() | @*" mode="cxsltl:xmlToDot.validation">
		<xsl:param name="node" select="."/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:apply-templates select="." mode="cxsltl:node.test">
			<xsl:with-param name="node" select="$node"/>
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
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:returnString xsltdoc:short="エイリアスを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToDot.callAlias">
		<xsl:param name="property" select="."/>
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:choose>
			<xsl:when test="$property/@cxsltl:alias or $property/*[@cxsltl:processing = 'alias']">
				<xsl:apply-templates select="$property/@cxsltl:alias" mode="cxsltl:xmlToDot.alias"/>

				<xsl:apply-templates select="$property/*[@cxsltl:processing = 'alias']" mode="cxsltl:xmlToDot.callProperty">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="ancestorWrap">string</xsl:with-param>
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
		<xsltdoc:short>ノードをDOT言語に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="config" xsltdoc:short="設定用のノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="DOT言語のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="DOT言語の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="DOT言語に変換されたノード情報を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToDot.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="config" select="$cxsltl:xmlToDot.config"/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>
		<xsl:param name="indent" select="$cxsltl:xmlToDot.dot.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToDot.dot.eol"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:for-each select="$config[self::cxsltl:config]">
			<xsl:call-template name="cxsltl:xmlToDot.propertyProcessing">
				<xsl:with-param name="node" select="$node[count(. | $deny) != $denyCount]"/>
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="eol" select="$eol"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$property/@xlink:hrefと$property/*を処理する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="property" xsltdoc:short="プロパティ要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="ancestorWrap" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="DOT言語のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="DOT言語の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="DOT言語に変換したノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToDot.propertyProcessing">
		<xsl:param name="property" select="."/>
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToDot.deny"/>
		<xsl:param name="ancestorWrap">string</xsl:param>
		<xsl:param name="position" select="0"/>
		<xsl:param name="last" select="0"/>
		<xsl:param name="indent" select="$cxsltl:xmlToDot.dot.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToDot.dot.eol"/>

		<xsl:for-each select="$node">
			<xsl:sort select="last() - position() * ($property/@cxsltl:order = 'desc')" data-type="number"/>

			<xsl:variable name="positionX" select="$position + (position() * not($position))"/>
			<xsl:variable name="lastX" select="$last + (last() * not($last))"/>

			<xsl:variable name="wrapType">
				<xsl:choose>
					<xsl:when test="$property[self::cxsltl:config]">object</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$ancestorWrap"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="result">
				<xsl:choose>
					<xsl:when test="substring-after($property/@xlink:href, '#')">
						<xsl:apply-templates select="document(substring-before($property/@xlink:href, '#'), $property)//self::*[@xml:id = substring-after($property/@xlink:href, '#')]/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToDot.callProperty">
							<xsl:with-param name="node" select="."/>
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="position" select="$positionX"/>
							<xsl:with-param name="last" select="$lastX"/>
							<xsl:with-param name="ancestorWrap" select="$wrapType"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$property/@xlink:href">
						<xsl:apply-templates select="document($property/@xlink:href, $property)/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToDot.callProperty">
							<xsl:with-param name="node" select="."/>
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="position" select="$positionX"/>
							<xsl:with-param name="last" select="$lastX"/>
							<xsl:with-param name="ancestorWrap" select="$wrapType"/>
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>

				<xsl:apply-templates select="$property/*[not(@cxsltl:processing) or @cxsltl:processing = 'property']" mode="cxsltl:xmlToDot.callProperty">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="position" select="$positionX"/>
					<xsl:with-param name="last" select="$lastX"/>
					<xsl:with-param name="ancestorWrap" select="$wrapType"/>
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$property[self::cxsltl:config]">
					<xsl:variable name="alias">
						<xsl:apply-templates select="$property/*[@cxsltl:processing = 'alias']" mode="cxsltl:xmlToDot.callProperty">
							<xsl:with-param name="node" select="."/>
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="position" select="$positionX"/>
							<xsl:with-param name="last" select="$lastX"/>
							<xsl:with-param name="ancestorWrap">string</xsl:with-param>
						</xsl:apply-templates>
					</xsl:variable>

					<xsl:if test="string($alias)">
						<xsl:call-template name="cxsltl:dot.generate.node">
							<xsl:with-param name="node" select="$alias"/>
							<xsl:with-param name="nodeEscape" select="false()"/>
							<xsl:with-param name="attribute" select="$result"/>
							<xsl:with-param name="indent" select="$indent"/>
							<xsl:with-param name="eol" select="$eol"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$result"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>ノード情報をDOT言語に変換する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:xpath.parse.acsessにて呼び出されるコールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param1" xsltdoc:short="プロパティ要素"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param2" xsltdoc:short="除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="param3" xsltdoc:short="祖先ノードのタイプ"/>
		<xsltdoc:returnString xsltdoc:short="DOT言語に変換されたノード情報を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:xmlToDot.callback.property']" mode="cxsltl:callback" name="cxsltl:xmlToDot.callback.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>

		<xsl:variable name="denyCount" select="count($param2)"/>

		<xsl:apply-templates select="$param1" mode="cxsltl:xmlToDot.property">
			<xsl:with-param name="node" select="$node[count(. | $param2) != $denyCount]"/>
			<xsl:with-param name="deny" select="$param2"/>
			<xsl:with-param name="ancestorWrap" select="$param3"/>
			<xsl:with-param name="position" select="0"/>
			<xsl:with-param name="last" select="0"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>