<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../string.xsl"/>
	<xsl:import href="../xml/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>HTMLを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-11-20</xsltdoc:version>
		<xsltdoc:since>2017-11-20</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>Marked Sectionを生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="section" xsltdoc:short="Marked Sectionのタイプ"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:returnString xsltdoc:short="Marked Sectionを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:html.generate.markedSection">
		<xsl:param name="section">CDATA</xsl:param>
		<xsl:param name="value" select="."/>

		<xsl:if test="not(contains($value, ']]&gt;'))">
			<xsl:value-of select="concat('&lt;![', $section , '[', $value, ']]&gt;')"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="要素名"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:paramString xsltdoc:name="empty" xsltdoc:short="空要素名"/>
		<xsltdoc:paramString xsltdoc:name="section" xsltdoc:short="Marked Sectionのタイプ"/>
		<xsltdoc:returnString xsltdoc:short="要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:html.generate.element">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="attribute"/>
		<xsl:param name="content"/>
		<xsl:param name="escape" select="false()"/>
		<xsl:param name="empty">area base basefont br command col embed frame hr img input isindex keygen link menuitem meta param source track wbr</xsl:param>
		<xsl:param name="section"/>

		<xsl:variable name="_name" select="translate($name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>

		<xsl:value-of select="concat('&lt;', $_name)"/>

		<xsl:if test="normalize-space($attribute)">
			<xsl:text> </xsl:text>

			<xsl:call-template name="cxsltl:string.bothTrim">
				<xsl:with-param name="string" select="$attribute"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:text>&gt;</xsl:text>

		<xsl:if test="not(contains(concat(' ', normalize-space($empty), ' '), concat(' ', $_name, ' ')))">
			<xsl:choose>
				<xsl:when test="$section and not(contains($content, ']]&gt;'))">
					<xsl:call-template name="cxsltl:html.generate.markedSection">
						<xsl:with-param name="section" select="$section"/>
						<xsl:with-param name="value" select="$content"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$escape">
					<xsl:call-template name="cxsltl:xml.generate.escape">
						<xsl:with-param name="string" select="$content"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$content"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:value-of select="concat('&lt;/', $_name, '&gt;')"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="cxsltl:html.generate.processingInstruction">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="value" select="."/>

		<xsl:variable name="pi">
			<xsl:call-template name="cxsltl:xml.generate.processingInstruction">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="concat(substring($pi, 1, string-length($pi) - 2), '&gt;')"/>
	</xsl:template>
</xsl:stylesheet>