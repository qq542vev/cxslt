<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.xhtmlToHtmlText.stylesheet"
	exclude-result-prefixes="cxsltl rdf xhtml xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/html/generate.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>
	<xsl:import href="../xml/xmlToText.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts XHTML format into HTML format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">XHTML 形式で書かれたファイルを HTML 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-17</xsltdoc:version>
		<xsltdoc:since>2011-11-17</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.w3.org/TR/html51/"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/html51/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output
		method="html"
		version="5.1"
		encoding="UTF-8"
		indent="no"
		media-type="text/html"
	/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:xhtmlToHtmlText.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のXHTMLの要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			HTMLへの変換はxsl:call-templateを使用しcxsltl:xhtmlToHtmlText.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xhtmlToHtmlText.convert">
				<xsl:with-param name="node" select="node()"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>]]></xsl:text>

		<xsl:value-of disable-output-escaping="yes" select="$result"/>
	</xsl:template>

	<!-- ==============================
		## xsl:template for XHTML element
	 ============================== -->

	<xsl:template match="*" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:param name="deny" select="$cxsltl:xhtmlToHtmlText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:xml.generate.element">
			<xsl:with-param name="name" select="name()"/>
			<xsl:with-param name="attribute">
				<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:xhtmlToHtmlText.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<xsl:variable name="ancestorXhtml" select="not(ancestor::*[not(self::xhtml:*)][count(. | $deny) != $denyCount])"/>

				<xsl:call-template name="cxsltl:xmlToText.namespaceAttribute">
					<xsl:with-param name="deny" select="$deny | ancestor::*[$ancestorXhtml]/namespace::*"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:xhtmlToHtmlText.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{xhtml:*}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="xhtml:*" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:param name="deny" select="$cxsltl:xhtmlToHtmlText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:call-template name="cxsltl:html.generate.element">
			<xsl:with-param name="name" select="local-name()"/>
			<xsl:with-param name="attribute">
				<xsl:apply-templates select="@*[count(. | $deny) != $denyCount]" mode="cxsltl:xhtmlToHtmlText.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="node()[count(. | $deny) != $denyCount]" mode="cxsltl:xhtmlToHtmlText.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>属性のベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@*" mode="cxsltl:xhtmlToHtmlText.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>属性をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="*[not(self::xhtml:*)]/@*" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:call-template name="cxsltl:xml.generate.attribute"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>属性をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="属性を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="xhtml:*/@*[not(namespace-uri())]" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:call-template name="cxsltl:xml.generate.attribute"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードをHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="エスケープしたテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text()" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:call-template name="cxsltl:xml.generate.escape"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{xhtml:script/text() | xhtml:style/text()}をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="テキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="xhtml:script/text() | xhtml:style/text()" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>コメントノードをHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="コメントを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="comment()" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:call-template name="cxsltl:xml.generate.comment"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>処理命令ノードをHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="処理命令を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="processing-instruction()" mode="cxsltl:xhtmlToHtmlText.converter">
		<xsl:call-template name="cxsltl:html.generate.processingInstruction"/>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XHTMLをHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnString xsltdoc:short="XHTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xhtmlToHtmlText.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:xhtmlToHtmlText.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:xhtmlToHtmlText.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>