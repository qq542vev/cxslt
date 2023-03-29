<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>HTML変換用のテンプレート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-15</xsltdoc:version>
		<xsltdoc:since>2017-10-15</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/html51/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output
		method="html"
		version="5.1"
		encoding="UTF-8"
		indent="no"
		media-type="text/html"
	/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:template.html.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>HTML変換用のメインレイアウトのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:template.html.layout" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.main']"/>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>メインのテンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="デフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{html}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.main']" mode="cxsltl:callback" name="cxsltl:template.html.main">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="defaultValue" select="/.."/>
		<xsl:param name="callback" select="/.."/>

		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>]]></xsl:text>

		<html>
			<head>
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.title']"/>
					<xsl:with-param name="type">title</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.description']"/>
					<xsl:with-param name="type">description</xsl:with-param>
				</xsl:apply-templates>

				<xsl:variable name="tags">
					<xsl:apply-templates select="$callback" mode="cxsltl:callback">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="defaultValue" select="$defaultValue"/>
						<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.tag']"/>
						<xsl:with-param name="type">tag</xsl:with-param>
					</xsl:apply-templates>
				</xsl:variable>

				<xsl:if test="string($tags)">
					<meta name="keywords" property="schema:keywords" content="{$tags}"/>
				</xsl:if>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.rights']"/>
					<xsl:with-param name="type">rights</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.date']"/>
					<xsl:with-param name="type">created</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.date']"/>
					<xsl:with-param name="type">modified</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="type">author</xsl:with-param>
					<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.agent']"/>
				</xsl:apply-templates>

				<meta name="generator" content="{system-property('xsl:vendor')}"/>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="type">alternate</xsl:with-param>
					<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.head.link']"/>
				</xsl:apply-templates>

				<link rel="schema.dcterms" href="http://purl.org/dc/terms/"/>

				<link rel="dcterms:conformsTo" href="http://www.w3.org/TR/html51/"/>
			</head>
			<body>
				<main>
					<xsl:apply-templates select="$callback" mode="cxsltl:callback">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="defaultValue" select="$defaultValue"/>
						<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.body.title']"/>
						<xsl:with-param name="type">title</xsl:with-param>
					</xsl:apply-templates>

					<xsl:apply-templates select="$callback" mode="cxsltl:callback">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="defaultValue" select="$defaultValue"/>
						<xsl:with-param name="callback" select="$cxsltl:template.html.self/xsl:template[@name = 'cxsltl:template.html.body.description']"/>
						<xsl:with-param name="type">description</xsl:with-param>
					</xsl:apply-templates>

					<xsl:apply-templates select="$callback" mode="cxsltl:callback">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="defaultValue" select="$defaultValue"/>
					</xsl:apply-templates>
				</main>
			</body>
		</html>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>{head}要素内のタイトルのテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="タイトル"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{title}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.head.title']" mode="cxsltl:callback" name="cxsltl:template.html.head.title">
		<xsl:param name="string"/>

		<title property="dcterms:title">
			<xsl:value-of select="$string"/>
		</title>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>{head}要素内の説明のテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="説明"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{meta}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.head.description']" mode="cxsltl:callback" name="cxsltl:template.html.head.description">
		<xsl:param name="string"/>
		<xsl:param name="type"/>

		<meta name="description" property="dcterms:description" content="{$string}"/>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>{head}要素内のタグのテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="タグ"/>
		<xsltdoc:returnString xsltdoc:short="{$string}を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.head.tag']" mode="cxsltl:callback" name="cxsltl:template.html.head.tag">
		<xsl:param name="string"/>
		<xsl:param name="type"/>
		<xsl:param name="position"/>
		<xsl:param name="last"/>

		<xsl:if test="not(contains($string, ','))">
			<xsl:value-of select="$string"/>

			<xsl:if test="$position != $last">,</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.head.rights']" mode="cxsltl:callback" name="cxsltl:template.html.head.rights">
		<xsl:param name="string"/>
		<xsl:param name="type"/>

		<meta name="copyright" property="dc11:rights" content="{$string}"/>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>日付のテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="ISO 8601の日付形式"/>
		<xsltdoc:return xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.head.date']" mode="cxsltl:callback" name="cxsltl:template.html.head.date">
		<xsl:param name="string"/>
		<xsl:param name="type"/>

		<meta name="dcterms.{$type}" property="dcterms:{$type}" datatype="dcterms:W3CDTF" content="{$string}"/>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>エージェントのテンプレート</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="エージェントの名前"/>
		<xsltdoc:return xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.head.agent']" mode="cxsltl:callback" name="cxsltl:template.html.head.agent">
		<xsl:param name="name"/>
		<xsl:param name="email"/>
		<xsl:param name="uri"/>

		<xsl:if test="string($name)">
			<meta name="author" property="dc11:creator" content="{$name}"/>
		</xsl:if>

		<xsl:if test="string($email)">
			<link property="dcterms:creator" rev="made" href="mailto:{$email}">
				<xsl:if test="string($name)">
					<xsl:attribute name="title">
						<xsl:value-of select="$name" />
					</xsl:attribute>
				</xsl:if>
			</link>
		</xsl:if>

		<xsl:if test="string($uri)">
			<link rel="author" content="{$uri}">
				<xsl:if test="string($name)">
					<xsl:attribute name="title">
						<xsl:value-of select="$name" />
					</xsl:attribute>
				</xsl:if>
			</link>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.head.link']" mode="cxsltl:callback" name="cxsltl:template.html.head.link">
		<xsl:param name="string"/>
		<xsl:param name="type"/>

		<link rel="{$type}" href="{$string}"/>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.body.title']" mode="cxsltl:callback" name="cxsltl:template.html.body.title">
		<xsl:param name="string"/>

		<h1>
			<xsl:value-of select="$string"/>
		</h1>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:template.html.body.description']" mode="cxsltl:callback" name="cxsltl:template.html.body.description">
		<xsl:param name="string"/>

		<p>
			<xsl:value-of select="$string"/>
		</p>
	</xsl:template>
</xsl:stylesheet>