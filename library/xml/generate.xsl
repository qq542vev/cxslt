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
		<xsltdoc:short>XMLを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2016-01-03</xsltdoc:version>
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

	<xsl:variable name="cxsltl:xml.generate.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>XMLの特殊文字をエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xml.generate.escape" select="$cxsltl:xml.generate.self/cxsltl:string.search[@xml:id = 'cxsltl.xml.generate.escape']/cxsltl:string.replace"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.xml.generate.escape">
		<xsltdoc:short>XMLの特殊文字をエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.xml.generate.escape">
		<cxsltl:string.replace src="&amp;" dst="&amp;amp;"/>
		<cxsltl:string.replace src="&lt;" dst="&amp;lt;"/>
		<cxsltl:string.replace src="&gt;" dst="&amp;gt;"/>
		<cxsltl:string.replace src="&quot;" dst="&amp;quot;"/>
		<cxsltl:string.replace src="&apos;" dst="&amp;apos;"/>
	</cxsltl:string.search>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>属性を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="属性値"/>
		<xsltdoc:return xsltdoc:short="属性を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.generate.attribute">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="value" select="."/>
		<xsl:param name="escape" select="true()"/>

		<xsl:text> </xsl:text>

		<xsl:value-of select="$name"/>

		<xsl:text>="</xsl:text>

		<xsl:choose>
			<xsl:when test="$escape">
				<xsl:call-template name="cxsltl:xml.generate.escape">
					<xsl:with-param name="string" select="$value"/>
					<xsl:with-param name="quotEscape" select="true()"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>CDATA Sectionを生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="CDATA Sectionの値"/>
		<xsltdoc:return xsltdoc:short="CDATA Sectionを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.generate.cdata">
		<xsl:param name="value" select="."/>

		<xsl:if test="not(contains($value, ']]&gt;'))">
			<xsl:value-of select="concat('&lt;![CDATA[', $value, ']]&gt;')"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>コメントを生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="コメントの値"/>
		<xsltdoc:return xsltdoc:short="コメントを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.generate.comment">
		<xsl:param name="value" select="."/>

		<xsl:if test="not(contains($value, '--'))">
			<xsl:value-of select="concat('&lt;!--', $value, '--&gt;')"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XML宣言を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="version" xsltdoc:short="XMLのバージョン情報"/>
		<xsltdoc:paramString xsltdoc:name="encoding" xsltdoc:short="符号化宣言"/>
		<xsltdoc:paramString xsltdoc:name="standalone" xsltdoc:short="スタンドアローン宣言"/>
		<xsltdoc:return xsltdoc:short="XML宣言を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.generate.declaration">
		<xsl:param name="version">1.0</xsl:param>
		<xsl:param name="encoding">UTF-8</xsl:param>
		<xsl:param name="standalone">no</xsl:param>

		<xsl:text>&lt;?xml</xsl:text>

		<xsl:call-template name="cxsltl:xml.generate.attribute">
			<xsl:with-param name="name">version</xsl:with-param>
			<xsl:with-param name="value" select="$version"/>
		</xsl:call-template>

		<xsl:if test="string($encoding)">
			<xsl:call-template name="cxsltl:xml.generate.attribute">
				<xsl:with-param name="name">encoding</xsl:with-param>
				<xsl:with-param name="value" select="$encoding"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="string($standalone)">
			<xsl:call-template name="cxsltl:xml.generate.attribute">
				<xsl:with-param name="name">standalone</xsl:with-param>
				<xsl:with-param name="value" select="$standalone"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>要素を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="要素名"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="要素の属性"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="要素の内容"/>
		<xsltdoc:paramBoolean xsltdoc:name="escape" xsltdoc:short="true()ならば要素の内容をエスケープする"/>
		<xsltdoc:paramBoolean xsltdoc:name="endTag" xsltdoc:short="true()ならば終了タグを生成する"/>
		<xsltdoc:paramBoolean xsltdoc:name="cdata" xsltdoc:short="true()ならばCDATA Sectionを生成する"/>
		<xsltdoc:return xsltdoc:short="要素を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.generate.element">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="attribute"/>
		<xsl:param name="content"/>
		<xsl:param name="escape" select="false()"/>
		<xsl:param name="endTag" select="false()"/>
		<xsl:param name="cdata" select="false()"/>

		<xsl:text>&lt;</xsl:text>

		<xsl:value-of select="$name"/>

		<xsl:if test="normalize-space($attribute)">
			<xsl:text> </xsl:text>

			<xsl:call-template name="cxsltl:string.bothTrim">
				<xsl:with-param name="string" select="$attribute"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="not($endTag or string($content))">/</xsl:if>

		<xsl:text>&gt;</xsl:text>

		<xsl:choose>
			<xsl:when test="$cdata and not(contains($content, ']]&gt;'))">
				<xsl:call-template name="cxsltl:xml.generate.cdata">
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

		<xsl:if test="$endTag or string($content)">
			<xsl:value-of select="concat('&lt;/', $name, '&gt;')"/>
		</xsl:if>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XMLの特殊文字をエスケープする</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short>Return is &lt;a href=&quot;http://www.w3.org/TR/xslt&quot;&gt;XSLT 1.0&lt;/a&gt;</xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:xml.generate.escape">
					<xsl:with-param name="string">&lt;a href=&quot;http://www.w3.org/TR/xslt&quot;&gt;XSLT 1.0&lt;/a&gt;</xsl:with-param>
					<xsl:with-param name="quotEscape" select="true()"/>
					<xsl:with-param name="aposEscape" select="true()"/>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-26</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="エスケープされる文字列"/>
		<xsltdoc:paramBoolean xsltdoc:name="quotEscape" xsltdoc:short="true()ならばダブルクォーテーションをエスケープする"/>
		<xsltdoc:paramBoolean xsltdoc:name="aposEscape" xsltdoc:short="true()ならばシングルクォーテーションをエスケープする"/>
		<xsltdoc:return xsltdoc:short="エスケープされた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.generate.escape">
		<xsl:param name="string" select="."/>
		<xsl:param name="quotEscape" select="false()"/>
		<xsl:param name="aposEscape" select="false()"/>

		<xsl:call-template name="cxsltl:string.multipleReplace">
			<xsl:with-param name="node" select="$cxsltl:xml.generate.escape[@src != '&quot;' or $quotEscape][@src != &quot;&apos;&quot; or $aposEscape]"/>
			<xsl:with-param name="string" select="$string"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>処理命令を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="処理命令名"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="処理命令の内容"/>
		<xsltdoc:return xsltdoc:short="処理命令を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.generate.processingInstruction">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="value" select="."/>

		<xsl:text>&lt;?</xsl:text>

		<xsl:value-of select="$name"/>

		<xsl:if test="normalize-space($value)">
			<xsl:text> </xsl:text>

			<xsl:call-template name="cxsltl:string.bothTrim">
				<xsl:with-param name="string" select="$value"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:text>?&gt;</xsl:text>
	</xsl:template>

	<xsl:template name="cxsltl:xml.generate.removeEntities">
		<xsl:param name="string" select="."/>

		<xsl:choose>
			<xsl:when test="contains($string, '&amp;')">
				<xsl:value-of select="substring-before($string, '&amp;')"/>

				<xsl:call-template name="cxsltl:xml.generate.removeEntities">
					<xsl:with-param name="string" select="substring-after($string, ';')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="cxsltl:xml.generate.removeTags">
		<xsl:param name="string" select="."/>

		<xsl:choose>
			<xsl:when test="contains($string, '&lt;')">
				<xsl:value-of select="substring-before($string, '&lt;')"/>

				<xsl:call-template name="cxsltl:xml.generate.removeTags">
					<xsl:with-param name="string" select="substring-after($string, '&gt;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>