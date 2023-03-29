<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>整形済みテキスト変換用のテンプレート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-15</xsltdoc:version>
		<xsltdoc:since>2017-10-15</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://en.wikipedia.org/wiki/Text_file"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:template.text.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>整形済みテキスト変換用のメインレイアウトのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:template.text.layout" select="$cxsltl:template.text.self/xsl:template[@name = 'cxsltl:template.text.main']"/>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>メインのテンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="デフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.text.main']" mode="cxsltl:callback" name="cxsltl:template.text.main">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="defaultValue" select="/.."/>
		<xsl:param name="callback" select="/.."/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:template.text.self/xsl:template[@name = 'cxsltl:template.text.title']"/>
			<xsl:with-param name="type">title</xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:template.text.self/xsl:template[@name = 'cxsltl:template.text.description']"/>
			<xsl:with-param name="type">description</xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
		</xsl:apply-templates>

		<xsl:text>&#xA;------------------------------&#xA;&#xA;</xsl:text>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:template.text.self/xsl:template[@name = 'cxsltl:template.text.date']"/>
			<xsl:with-param name="type">created</xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:template.text.self/xsl:template[@name = 'cxsltl:template.text.date']"/>
			<xsl:with-param name="type">modified</xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:template.text.self/xsl:template[@name = 'cxsltl:template.text.agent']"/>
			<xsl:with-param name="type">author</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>タイトルのテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="タイトル"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.text.title']" mode="cxsltl:callback" name="cxsltl:template.text.title">
		<xsl:param name="string"/>

		<xsl:value-of select="concat('# ', normalize-space($string), '&#xA;&#xA;')"/>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>説明のテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="説明"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.text.description']" mode="cxsltl:callback" name="cxsltl:template.text.description">
		<xsl:param name="string"/>

		<xsl:value-of select="concat(normalize-space($string), '&#xA;&#xA;')"/>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>日付のテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="ISO 8601の日付形式"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.text.date']" mode="cxsltl:callback" name="cxsltl:template.text.date">
		<xsl:param name="string"/>
		<xsl:param name="type"/>

		<xsl:value-of select="concat($type, '&#xA;:   ', normalize-space($string), '&#xA;')"/>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>エージェントのテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="エージェントの名前"/>
		<xsltdoc:paramString xsltdoc:name="email" xsltdoc:short="エージェントのE-Mailアドレス"/>
		<xsltdoc:paramString xsltdoc:name="uri" xsltdoc:short="エージェントのURI"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.text.agent']" mode="cxsltl:callback" name="cxsltl:template.text.agent">
		<xsl:param name="name"/>
		<xsl:param name="email"/>
		<xsl:param name="uri"/>
		<xsl:param name="type"/>

		<xsl:value-of select="concat($type, '&#xA;:  ')"/>

		<xsl:if test="string($name)">
			<xsl:value-of select="concat(' ', normalize-space($name))"/>
		</xsl:if>

		<xsl:if test="string($email)">
			<xsl:value-of select="concat(' (', normalize-space($email), ')')"/>
		</xsl:if>

		<xsl:if test="string($uri)">
			<xsl:value-of select="concat(' &lt;', normalize-space($uri), '&gt;')"/>
		</xsl:if>

		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
</xsl:stylesheet>