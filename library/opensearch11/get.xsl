<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../node/common.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>Open Search 1.1 のゲッター XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-12-02</xsltdoc:version>
		<xsltdoc:since>2017-11-26</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.opensearch.org/Specifications/OpenSearch/1.1"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{opensearch:AdultContent}要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{opensearch:AdultContent}要素"/>
		<xsltdoc:returnString xsltdoc:short="要素値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.adultContent">
		<xsl:param name="node" select="opensearch:AdultContent"/>

		<xsl:variable name="adultContent" select="$node/self::opensearch:AdultContent"/>
		<xsl:variable name="normalize" select="normalize-space($adultContent)"/>

		<xsl:choose>
			<xsl:when test="not($adultContent) or $normalize = 'false' or $normalize = 'FALSE' or $normalize = '0' or $normalize = 'no' or $normalize = 'NO'">false</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>パラメーターを{$namespace}から展開する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="パラメーター"/>
		<xsltdoc:paramNodeSet xsltdoc:name="namespace" xsltdoc:short="名前空間"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="名前空間URIとローカル名の区切り文字"/>
		<xsltdoc:returnString xsltdoc:short="展開されたハラメーターを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.expandParameter">
		<xsl:param name="string" select="."/>
		<xsl:param name="namespace" select="ancestor-or-self::*[1]/namespace::*"/>
		<xsl:param name="delimiter" select="' '"/>

		<xsl:choose>
			<xsl:when test="contains($string, ':')">
				<xsl:variable name="prefix" select="substring-before($string, ':')"/>

				<xsl:value-of select="concat($namespace[name() = $prefix], $delimiter, substring-after($string, ':'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('http://a9.com/-/spec/opensearch/1.1/', $delimiter, $string)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>OpenSearch URL template内のパラメーターを{$namespace}から展開する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="OpenSearch URL template"/>
		<xsltdoc:paramNodeSet xsltdoc:name="namespace" xsltdoc:short="名前空間"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="名前空間URIとローカル名の区切り文字"/>
		<xsltdoc:returnString xsltdoc:short="パラメーターが展開されたOpenSearch URL templateを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.expandTemplateParameter">
		<xsl:param name="string" select="normalize-space()"/>
		<xsl:param name="namespace" select="ancestor-or-self::*[1]/namespace::*"/>
		<xsl:param name="delimiter">:</xsl:param>

		<xsl:choose>
			<xsl:when test="contains(substring-after($string, '{'), '}')">
				<xsl:variable name="parameter" select="substring-before(substring-after($string, '{'), '}')"/>
				<xsl:variable name="expanded">
					<xsl:call-template name="cxsltl:opensearch11.get.expandParameter">
						<xsl:with-param name="string" select="$parameter"/>
						<xsl:with-param name="namespace" select="$namespace"/>
						<xsl:with-param name="delimiter" select="$delimiter"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:value-of select="concat(substring-before($string, '{'), '{', $expanded, '}')"/>

				<xsl:call-template name="cxsltl:opensearch11.get.expandTemplateParameter">
					<xsl:with-param name="string" select="substring-after($string, '}')"/>
					<xsl:with-param name="namespace" select="$namespace"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{@indexOffset}属性を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{@indexOffset}属性"/>
		<xsltdoc:returnString xsltdoc:short="属性値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.indexOffset">
		<xsl:param name="node" select="@indexOffset"/>

		<xsl:choose>
			<xsl:when test="$node">
				<xsl:value-of select="normalize-space($node)"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{opensearch:InputEncoding}要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{opensearch:InputEncoding}要素"/>
		<xsltdoc:returnString xsltdoc:short="要素値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.inputEncoding">
		<xsl:param name="node" select="opensearch:InputEncoding"/>

		<xsl:variable name="inputEncoding" select="$node/self::opensearch:InputEncoding"/>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$inputEncoding"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.normalize']"/>
		</xsl:call-template>

		<xsl:if test="not($inputEncoding)">UTF-8</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{opensearch:Language}要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{opensearch:Language}要素"/>
		<xsltdoc:returnString xsltdoc:short="要素値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.language">
		<xsl:param name="node" select="opensearch:Language"/>

		<xsl:variable name="language" select="$node/self::opensearch:Language"/>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$language"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.normalize']"/>
		</xsl:call-template>

		<xsl:if test="not($language)">*</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{opensearch:SyndicationRight}要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{opensearch:SyndicationRight}要素"/>
		<xsltdoc:returnString xsltdoc:short="要素値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.syndicationRight">
		<xsl:param name="node" select="opensearch:SyndicationRight"/>

		<xsl:variable name="syndicationRight" select="$node/self::opensearch:SyndicationRight"/>

		<xsl:choose>
			<xsl:when test="$syndicationRight">
				<xsl:value-of select="translate(normalize-space($syndicationRight), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
			</xsl:when>
			<xsl:otherwise>open</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{opensearch:OutputEncoding}要素を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{opensearch:OutputEncoding}要素"/>
		<xsltdoc:returnString xsltdoc:short="要素値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.outputEncoding">
		<xsl:param name="node" select="opensearch:OutputEncoding"/>

		<xsl:variable name="outputEncoding" select="$node/self::opensearch:OutputEncoding"/>

		<xsl:call-template name="cxsltl:node.common.map">
			<xsl:with-param name="node" select="$outputEncoding"/>
			<xsl:with-param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.normalize']"/>
		</xsl:call-template>

		<xsl:if test="not($outputEncoding)">UTF-8</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{@pageOffset}属性を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{@pageOffset}属性"/>
		<xsltdoc:returnString xsltdoc:short="属性値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.pageOffset">
		<xsl:param name="node" select="@pageOffset"/>

		<xsl:choose>
			<xsl:when test="$node">
				<xsl:value-of select="normalize-space($node)"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{@rel}属性を取得する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="{@rel}属性"/>
		<xsltdoc:returnString xsltdoc:short="属性値を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opensearch11.get.rel">
		<xsl:param name="node" select="@rel"/>

		<xsl:variable name="normalize" select="normalize-space($node)"/>

		<xsl:choose>
			<xsl:when test="$normalize">
				<xsl:value-of select="$normalize"/>
			</xsl:when>
			<xsl:otherwise>results</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>