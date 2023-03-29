<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../node/common.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XPathを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-03-18</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xpath.generate.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Node-SetからXPathを生成する</xsltdoc:short>
		<xsltdoc:version>2017-06-25</xsltdoc:version>
		<xsltdoc:since>2017-06-25</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノードセット"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="除外するノード"/>
		<xsltdoc:paramBoolean xsltdoc:name="omit" xsltdoc:short="true()ならば簡易表記を行う"/>
		<xsltdoc:return xsltdoc:short="XPathを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xpath.generate.nodeXPath">
		<xsl:param name="node" select="ancestor-or-self::node()"/>
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="omit" select="true()"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:for-each select="$node[count(. | $deny) != $denyCount]">
			<xsl:call-template name="cxsltl:xpath.generate.step">
				<xsl:with-param name="omit" select="$omit"/>
				<xsl:with-param name="preceding" select="preceding-sibling::node()[count(. | $deny) != $denyCount]"/>
			</xsl:call-template>

			<xsl:if test="count(. | /) = 2 and position() != last()">/</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>始点から終点までのXPathを生成する</xsltdoc:short>
		<xsltdoc:version>2017-03-18</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="start" xsltdoc:short="始点のノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="end" xsltdoc:short="終点のノード"/>
		<xsltdoc:paramBoolean xsltdoc:name="omit" xsltdoc:short="true()ならば簡易表記を行う"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切りの文字列"/>
		<xsltdoc:return xsltdoc:short="XPathのリスト"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xpath.generate.relative">
		<xsl:param name="start" select="/"/>
		<xsl:param name="end" select="."/>
		<xsl:param name="omit" select="true()"/>
		<xsl:param name="delimiter" select="' '"/>
		<xsl:param name="_position" select="1"/>

		<xsl:if test="$start[$_position] and $end[$_position]">
			<xsl:if test="2 &lt;= $_position">
				<xsl:value-of select="$delimiter"/>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="count($start[$_position] | $end[$_position]) = 1">
					<xsl:choose>
						<xsl:when test="$omit">.</xsl:when>
						<xsl:otherwise>self::node()</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="count($start[$_position]/ancestor-or-self::node()[last()] | $end[$_position]/ancestor-or-self::node()[last()]) = 1">
					<xsl:variable name="startAncestor" select="$start[$_position]/ancestor-or-self::node()"/>
					<xsl:variable name="startAncestorCount" select="count($startAncestor)"/>
					<xsl:variable name="endAncestor" select="$end[$_position]/ancestor-or-self::node()"/>
					<xsl:variable name="endAncestorCount" select="count($endAncestor)"/>

					<xsl:for-each select="$startAncestor[count(. | $endAncestor) != $endAncestorCount]">
						<xsl:choose>
							<xsl:when test="$omit">..</xsl:when>
							<xsl:otherwise>parent::node()</xsl:otherwise>
						</xsl:choose>

						<xsl:if test="position() != last()">/</xsl:if>
					</xsl:for-each>

					<xsl:if test="not($start[$_position]/ancestor::node()[count(. | $end[$_position]) = 1] or $end[$_position]/ancestor::node()[count(. | $start[$_position]) = 1])">/</xsl:if>

					<xsl:for-each select="$endAncestor[count(. | $startAncestor) != $startAncestorCount]">
						<xsl:call-template name="cxsltl:xpath.generate.step"/>

						<xsl:if test="position() != last()">/</xsl:if>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>

			<xsl:call-template name="cxsltl:xpath.generate.relative">
				<xsl:with-param name="start" select="$start"/>
				<xsl:with-param name="end" select="$end"/>
				<xsl:with-param name="omit" select="$omit"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
				<xsl:with-param name="_position" select="$_position + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XPathのStepを生成する</xsltdoc:short>
		<xsltdoc:version>2017-06-25</xsltdoc:version>
		<xsltdoc:since>2017-03-18</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="Stepのノード"/>
		<xsltdoc:paramBoolean xsltdoc:name="omit" xsltdoc:short="true()ならば簡易表記を行う"/>
		<xsltdoc:return xsltdoc:short="XPathのStep"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xpath.generate.step">
		<xsl:param name="node" select="."/>
		<xsl:param name="omit" select="true()"/>
		<xsl:param name="preceding" select="$node[1]/preceding-sibling::node()"/>

		<xsl:variable name="nodeType">
			<xsl:call-template name="cxsltl:node.common.type">
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$nodeType = 'root'">/</xsl:when>
			<xsl:when test="$nodeType = 'element'">
				<xsl:if test="not($omit)">child::</xsl:if>

				<xsl:value-of select="concat(name(), '[', count($preceding/self::*[name() = name(current())]) + 1 , ']')"/>
			</xsl:when>
			<xsl:when test="$nodeType = 'text'">
				<xsl:if test="not($omit)">child::</xsl:if>

				<xsl:value-of select="concat('text()[', count($preceding/self::text()) + 1, ']')"/>
			</xsl:when>
			<xsl:when test="$nodeType = 'comment'">
				<xsl:if test="not($omit)">child::</xsl:if>

				<xsl:value-of select="concat('comment()[', count($preceding/self::comment()) + 1, ']')"/>
			</xsl:when>
			<xsl:when test="$nodeType = 'processing-instruction'">
				<xsl:if test="not($omit)">child::</xsl:if>

				<xsl:value-of select="concat('processing-instruction()[', count($preceding/self::processing-instruction()) + 1, ']')"/>
			</xsl:when>
			<xsl:when test="$nodeType = 'attribute'">
				<xsl:choose>
					<xsl:when test="$omit">@</xsl:when>
					<xsl:otherwise>attribute::</xsl:otherwise>
				</xsl:choose>

				<xsl:value-of select="name()"/>
			</xsl:when>
			<xsl:when test="$nodeType = 'namespace'">
				<xsl:text>namespace::</xsl:text>

				<xsl:choose>
					<xsl:when test="name()">
						<xsl:value-of select="name()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>*[name()=""]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not($omit)">child::</xsl:if>

				<xsl:value-of select="concat('node()[', count($preceding) + 1, ']')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>