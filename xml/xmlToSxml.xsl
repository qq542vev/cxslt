<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="application/xslt+xml" charset="UTF-8" title="SXML" href="xmlToSxml.xsl" alternate="yes"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xmlToSxml.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLで書かれたファイルをSXMLに変換するXSLT</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、デフォルトでXMLのルートノード以下の全てのノードを文字列に変換する。
			{xsl:import}, {xsl:include}を使用し外部のスタイルシートとして使用することも出来る。
		</xsltdoc:detail>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>a要素以下の全てのノードをSXMLに変換するコードである</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:template match="/">
					<xsl:call-template name="cxsltl:xmlToSxml.convert">
						<xsl:with-param name="node" select="/a/node()"/>
					</xsl:call-template>
				</xsl:template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-06-17</xsltdoc:version>
		<xsltdoc:since>2010-11-29T06:03:14+00:00</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:source rdf:resource="http://svn.coderepos.org/share/lang/xslt/misc/xml-to-sexp.xsl"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/xml/"/>
		<xsltdoc:output rdf:resource="http://okmij.org/ftp/Scheme/SXML.html"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/sxml"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xmlToSxml.deny" select="/.."/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでの無名名前空間接頭辞</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSxml.defaultNsPrefix">defaltNs</xsl:param>

	<xsltdoc:NumberParam>
		<xsltdoc:short>デフォルトでのS式の深さ</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NumberParam>

	<xsl:param name="cxsltl:xmlToSxml.sexp.depth" select="0"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのS式のインデント文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSxml.sexp.indent" select="'&#x9;'"/>

	<xsltdoc:StringParam>
		<xsltdoc:short>デフォルトでのS式の改行文字</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:StringParam>

	<xsl:param name="cxsltl:xmlToSxml.sexp.eol" select="'&#xA;'"/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			SXMLへの変換はxsl:call-templateを使用し、cxsltl:xmlToSxml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:xmlToSxml.convert"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="defaltNsPrefix" xsltdoc:short="無名名前空間接頭辞"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換したルートノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/" mode="cxsltl:xmlToSxml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSxml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaltNsPrefix" select="$cxsltl:xmlToSxml.defaultNsPrefix"/>
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:value-of select="$eol"/>

		<xsl:call-template name="cxsltl:string.repeat">
			<xsl:with-param name="string" select="$indent"/>
			<xsl:with-param name="multiplier" select="$depth"/>
		</xsl:call-template>

		<xsl:text>(*TOP*</xsl:text>

		<xsl:apply-templates select="processing-instruction()[count(. | $deny) != $denyCount][not(preceding-sibling::*)]" mode="cxsltl:xmlToSxml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaltNsPrefix" select="$defaltNsPrefix"/>
			<xsl:with-param name="depth" select="$depth + 1"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="comment()[count(. | $deny) != $denyCount][not(preceding-sibling::*)]" mode="cxsltl:xmlToSxml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaltNsPrefix" select="$defaltNsPrefix"/>
			<xsl:with-param name="depth" select="$depth + 1"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToSxml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaltNsPrefix" select="$defaltNsPrefix"/>
			<xsl:with-param name="depth" select="$depth + 1"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>

		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素ノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="defaltNsPrefix" xsltdoc:short="無名名前空間接頭辞"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換した要素ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*" mode="cxsltl:xmlToSxml.converter">
		<xsl:param name="deny" select="$cxsltl:xmlToSxml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaltNsPrefix" select="$cxsltl:xmlToSxml.defaultNsPrefix"/>
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:call-template name="cxsltl:xmlToSxml.indent">
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:call-template>

		<xsl:text>(</xsl:text>

		<xsl:if test="namespace-uri() and local-name() = name()">
			<xsl:value-of select="concat($defaltNsPrefix, ':')"/>
		</xsl:if>

		<xsl:value-of select="name()"/>

		<xsl:variable name="namespace">
			<xsl:call-template name="cxsltl:xmlToSxml.namespaceAttribute">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
				<xsl:with-param name="defaltNsPrefix" select="$defaltNsPrefix"/>
				<xsl:with-param name="depth" select="$depth + 2"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="eol" select="$eol"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="string($namespace) or @*[count(. | $deny) != $denyCount]">
			<xsl:text> (@</xsl:text>

			<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToSxml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
				<xsl:with-param name="defaltNsPrefix" select="$defaltNsPrefix"/>
				<xsl:with-param name="depth" select="$depth + 2"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="eol" select="$eol"/>
			</xsl:apply-templates>

			<xsl:value-of select="$namespace"/>

			<xsl:text>)</xsl:text>
		</xsl:if>

		<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToSxml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaltNsPrefix" select="$defaltNsPrefix"/>
			<xsl:with-param name="depth" select="$depth + 1"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:apply-templates>

		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>属性ノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換した属性ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@*" mode="cxsltl:xmlToSxml.converter">
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:call-template name="cxsltl:xmlToSxml.indent">
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:call-template>

		<xsl:text>(</xsl:text>

		<xsl:value-of select="concat(name(), ' ')"/>

		<xsl:call-template name="cxsltl:xmlToSxml.escape"/>

		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換したテキストノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text()" mode="cxsltl:xmlToSxml.converter">
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:call-template name="cxsltl:xmlToSxml.indent">
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:call-template>

		<xsl:call-template name="cxsltl:xmlToSxml.escape"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>コメントノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換したコメントノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="comment()" mode="cxsltl:xmlToSxml.converter">
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:call-template name="cxsltl:xmlToSxml.indent">
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:call-template>

		<xsl:text>(*COMMENT* </xsl:text>

		<xsl:call-template name="cxsltl:xmlToSxml.escape"/>

		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>処理命令ノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換した処理命令ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="processing-instruction()" mode="cxsltl:xmlToSxml.converter">
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:call-template name="cxsltl:xmlToSxml.indent">
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="eol" select="$eol"/>
		</xsl:call-template>

		<xsl:value-of select="concat('(*PI* ', name(), ' ')"/>

		<xsl:call-template name="cxsltl:xmlToSxml.escape"/>

		<xsl:text>)</xsl:text>
	</xsl:template>

	<!-- ==============================
		# Named xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>任意のノードセットをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="変換対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="defaltNsPrefix" xsltdoc:short="無名名前空間接頭辞"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換したノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSxml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToSxml.deny"/>
		<xsl:param name="defaltNsPrefix" select="$cxsltl:xmlToSxml.defaultNsPrefix"/>
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:string.leftTrim">
			<xsl:with-param name="string">
				<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:xmlToSxml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
					<xsl:with-param name="defaltNsPrefix" select="$defaltNsPrefix"/>
					<xsl:with-param name="depth" select="$depth"/>
					<xsl:with-param name="indent" select="$indent"/>
					<xsl:with-param name="eol" select="$eol"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列をバックスラッシュでエスケープする</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:returnString xsltdoc:short="エスケープした文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSxml.escape">
		<xsl:param name="string" select="."/>

		<xsl:text>"</xsl:text>

		<xsl:call-template name="cxsltl:string.backslashEscape">
			<xsl:with-param name="string" select="$string"/>
		</xsl:call-template>

		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>インデントを生成する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="インデントを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSxml.indent">
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:choose>
			<xsl:when test="string($indent)">
				<xsl:value-of select="$eol"/>

				<xsl:call-template name="cxsltl:string.repeat">
					<xsl:with-param name="string" select="$indent"/>
					<xsl:with-param name="multiplier" select="$depth"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>名前空間ノードをSXMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="element" xsltdoc:short="対象とする要素ノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramString xsltdoc:name="defaltNsPrefix" xsltdoc:short="無名名前空間接頭辞"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="S式の深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="S式のインデント文字"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="S式の改行文字"/>
		<xsltdoc:returnString xsltdoc:short="SXMLに変換した名前空間ノードを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xmlToSxml.namespaceAttribute">
		<xsl:param name="element" select="."/>
		<xsl:param name="deny" select="$cxsltl:xmlToSxml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaltNsPrefix" select="$cxsltl:xmlToSxml.defaultNsPrefix"/>
		<xsl:param name="depth" select="$cxsltl:xmlToSxml.sexp.depth"/>
		<xsl:param name="indent" select="$cxsltl:xmlToSxml.sexp.indent"/>
		<xsl:param name="eol" select="$cxsltl:xmlToSxml.sexp.eol"/>

		<xsl:variable name="result">
			<xsl:for-each select="$element/namespace::*[count(. | $deny) != $denyCount][not(starts-with(translate(name(), 'XML', 'xml'), 'xml'))]">
				<xsl:if test="not(. = parent::*/parent::*/namespace::*[count(. | $deny) != $denyCount][name() = name(current())])">
					<xsl:call-template name="cxsltl:xmlToSxml.indent">
						<xsl:with-param name="depth" select="$depth + 1"/>
						<xsl:with-param name="indent" select="$indent"/>
						<xsl:with-param name="eol" select="$eol"/>
					</xsl:call-template>

					<xsl:text>(</xsl:text>

					<xsl:if test="not(name())">
						<xsl:value-of select="$defaltNsPrefix"/>
					</xsl:if>

					<xsl:value-of select="concat(name(), ' &quot;', normalize-space(), '&quot;')"/>

					<xsl:if test="name()">
						<xsl:value-of select="concat(' ', name())"/>
					</xsl:if>

					<xsl:text>)</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string($result)">
			<xsl:call-template name="cxsltl:xmlToSxml.indent">
				<xsl:with-param name="depth" select="$depth"/>
				<xsl:with-param name="indent" select="$indent"/>
				<xsl:with-param name="eol" select="$eol"/>
			</xsl:call-template>

			<xsl:value-of select="concat('(@ (*NAMESPACES*', $result, '))')"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>