<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>RSS 3.0を扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-05</xsltdoc:version>
		<xsltdoc:since>2017-09-05</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.aaronsw.com/2002/rss30"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 3.0のE-Mailと名前を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="email" xsltdoc:short="E-Mailアドレス"/>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="名前"/>
		<xsltdoc:return xsltdoc:short="RSS 3.0の行を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss30.generate.agent">
		<xsl:param name="tokenName" select="local-name()"/>
		<xsl:param name="email" select="normalize-space()"/>
		<xsl:param name="name"/>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name" select="$tokenName"/>
			<xsl:with-param name="value">
				<xsl:value-of select="$email"/>

				<xsl:if test="string($name)">
					<xsl:value-of select="concat(' ', $name)"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 3.0の行を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="名前"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="値"/>
		<xsltdoc:return xsltdoc:short="RSS 3.0の行を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss30.generate.line">
		<xsl:param name="name" select="local-name()"/>
		<xsl:param name="value" select="normalize-space()"/>

		<xsl:value-of select="concat($name, ': ')"/>

		<xsl:call-template name="cxsltl:string.replace">
			<xsl:with-param name="string" select="$value"/>
			<xsl:with-param name="src" select="'&#xA;'"/>
			<xsl:with-param name="dst" select="'&#xA; '"/>
		</xsl:call-template>

		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
</xsl:stylesheet>