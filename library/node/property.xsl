<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="common.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>ノードのプロパティを処理するXSLT</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-05-11</xsltdoc:version>
		<xsltdoc:since>2017-04-25</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Template for node property
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="position" select="0"/>
		<xsl:param name="last" select="0"/>

		<xsl:apply-templates select="node() | @*" mode="cxsltl:node.property">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$last"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:node.property"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノード数を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="ノード数を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-count"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:count" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="count($node)"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>現在のノードの深度を取得する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:return xsltdoc:short="現在のノードの深度を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:depth" mode="cxsltl:node.property">
		<xsl:param name="depth" select="0"/>

		<xsl:value-of select="$depth"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの展開名(名前空間URI + ローカル名)を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードの展開名を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-local-name"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-namespace-uri"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:expanded" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.expanded']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの一意的なidを取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードのidを返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xslt#function-generate-id"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:id" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.id']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの文脈サイズを取得する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:return xsltdoc:short="文脈サイズを返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-last"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:last" mode="cxsltl:node.property">
		<xsl:param name="last" select="0"/>

		<xsl:value-of select="$last"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの文字数を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードの文字数を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-string-length"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:length" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.length']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードのローカル名を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードのローカル名を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-local-name"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:local" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.local']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの名前を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードの名前を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-name"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:name" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.name']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの名前空間URIを取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードの名前空間URIを返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-namespace-uri"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:namespaceUri" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.namespaceUri']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの文字列を正規化して取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="正規化したノードの文字列を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-normalize-space"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:normalize" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.normalize']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>正規化したノードの文字列数を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="正規化したノードの文字列を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-normalize-space"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-string-length"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:normalizeLength" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.normalizedLength']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>文脈ポジションを取得する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:return xsltdoc:short="文脈ポジションを返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-position"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:position" mode="cxsltl:node.property">
		<xsl:param name="position" select="0"/>

		<xsl:value-of select="$position"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの接頭辞を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードの接頭辞を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-name"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:prefix" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.prefix']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>cxsltl:static要素の文字列を正規化して取得する</xsltdoc:short>
		<xsltdoc:return xsltdoc:short="ノードの文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:static" mode="cxsltl:node.property">
		<xsl:for-each select="text()">
			<xsl:value-of select="normalize-space()"/>
		</xsl:for-each>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>cxsltl:static要素の文字列を取得する</xsltdoc:short>
		<xsltdoc:return xsltdoc:short="ノードの文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:static[@xml:space = 'preserve']" mode="cxsltl:node.property">
		<xsl:for-each select="text()">
			<xsl:value-of select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの文字列を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードの文字列を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-string"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:string" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.string']"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードのタイプを取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="ノードのタイプを返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#data-model"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="cxsltl:type" mode="cxsltl:node.property">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter">,</xsl:param>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="delimiter" select="$delimiter"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.type']"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>