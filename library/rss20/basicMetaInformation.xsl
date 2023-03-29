<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="get.xsl"/>
	<xsl:import href="../basicMetaInformation.xsl"/>
	<xsl:import href="../date/common.xsl"/>
	<xsl:import href="../date/email.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>RSS 2.0 の基本メタ情報を扱う XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-12-06</xsltdoc:version>
		<xsltdoc:since>2011-12-06</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.rssboard.org/rss-specification"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:rss20.basicMetaInformation.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>RSS 2.0のデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:rss20.basicMetaInformation.defaultValue" select="$cxsltl:rss20.basicMetaInformation.self/rdf:Description[@xml:id = 'cxsltl.rss20.basicMetaInformation.defaultValue']"/>

	<!-- ==============================
		# rdf:Description Element
	 ============================== -->

	<rdf:Description rdf:about="#cxsltl.rss20.basicMetaInformation.defaultValue" xml:id="cxsltl.rss20.basicMetaInformation.defaultValue">
		<dcterms:title>RSS</dcterms:title>
		<dcterms:description>The Syndication file. Entry items.</dcterms:description>
		<dcterms:conformsTo rdf:resource="http://www.rssboard.org/rss-specification"/>
		<dc:format>application/rss+xml</dc:format>
	</rdf:Description>

	<!-- ==============================
		## xsl:template for OPML 2.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss20.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="node() | @*" mode="cxsltl:rss20.basicMetaInformation.geter">
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20.basicMetaInformation.geter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素を{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="title | link | description | copyright | category | generator" mode="cxsltl:rss20.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="string" select="normalize-space()"/>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="self::title">title</xsl:when>
					<xsl:when test="self::link">alternate</xsl:when>
					<xsl:when test="self::description">description</xsl:when>
					<xsl:when test="self::copyright">rights</xsl:when>
					<xsl:when test="self::category">tag</xsl:when>
					<xsl:when test="self::generator">generator</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="position" select="position()"/>
			<xsl:with-param name="last" select="last()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{pubDate}要素、{lastBuildDate}要素をISO 8601の日付形式に変換し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="pubDate | lastBuildDate" mode="cxsltl:rss20.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="string">
				<xsl:call-template name="cxsltl:date.email.parse">
					<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="self::pubDate">created</xsl:when>
					<xsl:when test="self::lastBuildDate">modified</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="position" select="position()"/>
			<xsl:with-param name="last" select="last()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="managingEditor | webMaster" mode="cxsltl:rss20.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:rss20.get.email"/>
		</xsl:variable>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="nameNode" select="."/>
			<xsl:with-param name="emailNode" select="."/>
			<xsl:with-param name="name" select="substring-after($result, ' ')"/>
			<xsl:with-param name="email" select="substring-before($result, ' ')"/>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="self::managingEditor">author</xsl:when>
					<xsl:when test="self::webMaster">publisher</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="position" select="position()"/>
			<xsl:with-param name="last" select="last()"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{$node}から{$type}の値を取得し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="$nodeから取得する値のタイプ"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:rss20.basicMetaInformation.get']" mode="cxsltl:callback" name="cxsltl:rss20.basicMetaInformation.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="defaultValue" select="$cxsltl:rss20.basicMetaInformation.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">title</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="(
					$node/title[$type = 'title'] |
					$node/link[$type = 'alternate'] |
					$node/description[$type = 'description'] |
					$node/copyright[$type = 'rights'] |
					$node/category[$type = 'tag'] |
					$node/pubDate[$type = 'created'] |
					$node/lastBuildDate[$type = 'modified'] |
					$node/generator[$type = 'generator'] |
					$node/managingEditor[$type = 'author'] |
					$node/webMaster[$type = 'publisher']
				)[count(. | $deny) != $denyCount]
			">
				<xsl:apply-templates select="
					(
						$node/title[$type = 'title'] |
						$node/link[$type = 'alternate'] |
						$node/description[$type = 'description'] |
						$node/copyright[$type = 'rights'] |
						$node/category[$type = 'tag'] |
						$node/pubDate[$type = 'created'] |
						$node/lastBuildDate[$type = 'modified'] |
						$node/generator[$type = 'generator'] |
						$node/managingEditor[$type = 'author'] |
						$node/webMaster[$type = 'publisher']
					)[count(. | $deny) != $denyCount]
				" mode="cxsltl:rss20.basicMetaInformation.geter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="callback" select="$callback"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:basicMetaInformation.get">
					<xsl:with-param name="node" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>