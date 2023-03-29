<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="Plain Text" href="xmlToText.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToText.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/line.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>
	<xsl:import href="../library/xml/parse.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルを文字列に変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードを文字列に変換する。
			{xsl:import}, {xsl:include}を使用し外部のスタイルシートとして使用することも出来る。
		</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>a要素以下の全てのノードを文字列に変換するコードである</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:xmlToText.convert">
						<xsl:with-param name="node" select="/a/node()"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-06-10</xsltdoc:version>
		<xsltdoc:since>2011-12-12</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="https://en.wikipedia.org/wiki/Text_file"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToText.deny" select="/.."/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのCDATAセクションのテキストノード</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToText.cdata" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのXML宣言</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToText.xmlDeclaration"><![CDATA[<?xml version="1.0" encoding="UTF-8">]]></xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでの文書型宣言</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToText.dtd"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでの改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToText.eol" select="'&#xA;'"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでの行番号の形式</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToText.format">rn</xsl:param>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでの行番号の初期値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToText.start" select="1"/>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでの行番号の加算値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToText.increment" select="1"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでの行の接頭辞</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToText.prefix"> | </xsl:param>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでの行の接尾辞</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToText.suffix"/>

	<!-- ==============================
		# Ruled Template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードを文字列に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			文字列への変換はxsl:call-templateを使用し、cxsltl:xmlToText.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="文字列に変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:xmlToText.convert"/>
	</xsl:template>

	<!-- ==============================
		## xsl:template for XML node
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>XML宣言を行い、ルートノードの子ノードにパターンマッチングしたxsl:templateを適用する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="xmlDeclaration" xsltdoc:short="XML宣言"/>
		<xsltdoc:paramString xsltdoc:name="dtd" xsltdoc:short="文書型宣言"/>
		<xsltdoc:returnString xsltdoc:short="文字列に変換したノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/" mode="cxsltl:xmlToText.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToText.cdata"/>
		<xsl:param name="xmlDeclaration" select="$cxsltl:xmlToText.xmlDeclaration"/>
		<xsl:param name="dtd" select="$cxsltl:xmlToText.dtd"/>

		<xsl:if test="string($xmlDeclaration)">
			<xsl:value-of select="$xmlDeclaration"/>

			<xsl:text>&#xA;</xsl:text>
		</xsl:if>

		<xsl:for-each select="*/preceding-sibling::node()[count(. | $deny) != $denyCount]">
			<xsl:apply-templates select="self::node()" mode="cxsltl:xmlToText.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
				<xsl:with-param name="cdata" select="$cdata"/>
			</xsl:apply-templates>

			<xsl:text>&#xA;</xsl:text>
		</xsl:for-each>

		<xsl:if test="string($dtd)">
			<xsl:value-of select="$dtd"/>

			<xsl:text>&#xA;</xsl:text>
		</xsl:if>

		<xsl:for-each select="*[count(. | $deny) != $denyCount] | */following-sibling::node()[count(. | $deny) != $denyCount]">
			<xsl:apply-templates select="self::node()" mode="cxsltl:xmlToText.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
				<xsl:with-param name="cdata" select="$cdata"/>
			</xsl:apply-templates>

			<xsl:if test="position() != last()">
				<xsl:text>&#xA;</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素ノードを文字列に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:returnString xsltdoc:short="文字列に変換した要素ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*" mode="cxsltl:xmlToText.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToText.cdata"/>

		<xsl:call-template name="cxsltl:xml.generate.element">
			<xsl:with-param name="attribute">
				<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToText.converter"/>

				<xsl:call-template name="cxsltl:xmlToText.namespaceAttribute">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
					<xsl:with-param name="cdata" select="$cdata"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToText.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
					<xsl:with-param name="cdata" select="$cdata"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>属性ノードを文字列に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="文字列に変換した属性ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@*" mode="cxsltl:xmlToText.converter">
		<xsl:call-template name="cxsltl:xml.generate.attribute"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードを文字列に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:returnString xsltdoc:short="文字列に変換したテキストノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text()" mode="cxsltl:xmlToText.converter">
		<xsl:param name="cdata" select="$cxsltl:xmlToText.cdata"/>

		<xsl:choose>
			<xsl:when test="$cdata[count(. | current()) = 1] and not(contains(., ']]&gt;'))">
				<xsl:call-template name="cxsltl:xml.generate.cdata"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:xml.generate.escape"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>コメントノードを文字列に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="文字列に変換したコメントノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="comment()" mode="cxsltl:xmlToText.converter">
		<xsl:call-template name="cxsltl:xml.generate.comment"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>処理命令ノードを文字列に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="文字列に変換した処理命令ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="processing-instruction()" mode="cxsltl:xmlToText.converter">
		<xsl:call-template name="cxsltl:xml.generate.processingInstruction">
			<xsl:with-param name="value">
				<xsl:choose>
					<xsl:when test="name() = 'oasis-xml-catalog' or name() = 'xml-model' or name() = 'xml-stylesheet'">
						<xsl:call-template name="cxsltl:xml.parse.attributeSplit"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>任意のノードセットを文字列に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="変換対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="cdata" xsltdoc:short="CDATAセクションとするテキストノード"/>
		<xsltdoc:paramString xsltdoc:name="xmlDeclaration" xsltdoc:short="XML宣言"/>
		<xsltdoc:paramString xsltdoc:name="dtd" xsltdoc:short="文書型宣言"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行コード"/>
		<xsltdoc:paramString xsltdoc:name="format" xsltdoc:short="行番号の形式"/>
		<xsltdoc:paramNumber xsltdoc:name="start" xsltdoc:short="行番号の初期値"/>
		<xsltdoc:paramNumber xsltdoc:name="increment" xsltdoc:short="行番号の加算値"/>
		<xsltdoc:paramString xsltdoc:name="prefix" xsltdoc:short="行の接頭辞"/>
		<xsltdoc:returnString xsltdoc:short="ノードの文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToText.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToText.deny"/>
		<xsl:param name="cdata" select="$cxsltl:xmlToText.cdata"/>
		<xsl:param name="xmlDeclaration" select="$cxsltl:xmlToText.xmlDeclaration"/>
		<xsl:param name="dtd" select="$cxsltl:xmlToText.dtd"/>
		<xsl:param name="eol" select="$cxsltl:xmlToText.eol"/>
		<xsl:param name="format" select="$cxsltl:xmlToText.format"/>
		<xsl:param name="start" select="$cxsltl:xmlToText.start"/>
		<xsl:param name="increment" select="$cxsltl:xmlToText.increment"/>
		<xsl:param name="prefix" select="$cxsltl:xmlToText.prefix"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:variable name="result">
			<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToText.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
				<xsl:with-param name="cdata" select="$cdata"/>
				<xsl:with-param name="xmlDeclaration" select="$xmlDeclaration"/>
				<xsl:with-param name="dtd" select="$dtd"/>
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$start &lt; 0">
				<xsl:call-template name="cxsltl:line.normalize">
					<xsl:with-param name="string" select="$result"/>
					<xsl:with-param name="eol" select="$eol"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:line.number">
					<xsl:with-param name="string" select="$result"/>
					<xsl:with-param name="format" select="$format"/>
					<xsl:with-param name="start" select="$start"/>
					<xsl:with-param name="increment" select="$increment"/>
					<xsl:with-param name="prefix" select="$prefix"/>
					<xsl:with-param name="eol" select="$eol"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>名前空間ノードを文字列に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="element" xsltdoc:short="対象とする要素ノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="名前空間ノードの文字列を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToText.namespaceAttribute">
		<xsl:param name="element" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:for-each select="$element/namespace::*[count(. | $deny) != $denyCount][not(starts-with(translate(name(), 'XML', 'xml'), 'xml'))]">
			<xsl:if test="not(. = parent::*/parent::*/namespace::*[count(. | $deny) != $denyCount][name() = name(current())])">
				<xsl:call-template name="cxsltl:xml.generate.attribute">
					<xsl:with-param name="name">
						<xsl:text>xmlns</xsl:text>

						<xsl:if test="name()">
							<xsl:value-of select="concat(':', name())"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="value" select="normalize-space()"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="$element/parent::*/namespace::*[count(. | $deny) != $denyCount]">
			<xsl:if test="not($element/namespace::*[name() = name(current())])">
				<xsl:call-template name="cxsltl:xml.generate.attribute">
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
</xsl:stylesheet>