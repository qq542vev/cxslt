<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>ノードを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2015-11-18</xsltdoc:version>
		<xsltdoc:since>2014-12-23</xsltdoc:since>
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

	<xsl:variable name="cxsltl:node.common.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.map']" mode="cxsltl:callback" name="cxsltl:node.common.map">
		<xsl:param name="node" select="."/>
		<xsl:param name="delimiter" select="' '"/>
		<xsl:param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.id']"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:variable name="original" select="$node"/>

		<xsl:for-each select="$node">
			<xsl:apply-templates select="$callback" mode="cxsltl:callback">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="position" select="position()"/>
				<xsl:with-param name="last" select="last()"/>
				<xsl:with-param name="original" select="$original"/>
				<xsl:with-param name="param1" select="$param1"/>
				<xsl:with-param name="param2" select="$param2"/>
				<xsl:with-param name="param3" select="$param3"/>
				<xsl:with-param name="param4" select="$param4"/>
				<xsl:with-param name="param5" select="$param5"/>
			</xsl:apply-templates>

			<xsl:if test="position() != last()">
				<xsl:value-of select="$delimiter"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.expanded']" mode="cxsltl:callback" name="cxsltl:node.common.expanded">
		<xsl:param name="node" select="."/>

		<xsl:if test="namespace-uri($node)">
			<xsl:value-of select="concat(namespace-uri($node), local-name($node))"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.id']" mode="cxsltl:callback" name="cxsltl:node.common.id">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="generate-id($node)"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.length']" mode="cxsltl:callback" name="cxsltl:node.common.length">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="string-length($node)"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.local']" mode="cxsltl:callback" name="cxsltl:node.common.local">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="local-name($node)"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.name']" mode="cxsltl:callback" name="cxsltl:node.common.name">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="name($node)"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.namespaceUri']" mode="cxsltl:callback" name="cxsltl:node.common.namespaceUri">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="namespace-uri($node)"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.normalize']" mode="cxsltl:callback" name="cxsltl:node.common.normalize">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="normalize-space($node)"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.normalizedLength']" mode="cxsltl:callback" name="cxsltl:node.common.normalizedLength">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="string-length(normalize-space($node))"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.number']" mode="cxsltl:callback" name="cxsltl:node.common.number">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="number($node)"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.prefix']" mode="cxsltl:callback" name="cxsltl:node.common.prefix">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="substring-before(name($node), ':')"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.string']" mode="cxsltl:callback" name="cxsltl:node.common.string">
		<xsl:param name="node" select="."/>

		<xsl:value-of select="$node"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>ノードのタイプを取得する</xsltdoc:short>
		<xsltdoc:version>2015-01-17</xsltdoc:version>
		<xsltdoc:since>2014-12-23</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノードセット"/>
		<xsltdoc:return xsltdoc:short="'root', 'element', 'text', 'comment', 'processing-instruction', 'attribute', 'namespace', 'other'の何れかの値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:node.common.type']" mode="cxsltl:callback" name="cxsltl:node.common.type">
		<xsl:param name="node" select="."/>

		<xsl:for-each select="$node[1]">
			<xsl:choose>
				<xsl:when test="count(. | /) = 1">root</xsl:when>
				<xsl:when test="self::*">element</xsl:when>
				<xsl:when test="self::text()">text</xsl:when>
				<xsl:when test="self::comment()">comment</xsl:when>
				<xsl:when test="self::processing-instruction()">processing-instruction</xsl:when>
				<xsl:when test="count(. | ../@*) = count(../@*)">attribute</xsl:when>
				<xsl:when test="count(. | ../namespace::*) = count(../namespace::*)">namespace</xsl:when>
				<xsl:otherwise>other</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>