<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../binary.xsl"/>
	<xsl:import href="../string.xsl"/>
	<xsl:import href="common.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>ノードの検査処理するXSLT</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-05-01</xsltdoc:version>
		<xsltdoc:since>2017-04-25</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:node.test.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# Template for node test
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="position" select="0"/>
		<xsl:param name="last" select="0"/>

		<xsl:apply-templates select="node() | @*" mode="cxsltl:node.test">
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

	<xsl:template match="text() | @*" mode="cxsltl:node.test"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの展開名(名前空間URI + ローカル名)が属性値と部分一致するか検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-local-name"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-namespace-uri"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:expandedIs | @cxsltl:expandedIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'expandedIs'"/>
		<xsl:variable name="expanded">
			<xsl:if test="namespace-uri($node)">
				<xsl:value-of select="concat(namespace-uri($node), local-name($node))"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="value" select="concat(' ', normalize-space(), ' ')"/>

		<xsl:variable name="result" select="contains($value, concat(' ', $expanded, ' ')) or (contains($value, ' {#null#} ') and not(string($expanded)))"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの階層値が属性値の範囲内か検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:depthIs | @cxsltl:depthIsNot" mode="cxsltl:node.test">
		<xsl:param name="depth" select="0"/>

		<xsl:variable name="unnot" select="local-name() = 'depthIs'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.range']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="$depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ノードの階層値の約数が属性値に含まれているかを検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="ノードの深さ"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:depthIsMultipleOf | @cxsltl:depthIsNotMultipleOf" mode="cxsltl:node.test">
		<xsl:param name="depth" select="0"/>

		<xsl:variable name="unnot" select="local-name() = 'depthIsMultipleOf'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.multiple']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="$depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの一意的なidが属性値と部分一致するか検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xslt#function-generate-id"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:idIs | @cxsltl:idIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'idIs'"/>
		<xsl:variable name="id" select="generate-id($node)"/>
		<xsl:variable name="value" select="concat(' ', normalize-space(), ' ')"/>

		<xsl:variable name="result" select="contains($value, concat(' ', generate-id($node), ' ')) or (contains($value, ' {#null#} ') and not($id))"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>文脈ポジションが文脈サイズと一致するかを検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="last" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xslt#function-last"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xslt#function-position"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:isLast[. = 'true'] | @cxsltl:isLast[. = 'false']" mode="cxsltl:node.test">
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>

		<xsl:value-of select="number((. = 'true' and $position = $last) or (. = 'false' and $position != $last))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの文字列数が属性値の範囲内か検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-string-length"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:lengthIs | @cxsltl:lengthIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'lengthIs'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.range']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="string-length($node)"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードのローカル名が属性と部分一致するか検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-local-name"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:localIs | @cxsltl:localIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'localIs'"/>
		<xsl:variable name="local" select="local-name($node)"/>
		<xsl:variable name="value" select="concat(' ', normalize-space(), ' ')"/>の会場

		<xsl:variable name="result" select="contains($value, concat(' ', $local, ' ')) or (contains($value, ' {#null#} ') and not($local))"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの名前が属性と部分一致するか検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-name"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:nameIs | @cxsltl:nameIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'nameIs'"/>
		<xsl:variable name="name" select="name($node)"/>
		<xsl:variable name="value" select="concat(' ', normalize-space(), ' ')"/>

		<xsl:variable name="result" select="contains($value, concat(' ', $name, ' ')) or (contains($value, ' {#null#} ') and not($name))"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの名前空間URIが属性と部分一致するか検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-namespace-uri"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:namespaceUriIs | @cxsltl:namespaceUriIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'namespaceUriIs'"/>
		<xsl:variable name="nsuri" select="namespace-uri($node)"/>
		<xsl:variable name="value" select="concat(' ', normalize-space(), ' ')"/>

		<xsl:variable name="result" select="contains($value, concat(' ', $nsuri, ' ')) or (contains($value, ' {#null#} ') and not($nsuri))"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>正規化した対象ノードの文字列数が属性値の範囲内か検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-normalize-space"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-string-length"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:normalizeLengthIs | @cxsltl:normalizeLengthIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'normalizeLengthIs'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.range']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="string-length(normalize-space($node))"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの数値が属性値の範囲内か検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-number"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:numberIs | @cxsltl:numberIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'numberIs'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.range']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="$node"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの数値の約数が属性値に含まれているかを検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xslt#function-number"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:numberIsMultipleOf | @cxsltl:numberIsNotMultipleOf" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'numberIsMultipleOf'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.multiple']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="$node"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードの接頭辞が属性と部分一致するか検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-name"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:prefixIs | @cxsltl:prefixIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'prefixIs'"/>
		<xsl:variable name="prefix" select="substring-before(name($node), ':')"/>
		<xsl:variable name="value" select="concat(' ', normalize-space(), ' ')"/>

		<xsl:variable name="result" select="contains($value, concat(' ', $prefix, ' ')) or (contains($value, ' {#null#} ') and not($prefix))"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>文脈ポジションの値が属性値の範囲内か検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath#function-position"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:positionIs | @cxsltl:positionIsNot" mode="cxsltl:node.test">
		<xsl:param name="position" select="position()"/>

		<xsl:variable name="unnot" select="local-name() = 'positionIs'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.range']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="$position"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>文脈ポジションの値の約数が属性値に含まれているかを検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>の会場
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xslt#function-position"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:positionIsMultipleOf | @cxsltl:positionIsNotMultipleOf" mode="cxsltl:node.test">
		<xsl:param name="position" select="position()"/>

		<xsl:variable name="unnot" select="local-name() = 'positionIsMultipleOf'"/>

		<xsl:variable name="binary">
			<xsl:call-template name="cxsltl:string.split">
				<xsl:with-param name="callback" select="$cxsltl:node.test.self/xsl:template[@name = 'cxsltl:node.test.callback.multiple']"/>
				<xsl:with-param name="string" select="normalize-space()"/>
				<xsl:with-param name="delimiter" select="' '"/>
				<xsl:with-param name="param1" select="$position"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="number($binary)"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>対象ノードのタイプが属性値と部分一致するか検査する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:return xsltdoc:short="trueならば1を、falseならば0を返す"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xslt#data-model"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="@cxsltl:typeIs | @cxsltl:typeIsNot" mode="cxsltl:node.test">
		<xsl:param name="node" select="."/>

		<xsl:variable name="unnot" select="local-name() = 'typeIs'"/>

		<xsl:variable name="type">
			<xsl:call-template name="cxsltl:node.common.type">
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="result" select="contains(concat(' ', normalize-space(), ' '), concat(' ', $type, ' '))"/>

		<xsl:value-of select="number(($unnot and $result) or not($unnot or $result))"/>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsl:template name="cxsltl:node.test.check">
		<xsl:param name="property" select="."/>
		<xsl:param name="node" select="."/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="position" select="position()"/>
		<xsl:param name="last" select="last()"/>
		<xsl:param name="binary">
			<xsl:apply-templates select="$property/@*" mode="cxsltl:node.test">
				<xsl:with-param name="node" select="$node"/>
				<xsl:with-param name="depth" select="$depth"/>
				<xsl:with-param name="position" select="$position"/>
				<xsl:with-param name="last" select="$last"/>
			</xsl:apply-templates>
		</xsl:param>
		<xsl:param name="operation" select="$property/@cxsltl:operation"/>

		<xsl:variable name="bool">
			<xsl:if test="1 &lt; string-length($binary)">
				<xsl:call-template name="cxsltl:binary.bitOperationInNextBit">
					<xsl:with-param name="binary" select="$binary"/>
					<xsl:with-param name="operation" select="$operation"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:value-of select="number(not(string($binary)) or $binary = '1' or number($bool))"/>
	</xsl:template>

	<!-- ==============================
		# Callback Template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>$param1を$stringで余りなく除算可能か検査する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:string.splitにて呼び出されるコールバック用コールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramNodeSet xsltdoc:name="string" xsltdoc:short="数値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param1" xsltdoc:short="数値"/>
		<xsltdoc:return xsltdoc:short="$param1を$stringで余りなく除算可能であれば1を、それ以外であれば0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.test.callback.multiple']" mode="cxsltl:callback" name="cxsltl:node.test.callback.multiple">
		<xsl:param name="string"/>
		<xsl:param name="param1"/>

		<xsl:choose>
			<xsl:when test="$param1 mod $string = 0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>$param1の値が$stringの範囲内であるか検査する</xsltdoc:short>
		<xsltdoc:detail>cxsltl:string.splitにて呼び出されるコールバック用コールバック用のテンプレート。</xsltdoc:detail>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="数値"/>
		<xsltdoc:paramNumber xsltdoc:name="param1" xsltdoc:short="数値"/>
		<xsltdoc:return xsltdoc:short="$param1の値が$stringの範囲内であれば1を、それ以外であれば0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.test.callback.range']" mode="cxsltl:callback" name="cxsltl:node.test.callback.range">
		<xsl:param name="string"/>
		<xsl:param name="param1"/>

		<xsl:call-template name="cxsltl:node.test.rangeOfNumber">
			<xsl:with-param name="number" select="$param1"/>
			<xsl:with-param name="range" select="$string"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>数値が範囲内か検査する</xsltdoc:short>
		<xsltdoc:paramNumber xsltdoc:name="number" xsltdoc:short="数値"/>
		<xsltdoc:paramNumber xsltdoc:name="range" xsltdoc:short="数値の範囲"/>
		<xsltdoc:return xsltdoc:short="数値が範囲内ならば1を、それ以外ならば0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:node.test.rangeOfNumber">
		<xsl:param name="number" select="."/>
		<xsl:param name="range" select="."/>

		<xsl:choose>
			<xsl:when test="
				string(number($range)) = 'NaN' and
				(not(starts-with($range, '-')) or string(number(substring-after($range, '-'))) = 'NaN') and
				(not(substring($range, string-length($range)) = '-') or string(number(substring-before($range, '-'))) = 'NaN') and
				(string(number(substring-before($range, '-'))) = 'NaN' or string(number(substring-after($range, '-'))) = 'NaN')
			">
				<xsl:message terminate="yes">$range is not number range format.</xsl:message>
			</xsl:when>
			<xsl:when test="
				(number($number) = number($range)) or
				(starts-with($range, '-') and $number &lt;= substring-after($range, '-')) or
				(substring($range, string-length($range)) = '-' and substring-before($range, '-') &lt;= $number) or
				(substring-before($range, '-') &lt;= $number and $number &lt;= substring-after($range, '-'))
			">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>